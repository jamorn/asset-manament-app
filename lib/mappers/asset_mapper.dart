// lib/mappers/asset_mapper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';  // ✅ debugPrint
import '../models/asset_model.dart';
import '../models/enums.dart';
import '../models/audit_history.dart';  // ✅ เพิ่ม
import '../configs/default_values.dart';

class AssetMapper {  static const Map<String, String> _assetClassMap = {
    'A2000': 'Building',
    'A2004': 'Machine',
    'A2007': 'Piping',
    'A2008': 'Plant Equipment',
    'A2009': 'Tools',
    'A2011': 'Furniture',
    'A3001': 'Vehicle',
    'A3002': 'Heavy Vehicle',
    'A5004': 'ROU Vehicle',
    'A62009': 'LVA Tools',
    'A62011': 'LVA Furniture',
    'A63001': 'LVA Vehicle',
    'A9000': 'LVA Equipment',
    'A9002': 'LVA Furniture',
    'A9004': 'LVA Vehicle',
    'A9801': 'AUC Machine',
    'A9802': 'AUC Other',
    'A2005': 'Machine (POM)',
  };

  static String getShortClassName(String rawClass) {
    return _assetClassMap[rawClass] ?? 'Unknown ($rawClass)';
  }

  static DateTime? parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static AssetModel fromFirestore(Map<String, dynamic> json, String docId) {
    final assetNo = json['assetNo']?.toString() ?? docId;
    final description = json['description']?.toString() ?? DefaultValues.description;
    final assetClass = json['assetClass']?.toString() ?? '';
    final assetClassName = json['assetClassName']?.toString() ?? 
        getShortClassName(assetClass);
    final capDate = json['capDate']?.toString();
    final assetOwner = json['assetOwner']?.toString() ?? DefaultValues.owner;
    final costCenter = json['costCenter']?.toString() ?? DefaultValues.costCenter;
    final costCenterName = json['costCenterName']?.toString() ?? DefaultValues.costCenterName;
    final mainLocation = json['mainLocation']?.toString() ?? '';
    final lastLocationName = json['lastLocationName']?.toString() ?? '';
    
    final environment = Environment.fromString(
      json['environment']?.toString() ?? 'indoor'
    );
    final mobility = Mobility.fromString(
      json['mobility']?.toString() ?? 'fixed'
    );
    
    final status = json['status']?.toString() ?? '';
    final currentStatus = (json['currentStatus'] as num?)?.toInt() ?? 0;
    final lastImageUrl = json['lastImageUrl']?.toString() ?? '';
    final lastCondition = json['lastCondition']?.toString() ?? '';
    final remarks = json['remarks']?.toString();
    final updatedAt = parseTimestamp(json['updatedAt']);
    final updatedBy = json['updatedBy']?.toString() ?? '';

    // ✅ แปลง history จาก Map → List<AuditHistory>
    final List<AuditHistory> history = [];
    if (json['history'] is List) {
      final list = json['history'] as List;
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          try {
            history.add(AuditHistory.fromJson(item));
          } catch (e) {
            debugPrint('⚠️ Failed to parse history item: $e');
          }
        }
      }
    }

    return AssetModel(
      assetNo: assetNo,
      description: description,
      assetClass: assetClass,
      assetClassName: assetClassName,
      capDate: capDate,
      assetOwner: assetOwner,
      costCenter: costCenter,
      costCenterName: costCenterName,
      mainLocation: mainLocation,
      lastLocationName: lastLocationName,
      environment: environment,
      mobility: mobility,
      status: status,
      currentStatus: currentStatus,
      lastImageUrl: lastImageUrl,
      lastCondition: lastCondition,
      remarks: remarks,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      history: history,  // ✅ เปลี่ยน
    );
  }

  static Map<String, dynamic> toJson(AssetModel asset) {
    return {
      'assetNo': asset.assetNo,
      'description': asset.description,
      'assetClass': asset.assetClass,
      'assetClassName': asset.assetClassName,
      'capDate': asset.capDate,
      'assetOwner': asset.assetOwner,
      'costCenter': asset.costCenter,
      'costCenterName': asset.costCenterName,
      'mainLocation': asset.mainLocation,
      'lastLocationName': asset.lastLocationName,
      'environment': asset.environment.toJson(),
      'mobility': asset.mobility.toJson(),
      'status': asset.status,
      'currentStatus': asset.currentStatus,
      'lastImageUrl': asset.lastImageUrl,
      'lastCondition': asset.lastCondition,
      'remarks': asset.remarks,
      'updatedAt': asset.updatedAt?.toIso8601String(),
      'updatedBy': asset.updatedBy,
      // ✅ แปลง history จาก List<AuditHistory> → List<Map>
      'history': asset.history.map((h) => h.toJson()).toList(),
    };
  }

  static AssetModel fromJson(Map<String, dynamic> json) {
    return fromFirestore(json, json['assetNo']?.toString() ?? '');
  }
}