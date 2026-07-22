package com.plbg.assetapp.domain.model

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

object DefaultValues {
    const val DESCRIPTION = "(No description)"
    const val UNKNOWN = "unknown"
    const val ENVIRONMENT = "unknown"
    const val MOBILITY = "unknown"
    const val STATUS = "unknown"
    const val OWNER = ""
    const val COST_CENTER = ""
    const val COST_CENTER_NAME = ""
    const val LOCATION = ""
    const val IMAGE_URL = ""
    const val CONDITION = "Normal"
    const val UPDATED_BY = ""
    const val CURRENT_STATUS = 0
    val AUDIT_YEAR: String get() = LocalDateTime.now().year.toString()
}

fun LocalDateTime.toIsoString(): String =
    this.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)

fun String.toLocalDateTimeSafe(): LocalDateTime? =
    runCatching { LocalDateTime.parse(this) }.getOrNull()