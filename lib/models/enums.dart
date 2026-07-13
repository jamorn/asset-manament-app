// lib/models/enums.dart

/// สภาพแวดล้อมของครุภัณฑ์
enum Environment {
  indoor('indoor'),
  outdoor('outdoor');

  final String value;
  const Environment(this.value);

  /// แสดงผลข้อความที่อ่านง่าย
  String get display {
    switch (this) {
      case Environment.indoor:
        return '🪟 Indoor';
      case Environment.outdoor:
        return '🌤️ Outdoor';
    }
  }

  /// แปลงจาก String → Enum
  static Environment fromString(String value) {
    switch (value.toLowerCase()) {
      case 'indoor':
        return Environment.indoor;
      case 'outdoor':
        return Environment.outdoor;
      default:
        return Environment.indoor; // ✅ ค่าเริ่มต้น
    }
  }

  /// แปลง Enum → String
  String toJson() => value;
}

/// ลักษณะการเคลื่อนที่ของครุภัณฑ์
enum Mobility {
  fixed('fixed'),
  portable('portable');

  final String value;
  const Mobility(this.value);

  /// แสดงผลข้อความที่อ่านง่าย
  String get display {
    switch (this) {
      case Mobility.fixed:
        return '🔒 Fixed';
      case Mobility.portable:
        return '📦 Portable';
    }
  }

  /// แปลงจาก String → Enum
  static Mobility fromString(String value) {
    switch (value.toLowerCase()) {
      case 'fixed':
        return Mobility.fixed;
      case 'portable':
        return Mobility.portable;
      default:
        return Mobility.fixed; // ✅ ค่าเริ่มต้น
    }
  }

  /// แปลง Enum → String
  String toJson() => value;
}

/// สถานะการตรวจสอบ
enum AuditStatus {
  pending('pending'),
  audited('audited');

  final String value;
  const AuditStatus(this.value);

  static AuditStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'audited':
        return AuditStatus.audited;
      default:
        return AuditStatus.pending;
    }
  }

  String toJson() => value;
}