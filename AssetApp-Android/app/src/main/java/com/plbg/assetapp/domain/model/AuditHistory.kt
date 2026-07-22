package com.plbg.assetapp.domain.model

import java.time.LocalDateTime

data class AuditHistory(
    val action: String,
    val performedBy: String,
    val timestamp: LocalDateTime,
    val changes: Map<String, Any?>,
)