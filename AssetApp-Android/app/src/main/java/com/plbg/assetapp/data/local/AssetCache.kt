package com.plbg.assetapp.data.local

import android.content.Context
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.model.Environment
import com.plbg.assetapp.domain.model.Mobility
import com.plbg.assetapp.domain.repository.AuthRepository
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import javax.inject.Inject
import javax.inject.Singleton
import java.time.LocalDateTime

@Serializable
data class AssetModelDto(
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
    val environment: String = "indoor",
    val mobility: String = "fixed",
    val status: String = "",
    val currentStatus: Int = 0,
    val lastImageUrl: String = "",
    val lastCondition: String = "",
    val remarks: String? = null,
    val updatedAt: String? = null,
    val updatedBy: String = "",
) {
    fun toDomain(): AssetModel = AssetModel(
        assetNo = assetNo,
        description = description,
        assetClass = assetClass,
        assetClassName = assetClassName,
        capDate = capDate,
        assetOwner = assetOwner,
        costCenter = costCenter,
        costCenterName = costCenterName,
        mainLocation = mainLocation,
        lastLocationName = lastLocationName,
        environment = Environment.fromString(environment),
        mobility = Mobility.fromString(mobility),
        status = status,
        currentStatus = currentStatus,
        lastImageUrl = lastImageUrl,
        lastCondition = lastCondition,
        remarks = remarks,
        updatedAt = updatedAt?.let { runCatching { LocalDateTime.parse(it) }.getOrNull() },
        updatedBy = updatedBy,
        history = emptyList(), // history not cached via DTO
    )
}

fun AssetModel.toDto(): AssetModelDto = AssetModelDto(
    assetNo = assetNo,
    description = description,
    assetClass = assetClass,
    assetClassName = assetClassName,
    capDate = capDate,
    assetOwner = assetOwner,
    costCenter = costCenter,
    costCenterName = costCenterName,
    mainLocation = mainLocation,
    lastLocationName = lastLocationName,
    environment = environment.value,
    mobility = mobility.value,
    status = status,
    currentStatus = currentStatus,
    lastImageUrl = lastImageUrl,
    lastCondition = lastCondition,
    remarks = remarks,
    updatedAt = updatedAt?.toString(),
    updatedBy = updatedBy,
)

@Singleton
class AssetCache @Inject constructor(
    @ApplicationContext private val context: Context,
    private val authRepository: AuthRepository,
    private val json: Json,
) {
    private val prefs = context.getSharedPreferences("asset_cache", Context.MODE_PRIVATE)
    private val ttlMs = 30L * 24 * 60 * 60 * 1000

    private fun computeKey(): String {
        val role = authRepository.role
        val ccs = authRepository.allowedCostCenters
        return when {
            role == "owner" -> "owner"
            ccs.isNullOrEmpty() -> "empty"
            else -> ccs.sorted().joinToString("|").hashCode().toString(16)
        }
    }

    fun get(): List<AssetModel>? {
        val key = computeKey()
        val ts = prefs.getLong("${key}_ts", 0)
        if (System.currentTimeMillis() - ts > ttlMs) return null

        val jsonStr = prefs.getString(key, null) ?: return null
        return runCatching {
            json.decodeFromString<List<AssetModelDto>>(jsonStr)
                .map { it.toDomain() }
        }.getOrNull()
    }

    fun save(assets: List<AssetModel>) {
        val key = computeKey()
        val jsonStr = json.encodeToString(assets.map { it.toDto() })
        prefs.edit()
            .putString(key, jsonStr)
            .putLong("${key}_ts", System.currentTimeMillis())
            .apply()
    }
}