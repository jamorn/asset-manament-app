package com.plbg.assetapp.domain.model

enum class RoutePolicy { PUBLIC, HYBRID, PRIVATE }

enum class UserRole(val displayName: String) {
    OWNER("Owner"),
    ADMIN("Admin"),
    USER("User"),
    VIEWER("Viewer");
}

data class AppRouteConfig(
    val name: String,
    val label: String,
    val policy: RoutePolicy,
    val allowedRoles: List<UserRole>? = null,
)

object AppRoutes {
    const val SURVEY = "survey"
    const val DASHBOARD = "dashboard"
    const val SEARCH = "search"
    const val TEMP_PHOTOS = "tempphoto"
    const val AUDIT = "audit"

    private val routes = listOf(
        AppRouteConfig(SURVEY, "Asset Survey", RoutePolicy.PRIVATE,
            listOf(UserRole.OWNER, UserRole.ADMIN, UserRole.USER)),
        AppRouteConfig(DASHBOARD, "Dashboard", RoutePolicy.PUBLIC),
        AppRouteConfig(SEARCH, "Search", RoutePolicy.PUBLIC),
        AppRouteConfig(TEMP_PHOTOS, "Temp Photos", RoutePolicy.PRIVATE,
            listOf(UserRole.OWNER, UserRole.ADMIN)),
    )

    fun getRoute(name: String): AppRouteConfig? = routes.find { it.name == name }
    fun getPolicy(name: String): RoutePolicy? = getRoute(name)?.policy

    fun getAllowedCostCenters(
        screenName: String,
        role: String?,
        userCostCenters: List<String>?,
    ): List<String>? {
        if (role == null) return emptyList()
        if (role == "owner") return null
        val policy = getPolicy(screenName)
        if (policy == RoutePolicy.PUBLIC) return null
        if (userCostCenters.isNullOrEmpty()) return emptyList()
        return userCostCenters
    }
}