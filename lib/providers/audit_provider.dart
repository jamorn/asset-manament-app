import '../configs/constants.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/asset_model.dart';
import 'temp_photo_provider.dart';

class AuditProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // RBAC context
  String? _role;
  List<String>? _allowedCostCenters;

  SubmitStatus _submitStatus = SubmitStatus.idle;
  String? _submitError;

  SubmitStatus get submitStatus => _submitStatus;
  String? get submitError => _submitError;

  void updateRbacContext(String? role, List<String>? allowedCostCenters) {
    _role = role;
    _allowedCostCenters = allowedCostCenters;
  }

  bool _canAuditAsset(AssetModel asset) {
    // owner สามารถ audit ได้ทั้งหมด
    if (_role == 'owner') return true;
    // ถ้าไม่มี allowedCostCenters → ไม่มีสิทธิ์
    if (_allowedCostCenters == null || _allowedCostCenters!.isEmpty) return false;
    // ตรวจสอบว่า asset อยู่ใน cost center ที่มีสิทธิ์
    return _allowedCostCenters!.contains(asset.costCenter);
  }

  Future<bool> submitAudit({
    required AssetModel asset,
    required String location,
    required String condition,
    required File imageFile,
    required String auditYear,
    required String auditorEmail,
    String? environment,
    String? mobility,
    String? remarks,
  }) async {
    _submitStatus = SubmitStatus.submitting;
    _submitError = null;
    notifyListeners();

    try {
      // 0) ตรวจสอบ permission ก่อน
      if (!_canAuditAsset(asset)) {
        _submitError = 'You do not have permission to audit this asset';
        _submitStatus = SubmitStatus.error;
        return false;
      }

      // 1) อัปโหลดรูปไปยัง Firebase Storage (ยังไม่มี transaction)
      final String imageName =
          '${asset.assetNo}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef =
          _storage.ref().child('${FirestorePath.auditPhotos}/$imageName');
      await storageRef.putFile(imageFile);
      final String imageUrl = await storageRef.getDownloadURL();

      final assetRef = _db.collection(FirestorePath.assets).doc(asset.assetNo);
      final auditLogRef = assetRef.collection('audit_logs').doc();

      // 2) ใช้ runTransaction เพื่อให้ audit log + asset update atomic
      await _db.runTransaction((transaction) async {
        final Map<String, dynamic> auditLogData = {
          'assetNo': asset.assetNo,
          'location': location,
          'condition': condition,
          'imageUrl': imageUrl,
          'auditYear': auditYear,
          'auditorEmail': auditorEmail,
          'timestamp': FieldValue.serverTimestamp(),
        };
        if (environment != null && environment.isNotEmpty) {
          auditLogData['environment'] = environment;
        }
        if (mobility != null && mobility.isNotEmpty) {
          auditLogData['mobility'] = mobility;
        }
        if (remarks != null && remarks.isNotEmpty) {
          auditLogData['remarks'] = remarks;
        }
        transaction.set(auditLogRef, auditLogData);

        final Map<String, dynamic> updateData = {
          'lastLocationName': location,
          'lastCondition': condition,
          'lastImageUrl': imageUrl,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': auditorEmail,
        };
        if (environment != null && environment.isNotEmpty) {
          updateData['environment'] = environment;
        }
        if (mobility != null && mobility.isNotEmpty) {
          updateData['mobility'] = mobility;
        }
        if (remarks != null && remarks.isNotEmpty) {
          updateData['remarks'] = remarks;
        }
        transaction.update(assetRef, updateData);
      });

      _submitStatus = SubmitStatus.success;
      return true;
    } catch (e) {
      debugPrint('Audit submit failed: $e');
      _submitError = e.toString();
      _submitStatus = SubmitStatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }
}
