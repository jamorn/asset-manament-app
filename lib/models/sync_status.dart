// lib/models/sync_status.dart
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

@HiveType(typeId: 1)
class SyncStatus extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final int total;
  
  @HiveField(2)
  final int synced;
  
  @HiveField(3)
  final int failed;
  
  @HiveField(4)
  final int remaining;
  
  @HiveField(5)
  final double progress;
  
  @HiveField(6)
  final DateTime lastSyncAt;
  
  @HiveField(7)
  final bool isCompleted;
  
  @HiveField(8)
  final List<String> failedIds;

  const SyncStatus({
    required this.id,
    this.total = 0,
    this.synced = 0,
    this.failed = 0,
    this.remaining = 0,
    this.progress = 0.0,
    required this.lastSyncAt,
    this.isCompleted = false,
    this.failedIds = const [],
  });
  
  double get progressPercentage => progress * 100;
  
  String get statusText {
    if (isCompleted) return '✅ Sync เสร็จสมบูรณ์';
    if (total == 0) return '📭 ไม่มีข้อมูล';
    return '🔄 ${synced + failed}/$total (${progressPercentage.toStringAsFixed(1)}%)';
  }
  
  String get detailText {
    if (isCompleted) {
      return failed > 0 
          ? '⚠️ สำเร็จ $synced รายการ, ล้มเหลว $failed รายการ'
          : '✅ สำเร็จทั้งหมด $synced รายการ';
    }
    return '📤 ส่งแล้ว $synced รายการ, เหลือ $remaining รายการ';
  }
  
  SyncStatus copyWith({
    int? total,
    int? synced,
    int? failed,
    int? remaining,
    double? progress,
    DateTime? lastSyncAt,
    bool? isCompleted,
    List<String>? failedIds,
  }) {
    return SyncStatus(
      id: id,
      total: total ?? this.total,
      synced: synced ?? this.synced,
      failed: failed ?? this.failed,
      remaining: remaining ?? this.remaining,
      progress: progress ?? this.progress,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      isCompleted: isCompleted ?? this.isCompleted,
      failedIds: failedIds ?? this.failedIds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    total,
    synced,
    failed,
    remaining,
    progress,
    lastSyncAt,
    isCompleted,
    failedIds,
  ];

  @override
  String toString() {
    return 'SyncStatus(id: $id, progress: ${(progress * 100).toStringAsFixed(1)}%)';
  }
}

// ✅ Hive Adapter สำหรับ SyncStatus
class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 1;

  @override
  SyncStatus read(BinaryReader reader) {
    return SyncStatus(
      id: reader.readString(),
      total: reader.readInt(),
      synced: reader.readInt(),
      failed: reader.readInt(),
      remaining: reader.readInt(),
      progress: reader.readDouble(),
      lastSyncAt: DateTime.parse(reader.readString()),
      isCompleted: reader.readBool(),
      failedIds: reader.readList().cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.total);
    writer.writeInt(obj.synced);
    writer.writeInt(obj.failed);
    writer.writeInt(obj.remaining);
    writer.writeDouble(obj.progress);
    writer.writeString(obj.lastSyncAt.toIso8601String());
    writer.writeBool(obj.isCompleted);
    writer.writeList(obj.failedIds);
  }
}