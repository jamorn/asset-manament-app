// lib/models/audit_data.dart
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

/// AuditData: ใช้เก็บข้อมูล Audit ขณะ Offline
/// ก่อนที่จะ Sync ขึ้น Firebase
@HiveType(typeId: 0)
class AuditData extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String assetNo;
  
  @HiveField(2)
  final String location;
  
  @HiveField(3)
  final String condition;
  
  @HiveField(4)
  final String imageUrl;
  
  @HiveField(5)
  final String auditorEmail;
  
  @HiveField(6)
  final DateTime timestamp;
  
  @HiveField(7)
  final String? remarks;
  
  @HiveField(8)
  final String? environment;
  
  @HiveField(9)
  final String? mobility;

  const AuditData({
    required this.id,
    required this.assetNo,
    required this.location,
    required this.condition,
    required this.imageUrl,
    required this.auditorEmail,
    required this.timestamp,
    this.remarks,
    this.environment,
    this.mobility,
  });

  /// แปลงจาก JSON
  factory AuditData.fromJson(Map<String, dynamic> json) {
    return AuditData(
      id: json['id']?.toString() ?? 
          'audit_${DateTime.now().millisecondsSinceEpoch}',
      assetNo: json['assetNo']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      condition: json['condition']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      auditorEmail: json['auditorEmail']?.toString() ?? '',
      timestamp: json['timestamp'] is DateTime
          ? json['timestamp']
          : DateTime.tryParse(json['timestamp']?.toString() ?? '') 
            ?? DateTime.now(),
      remarks: json['remarks']?.toString(),
      environment: json['environment']?.toString(),
      mobility: json['mobility']?.toString(),
    );
  }

  /// แปลงเป็น JSON (สำหรับส่งขึ้น Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetNo': assetNo,
      'location': location,
      'condition': condition,
      'imageUrl': imageUrl,
      'auditorEmail': auditorEmail,
      'timestamp': timestamp.toIso8601String(),
      'remarks': remarks,
      'environment': environment,
      'mobility': mobility,
    };
  }

  @override
  List<Object?> get props => [
    id,
    assetNo,
    location,
    condition,
    imageUrl,
    auditorEmail,
    timestamp,
    remarks,
    environment,
    mobility,
  ];

  @override
  String toString() {
    return 'AuditData(assetNo: $assetNo, location: $location, at: $timestamp)';
  }
}

/// Hive Adapter สำหรับ AuditData (ใช้ใน main.dart)
class AuditDataAdapter extends TypeAdapter<AuditData> {
  @override
  final int typeId = 0;

  @override
  AuditData read(BinaryReader reader) {
    final map = reader.readMap();
    return AuditData.fromJson(map.cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, AuditData obj) {
    writer.writeMap(obj.toJson());
  }
}