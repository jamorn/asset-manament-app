// temp_photo_model.dart

enum TempPhotoStatus { pending, merged }

class TempPhoto {
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

  TempPhoto({
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
    required this.status,
  });

  // แปลงจาก Map (Firestore Document) มาเป็น Object
  factory TempPhoto.fromMap(Map<String, dynamic> map, String id) {
    return TempPhoto(
      tempId: id,
      referenceAssetNo: map['referenceAssetNo'] ?? '',
      description: map['description'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      location: map['location'] ?? '',
      capturedAt: map['capturedAt'] != null 
          ? (map['capturedAt'] as DateTime) // หรือดึงผ่าน Timestamp.toDate() ใน Cloud Firestore
          : null,
      assetClass: map['assetClass'] ?? '',
      assetClassName: map['assetClassName'] ?? '',
      costCenter: map['costCenter'] ?? '',
      costCenterName: map['costCenterName'] ?? '',
      status: map['status'] == 'merged' ? TempPhotoStatus.merged : TempPhotoStatus.pending,
    );
  }

  // แปลงจาก Object เป็น Map เพื่อบันทึกลงฐานข้อมูล
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

  /// 🆕 fromJson alias — for consistency with AssetModel.fromJson
  factory TempPhoto.fromJson(Map<String, dynamic> json) {
    return TempPhoto.fromMap(json, json['tempId']?.toString() ?? '');
  }
}

class AcceptResult {
  final bool ok;
  final String message;

  AcceptResult({required this.ok, required this.message});
}