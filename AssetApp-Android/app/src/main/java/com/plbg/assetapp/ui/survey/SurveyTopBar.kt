// ui/survey/SurveyTopBar.kt
package com.plbg.assetapp.ui.survey

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.plbg.assetapp.ui.auth.AuthUser

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SurveyTopBar(
    user: AuthUser,
    isTablet: Boolean,
    onSearch: () -> Unit,
    onDashboard: () -> Unit,
    onTempPhotos: () -> Unit,
    onLogout: () -> Unit,
) {
    TopAppBar(
        title = {
            Column {
                Text("Asset Survey", fontWeight = FontWeight.Bold)
                Text(
                    user.displayName ?: user.email,
                    style = MaterialTheme.typography.bodySmall,
                )
            }
        },
        actions = {
            IconButton(onClick = onSearch) {
                Icon(Icons.Default.Search, contentDescription = "Search")
            }
            IconButton(onClick = onDashboard) {
                Icon(Icons.Default.Dashboard, contentDescription = "Dashboard")
            }
            IconButton(onClick = onTempPhotos) {
                Icon(Icons.Default.CameraAlt, contentDescription = "Temp Photos")
            }
            IconButton(onClick = onLogout) {
                Icon(Icons.Default.Logout, contentDescription = "Logout")
            }
        },
    )
}
