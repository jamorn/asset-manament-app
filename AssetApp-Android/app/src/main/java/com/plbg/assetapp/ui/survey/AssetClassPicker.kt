// ui/survey/AssetClassPicker.kt
package com.plbg.assetapp.ui.survey

import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.plbg.assetapp.domain.model.AssetClassStats

@Composable
fun AssetClassPicker(
    classes: List<AssetClassStats>,
    selectedClass: String?,
    onSelect: (String?) -> Unit,
) {
    Column {
        Text(
            "Asset Class",
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.Bold,
        )
        Spacer(modifier = Modifier.height(4.dp))
        Row(
            modifier = Modifier.horizontalScroll(rememberScrollState()),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            FilterChip(
                selected = selectedClass == null,
                onClick = { onSelect(null) },
                label = { Text("All Classes", fontSize = 11.sp) },
            )
            classes.forEach { ac ->
                FilterChip(
                    selected = selectedClass == ac.assetClass,
                    onClick = {
                        onSelect(if (selectedClass == ac.assetClass) null else ac.assetClass)
                    },
                    label = {
                        Text("${ac.assetClass} (${ac.total})", fontSize = 11.sp)
                    },
                )
            }
        }
    }
}
