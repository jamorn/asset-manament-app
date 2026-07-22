package com.plbg.assetapp.domain.model

import java.time.LocalDateTime

data class SyncStatus(
    val id: String,
    val total: Int = 0,
    val synced: Int = 0,
    val failed: Int = 0,
    val remaining: Int = 0,
    val progress: Double = 0.0,
    val lastSyncAt: LocalDateTime = LocalDateTime.now(),
    val isCompleted: Boolean = false,
    val failedIds: List<String> = emptyList(),
) {
    val progressPercentage: Double get() = progress * 100

    val statusText: String
        get() = when {
            isCompleted -> "Sync completed"
            total == 0 -> "No data to sync"
            else -> "${synced + failed}/$total (${String.format("%.1f", progressPercentage)}%)"
        }

    val detailText: String
        get() = when {
            isCompleted -> if (failed > 0)
                "Completed $synced items, $failed failed"
            else "Successfully synced $synced items"
            else -> "Syncing $synced items, $remaining remaining"
        }
}

data class AuditData(
    val id: String,
    val assetNo: String,
    val location: String,
    val condition: String,
    val imageUrl: String,
    val auditorEmail: String,
    val timestamp: LocalDateTime,
    val remarks: String? = null,
    val environment: String? = null,
    val mobility: String? = null,
)

data class TempPhoto(
    val tempId: String,
    val referenceAssetNo: String,
    val description: String,
    val photoUrl: String,
    val location: String,
    val capturedAt: LocalDateTime? = null,
    val assetClass: String = "",
    val assetClassName: String = "",
    val costCenter: String = "",
    val costCenterName: String = "",
    val status: TempPhotoStatus = TempPhotoStatus.PENDING,
)

data class AcceptResult(val ok: Boolean, val message: String)