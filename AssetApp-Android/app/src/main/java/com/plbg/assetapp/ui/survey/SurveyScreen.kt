package com.plbg.assetapp.ui.survey

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.plbg.assetapp.domain.model.AppRoutes
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.model.RBACContext
import com.plbg.assetapp.domain.usecase.RbacService
import com.plbg.assetapp.ui.auth.AuthUser
import com.plbg.assetapp.ui.auth.AuthViewModel
import com.plbg.assetapp.ui.common.AssetSearchBar
import com.plbg.assetapp.ui.common.LoadMoreList

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SurveyScreen(
    viewModel: AssetViewModel = hiltViewModel(),
    authViewModel: AuthViewModel = hiltViewModel(),
    onNavigateToAudit: (AssetModel) -> Unit,
    onNavigateToSearch: () -> Unit,
    onNavigateToDashboard: () -> Unit,
    onNavigateToTempPhotos: () -> Unit,
) {
    val uiState by viewModel.uiState.collectAsState()
    val authState by authViewModel.uiState.collectAsState()
    val auditedAssetNos by viewModel.auditedAssetNos.collectAsState()

    var selectedCostCenter by rememberSaveable { mutableStateOf<String?>(null) }
    var selectedAssetClass by rememberSaveable { mutableStateOf<String?>(null) }
    var searchQuery by rememberSaveable { mutableStateOf("") }
    var showUnauditedOnly by rememberSaveable { mutableStateOf(true) }

    when (val state = authState) {
        is AuthViewModel.UiState.Loading -> {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
            return
        }
        is AuthViewModel.UiState.NotLoggedIn -> {
            com.plbg.assetapp.ui.auth.LoginScreen(
                onLogin = { authViewModel.login() }
            )
            return
        }
        is AuthViewModel.UiState.Unauthorized -> {
            com.plbg.assetapp.ui.auth.UnauthorizedScreen(
                email = state.email,
                onLogout = { authViewModel.logout() }
            )
            return
        }
        is AuthViewModel.UiState.LoggedIn -> { }
    }

    val authUser = (authState as AuthViewModel.UiState.LoggedIn).user
    val assets = when (val state = uiState) {
        is AssetViewModel.UiState.Success -> state.assets
        else -> emptyList()
    }

    val allowedCostCenters = AppRoutes.getAllowedCostCenters(
        screenName = AppRoutes.SURVEY,
        role = authUser.role,
        userCostCenters = authUser.allowedCostCenters,
    )

    val visibleAssets = remember(assets, allowedCostCenters, authUser.role) {
        RbacService.filterAssets(
            assets,
            RBACContext(role = authUser.role, allowedCostCenters = allowedCostCenters),
        )
    }

    LaunchedEffect(allowedCostCenters) {
        if (selectedCostCenter == null &&
            allowedCostCenters is List &&
            allowedCostCenters.isNotEmpty()) {
            selectedCostCenter = allowedCostCenters[0]
        }
    }

    val filteredAssets = remember(
        visibleAssets, selectedCostCenter, selectedAssetClass,
        searchQuery, showUnauditedOnly, auditedAssetNos
    ) {
        visibleAssets
            .filter { selectedCostCenter == null || it.costCenter == selectedCostCenter }
            .filter { selectedAssetClass == null || it.assetClass == selectedAssetClass }
            .filter { !showUnauditedOnly || !auditedAssetNos.contains(it.assetNo) }
            .filter {
                searchQuery.isEmpty() || run {
                    val q = searchQuery.uppercase()
                    it.assetNo.uppercase().contains(q) ||
                    it.description.uppercase().contains(q) ||
                    it.lastLocationName.uppercase().contains(q) ||
                    it.costCenter.uppercase().contains(q) ||
                    (it.remarks?.uppercase() ?: "").contains(q)
                }
            }
    }

    val availableCostCenters = remember(visibleAssets, authUser.role, allowedCostCenters) {
        RbacService.getAvailableCostCenters(
            visibleAssets,
            RBACContext(role = authUser.role, allowedCostCenters = allowedCostCenters),
        )
    }

    val availableAssetClasses = remember(visibleAssets, selectedCostCenter) {
        val pool = if (selectedCostCenter != null)
            visibleAssets.filter { it.costCenter == selectedCostCenter }
        else visibleAssets
        pool.groupBy { it.assetClass }.map { (ac, list) ->
            com.plbg.assetapp.domain.model.AssetClassStats(
                assetClass = ac,
                assetClassName = list.first().assetClassName,
                total = list.size,
                audited = list.count { auditedAssetNos.contains(it.assetNo) },
            )
        }.sortedBy { it.assetClass }
    }

    val isTablet = LocalConfiguration.current.smallestScreenWidthDp >= 600

    Scaffold(
        topBar = {
            SurveyTopBar(
                user = authUser,
                isTablet = isTablet,
                onSearch = onNavigateToSearch,
                onDashboard = onNavigateToDashboard,
                onTempPhotos = onNavigateToTempPhotos,
                onLogout = { authViewModel.logout() },
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(12.dp),
        ) {
            val totalCount by viewModel.totalCount.collectAsState()
            val auditedCount by viewModel.auditedCount.collectAsState()

            LinearProgressIndicator(
                progress = { if (totalCount > 0) auditedCount.toFloat() / totalCount else 0f },
                modifier = Modifier.fillMaxWidth(),
            )
            Spacer(Modifier.height(8.dp))
            Text("$auditedCount/$totalCount audited", fontSize = 12.sp)

            Spacer(Modifier.height(12.dp))

            CostCenterSelector(
                costCenters = availableCostCenters,
                selectedCostCenter = selectedCostCenter,
                onSelect = { selectedCostCenter = it; selectedAssetClass = null },
                hideAll = allowedCostCenters is List,
            )

            Spacer(Modifier.height(12.dp))

            if (selectedCostCenter != null && availableAssetClasses.isNotEmpty()) {
                AssetClassPicker(
                    classes = availableAssetClasses,
                    selectedClass = selectedAssetClass,
                    onSelect = { selectedAssetClass = it },
                )
                Spacer(Modifier.height(12.dp))
            }

            Row(verticalAlignment = Alignment.CenterVertically) {
                Switch(
                    checked = showUnauditedOnly,
                    onCheckedChange = { showUnauditedOnly = it },
                )
                Text(
                    if (showUnauditedOnly) "Pending audit" else "All",
                    fontSize = 12.sp,
                )
                Spacer(Modifier.weight(1f))
                Text("${filteredAssets.size} items", fontSize = 11.sp)
            }

            AssetSearchBar(
                value = searchQuery,
                onValueChange = { searchQuery = it },
            )

            when (val state = uiState) {
                is AssetViewModel.UiState.Loading -> {
                    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        CircularProgressIndicator()
                    }
                }
                is AssetViewModel.UiState.Error -> {
                    Text(
                        state.message,
                        color = MaterialTheme.colorScheme.error,
                        fontSize = 14.sp,
                    )
                }
                is AssetViewModel.UiState.Success -> {
                    LoadMoreList(
                        assets = filteredAssets,
                        auditedSet = auditedAssetNos,
                        onAssetClick = onNavigateToAudit,
                        pageSize = 50,
                    )
                }
            }
        }
    }
}