import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asset_model.dart';

class AssetProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<AssetModel> _assets = [];
  bool _loading = true;
  String? _error;
  DateTime? _lastFetched;

    List<AssetModel> get assets => _assets;
  bool get loading => _loading;
  String? get error => _error;
  DateTime? get lastFetched => _lastFetched;

    // RBAC context (เก็บไว้ใช้ใน future เช่น role-based UI)
  // ignore: unused_field
  String? _role;
  // ignore: unused_field
  List<String>? _allowedCostCenters;

  // Dashboard / filter state
  String _auditYear = DateTime.now().year.toString();
  Set<String> _auditedAssetNos = {};
  bool _auditLogsLoading = true;

  // Extra getters for Dashboard
  String get auditYear => _auditYear;
  Set<String> get auditedAssetNos => _auditedAssetNos;
  bool get auditLogsLoading => _auditLogsLoading;
  int get totalCount => _assets.length;
  int get auditedCount =>
      _assets.where((a) => _auditedAssetNos.contains(a.assetNo)).length;

  static const String _cacheKey = 'assetapp-assets-cache';
  static const String _cacheTimestampKey = 'assetapp-assets-cache-ts';
  static const int _cacheTtlMs = 5 * 60 * 1000;

  static const String _firestoreCollection =
      'artifacts/irpc-asset-audit/public/data/assets';

  AssetProvider() {
    _init();
  }

  /// RBAC context updater (called from ProxyProvider in main.dart)
  void updateRbacContext(String? role, List<String>? allowedCostCenters) {
    _role = role;
    _allowedCostCenters = allowedCostCenters;
    notifyListeners();
  }

  /// เปลี่ยนปี audit และโหลด audit logs ใหม่
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

  // ฟังก์ชันหลักดักจับการดึงข้อมูลและคุมแคช
  Future<void> loadAssetsWithCacheLogic() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);
      final cachedTsStr = prefs.getString(_cacheTimestampKey);

      if (cachedJson != null && cachedTsStr != null) {
        final cachedTs = DateTime.parse(cachedTsStr);
        final age = DateTime.now().difference(cachedTs).inMilliseconds;

        if (age < _cacheTtlMs) {
          final List<dynamic> decoded = jsonDecode(cachedJson);
          _assets = decoded.map((item) => AssetModel.fromJson(item as Map<String, dynamic>)).toList();
          _lastFetched = cachedTs;
          _loading = false;
          notifyListeners();
          return;
        }
      }

      // หากแคชหมดอายุหรือเป็นเครื่องใหม่ -> บินไปดึงสดจาก Cloud Firestore
      await fetchAssetsFromServer();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAssetsFromServer() async {
    try {
      // ดึงจากคอลเลกชันหลัก เรียงลำดับตามความต้องการเดิม
            final snapshot = await _db.collection(_firestoreCollection).orderBy('assetNo').get();

      _assets = snapshot.docs.map((doc) {
        return AssetModel.fromFirestore(doc.data(), doc.id);
      }).toList();

      _lastFetched = DateTime.now();
      _loading = false;

      // บันทึกความจำลง Local Storage ทันที
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_assets.map((e) => e.toJson()).toList());
      await prefs.setString(_cacheKey, jsonStr);
      await prefs.setString(_cacheTimestampKey, _lastFetched!.toIso8601String());

    } catch (e) {
      _error = 'Failed to load assets: $e';
      _loading = false;
    } finally {
      notifyListeners();
    }
  }

    /// อัปเดต asset ใน cache แบบ optimistic (partial merge)
  void updateAssetInCache(String assetNo, Map<String, dynamic> updatedData) {
    final index = _assets.indexWhere((a) => a.assetNo == assetNo);

    if (index != -1) {
      final existing = _assets[index];

      _assets[index] = AssetModel(
        assetNo: updatedData['assetNo']?.toString() ?? existing.assetNo,
        description: updatedData['description']?.toString() ?? existing.description,
        assetClass: updatedData['assetClass']?.toString() ?? existing.assetClass,
        assetClassName: updatedData['assetClassName']?.toString() ?? existing.assetClassName,
        capDate: updatedData['capDate']?.toString() ?? existing.capDate,
        assetOwner: updatedData['assetOwner']?.toString() ?? existing.assetOwner,
        costCenter: updatedData['costCenter']?.toString() ?? existing.costCenter,
        costCenterName: updatedData['costCenterName']?.toString() ?? existing.costCenterName,
        mainLocation: updatedData['mainLocation']?.toString() ?? existing.mainLocation,
        lastLocationName: updatedData['lastLocationName']?.toString() ?? existing.lastLocationName,
        environment: updatedData['environment']?.toString() ?? existing.environment,
        mobility: updatedData['mobility']?.toString() ?? existing.mobility,
        status: updatedData['status']?.toString() ?? existing.status,
        currentStatus: int.tryParse(updatedData['currentStatus']?.toString() ?? '') ?? existing.currentStatus,
        lastImageUrl: updatedData['lastImageUrl']?.toString() ?? existing.lastImageUrl,
        lastCondition: updatedData['lastCondition']?.toString() ?? existing.lastCondition,
        remarks: updatedData['remarks']?.toString() ?? existing.remarks,
        updatedAt: existing.updatedAt,
        updatedBy: updatedData['updatedBy']?.toString() ?? existing.updatedBy,
        history: existing.history,
      );

      notifyListeners();
      _syncCache();
    }
  }

  /// mark asset as audited (optimistic)
  void markAsAudited(String assetNo) {
    _auditedAssetNos = {..._auditedAssetNos, assetNo};
    notifyListeners();
  }

  /// retry — reload จาก Firestore
  Future<void> retry() async {
    _auditedAssetNos = {};
    _auditLogsLoading = true;
    notifyListeners();
    await loadAssetsWithCacheLogic();
    await _loadAuditedAssetNos();
  }

  /// โหลด audit logs เพื่อหา assetNo ที่ audit แล้ว
  Future<void> _loadAuditedAssetNos() async {
    _auditLogsLoading = true;
    final auditedSet = <String>{};

    try {
      final auditQuery = await _db
          .collectionGroup('audit_logs')
          .where('auditYear', isEqualTo: _auditYear)
          .get();

      for (final d in auditQuery.docs) {
        final segments = d.reference.path.split('/');
        final assetIdx = segments.indexOf('assets');
        if (assetIdx != -1 && segments.length >= assetIdx + 2) {
          auditedSet.add(segments[assetIdx + 1]);
        }
      }

      // fallback: ถ้า collectionGroup ไม่เจอ ให้ loop เฉพาะ
      if (auditedSet.isEmpty && _assets.isNotEmpty) {
        for (int i = 0; i < _assets.length; i += 10) {
          for (final asset in _assets.skip(i).take(10)) {
            try {
              final logSnap = await _db
                  .collection('$_firestoreCollection/${asset.assetNo}/audit_logs')
                  .where('auditYear', isEqualTo: _auditYear)
                  .limit(1)
                  .get();
              if (logSnap.docs.isNotEmpty) {
                auditedSet.add(asset.assetNo);
              }
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to load audited asset nos: $e');
    }

    _auditedAssetNos = auditedSet;
    _auditLogsLoading = false;
    notifyListeners();
  }

  Future<void> _syncCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_assets.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, jsonStr);
  }
}