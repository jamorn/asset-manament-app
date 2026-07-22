package com.plbg.assetapp.data.mapper

import com.google.firebase.Timestamp
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.model.Environment
import com.plbg.assetapp.domain.model.Mobility
import com.plbg.assetapp.domain.model.DefaultValues
import java.time.LocalDateTime

object AssetMapper {
    private val assetClassMap = mapOf(
        "A2000" to "Building",
        "A2004" to "Machine",
        "A2007" to "Piping",
        "A2008" to "Plant Equipment",
        "A2009" to "Tools",
        "A2011" to "Furniture",
        "A3001" to "Vehicle",
        "A3002" to "Heavy Vehicle",
    )

    fun getShortClassName(rawClass: String): String =
        assetClassMap[rawClass] ?: "Unknown ($rawClass)"

    fun parseTimestamp(value: Any?): LocalDateTime? = when (value) {
        null -> null
        is LocalDateTime -> value
        is Timestamp -> value.toDate().toInstant()
            .atZone(java.time.ZoneId.systemDefault())
            .toLocalDateTime()
        is String -> runCatching { LocalDateTime.parse(value) }.getOrNull()
        else -> null
    }

    fun fromFirestore(json: Map<String, Any?>, docId: String): AssetModel {
        val assetNo = json["assetNo"]?.toString() ?: docId
        val assetClass = json["assetClass"]?.toString().orEmpty()

        val history = (json["history"] as? List<*>)
            ?.filterIsInstance<Map<String, Any?>>()
            ?.mapNotNull { runCatching { AuditHistoryMapper.fromJson(it) }.getOrNull() }
            ?: emptyList()

        return AssetModel(
            assetNo = assetNo,
            description = json["description"]?.toString() ?: DefaultValues.DESCRIPTION,
            assetClass = assetClass,
            assetClassName = json["assetClassName"]?.toString()
                ?: getShortClassName(assetClass),
            capDate = json["capDate"]?.toString(),
            assetOwner = json["assetOwner"]?.toString().orEmpty(),
            costCenter = json["costCenter"]?.toString().orEmpty(),
            costCenterName = json["costCenterName"]?.toString().orEmpty(),
            mainLocation = json["mainLocation"]?.toString().orEmpty(),
            lastLocationName = json["lastLocationName"]?.toString().orEmpty(),
            environment = Environment.fromString(json["environment"]?.toString()),
            mobility = Mobility.fromString(json["mobility"]?.toString()),
            status = json["status"]?.toString().orEmpty(),
            currentStatus = (json["currentStatus"] as? Number)?.toInt() ?: 0,
            lastImageUrl = json["lastImageUrl"]?.toString().orEmpty(),
            lastCondition = json["lastCondition"]?.toString().orEmpty(),
            remarks = json["remarks"]?.toString(),
            updatedAt = parseTimestamp(json["updatedAt"]),
            updatedBy = json["updatedBy"]?.toString().orEmpty(),
            history = history,
        )
    }

    fun toJson(asset: AssetModel): Map<String, Any?> = mapOf(
        "assetNo" to asset.assetNo,
        "description" to asset.description,
        "assetClass" to asset.assetClass,
        "assetClassName" to asset.assetClassName,
        "capDate" to asset.capDate,
        "assetOwner" to asset.assetOwner,
        "costCenter" to asset.costCenter,
        "costCenterName" to asset.costCenterName,
        "mainLocation" to asset.mainLocation,
        "lastLocationName" to asset.lastLocationName,
        "environment" to asset.environment.toJson(),
        "mobility" to asset.mobility.toJson(),
        "status" to asset.status,
        "currentStatus" to asset.currentStatus,
        "lastImageUrl" to asset.lastImageUrl,
        "lastCondition" to asset.lastCondition,
        "remarks" to asset.remarks,
        "updatedAt" to asset.updatedAt?.toString(),
        "updatedBy" to asset.updatedBy,
        "history" to asset.history.map { AuditHistoryMapper.toJson(it) },
    )
}