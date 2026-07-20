// lib/providers/asset_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asset_model.dart';
import '../configs/constants.dart';
import '../models/enums.dart';

class AssetProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<AssetModel> _assets = [];
  bool _loading = true;
  String? _error;
  DateTime? _lastFetched;
  // ✅ เพิ่ม 2 ตัวแปรนี้ (สำหรับ RBAC)
  String? _userRole;
  List<String>? _allowedCostCenters;
  List<AssetModel> get assets => _assets;
  bool get loading => _loading;
  String? get error => _error;
  DateTime? get lastFetched => _lastFetched;

  // Dashboard / filter state
  String _auditYear = DateTime.now().year.toString();
  Set<String> _auditedAssetNos = {};
  bool _auditLogsLoading = true;

  String get auditYear => _auditYear;
  Set<String> get auditedAssetNos => _auditedAssetNos;
  bool get auditLogsLoading => _auditLogsLoading;
  int get totalCount => _assets.length;
  int get auditedCount =>
      _assets.where((a) => _auditedAssetNos.contains(a.assetNo)).length;

  static const String _cacheKey = 'assetapp-assets-cache';
  static const String _cacheTimestampKey = 'assetapp-assets-cache-ts';
  static const int _cacheTtlMs = 30 * 24 * 60 * 60 * 1000; // 30 วัน
  static const String _firestoreCollection = FirestorePath.assets;

  AssetProvider() {
    _init();
  }

  /// คำนวณ uid สำหรับ cache key — sort + hash ป้องกัน key collision
  String _computeUid() {
    if (_userRole == 'owner') return 'owner';
    final costCenters = (_allowedCostCenters ?? [])
        .where((cc) => cc.isNotEmpty)
        .toList();
    if (costCenters.isEmpty) return 'empty';
    final sorted = List<String>.from(costCenters)..sort();
    return sorted.join('|').hashCode.toRadixString(16);
  }

  void updateRbacContext(String? role, List<String>? allowedCostCenters) {
    _userRole = role;
    _allowedCostCenters = allowedCostCenters;
    // ไม่ต้อง notifyListeners เพราะยังไม่มีข้อมูลเปลี่ยนแปลง
    // (แต่ถ้าอยากให้โหลดใหม่ทันทีเมื่อสิทธิ์เปลี่ยน ให้เรียก loadAssetsWithCacheLogic())
  }

  void setAuditYear(String year) {
    if (_auditYear == year) return;
    _auditYear = year;
    notifyListeners();
    _loadAuditedAssetNos();
  }

  Future<void> _init() async {
    await loadAssetsWithCacheLogic();
    await _loadAuditedAssetNos();
  }

  Future<void> loadAssetsWithCacheLogic() async {
  _loading = true;
  _error = null;
  notifyListeners();

  try {
    final prefs = await SharedPreferences.getInstance();
    
    final uid = _computeUid();
    final cacheKey = '${_cacheKey}_$uid';
    final cacheTsKey = '${_cacheTimestampKey}_$uid';

    final cachedJson = prefs.getString(cacheKey);
    final cachedTsStr = prefs.getString(cacheTsKey);

    if (cachedJson != null && cachedTsStr != null) {
      final cachedTs = DateTime.parse(cachedTsStr);
      final age = DateTime.now().difference(cachedTs).inMilliseconds;

      if (age < _cacheTtlMs) {
        final dynamic decoded = jsonDecode(cachedJson);
        
        // ✅ ตรวจสอบ Type ปลอดภัย
        if (decoded is List) {
          final List<Map<String, dynamic>> validItems = decoded
              .whereType<Map<String, dynamic>>()
              .toList();
          
          _assets = validItems
              .map((item) => AssetModel.fromJson(item))
              .toList();
          _lastFetched = cachedTs;
          _loading = false;
          notifyListeners();
          debugPrint('✅ Loaded ${_assets.length} assets from cache (uid: $uid)');
          return;
        } else {
          debugPrint('⚠️ Invalid cache format, clearing...');
          await prefs.remove(cacheKey);
          await prefs.remove(cacheTsKey);
        }
      }
    }
    await fetchAssetsFromServer();
  } catch (e) {
    _error = e.toString();
    _loading = false;
    notifyListeners();
  }
}

  Future<void> fetchAssetsFromServer() async {
    try {
      debugPrint('🔄 fetchAssetsFromServer: loading from server...');

      // ✅ สร้าง Query แบบมีเงื่อนไข
      Query query = _db.collection(_firestoreCollection);

      // ✅ แปลง _allowedCostCenters ให้เป็น List<String> ที่ปลอดภัย
      List<String> costCenters = (_allowedCostCenters ?? [])
          .where((cc) => cc.isNotEmpty)
          .cast<String>()
          .toList();

      // ✅ ถ้าไม่ใช่ Owner และมี Cost Centers ให้กรอง
      if (_userRole != 'owner' && costCenters.isNotEmpty) {
        query = query.where('costCenter', whereIn: costCenters);
        debugPrint(
            '🔍 Filtering by ${costCenters.length} cost centers: $costCenters');
      } else if (_userRole != 'owner' && costCenters.isEmpty) {
        debugPrint('⏳ No cost centers available, skipping load');
        _assets = [];
        _loading = false;
        notifyListeners();
        return;
      }

      // ✅ ยังคงเรียงลำดับเหมือนเดิม
      query = query.orderBy('assetNo');

      final snapshot = await query.get(const GetOptions(source: Source.server));

      _assets = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          debugPrint('⚠️ Skipping doc ${doc.id}: data is null');
          return null;
        }
        return AssetModel.fromFirestore(data, doc.id);
      }).whereType<AssetModel>().toList();

      _lastFetched = DateTime.now();
      _loading = false;

      // ✅ แยก Cache ตามสิทธิ์ (กันข้อมูลปน)
      final uid = _computeUid();
      final cacheKey = '${_cacheKey}_$uid';
      final cacheTsKey = '${_cacheTimestampKey}_$uid';

      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_assets.map((e) => e.toJson()).toList());
      await prefs.setString(cacheKey, jsonStr);
      await prefs.setString(cacheTsKey, _lastFetched!.toIso8601String());
    } catch (e) {
      _error = 'Failed to load assets: $e';
      _loading = false;
    } finally {
      notifyListeners();
    }
  }

  void updateAssetInCache(String assetNo, Map<String, dynamic> updatedData) {
    final index = _assets.indexWhere((a) => a.assetNo == assetNo);
    if (index != -1) {
      final existing = _assets[index];

      // ✅ แปลง String → Enum
      final environment = updatedData['environment'] != null
          ? Environment.fromString(updatedData['environment'].toString())
          : existing.environment;

      final mobility = updatedData['mobility'] != null
          ? Mobility.fromString(updatedData['mobility'].toString())
          : existing.mobility;

      _assets[index] = AssetModel(
        assetNo: updatedData['assetNo']?.toString() ?? existing.assetNo,
        description:
            updatedData['description']?.toString() ?? existing.description,
        assetClass:
            updatedData['assetClass']?.toString() ?? existing.assetClass,
        assetClassName: updatedData['assetClassName']?.toString() ??
            existing.assetClassName,
        capDate: updatedData['capDate']?.toString() ?? existing.capDate,
        assetOwner:
            updatedData['assetOwner']?.toString() ?? existing.assetOwner,
        costCenter:
            updatedData['costCenter']?.toString() ?? existing.costCenter,
        costCenterName: updatedData['costCenterName']?.toString() ??
            existing.costCenterName,
        mainLocation:
            updatedData['mainLocation']?.toString() ?? existing.mainLocation,
        lastLocationName: updatedData['lastLocationName']?.toString() ??
            existing.lastLocationName,

        // ✅ ใช้ Enum ที่แปลงแล้ว
        environment: environment,
        mobility: mobility,

        status: updatedData['status']?.toString() ?? existing.status,
        currentStatus:
            int.tryParse(updatedData['currentStatus']?.toString() ?? '') ??
                existing.currentStatus,
        lastImageUrl:
            updatedData['lastImageUrl']?.toString() ?? existing.lastImageUrl,
        lastCondition:
            updatedData['lastCondition']?.toString() ?? existing.lastCondition,
        remarks: updatedData['remarks']?.toString() ?? existing.remarks,
        updatedAt: existing.updatedAt,
        updatedBy: updatedData['updatedBy']?.toString() ?? existing.updatedBy,
        history: existing.history,
      );
      notifyListeners();
      _syncCache();
    }
  }

  void markAsAudited(String assetNo) {
    _auditedAssetNos = {..._auditedAssetNos, assetNo};
    notifyListeners();
  }

  Future<void> refreshSingleAsset(String assetNo) async {
    try {
      final doc = await _db
          .collection(_firestoreCollection)
          .doc(assetNo)
          .get(const GetOptions(source: Source.server));
      if (doc.exists && doc.data() != null) {
        final updated = AssetModel.fromFirestore(doc.data()!, doc.id);
        final index = _assets.indexWhere((a) => a.assetNo == assetNo);
        if (index != -1) {
          _assets[index] = updated;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('❌ refreshSingleAsset($assetNo) failed: $e');
    }
  }

  Future<void> retry() async {
    _auditedAssetNos = {};
    _auditLogsLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // ✅ ลบ Cache ของสิทธิ์ปัจจุบันเท่านั้น
    final uid = _computeUid();
    final cacheKey = '${_cacheKey}_$uid';
    final cacheTsKey = '${_cacheTimestampKey}_$uid';

    await prefs.remove(cacheKey);
    await prefs.remove(cacheTsKey);

    await loadAssetsWithCacheLogic();
    await _loadAuditedAssetNos();
  }

  Future<void> _loadAuditedAssetNos() async {
    _auditLogsLoading = true;
    final auditedSet = <String>{};
    try {
      final auditQuery = await _db
          .collectionGroup('audit_logs')
          .where('auditYear', isEqualTo: _auditYear)
          .get(const GetOptions(source: Source.server));

      for (final d in auditQuery.docs) {
        final segments = d.reference.path.split('/');
        final assetIdx = segments.indexOf('assets');
        if (assetIdx != -1 && segments.length >= assetIdx + 2) {
          auditedSet.add(segments[assetIdx + 1]);
        }
      }
      // ✅ ใช้ collectionGroup query เพียงอย่างเดียว — ไม่มี fallback N+1 loop
    } catch (e) {
      debugPrint('❌ Failed to load audited asset nos: $e');
    }
    _auditedAssetNos = auditedSet;
    _auditLogsLoading = false;
    notifyListeners();
  }

  Future<void> _syncCache() async {
  final prefs = await SharedPreferences.getInstance();
  
  final uid = _computeUid();
  final cacheKey = '${_cacheKey}_$uid';
  
  final jsonStr = jsonEncode(_assets.map((e) => e.toJson()).toList());
  await prefs.setString(cacheKey, jsonStr);
}
}
