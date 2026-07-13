// lib/models/asset_model.dart
import 'package:equatable/equatable.dart';
import '../mappers/asset_mapper.dart';
import 'enums.dart';
import 'audit_history.dart';  // ✅ เพิ่ม

class AssetModel extends Equatable {
  final String assetNo;
  final String description;
  final String assetClass;
  final String assetClassName;
  final String? capDate;
  final String assetOwner;
  final String costCenter;
  final String costCenterName;
  final String mainLocation;
  final String lastLocationName;
  
  final Environment environment;
  final Mobility mobility;
  
  final String status;
  final int currentStatus;
  final String lastImageUrl;
  final String lastCondition;
  final String? remarks;
  final DateTime? updatedAt;
  final String updatedBy;
  
  // ✅ เปลี่ยนเป็น List<AuditHistory>
  final List<AuditHistory> history;

  const AssetModel({
    required this.assetNo,
    required this.description,
    required this.assetClass,
    required this.assetClassName,
    this.capDate,
    required this.assetOwner,
    required this.costCenter,
    required this.costCenterName,
    required this.mainLocation,
    required this.lastLocationName,
    required this.environment,
    required this.mobility,
    required this.status,
    required this.currentStatus,
    required this.lastImageUrl,
    required this.lastCondition,
    this.remarks,
    this.updatedAt,
    required this.updatedBy,
    required this.history,  // ✅ เปลี่ยน
  });

  factory AssetModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return AssetMapper.fromFirestore(json, docId);
  }

  Map<String, dynamic> toJson() {
    return AssetMapper.toJson(this);
  }

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetMapper.fromJson(json);
  }

  bool get isAudited => lastCondition.isNotEmpty && lastImageUrl.isNotEmpty;

  String get environmentDisplay {
    switch (environment) {
      case Environment.indoor:
        return '🪟 Indoor';
      case Environment.outdoor:
        return '🌤️ Outdoor';
    }
  }

  String get mobilityDisplay {
    switch (mobility) {
      case Mobility.fixed:
        return '🔒 Fixed';
      case Mobility.portable:
        return '📦 Portable';
    }
  }

  @override
  List<Object?> get props => [
    assetNo,
    description,
    assetClass,
    assetClassName,
    capDate,
    assetOwner,
    costCenter,
    costCenterName,
    mainLocation,
    lastLocationName,
    environment,
    mobility,
    status,
    currentStatus,
    lastImageUrl,
    lastCondition,
    remarks,
    updatedAt,
    updatedBy,
    history,  // ✅ เปลี่ยน
  ];

  @override
  String toString() {
    return 'AssetModel(assetNo: $assetNo, description: $description, costCenter: $costCenter)';
  }
}