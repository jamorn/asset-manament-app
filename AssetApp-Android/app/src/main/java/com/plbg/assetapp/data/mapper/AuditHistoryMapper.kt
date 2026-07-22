package com.plbg.assetapp.data.mapper

import com.google.firebase.Timestamp
import com.plbg.assetapp.domain.model.AuditHistory
import java.time.LocalDateTime
import java.time.ZoneId

object AuditHistoryMapper {

    fun fromJson(json: Map<String, Any?>): AuditHistory {
        return AuditHistory(
            action = json["action"]?.toString() ?: "UNKNOWN",
            performedBy = json["performedBy"]?.toString() ?: "",
            timestamp = parseTimestamp(json["timestamp"]) ?: LocalDateTime.now(),
            changes = parseChanges(json["changes"]),
        )
    }

    fun toJson(history: AuditHistory): Map<String, Any?> {
        return mapOf(
            "action" to history.action,
            "performedBy" to history.performedBy,
            "timestamp" to history.timestamp.toString(),
            "changes" to history.changes,
        )
    }

    private fun parseTimestamp(value: Any?): LocalDateTime? {
        return when (value) {
            null -> null
            is LocalDateTime -> value
            is Timestamp -> {
                value.toDate().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDateTime()
            }
            is String -> {
                runCatching { LocalDateTime.parse(value) }.getOrNull()
            }
            is Long -> {
                java.util.Date(value).toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDateTime()
            }
            else -> null
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun parseChanges(value: Any?): Map<String, Any?> {
        return when (value) {
            null -> emptyMap()
            is Map<*, *> -> value as Map<String, Any?>
            else -> emptyMap()
        }
    }
}