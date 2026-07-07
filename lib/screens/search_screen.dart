// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'package:provider/provider.dart';
import '../models/asset_model.dart';
import '../providers/auth_provider.dart';
import '../providers/asset_provider.dart';
import '../providers/theme_provider.dart'; // 🟢 เพิ่ม import theme_provider
import '../services/rbac_service.dart';
import '../configs/routes.dart';
import '../widgets/asset_search_bar.dart';
import '../widgets/load_more_list.dart';
import '../widgets/image_modal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final assetProv = context.watch<AssetProvider>();
    final themeProvider = context.watch<ThemeProvider>(); // 🟢 เรียกใช้ watch เฝ้าดูสถานะธีม

    // Public route — skip RBAC filter (skipFilter = true)
    final allowedCostCenters = AppRoutes.getAllowedCostCenters(
      screenName: AppRoutes.search,
      role: auth.role,
      userCostCenters: auth.allowedCostCenters,
    );

    final visibleAssets = RbacService.filterAssets(
      assetProv.assets,
      RBACContext(
        role: auth.role,
        allowedCostCenters: allowedCostCenters,
        skipFilter: true, // public route
      ),
    );

    var filteredAssets = visibleAssets;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toUpperCase();
      filteredAssets = visibleAssets.where((a) =>
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Search'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (route) async {
              if (route == AppRoutes.dashboard) {
                Navigator.pushNamed(context, AppRoutes.dashboard);
              } else if (route == 'home') {
                Navigator.pop(context);
              } else if (route == 'toggle_theme') { // 🟢 ดักฟังคำสั่งกดสลับธีมสี
                final theme = context.read<ThemeProvider>();
                theme.setThemeMode(theme.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              } else if (route == 'logout') {
                await context.read<AuthProvider>().logout();
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
              const PopupMenuItem(value: 'home', child: Text('🏠 Home (Survey)')),
              const PopupMenuItem(value: AppRoutes.dashboard, child: Text('📊 Dashboard')),
              const PopupMenuDivider(),
              PopupMenuItem( // 🟢 เพิ่มปุ่มสลับธีมสีเข้าไปในหน้าค้นหาทรัพย์สิน
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            AssetSearchBar(
              value: _searchQuery,
              onChanged: (v) => setState(() => _searchQuery = v),
              placeholder: 'ค้นหาเลขทรัพย์สิน ชื่อ หรือสถานที่...',
            ),
            const SizedBox(height: 8),
            Text(
              '${filteredAssets.length} รายการ',
              style: TextStyle(fontSize: 11, color: context.textSecondary),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView( 
                child: LoadMoreList(
                  assets: filteredAssets,
                  selectedAssetNo: null,
                  onSelect: (asset) => _showAssetDetail(context, asset),
                  onImageClick: (url) => _showImageModal(url),
                  auditedSet: assetProv.auditedAssetNos,
                  pageSize: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageModal(String url) {
    showImageModal(context, url);
  }

  void _showAssetDetail(BuildContext context, AssetModel asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(asset.assetNo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(asset.description),
              const SizedBox(height: 4),
              Text('📍 ${asset.lastLocationName}'),
              Text('🏢 ${asset.costCenter} - ${asset.costCenterName}'),
              Text('🔧 ${asset.lastCondition}'),
              if (asset.lastImageUrl.isNotEmpty) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(asset.lastImageUrl, height: 150, fit: BoxFit.cover),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}