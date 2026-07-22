package com.plbg.assetapp.domain.model

enum class Environment(val value: String) {
    INDOOR("indoor"),
    OUTDOOR("outdoor");

    val display: String
        get() = when (this) {
            INDOOR -> "Indoor"
            OUTDOOR -> "Outdoor"
        }

    companion object {
        fun fromString(value: String?): Environment =
            entries.firstOrNull { it.value == value?.lowercase() } ?: INDOOR
    }

    fun toJson(): String = value
}

enum class Mobility(val value: String) {
    FIXED("fixed"),
    PORTABLE("portable");

    val display: String
        get() = when (this) {
            FIXED -> "Fixed"
            PORTABLE -> "Portable"
        }

    companion object {
        fun fromString(value: String?): Mobility =
            entries.firstOrNull { it.value == value?.lowercase() } ?: FIXED
    }

    fun toJson(): String = value
}

enum class AuditStatus(val value: String) {
    PENDING("pending"),
    AUDITED("audited");

    companion object {
        fun fromString(value: String?): AuditStatus =
            entries.firstOrNull { it.value == value?.lowercase() } ?: PENDING
    }
}

enum class TempPhotoStatus { PENDING, MERGED }