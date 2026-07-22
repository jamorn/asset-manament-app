package com.plbg.assetapp.domain.model

import java.time.LocalDateTime

data class AssetModel(
    val assetNo: String,
    val description: String,
    val assetClass: String,
    val assetClassName: String,
    val capDate: String? = null,
    val assetOwner: String = "",
    val costCenter: String = "",
    val costCenterName: String = "",
    val mainLocation: String = "",
    val lastLocationName: String = "",
    val environment: Environment = Environment.INDOOR,
    val mobility: Mobility = Mobility.FIXED,
    val status: String = "",
    val currentStatus: Int = 0,
    val lastImageUrl: String = "",
    val lastCondition: String = "",
    val remarks: String? = null,
    val updatedAt: LocalDateTime? = null,
    val updatedBy: String = "",
    val history: List<AuditHistory> = emptyList(),
) {
    val isAudited: Boolean
        get() = lastCondition.isNotEmpty() && lastImageUrl.isNotEmpty()

    val environmentDisplay: String
        get() = environment.display

    val mobilityDisplay: String
        get() = mobility.display
}