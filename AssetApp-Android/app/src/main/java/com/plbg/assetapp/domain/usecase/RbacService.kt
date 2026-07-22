package com.plbg.assetapp.domain.usecase

import com.plbg.assetapp.domain.model.AssetClassStats
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.model.CostCenterInfo
import com.plbg.assetapp.domain.model.CostCenterStats
import com.plbg.assetapp.domain.model.RBACContext
import com.plbg.assetapp.domain.model.TempPhoto

object RbacService {
    fun filterAssets(assets: List<AssetModel>, ctx: RBACContext): List<AssetModel> {
        if (ctx.skipFilter) return assets
        if (ctx.allowedCostCenters == null) return assets
        if (ctx.allowedCostCenters.isEmpty()) return emptyList()
        return assets.filter { ctx.allowedCostCenters.contains(it.costCenter) }
    }

    fun filterTempPhotos(photos: List<TempPhoto>, ctx: RBACContext): List<TempPhoto> {
        if (ctx.skipFilter) return photos
        if (ctx.allowedCostCenters == null) return photos
        if (ctx.allowedCostCenters.isEmpty()) return emptyList()
        return photos.filter { ctx.allowedCostCenters.contains(it.costCenter) }
    }

    fun getAvailableCostCenters(
        assets: List<AssetModel>,
        ctx: RBACContext,
    ): List<CostCenterInfo> {
        val visible = if (ctx.skipFilter) assets else filterAssets(assets, ctx)
        return visible
            .groupBy { it.costCenter }
            .map { (cc, list) ->
                CostCenterInfo(
                    costCenter = cc,
                    costCenterName = list.first().costCenterName,
                    count = list.size,
                )
            }
            .sortedBy { it.costCenter }
    }

    fun getCostCenterStats(
        assets: List<AssetModel>,
        auditedAssetNos: Set<String>,
        ctx: RBACContext,
    ): List<CostCenterStats> {
        val visible = if (ctx.skipFilter) assets else filterAssets(assets, ctx)
        return visible
            .groupBy { it.costCenter }
            .map { (cc, list) ->
                CostCenterStats(
                    costCenter = cc,
                    costCenterName = list.first().costCenterName,
                    total = list.size,
                    audited = list.count { auditedAssetNos.contains(it.assetNo) },
                )
            }
            .sortedBy { it.costCenter }
    }
}