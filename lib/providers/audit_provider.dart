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

  SubmitStatus _submitStatus = SubmitStatus.idle;
  String? _submitError;

  SubmitStatus get submitStatus => _submitStatus;
  String? get submitError => _submitError;

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
      final String imageName =
          '${asset.assetNo}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef =
          _storage.ref().child('${FirestorePath.auditPhotos}/$imageName');
      await storageRef.putFile(imageFile);
      final String imageUrl = await storageRef.getDownloadURL();

      final docRef = _db
          .collection(FirestorePath.assets)
          .doc(asset.assetNo)
          .collection('audit_logs')
          .doc();

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
      await docRef.set(auditLogData);

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

      await _db
          .collection(FirestorePath.assets)
          .doc(asset.assetNo)
          .update(updateData);

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
