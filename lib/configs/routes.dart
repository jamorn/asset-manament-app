// lib/configs/routes.dart

// ============================================================================
// 📌 Route Policy Enum
// ============================================================================
enum RoutePolicy { public, hybrid, private }

// ============================================================================
// 👤 User Role Enum (Type-safe แทน String)
// ============================================================================
enum UserRole {
  owner,
  admin,
  user,
  viewer,
}

extension UserRoleExtension on UserRole {
  bool get isOwner => this == UserRole.owner;
  bool get isAdmin => this == UserRole.admin;
  bool get isUser => this == UserRole.user;
  bool get isViewer => this == UserRole.viewer;
  
  String get displayName {
    switch (this) {
      case UserRole.owner:
        return '👑 Owner';
      case UserRole.admin:
        return '🛡️ Admin';
      case UserRole.user:
        return '👤 User';
      case UserRole.viewer:
        return '👀 Viewer';
    }
  }
}

// ============================================================================
// 📋 Route Configuration
// ============================================================================
class RouteConfig {
  final String name;
  final String label;
  final RoutePolicy policy;
  final List<UserRole>? allowedRoles;

  const RouteConfig({
    required this.name,
    required this.label,
    required this.policy,
    this.allowedRoles,
  });
}

// ============================================================================
// 🧭 App Routes
// ============================================================================
class AppRoutes {
  // ====== Route Names ======
  static const String survey = 'survey';
  static const String dashboard = 'dashboard';
  static const String search = 'search';
  static const String tempPhotos = 'temp_photos';
  static const String audit = 'audit';
  static const String assetDetail = 'asset_detail';

  // ====== Route Configs ======
  static const List<RouteConfig> routes = [
    RouteConfig(
      name: survey,
      label: '📋 Asset Survey',
      policy: RoutePolicy.private,
      allowedRoles: [UserRole.owner, UserRole.admin, UserRole.user],
    ),
    RouteConfig(
      name: dashboard,
      label: '📊 Dashboard',
      policy: RoutePolicy.public,
    ),
    RouteConfig(
      name: search,
      label: '🔍 Search',
      policy: RoutePolicy.public,
    ),
    RouteConfig(
      name: tempPhotos,
      label: '📸 Temp Photos',
      policy: RoutePolicy.private,
      allowedRoles: [UserRole.owner, UserRole.admin],
    ),
    RouteConfig(
      name: audit,
      label: '📝 Audit',
      policy: RoutePolicy.private,
      allowedRoles: [UserRole.owner, UserRole.admin, UserRole.user],
    ),
    RouteConfig(
      name: assetDetail,
      label: '📄 Asset Detail',
      policy: RoutePolicy.private,
      allowedRoles: [UserRole.owner, UserRole.admin, UserRole.user],
    ),
  ];

  // ==========================================================================
  // 📌 Helper Methods
  // ==========================================================================

  /// ดึง Label ของ Route
  static String? getRouteLabel(String routeName) {
    try {
      return routes.firstWhere((r) => r.name == routeName).label;
    } catch (_) {
      return null;
    }
  }

  /// ดึง Policy ของ Route
  static RoutePolicy? getRoutePolicy(String routeName) {
    try {
      return routes.firstWhere((r) => r.name == routeName).policy;
    } catch (_) {
      return null;
    }
  }

  /// ตรวจสอบว่า Role มีสิทธิ์เข้าถึง Route นี้หรือไม่
  static bool isRouteAllowed(String routeName, UserRole? role) {
    if (role == null) return false;
    
    try {
      final config = routes.firstWhere((r) => r.name == routeName);
      
      // Public route → ใครก็ได้
      if (config.policy == RoutePolicy.public) {
        return true;
      }
      
      // Private/Hybrid → ตรวจสอบ allowedRoles
      if (config.allowedRoles != null) {
        return config.allowedRoles!.contains(role);
      }
      
      // Fallback: Owner มีสิทธิ์ทุกอย่าง
      return role.isOwner;
    } catch (_) {
      return false;
    }
  }

  /// Utility: สร้าง path
  static String auditPath(String assetNo) => '/audit/$assetNo';
  static String assetDetailPath(String assetNo) => '/asset/$assetNo';

  // ==========================================================================
  // 🔐 RBAC: คำนวณ Cost Centers ที่อนุญาต
  // ==========================================================================
  static List<String>? getAllowedCostCenters({
    required String screenName,
    required UserRole? role,
    required List<String>? userCostCenters,
  }) {
    // ถ้ายังไม่ login → ไม่มีสิทธิ์
    if (role == null) {
      return [];
    }

    // Owner → เห็นทุกอย่าง
    if (role.isOwner) {
      return null;
    }

    // Public route → เห็นทุกอย่าง (ไม่ filter)
    final policy = getRoutePolicy(screenName);
    if (policy == RoutePolicy.public) {
      return null;
    }

    // Private/Hybrid → filter ตาม Cost Center
    if (userCostCenters == null || userCostCenters.isEmpty) {
      return [];
    }

    // Admin/User → เห็นเฉพาะ Cost Center ของตัวเอง
    return userCostCenters;
  }

  /// Version 2: ใช้กับ role เป็น String (backward compatibility)
  static List<String>? getAllowedCostCentersV2({
    required String screenName,
    required String? role,
    required List<String>? userCostCenters,
  }) {
    UserRole? parsedRole;
    if (role != null) {
      try {
        parsedRole = UserRole.values.firstWhere(
          (r) => r.name == role,
          orElse: () => UserRole.viewer,
        );
      } catch (_) {
        parsedRole = UserRole.viewer;
      }
    }
    
    return getAllowedCostCenters(
      screenName: screenName,
      role: parsedRole,
      userCostCenters: userCostCenters,
    );
  }
}

