package com.plbg.assetapp.ui.search

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.ui.common.AssetCard
import com.plbg.assetapp.ui.common.AssetSearchBar

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchScreen(
    viewModel: SearchViewModel = hiltViewModel(),
    onBack: () -> Unit,
    onAssetClick: (AssetModel) -> Unit,
) {
    val filteredAssets by viewModel.filteredAssets.collectAsState()
    val auditedAssetNos by viewModel.auditedAssetNos.collectAsState()
    var searchQuery by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Search") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(12.dp),
        ) {
            AssetSearchBar(
                value = searchQuery,
                onValueChange = {
                    searchQuery = it
                    viewModel.setSearchQuery(it)
                },
                placeholder = "Search by asset code or location...",
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                "${filteredAssets.size} items",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )

            Spacer(modifier = Modifier.height(8.dp))

            LazyColumn {
                items(filteredAssets, key = { it.assetNo }) { asset ->
                    AssetCard(
                        asset = asset,
                        isAudited = auditedAssetNos.contains(asset.assetNo),
                        onClick = { onAssetClick(asset) },
                        onImageClick = { },
                    )
                }
            }
        }
    }
}