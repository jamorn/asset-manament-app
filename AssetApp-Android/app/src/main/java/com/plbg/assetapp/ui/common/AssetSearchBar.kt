package com.plbg.assetapp.ui.common

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import coil.request.ImageRequest
import com.plbg.assetapp.domain.model.AssetModel

@Composable
fun AssetSearchBar(
    value: String,
    onValueChange: (String) -> Unit,
    placeholder: String = "Search by asset code or location...",
) {
    var text by remember(value) { mutableStateOf(value) }

    OutlinedTextField(
        value = text,
        onValueChange = {
            text = it
            onValueChange(it)
        },
        modifier = Modifier
            .fillMaxWidth()
            .padding(bottom = 12.dp),
        placeholder = { Text(placeholder, fontSize = 14.sp) },
        leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
        shape = RoundedCornerShape(16.dp),
        singleLine = true,
        colors = OutlinedTextFieldDefaults.colors(
            focusedBorderColor = MaterialTheme.colorScheme.primary,
        ),
    )
}

@Composable
fun AssetCard(
    asset: AssetModel,
    isAudited: Boolean,
    onClick: () -> Unit,
    onImageClick: () -> Unit,
) {
    val context = LocalContext.current

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
            .clickable(onClick = onClick),
        shape = RoundedCornerShape(12.dp),
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.Top,
        ) {
            AsyncImage(
                model = ImageRequest.Builder(context)
                    .data(asset.lastImageUrl)
                    .crossfade(true)
                    .build(),
                contentDescription = null,
                modifier = Modifier
                    .size(54.dp)
                    .clip(RoundedCornerShape(8.dp))
                    .clickable(enabled = asset.lastImageUrl.isNotEmpty()) { onImageClick() },
                contentScale = ContentScale.Crop,
            )

            Spacer(Modifier.width(12.dp))

            Column(modifier = Modifier.weight(1f)) {
                Row {
                    Text(
                        asset.assetNo,
                        fontWeight = FontWeight.Bold,
                        fontSize = 13.sp,
                    )
                    if (isAudited && asset.remarks.isNullOrEmpty()) {
                        Spacer(Modifier.width(4.dp))
                        Text("Done", fontSize = 11.sp, color = Color(0xFF4CAF50))
                    }
                }
                Text(
                    asset.description,
                    fontSize = 12.sp,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis,
                )
                Spacer(Modifier.height(4.dp))
                Row {
                    Badge(text = asset.environmentDisplay)
                    Spacer(Modifier.width(4.dp))
                    Badge(text = asset.mobilityDisplay)
                }
                if (asset.lastCondition.isNotEmpty()) {
                    Text(
                        "Condition: ${asset.lastCondition}",
                        fontSize = 10.sp,
                        color = MaterialTheme.colorScheme.primary,
                    )
                }
            }

            Column(horizontalAlignment = Alignment.End) {
                Text(
                    asset.lastLocationName.ifEmpty { asset.mainLocation }.ifEmpty { "N/A" },
                    fontSize = 10.sp,
                    fontStyle = FontStyle.Italic,
                    textAlign = TextAlign.End,
                )
            }
        }
    }
}

@Composable
fun LoadMoreList(
    assets: List<AssetModel>,
    auditedSet: Set<String>,
    onAssetClick: (AssetModel) -> Unit,
    pageSize: Int = 50,
) {
    var visibleCount by remember { mutableStateOf(pageSize) }

    LaunchedEffect(assets) { visibleCount = pageSize }

    val visibleAssets = assets.take(visibleCount)
    val hasMore = visibleCount < assets.size
    val remaining = assets.size - visibleCount

    Column {
        Card(
            shape = RoundedCornerShape(16.dp),
            modifier = Modifier.fillMaxWidth(),
        ) {
            Column {
                visibleAssets.forEachIndexed { index, asset ->
                    AssetCard(
                        asset = asset,
                        isAudited = auditedSet.contains(asset.assetNo),
                        onClick = { onAssetClick(asset) },
                        onImageClick = { },
                    )
                    if (index < visibleAssets.lastIndex) {
                        HorizontalDivider(thickness = 0.5.dp)
                    }
                }
            }
        }

        if (hasMore) {
            Spacer(Modifier.height(12.dp))
            Button(
                onClick = { visibleCount += pageSize },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(12.dp),
            ) {
                Text("LOAD MORE ($remaining REMAINING)", fontWeight = FontWeight.Bold)
            }
        }
    }
}