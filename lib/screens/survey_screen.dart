// lib/screens/survey_screen.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'package:provider/provider.dart';
import '../models/asset_model.dart';
import '../providers/auth_provider.dart';
import '../providers/asset_provider.dart';
import '../providers/theme_provider.dart';
import '../services/rbac_service.dart';
import '../configs/routes.dart';
import '../widgets/cost_center_selector.dart';
import '../widgets/asset_class_picker.dart';
import '../widgets/asset_search_bar.dart';
import '../widgets/load_more_list.dart';
import '../widgets/image_modal.dart';
import 'audit_screen.dart';
import 'temp_photo_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  AssetModel? _selectedAsset;
  String _searchQuery = '';
  String? _selectedCostCenter;
  String? _selectedAssetClass;
  bool _showUnauditedOnly = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final assetProv = context.watch<AssetProvider>();
    final themeProvider = context.watch<ThemeProvider>(); // 🟢 เรียกใช้เฝ้าดูสถานะธีม

    if (auth.isAppLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Asset Survey')),
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('กรุณาเข้าสู่ระบบ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('ระบบจำเป็นต้องยืนยันตัวตนผ่านบัญชี Google'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => auth.login(),
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!auth.authorized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Asset Survey')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ไม่มีสิทธิ์เข้าใช้งาน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('บัญชี ${auth.user!.email} ไม่อยู่ในรายชื่อผู้มีสิทธิ์'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => auth.logout(),
                child: const Text('ออกจากระบบ'),
              ),
            ],
          ),
        ),
      );
    }

    final allowedCostCenters = AppRoutes.getAllowedCostCentersV2(
      screenName: AppRoutes.survey,
      role: auth.role,
      userCostCenters: auth.allowedCostCenters,
    );

    final availableCostCenters = RbacService.getAvailableCostCenters(
      assetProv.assets,
      RBACContext(
        role: auth.role,
        allowedCostCenters: allowedCostCenters,
      ),
    );

    if (_selectedCostCenter == null && allowedCostCenters is List && allowedCostCenters!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _selectedCostCenter = allowedCostCenters[0]);
      });
    }

    final visibleAssets = RbacService.filterAssets(
      assetProv.assets,
      RBACContext(
        role: auth.role,
        allowedCostCenters: allowedCostCenters,
      ),
    );

    var filteredAssets = visibleAssets;
    if (_selectedCostCenter != null) {
      filteredAssets = filteredAssets.where((a) => a.costCenter == _selectedCostCenter).toList();
    }
    if (_selectedAssetClass != null) {
      filteredAssets = filteredAssets.where((a) => a.assetClass == _selectedAssetClass).toList();
    }
    if (_showUnauditedOnly) {
      filteredAssets = filteredAssets.where((a) => !assetProv.auditedAssetNos.contains(a.assetNo)).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toUpperCase();
      filteredAssets = filteredAssets.where((a) =>
        a.assetNo.toUpperCase().contains(q) ||
        a.description.toUpperCase().contains(q) ||
        a.lastLocationName.toUpperCase().contains(q) ||
        a.mainLocation.toUpperCase().contains(q) ||
        a.costCenter.toUpperCase().contains(q) ||
        a.costCenterName.toUpperCase().contains(q) ||
        a.assetOwner.toUpperCase().contains(q) ||
        (a.remarks?.toUpperCase() ?? '').contains(q)
      ).toList();
    }

    final poolForClasses = _selectedCostCenter != null
        ? visibleAssets.where((a) => a.costCenter == _selectedCostCenter).toList()
        : visibleAssets;
    final classMap = <String, AssetClassStats>{};
    for (final a in poolForClasses) {
      classMap.putIfAbsent(a.assetClass, () => AssetClassStats(
        assetClass: a.assetClass,
        assetClassName: a.assetClassName,
        total: 0,
        audited: 0,
      )).total++;
    }
    final availableAssetClasses = classMap.values.toList()
      ..sort((a, b) => a.assetClass.compareTo(b.assetClass));

    // ✅ ตรวจสอบว่า _selectedAssetClass ยังมีอยู่ใน available classes หรือไม่
    if (_selectedAssetClass != null && 
        !availableAssetClasses.any((ac) => ac.assetClass == _selectedAssetClass)) {
      _selectedAssetClass = null;
    }

    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ASSET DEV — Survey'),
        actions: isTablet
            // ── iPad: แสดงปุ่มทั้งหมด ──
            ? [
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
                ),
                IconButton(
                  tooltip: 'Dashboard',
                  icon: const Icon(Icons.dashboard),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.dashboard),
                ),
                IconButton(
                  tooltip: 'Temp Photos',
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () => _showTempPhotosPage(context),
                ),
                IconButton(
                  tooltip: themeProvider.isDarkMode ? 'Light mode' : 'Dark mode',
                  icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () {
                    final t = context.read<ThemeProvider>();
                    t.setThemeMode(t.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  },
                ),
                // Avatar
                CircleAvatar(
                  radius: 16,
                  backgroundImage: auth.user?.photoURL != null
                      ? NetworkImage(auth.user!.photoURL!)
                      : null,
                  backgroundColor: context.primary,
                  child: auth.user?.photoURL == null
                      ? Text(
                          (auth.user?.email ?? 'U')[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: 4),
              ]
            // ── iPhone: PopupMenuButton (เหมือนเดิม) ──
            : [
                PopupMenuButton<String>(
                  onSelected: (route) {
                    if (route == AppRoutes.dashboard) {
                      Navigator.pushNamed(context, AppRoutes.dashboard);
                    } else if (route == AppRoutes.search) {
                      Navigator.pushNamed(context, AppRoutes.search);
                    } else if (route == 'temp_photos') {
                      _showTempPhotosPage(context);
                    } else if (route == 'toggle_theme') {
                      final theme = context.read<ThemeProvider>();
                      theme.setThemeMode(theme.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                    } else if (route == 'logout') {
                      context.read<AuthProvider>().logout();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: auth.user?.photoURL != null
                          ? NetworkImage(auth.user!.photoURL!)
                          : null,
                      backgroundColor: context.primary,
                      child: auth.user?.photoURL == null
                          ? Text(
                              (auth.user?.email ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(auth.user?.displayName ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(auth.user?.email ?? '', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: AppRoutes.dashboard, child: Text('📊 Dashboard')),
                    const PopupMenuItem(value: AppRoutes.search, child: Text('🔍 Search')),
                    const PopupMenuItem(value: 'temp_photos', child: Text('📸 Temp Photos')),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'toggle_theme',
                      child: Row(
                        children: [
                          Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 18),
                          const SizedBox(width: 8),
                          Text(themeProvider.isDarkMode ? '☀️ Light mode' : '🌙 Dark mode'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: 'logout', child: Text('🚪 Sign out', style: TextStyle(color: Colors.red))),
                  ],
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: assetProv.totalCount > 0
                  ? assetProv.auditedCount / assetProv.totalCount
                  : 0,
            ),
            const SizedBox(height: 8),
            Text(
              '${assetProv.auditedCount}/${assetProv.totalCount} สำรวจแล้ว',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),

            CostCenterSelector(
              costCenters: availableCostCenters,
              selectedCostCenter: _selectedCostCenter,
              onSelect: (cc) => setState(() {
                _selectedCostCenter = cc;
                _selectedAssetClass = null;
              }),
              auditedCounts: _buildAuditedCounts(visibleAssets, assetProv.auditedAssetNos),
              hideAll: allowedCostCenters is List,
            ),
            const SizedBox(height: 12),

            if (_selectedCostCenter != null)
              AssetClassPicker(
                classes: availableAssetClasses,
                selectedClass: _selectedAssetClass,
                onSelect: (ac) => setState(() => _selectedAssetClass = ac),
                auditedCounts: _buildClassAuditedCounts(poolForClasses, assetProv.auditedAssetNos),
              ),
            if (_selectedCostCenter != null) const SizedBox(height: 12),

            Row(
              children: [
                Switch(
                  value: _showUnauditedOnly,
                  onChanged: (v) => setState(() => _showUnauditedOnly = v),
                ),
                Text(_showUnauditedOnly ? 'เหลือยังไม่ตรวจ' : 'ทั้งหมด'),
                const Spacer(),
                Text('${filteredAssets.length} รายการ', style: const TextStyle(fontSize: 11)),
              ],
            ),

            AssetSearchBar(
              value: _searchQuery,
              onChanged: (v) => setState(() => _searchQuery = v),
            ),

            LoadMoreList(
              assets: filteredAssets,
              selectedAssetNo: _selectedAsset?.assetNo,
              onSelect: (asset) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AuditScreen(asset: asset),
                ),
              ),
              onImageClick: (url) => showImageModal(context, url),
              auditedSet: assetProv.auditedAssetNos,
              pageSize: 50,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showTempPhotosPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TempPhotoScreen(),
      ),
    );
  }

  Map<String, int> _buildAuditedCounts(List<AssetModel> assets, Set<String> auditedSet) {
    final map = <String, int>{};
    for (final a in assets) {
      if (auditedSet.contains(a.assetNo)) {
        map[a.costCenter] = (map[a.costCenter] ?? 0) + 1;
      }
    }
    return map;
  }

  Map<String, int> _buildClassAuditedCounts(List<AssetModel> assets, Set<String> auditedSet) {
    final map = <String, int>{};
    for (final a in assets) {
      if (auditedSet.contains(a.assetNo)) {
        map[a.assetClass] = (map[a.assetClass] ?? 0) + 1;
      }
    }
    return map;
  }
}