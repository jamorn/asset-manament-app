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
  }) async {
    _submitStatus = SubmitStatus.submitting;
    _submitError = null;
    notifyListeners();

    try {
      final String imageName = '${asset.assetNo}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child('artifacts/irpc-asset-audit/audit_photos/$imageName');
      await storageRef.putFile(imageFile);
      final String imageUrl = await storageRef.getDownloadURL();

      final docRef = _db
          .collection('artifacts/irpc-asset-audit/public/data/assets')
          .doc(asset.assetNo)
          .collection('audit_logs')
          .doc();

      await docRef.set({
        'assetNo': asset.assetNo,
        'location': location,
        'condition': condition,
        'imageUrl': imageUrl,
        'auditYear': auditYear,
        'auditorEmail': auditorEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _db
          .collection('artifacts/irpc-asset-audit/public/data/assets')
          .doc(asset.assetNo)
          .update({
        'lastLocationName': location,
        'lastCondition': condition,
        'lastImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': auditorEmail,
      });

      _submitStatus = SubmitStatus.success;
      return true;
    } catch (e) {
      print('Audit submit failed: $e');
      _submitError = e.toString();
      _submitStatus = SubmitStatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }
}
