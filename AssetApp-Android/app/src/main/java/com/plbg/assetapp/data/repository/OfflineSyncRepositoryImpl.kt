package com.plbg.assetapp.data.repository

import android.content.Context
import com.plbg.assetapp.domain.model.AuditData
import com.plbg.assetapp.domain.model.SyncStatus
import com.plbg.assetapp.domain.repository.AuditRepository
import com.plbg.assetapp.domain.repository.OfflineSyncRepository
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.File
import java.time.LocalDateTime
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OfflineSyncRepositoryImpl @Inject constructor(
    @ApplicationContext private val context: Context,
    private val json: Json,
    private val auditRepository: AuditRepository,
) : OfflineSyncRepository {

    private val prefs = context.getSharedPreferences("offline_audits", Context.MODE_PRIVATE)

    @Serializable
    data class PendingAuditDto(
        val id: String,
        val assetNo: String,
        val location: String,
        val condition: String,
        val imageUrl: String,
        val auditorEmail: String,
        val timestamp: String,
        val remarks: String? = null,
        val environment: String? = null,
        val mobility: String? = null,
    )

    override suspend fun saveAuditOffline(audit: AuditData) {
        val dto = PendingAuditDto(
            id = audit.id,
            assetNo = audit.assetNo,
            location = audit.location,
            condition = audit.condition,
            imageUrl = audit.imageUrl,
            auditorEmail = audit.auditorEmail,
            timestamp = audit.timestamp.toString(),
            remarks = audit.remarks,
            environment = audit.environment,
            mobility = audit.mobility,
        )
        val pending = getPendingList().toMutableList()
        pending.add(dto)
        prefs.edit().putString("pending", json.encodeToString(pending)).apply()
    }

    override suspend fun syncPendingAudits(): SyncStatus {
        val pending = getPendingList()
        val total = pending.size
        var synced = 0
        var failed = 0
        val failedIds = mutableListOf<String>()

        for (dto in pending) {
            try {
                val audit = AuditData(
                    id = dto.id,
                    assetNo = dto.assetNo,
                    location = dto.location,
                    condition = dto.condition,
                    imageUrl = dto.imageUrl,
                    auditorEmail = dto.auditorEmail,
                    timestamp = LocalDateTime.parse(dto.timestamp),
                    remarks = dto.remarks,
                    environment = dto.environment,
                    mobility = dto.mobility,
                )
                val imageFile = if (dto.imageUrl.isNotEmpty()) {
                    File(dto.imageUrl)
                } else File("")

                val result = auditRepository.submitAudit(audit, imageFile)
                result.fold(
                    onSuccess = { synced++ },
                    onFailure = {
                        failed++
                        failedIds.add(dto.assetNo)
                    }
                )
            } catch (e: Exception) {
                failed++
                failedIds.add(dto.assetNo)
            }
        }

        prefs.edit().remove("pending").apply()
        if (failedIds.isNotEmpty()) {
            val retryList = pending.filter { failedIds.contains(it.assetNo) }
            prefs.edit().putString("pending", json.encodeToString(retryList)).apply()
        }

        return SyncStatus(
            id = "offline_sync",
            total = total,
            synced = synced,
            failed = failed,
            remaining = failedIds.size,
            progress = if (total > 0) synced.toDouble() / total else 0.0,
            isCompleted = failed == 0,
            failedIds = failedIds,
        )
    }

    override suspend fun getCurrentStatus(): SyncStatus {
        val pending = getPendingList()
        return SyncStatus(
            id = "offline_sync",
            total = pending.size,
            remaining = pending.size,
        )
    }

    override suspend fun retryFailed(): SyncStatus = syncPendingAudits()

    private fun getPendingList(): List<PendingAuditDto> {
        val jsonStr = prefs.getString("pending", null) ?: return emptyList()
        return runCatching {
            json.decodeFromString<List<PendingAuditDto>>(jsonStr)
        }.getOrElse { emptyList() }
    }
}