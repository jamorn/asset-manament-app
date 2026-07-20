// lib/constants/default_values.dart

/// ค่าเริ่มต้นที่ใช้ในแอป
class DefaultValues {
  // ===== Asset Defaults =====
  static const String description = '(ไม่มีคำอธิบาย)';
  static const String unknown = 'unknown';
  static const String environment = 'unknown';
  static const String mobility = 'unknown';
  static const String status = 'unknown';
  static const String owner = '';
  static const String costCenter = '';
  static const String costCenterName = '';
  static const String location = '';
  static const String imageUrl = '';
  static const String condition = 'ใช้งานปกติ (Normal)';
  static const String updatedBy = '';
  static const int currentStatus = 0;
  
  // ===== Audit Defaults =====
  static String get auditYear => DateTime.now().year.toString();
  static const String auditor = 'unknown';
  
  // ===== Temp Photo Defaults =====
  static const String tempDescription = 'Temp Photo';
  static const String tempLocation = 'Unknown Location';
}
