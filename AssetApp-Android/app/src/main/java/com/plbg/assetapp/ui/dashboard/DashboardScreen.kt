package com.plbg.assetapp.ui.dashboard

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.plbg.assetapp.domain.model.CostCenterStats

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DashboardScreen(
    viewModel: DashboardViewModel = hiltViewModel(),
    onBack: () -> Unit,
) {
    val assets by viewModel.assets.collectAsState()
    val auditYear by viewModel.auditYear.collectAsState()
    val costCenterStats by viewModel.costCenterStats.collectAsState()
    val totalCount by viewModel.totalCount.collectAsState()
    val auditedCount by viewModel.auditedCount.collectAsState()

    val remaining = totalCount - auditedCount
    val progress = if (totalCount > 0) auditedCount.toFloat() / totalCount else 0f

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Dashboard", fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    var expanded by remember { mutableStateOf(false) }
                    Box {
                        TextButton(onClick = { expanded = true }) {
                            Text(auditYear)
                        }
                        DropdownMenu(
                            expanded = expanded,
                            onDismissRequest = { expanded = false },
                        ) {
                            listOf("2024", "2025", "2026").forEach { year ->
                                DropdownMenuItem(
                                    text = { Text(year) },
                                    onClick = {
                                        viewModel.setAuditYear(year)
                                        expanded = false
                                    },
                                )
                            }
                        }
                    }

                    IconButton(onClick = { viewModel.refresh() }) {
                        Icon(Icons.Default.Refresh, contentDescription = "Refresh")
                    }
                },
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
        ) {
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = MaterialTheme.shapes.large,
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        "Survey Summary",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceAround,
                    ) {
                        StatColumn("Total", totalCount.toString(), MaterialTheme.colorScheme.primary)
                        StatColumn("Audited", auditedCount.toString(), Color(0xFF4CAF50))
                        StatColumn("Remaining", remaining.toString(), Color(0xFFFF9800))
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    LinearProgressIndicator(
                        progress = { progress },
                        modifier = Modifier.fillMaxWidth(),
                        color = Color(0xFF4CAF50),
                    )
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            Text(
                "By Cost Center",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
            )

            Spacer(modifier = Modifier.height(8.dp))

            Card(modifier = Modifier.fillMaxWidth()) {
                Column {
                    costCenterStats.forEachIndexed { index, cc ->
                        CostCenterRow(cc = cc)
                        if (index < costCenterStats.lastIndex) {
                            HorizontalDivider()
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun StatColumn(label: String, value: String, color: Color) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text(
            value,
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold,
            color = color,
        )
        Text(
            label,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}

@Composable
private fun CostCenterRow(cc: CostCenterStats) {
    val progress = if (cc.total > 0) cc.audited.toFloat() / cc.total else 0f

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(12.dp),
    ) {
        Text(
            "${cc.costCenter} - ${cc.costCenterName}",
            style = MaterialTheme.typography.bodyMedium,
            fontWeight = FontWeight.Bold,
        )

        Spacer(modifier = Modifier.height(4.dp))

        Text(
            "Total: ${cc.total} | Audited: ${cc.audited} | Remaining: ${cc.total - cc.audited}",
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )

        Spacer(modifier = Modifier.height(8.dp))

        LinearProgressIndicator(
            progress = { progress },
            modifier = Modifier.fillMaxWidth(),
            color = Color(0xFF4CAF50),
        )
    }
}