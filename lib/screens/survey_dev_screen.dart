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
import 'simple_audit_screen.dart';

class SurveyDevScreen extends StatefulWidget {
  const SurveyDevScreen({super.key});

  @override
  State<SurveyDevScreen> createState() => _SurveyDevScreenState();
}

class _SurveyDevScreenState extends State<SurveyDevScreen> {
  AssetModel? _selectedAsset;
  String _searchQuery = '';
  String? _selectedCostCenter;
  String? _selectedAssetClass;
  bool _showUnauditedOnly = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final assetProv = context.watch<AssetProvider>();
    //final themeProvider = context.watch<ThemeProvider>();

    if (auth.isAppLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Survey Dev')),
        body: Center(child: Text('กรุณาเข้าสู่ระบบ', style: TextStyle(color: context.textSecondary))),
      );
    }

    if (!auth.authorized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Survey Dev')),
        body: Center(child: Text('ไม่มีสิทธิ์', style: TextStyle(color: context.textSecondary))),
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
        (a.remarks?.toUpperCase() ?? '').contains(q) ||
        a.assetClass.toUpperCase().contains(q) ||
        a.assetClassName.toUpperCase().contains(q)
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

    if (_selectedAssetClass != null && 
        !availableAssetClasses.any((ac) => ac.assetClass == _selectedAssetClass)) {
      _selectedAssetClass = null;
    }

    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SURVEY DEV — SIMPLE'),
        actions: [
          if (isTablet)
            CircleAvatar(
              radius: 16,
              backgroundImage: auth.user?.photoURL != null ? NetworkImage(auth.user!.photoURL!) : null,
              backgroundColor: context.primary,
              child: auth.user?.photoURL == null
                  ? Text((auth.user?.email ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))
                  : null,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: assetProv.totalCount > 0 ? assetProv.auditedCount / assetProv.totalCount : 0,
            ),
            const SizedBox(height: 8),
            Text('${assetProv.auditedCount}/${assetProv.totalCount} สำรวจแล้ว', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 12),

            CostCenterSelector(
              costCenters: availableCostCenters,
              selectedCostCenter: _selectedCostCenter,
              onSelect: (cc) => setState(() {
                _selectedCostCenter = cc;
                _selectedAssetClass = null;
              }),
              auditedCounts: _buildCostCenterAuditedCounts(visibleAssets, assetProv.auditedAssetNos),
              hideAll: allowedCostCenters is List,
            ),
            const SizedBox(height: 12),

            if (_selectedCostCenter != null)
              AssetClassPicker(
                classes: availableAssetClasses,
                selectedClass: _selectedAssetClass,
                onSelect: (ac) => setState(() => _selectedAssetClass = ac),
                auditedCounts: _buildAssetClassAuditedCounts(poolForClasses, assetProv.auditedAssetNos),
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
                  builder: (_) => SimpleAuditScreen(asset: asset),  // ✅ SIMPLE!
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

  Map<String, int> _buildCostCenterAuditedCounts(List<AssetModel> assets, Set<String> auditedSet) {
    final map = <String, int>{};
    for (final a in assets) {
      if (auditedSet.contains(a.assetNo)) {
        map[a.costCenter] = (map[a.costCenter] ?? 0) + 1;
      }
    }
    return map;
  }

  Map<String, int> _buildAssetClassAuditedCounts(List<AssetModel> assets, Set<String> auditedSet) {
    final map = <String, int>{};
    for (final a in assets) {
      if (auditedSet.contains(a.assetNo)) {
        map[a.assetClass] = (map[a.assetClass] ?? 0) + 1;
      }
    }
    return map;
  }
}
