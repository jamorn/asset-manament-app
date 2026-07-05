// 1. แปลง RoutePolicy จากแบบข้อความธรรมดา ให้เป็น Enum ที่พิมพ์สัญกรณ์พิมพ์ผิดไม่ได้ (Type-safe)
enum RoutePolicy { public, hybrid, private }

// 2. ขึ้นโมเดล RouteConfig ล้อตามอินเตอร์เฟสของ TypeScriptเดิม
class RouteConfig {
  final String name;       // ใช้เป็นชื่อเรียกแทน PathName บนหน้าเว็บ
  final String label;
  final RoutePolicy policy;

  const RouteConfig({
    required this.name,
    required this.label,
    required this.policy,
  });
}

// 3. กำหนดสิทธิ์และหน้าแอปทั้งหมดไว้ที่นี่ที่เดียว (ลอกโครงมาจาก Next.js เป๊ะๆ)
class AppRoutes {
  static const String survey = 'survey';
  static const String dashboard = 'dashboard';
  static const String search = 'search';

  static const List<RouteConfig> routes = [
    RouteConfig(name: survey, label: '📋 Asset Survey', policy: RoutePolicy.private),
    RouteConfig(name: dashboard, label: '📊 Dashboard', policy: RoutePolicy.public),
    RouteConfig(name: search, label: '🔍 Search', policy: RoutePolicy.public),
  ];

  /// 4. ฟังก์ชันคำนวณสิทธิ์ Cost Centers ที่อนุญาตให้ดึงข้อมูลมาแสดงผลในหน้าจอของ Flutter
  /// พอร์ตมาจากฟังก์ชัน `getAllowedCostCentersForRoute` ใน TypeScript ของคุณ
  static List<String>? getAllowedCostCenters({
    required String screenName,
    required String? role, // 'owner', 'admin', หรือ null ถ้ายังไม่ login
    required List<String>? userCostCenters, // สิทธิ์ที่อมไว้ใน AuthProvider
  }) {
    // 💡 ถ้าข้อมูลสิทธิ์ผู้ใช้จากคลังหลัก (Firebase) ยังโหลดไม่เสร็จ -> ส่งค่า null เสมือนเป็น undefined กลับไป
    if (userCostCenters == null && role == null) {
      return []; // ส่งลิสต์ว่างกลับไปก่อนเพื่อความปลอดภัย ป้องกัน Data Leak
    }

    // ค้นหา Policy ของหน้าจอปัจจุบัน (ถ้าไม่เจอ ให้ fallback ไปที่ public เพื่อความปลอดภัย)
    final currentRoute = routes.firstWhere(
      (r) => r.name == screenName,
      orElse: () => const RouteConfig(name: 'unknown', label: 'Unknown', policy: RoutePolicy.public),
    );
    
    final policy = currentRoute.policy;

    // 💡 กรณี PUBLIC (เช่น หน้าค้นหา) — ส่องได้หมด ไม่กรองตามสิทธิ์สาขา
    if (policy == RoutePolicy.public) {
      return null; // null ในความหมายของแอปคุณคือ 'แสดงผลข้อมูลทั้งหมด' (ไม่ฟิลเตอร์)
    }

    // 💡 กรณี HYBRID (เช่น หน้าสรุปยอดแดชบอร์ด)
    if (policy == RoutePolicy.hybrid) {
      if (role == null) return []; // ยังไม่ล็อกอิน ห้ามเห็นข้อมูลเด็ดขาด
      if (role == 'owner') return null; // สิทธิ์สูงสุด ดูได้ทุกสาขา
      if (role == 'admin') return userCostCenters; // แอดมินทั่วไป ล็อกให้เห็นแค่สาขาตัวเอง
    }

    // 💡 กรณีหน้า PRIVATE (เช่น หน้าแรกที่พนักงานใช้ลุยทำ Asset Survey)
    if (policy == RoutePolicy.private) {
      if (role == null) return []; // ดีดกลับ ไม่ให้เห็นคลังข้อมูลใหญ่
      if (role == 'owner') return null; // ดูได้หมด
      if (role == 'admin') return userCostCenters; // ล็อกเฉพาะรหัส Cost Center ของตัวเอง
    }

    return [];
  }
}