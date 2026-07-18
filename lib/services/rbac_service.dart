import '../models/asset_model.dart';
import '../models/temp_photo_model.dart';

class RBACContext {
  final String? role;
  final List<String>? allowedCostCenters;
  final bool skipFilter;

  RBACContext({
    required this.role,
    required this.allowedCostCenters,
    this.skipFilter = false,
  });
}

class RbacService {
  // ------------------------------------------------------------------
  // กรองชุดข้อมูลครุภัณฑ์ปกติ
  // ------------------------------------------------------------------
  static List<AssetModel> filterAssets(
      List<AssetModel> assets, RBACContext ctx) {
    if (ctx.skipFilter) return assets; // หน้า Search สาธารณะ ไม่ต้องกรอง
        if (ctx.allowedCostCenters == null) {
      return assets; // สิทธิ์สูงสุด (Owner เจอรหัส '*') ส่องเห็นทั้งหมด
    }
    if (ctx.allowedCostCenters!.isEmpty) {
      return []; // ไม่มีสิทธิ์ บล็อกให้เห็นศูนย์ชิ้น
    }

    // ดึงเฉพาะชิ้นที่มีรหัส CostCenter ตรงตามบัตรสิทธิ์พนักงาน
    return assets
        .where((a) => ctx.allowedCostCenters!.contains(a.costCenter))
        .toList();
  }

  // ------------------------------------------------------------------
  // กรองชุดภาพ TempPhoto
  // ------------------------------------------------------------------
  static List<TempPhoto> filterTempPhotos(
      List<TempPhoto> photos, RBACContext ctx) {
    if (ctx.skipFilter) return photos;
    if (ctx.allowedCostCenters == null) return photos;
    if (ctx.allowedCostCenters!.isEmpty) return [];

    return photos
        .where((p) => ctx.allowedCostCenters!.contains(p.costCenter))
        .toList();
  }

  // ------------------------------------------------------------------
  // กรอง Reference Assets (สำหรับ TempPhotoForm)
  // ------------------------------------------------------------------
  static List<AssetModel> filterReferenceAssets(
      List<AssetModel> assets, RBACContext ctx) {
    if (ctx.skipFilter) return assets;
    if (ctx.allowedCostCenters == null) return assets;
    if (ctx.allowedCostCenters!.isEmpty) return [];

    return assets
        .where((a) => ctx.allowedCostCenters!.contains(a.costCenter))
        .toList();
  }

  // ------------------------------------------------------------------
  // getAvailableCostCenters — รายการ Cost Center + จำนวน
  // ------------------------------------------------------------------
  static List<CostCenterInfo> getAvailableCostCenters(
    List<AssetModel> assets,
    RBACContext ctx,
  ) {
    final visible = ctx.skipFilter ? assets : filterAssets(assets, ctx);
    final map = <String, CostCenterInfo>{};
    for (final a in visible) {
      map
          .putIfAbsent(
              a.costCenter,
              () => CostCenterInfo(
                    costCenter: a.costCenter,
                    costCenterName: a.costCenterName,
                    count: 0,
                  ))
          .count++;
    }
    final list = map.values.toList();
    list.sort((a, b) => a.costCenter.compareTo(b.costCenter));
    return list;
  }

  // ------------------------------------------------------------------
  // getCostCenterStats — สถิติแยกตาม Cost Center (Dashboard)
  // ------------------------------------------------------------------
  static List<CostCenterStats> getCostCenterStats(
    List<AssetModel> assets,
    Set<String> auditedAssetNos,
    RBACContext ctx,
  ) {
    final visible = ctx.skipFilter ? assets : filterAssets(assets, ctx);
    final map = <String, CostCenterStats>{};
    for (final a in visible) {
      map.putIfAbsent(
          a.costCenter,
          () => CostCenterStats(
                costCenter: a.costCenter,
                costCenterName: a.costCenterName,
                total: 0,
                audited: 0,
              ));
      map[a.costCenter]!.total++;
      if (auditedAssetNos.contains(a.assetNo)) {
        map[a.costCenter]!.audited++;
      }
    }
    final list = map.values.toList();
    list.sort((a, b) => a.costCenter.compareTo(b.costCenter));
    return list;
  }

  // ------------------------------------------------------------------
  // getCostCenterAssetClassStats — สถิติแยกตาม Cost Center > Asset Class
  // ------------------------------------------------------------------
  static Map<String, List<AssetClassStats>> getCostCenterAssetClassStats(
    List<AssetModel> assets,
    Set<String> auditedAssetNos,
    RBACContext ctx,
  ) {
    final visible = ctx.skipFilter ? assets : filterAssets(assets, ctx);
    final ccMap = <String, Map<String, AssetClassStats>>{};
    for (final a in visible) {
      ccMap.putIfAbsent(a.costCenter, () => {});
      final acMap = ccMap[a.costCenter]!;
      acMap.putIfAbsent(
          a.assetClass,
          () => AssetClassStats(
                assetClass: a.assetClass,
                assetClassName: a.assetClassName,
                total: 0,
                audited: 0,
              ));
      acMap[a.assetClass]!.total++;
      if (auditedAssetNos.contains(a.assetNo)) {
        acMap[a.assetClass]!.audited++;
      }
    }
    final result = <String, List<AssetClassStats>>{};
    for (final entry in ccMap.entries) {
      final list = entry.value.values.toList();
      list.sort((a, b) => a.assetClass.compareTo(b.assetClass));
      result[entry.key] = list;
    }
    return result;
  }
}

// ====================================================================
// Data classes สำหรับ RbacService return types
// ====================================================================

class CostCenterInfo {
  final String costCenter;
  final String costCenterName;
  int count;

  CostCenterInfo({
    required this.costCenter,
    required this.costCenterName,
    this.count = 0,
  });
}

class CostCenterStats {
  final String costCenter;
  final String costCenterName;
  int total;
  int audited;

  CostCenterStats({
    required this.costCenter,
    required this.costCenterName,
    this.total = 0,
    this.audited = 0,
  });
}

class AssetClassStats {
  final String assetClass;
  final String assetClassName;
  int total;
  int audited;

  AssetClassStats({
    required this.assetClass,
    required this.assetClassName,
    this.total = 0,
    this.audited = 0,
  });
}
