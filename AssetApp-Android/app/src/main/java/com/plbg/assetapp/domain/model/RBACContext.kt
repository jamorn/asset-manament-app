// domain/model/RBACContext.kt
data class RBACContext(
    val role: String? = null,
    val allowedCostCenters: List<String>? = null,
    val skipFilter: Boolean = false,
)

data class CostCenterInfo(
    val costCenter: String,
    val costCenterName: String,
    var count: Int = 0,
)

data class CostCenterStats(
    val costCenter: String,
    val costCenterName: String,
    var total: Int = 0,
    var audited: Int = 0,
)

data class AssetClassStats(
    val assetClass: String,
    val assetClassName: String,
    var total: Int = 0,
    var audited: Int = 0,
)