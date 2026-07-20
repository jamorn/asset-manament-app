// lib/models/temp_photo_model.dart
import 'package:equatable/equatable.dart';
import '../mappers/asset_mapper.dart';

enum TempPhotoStatus { pending, merged }

class TempPhoto extends Equatable {
  final String tempId;
  final String referenceAssetNo;
  final String description;
  final String photoUrl;
  final String location;
  final DateTime? capturedAt;
  final String assetClass;
  final String assetClassName;
  final String costCenter;
  final String costCenterName;
  final TempPhotoStatus status;

  const TempPhoto({
    required this.tempId,
    required this.referenceAssetNo,
    required this.description,
    required this.photoUrl,
    required this.location,
    this.capturedAt,
    required this.assetClass,
    required this.assetClassName,
    required this.costCenter,
    required this.costCenterName,
    this.status = TempPhotoStatus.pending,
  });

  factory TempPhoto.fromMap(Map<String, dynamic> map, String id) {
    // ✅ ใส่ validation
    if (map['referenceAssetNo'] == null || 
        map['referenceAssetNo'].toString().isEmpty) {
      throw ArgumentError('referenceAssetNo is required');
    }

    return TempPhoto(
      tempId: id,
      referenceAssetNo: map['referenceAssetNo']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      photoUrl: map['photoUrl']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      capturedAt: AssetMapper.parseTimestamp(map['capturedAt']),
      assetClass: map['assetClass']?.toString() ?? '',
      assetClassName: map['assetClassName']?.toString() ?? '',
      costCenter: map['costCenter']?.toString() ?? '',
      costCenterName: map['costCenterName']?.toString() ?? '',
      status: map['status'] == 'merged' 
          ? TempPhotoStatus.merged 
          : TempPhotoStatus.pending,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'referenceAssetNo': referenceAssetNo,
      'description': description,
      'photoUrl': photoUrl,
      'location': location,
      'capturedAt': capturedAt,
      'assetClass': assetClass,
      'assetClassName': assetClassName,
      'costCenter': costCenter,
      'costCenterName': costCenterName,
      'status': status == TempPhotoStatus.merged ? 'merged' : 'pending',
    };
  }

    factory TempPhoto.fromJson(Map<String, dynamic> json) {
    final id = json['tempId']?.toString() ?? '';
    if (id.isEmpty) {
      throw ArgumentError('tempId is required in JSON');
    }
    return TempPhoto.fromMap(json, id);
  }

  @override
  List<Object?> get props => [
    tempId,
    referenceAssetNo,
    description,
    photoUrl,
    location,
    capturedAt,
    assetClass,
    assetClassName,
    costCenter,
    costCenterName,
    status,
  ];

  @override
  String toString() => 
      'TempPhoto(tempId: $tempId, referenceAssetNo: $referenceAssetNo)';
}

class AcceptResult extends Equatable {
  final bool ok;
  final String message;

  // ✅ เพิ่ม const
  const AcceptResult({required this.ok, required this.message});

  @override
  List<Object?> get props => [ok, message];
}