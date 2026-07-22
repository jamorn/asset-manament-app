package com.plbg.assetapp.ui.navigation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.ui.audit.AuditScreen
import com.plbg.assetapp.ui.dashboard.DashboardScreen
import com.plbg.assetapp.ui.search.SearchScreen
import com.plbg.assetapp.ui.survey.AssetViewModel
import com.plbg.assetapp.ui.survey.SurveyScreen
import com.plbg.assetapp.ui.tempphoto.TempPhotoScreen

@Composable
fun AssetNavHost() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = "survey",
    ) {
        composable("survey") {
            SurveyScreen(
                onNavigateToAudit = { asset ->
                    navController.navigate("audit/${asset.assetNo}")
                },
                onNavigateToSearch = { navController.navigate("search") },
                onNavigateToDashboard = { navController.navigate("dashboard") },
                onNavigateToTempPhotos = { navController.navigate("tempphoto") },
            )
        }

        composable("search") {
            SearchScreen(
                onBack = { navController.popBackStack() },
                onAssetClick = { asset ->
                    navController.navigate("audit/${asset.assetNo}")
                },
            )
        }

        composable("dashboard") {
            DashboardScreen(onBack = { navController.popBackStack() })
        }

        composable("tempphoto") {
            TempPhotoScreen(onBack = { navController.popBackStack() })
        }

        composable(
            "audit/{assetNo}",
            arguments = listOf(navArgument("assetNo") { type = NavType.StringType }),
        ) { backStackEntry ->
            val assetNo = backStackEntry.arguments?.getString("assetNo") ?: return@composable
            // Fetch asset from ViewModel by assetNo
            val viewModel: AssetViewModel = hiltViewModel()
            val uiState by viewModel.uiState.collectAsState()
            val assets = when (uiState) {
                is AssetViewModel.UiState.Success -> (uiState as AssetViewModel.UiState.Success).assets
                else -> emptyList()
            }
            val asset = assets.find { it.assetNo == assetNo }

            if (asset != null) {
                AuditScreen(
                    asset = asset,
                    onBack = { navController.popBackStack() },
                )
            } else {
                // Trigger load if not loaded yet
                viewModel.loadData()
            }
        }
    }
}