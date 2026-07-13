// lib/models/audit_history.dart
import 'package:equatable/equatable.dart';

/// AuditHistory: บันทึกการเปลี่ยนแปลงของ Asset แต่ละครั้ง
class AuditHistory extends Equatable {
  final String action;          // 'UPDATE', 'CREATE', 'AUDIT'
  final String performedBy;     // อีเมลผู้ทำ
  final DateTime timestamp;     // เวลาที่ทำ
  final Map<String, dynamic> changes; // การเปลี่ยนแปลง

  const AuditHistory({
    required this.action,
    required this.performedBy,
    required this.timestamp,
    required this.changes,
  });

  /// แปลงจาก Map (Firestore)
  factory AuditHistory.fromJson(Map<String, dynamic> json) {
    return AuditHistory(
      action: json['action']?.toString() ?? 'UNKNOWN',
      performedBy: json['performedBy']?.toString() ?? '',
      timestamp: json['timestamp'] is DateTime
          ? json['timestamp']
          : DateTime.tryParse(json['timestamp']?.toString() ?? '') 
            ?? DateTime.now(),
      changes: Map<String, dynamic>.from(json['changes'] ?? {}),
    );
  }

  /// แปลงเป็น Map (สำหรับ Firestore)
  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'performedBy': performedBy,
      'timestamp': timestamp.toIso8601String(),
      'changes': changes,
    };
  }

  @override
  List<Object?> get props => [
    action,
    performedBy,
    timestamp,
    changes,
  ];

  @override
  String toString() {
    return 'AuditHistory(action: $action, by: $performedBy, at: $timestamp)';
  }
}