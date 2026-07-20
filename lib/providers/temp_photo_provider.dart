// lib/providers/temp_photo_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/temp_photo_model.dart';
import '../services/rbac_service.dart';
import '../configs/constants.dart';

enum SubmitStatus { idle, submitting, success, error }

class TempPhotoProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<TempPhoto> _tempPhotos = [];
  bool _loading = false;
  SubmitStatus _submitStatus = SubmitStatus.idle;
  String? _submitError;

  String? _role;
  List<String>? _allowedCostCenters;

  List<TempPhoto> get tempPhotos => _tempPhotos;
  bool get loading => _loading;
  SubmitStatus get submitStatus => _submitStatus;
  String? get submitError => _submitError;

  List<TempPhoto> get visibleTempPhotos => RbacService.filterTempPhotos(
      _tempPhotos,
      RBACContext(
        role: _role,
        allowedCostCenters: _allowedCostCenters,
      ));

  static const String _collectionPath = FirestorePath.tempPhotos;
  static const String _storageTempPath = FirestorePath.tempPhotosStorage;
  void updateRbacContext(String? role, List<String>? allowedCostCenters) {
    _role = role;
    _allowedCostCenters = allowedCostCenters;
    notifyListeners();
  }

  Future<void> loadTempPhotos() async {
    _loading = true;
    notifyListeners();
    try {
      final snapshot = await _db
          .collection(_collectionPath)
          .orderBy('capturedAt', descending: true)
          .get();
      _tempPhotos = snapshot.docs
          .map((doc) => TempPhoto.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Load temp photos failed: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> saveTempPhoto({
    required String referenceAssetNo,
    required String description,
    required String location,
    required File imageFile,
    required String assetClass,
    required String assetClassName,
    required String costCenter,
    required String costCenterName,
  }) async {
    _submitStatus = SubmitStatus.submitting;
    _submitError = null;
    notifyListeners();
    try {
      final String tempId = _db.collection(_collectionPath).doc().id;
      final storageRef = _storage.ref().child('$_storageTempPath/$tempId.jpg');
      await storageRef.putFile(imageFile);
      final String photoUrl = await storageRef.getDownloadURL();
      final Map<String, dynamic> data = {
        'tempId': tempId,
        'referenceAssetNo': referenceAssetNo,
        'description': description,
        'photoUrl': photoUrl,
        'location': location,
        'capturedAt': FieldValue.serverTimestamp(),
        'assetClass': assetClass,
        'assetClassName': assetClassName,
        'costCenter': costCenter,
        'costCenterName': costCenterName,
        'status': 'pending',
      };
      await _db.collection(_collectionPath).doc(tempId).set(data);
      _tempPhotos.insert(
          0,
          TempPhoto(
            tempId: tempId,
            referenceAssetNo: referenceAssetNo,
            description: description,
            photoUrl: photoUrl,
            location: location,
            capturedAt: DateTime.now(),
            assetClass: assetClass,
            assetClassName: assetClassName,
            costCenter: costCenter,
            costCenterName: costCenterName,
            status: TempPhotoStatus.pending,
          ));
      _submitStatus = SubmitStatus.success;
      return true;
    } catch (e) {
      _submitError = e.toString();
      _submitStatus = SubmitStatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<AcceptResult> acceptTempPhotoAsAsset({
    required String tempId,
    required String newAssetNo,
  }) async {
    _submitStatus = SubmitStatus.submitting;
    _submitError = null;
    notifyListeners();
    try {
      final existing = _tempPhotos.firstWhere((t) => t.tempId == tempId);
      final assetRef = _db.collection(FirestorePath.assets).doc(newAssetNo);
      await assetRef.set({
        'assetNo': newAssetNo,
        'description': existing.description,
        'lastLocationName': existing.location,
        'lastCondition': 'GOOD',
        'lastImageUrl': existing.photoUrl,
        'environment': 'INDOOR',
        'mobility': 'FIXED',
        'remarks': 'Created from temp photo: $tempId',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': 'system',
        'assetClass': existing.assetClass,
        'assetClassName': existing.assetClassName,
        'costCenter': existing.costCenter,
        'costCenterName': existing.costCenterName,
      });
      await _db.collection(_collectionPath).doc(tempId).update({
        'status': 'merged',
        'mergedAssetNo': newAssetNo,
      });
      _tempPhotos = _tempPhotos
          .map((t) => t.tempId == tempId
              ? TempPhoto(
                  tempId: t.tempId,
                  referenceAssetNo: t.referenceAssetNo,
                  description: t.description,
                  photoUrl: t.photoUrl,
                  location: t.location,
                  capturedAt: t.capturedAt,
                  assetClass: t.assetClass,
                  assetClassName: t.assetClassName,
                  costCenter: t.costCenter,
                  costCenterName: t.costCenterName,
                  status: TempPhotoStatus.merged,
                )
              : t)
          .toList();
      _submitStatus = SubmitStatus.success;
      notifyListeners();
      return AcceptResult(ok: true, message: 'สร้าง Asset $newAssetNo สำเร็จ!');
    } catch (e) {
      _submitError = e.toString();
      _submitStatus = SubmitStatus.error;
      notifyListeners();
      return AcceptResult(ok: false, message: 'เกิดข้อผิดพลาด: $e');
    }
  }

  Future<bool> updateTempPhoto({
    required String tempId,
    required String referenceAssetNo,
    required String description,
    required String location,
    File? imageFile,
    required String assetClass,
    required String assetClassName,
    required String costCenter,
    required String costCenterName,
  }) async {
    _submitStatus = SubmitStatus.submitting;
    _submitError = null;
    notifyListeners();
    try {
      String photoUrl = '';
      final existing = _tempPhotos.firstWhere((t) => t.tempId == tempId);
      if (imageFile != null) {
        try {
          await _storage.ref().child('$_storageTempPath/$tempId.jpg').delete();
        } catch (_) {}
        final storageRef =
            _storage.ref().child('$_storageTempPath/$tempId.jpg');
        await storageRef.putFile(imageFile);
        photoUrl = await storageRef.getDownloadURL();
      } else {
        photoUrl = existing.photoUrl;
      }
      await _db.collection(_collectionPath).doc(tempId).update({
        'referenceAssetNo': referenceAssetNo,
        'description': description,
        'photoUrl': photoUrl,
        'location': location,
        'assetClass': assetClass,
        'assetClassName': assetClassName,
        'costCenter': costCenter,
        'costCenterName': costCenterName,
      });
      _tempPhotos = _tempPhotos
          .map((t) => t.tempId == tempId
              ? TempPhoto(
                  tempId: t.tempId,
                  referenceAssetNo: referenceAssetNo,
                  description: description,
                  photoUrl: photoUrl,
                  location: location,
                  capturedAt: DateTime.now(),
                  assetClass: assetClass,
                  assetClassName: assetClassName,
                  costCenter: costCenter,
                  costCenterName: costCenterName,
                  status: t.status,
                )
              : t)
          .toList();
      _submitStatus = SubmitStatus.success;
      return true;
    } catch (e) {
      _submitError = e.toString();
      _submitStatus = SubmitStatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> deleteTempPhoto(String tempId) async {
    try {
      try {
        await _storage.ref().child('$_storageTempPath/$tempId.jpg').delete();
      } catch (_) {}
      await _db.collection(_collectionPath).doc(tempId).delete();
      _tempPhotos.removeWhere((t) => t.tempId == tempId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Delete temp photo failed: $e');
      return false;
    }
  }

  Future<void> refresh() async {
    await loadTempPhotos();
  }
}
