// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset_model.dart';
import '../providers/auth_provider.dart';
import '../providers/asset_provider.dart';
import '../services/rbac_service.dart';
import '../configs/routes.dart';
import '../widgets/asset_search_bar.dart';
import '../widgets/load_more_list.dart';

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
        a.costCenter.toUpperCase().contains(q) ||
        a.costCenterName.toUpperCase().contains(q)
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
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
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView( // 🟢 เติมตัวนี้ครอบเพื่อให้หน้า Search เลื่อนหน้าจอเฉพาะจุดได้ ม้าลายจะหายไปครับ
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
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: url.isNotEmpty
            ? Image.network(url, fit: BoxFit.contain)
            : const Center(child: Text('No image')),
      ),
    );
  }

  void _showAssetDetail(BuildContext context, AssetModel asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // เปิดสิทธิ์ให้ Bottom Sheet ขยายความสูงตามเนื้อหาได้อิสระ
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // ครอบตัวนี้เพิ่ม เพื่อเปลี่ยนปัญหาม้าลายในป๊อปอัปให้กลายเป็นเลื่อนได้แทน
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