// ui/survey/CostCenterSelector.kt
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
import com.plbg.assetapp.domain.model.CostCenterInfo

@Composable
fun CostCenterSelector(
    costCenters: List<CostCenterInfo>,
    selectedCostCenter: String?,
    onSelect: (String?) -> Unit,
    hideAll: Boolean = false,
) {
    Column {
        Text(
            "Cost Center",
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.Bold,
        )
        Spacer(modifier = Modifier.height(4.dp))
        Row(
            modifier = Modifier.horizontalScroll(rememberScrollState()),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            if (!hideAll) {
                FilterChip(
                    selected = selectedCostCenter == null,
                    onClick = { onSelect(null) },
                    label = { Text("All", fontSize = 11.sp) },
                )
            }
            costCenters.forEach { cc ->
                FilterChip(
                    selected = selectedCostCenter == cc.costCenter,
                    onClick = {
                        onSelect(if (selectedCostCenter == cc.costCenter) null else cc.costCenter)
                    },
                    label = {
                        Text(
                            "${cc.costCenter} (${cc.count})",
                            fontSize = 11.sp,
                        )
                    },
                )
            }
        }
    }
}
