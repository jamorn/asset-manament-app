package com.plbg.assetapp.ui.audit

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.CameraAlt
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import coil.compose.AsyncImage
import coil.request.ImageRequest
import com.plbg.assetapp.domain.model.AssetModel
import java.io.File

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AuditScreen(
    asset: AssetModel,
    viewModel: AuditViewModel = hiltViewModel(),
    onBack: () -> Unit,
) {
    val submitStatus by viewModel.submitStatus.collectAsState()
    val context = LocalContext.current

    var location by remember { mutableStateOf(asset.lastLocationName) }
    var condition by remember { mutableStateOf("Normal") }
    var environment by remember { mutableStateOf(asset.environment.value) }
    var mobility by remember { mutableStateOf(asset.mobility.value) }
    var remarks by remember { mutableStateOf(asset.remarks ?: "") }
    var imageUri by remember { mutableStateOf<Uri?>(null) }

    var conditionExpanded by remember { mutableStateOf(false) }
    var environmentExpanded by remember { mutableStateOf(false) }
    var mobilityExpanded by remember { mutableStateOf(false) }

    val conditionOptions = listOf("Normal", "Damaged", "Missing", "Not Found", "Under Maintenance")
    val environmentOptions = listOf("indoor", "outdoor")
    val mobilityOptions = listOf("fixed", "portable")

    val imagePickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent()
    ) { uri: Uri? -> imageUri = uri }

    LaunchedEffect(submitStatus) {
        if (submitStatus is AuditViewModel.SubmitStatus.Success) onBack()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Audit: ${asset.assetNo}") },
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
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
        ) {
            // Asset info
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(asset.description, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                    Spacer(Modifier.height(4.dp))
                    Text("Asset No: ${asset.assetNo}", style = MaterialTheme.typography.bodySmall)
                    if (asset.costCenterName.isNotEmpty())
                        Text("Cost Center: ${asset.costCenterName}", style = MaterialTheme.typography.bodySmall)
                }
            }
            Spacer(Modifier.height(12.dp))

            // Photo
            Text("PHOTO", style = MaterialTheme.typography.labelMedium)
            Spacer(Modifier.height(4.dp))
            if (imageUri != null) {
                AsyncImage(
                    model = ImageRequest.Builder(context).data(imageUri).crossfade(true).build(),
                    contentDescription = "Photo",
                    modifier = Modifier.fillMaxWidth().height(200.dp),
                    contentScale = ContentScale.Crop,
                )
            }
            OutlinedButton(
                onClick = { imagePickerLauncher.launch("image/*") },
                modifier = Modifier.fillMaxWidth(),
            ) {
                Icon(Icons.Default.CameraAlt, contentDescription = null)
                Spacer(Modifier.width(8.dp))
                Text(if (imageUri != null) "Change Photo" else "Take / Pick Photo")
            }
            Spacer(Modifier.height(12.dp))

            // Location
            OutlinedTextField(
                value = location,
                onValueChange = { location = it },
                modifier = Modifier.fillMaxWidth(),
                label = { Text("Location") },
            )
            Spacer(Modifier.height(12.dp))

            // Condition dropdown
            DropdownField(label = "Condition", value = condition, expanded = conditionExpanded,
                onExpandedChange = { conditionExpanded = it }, options = conditionOptions,
                onSelect = { condition = it; conditionExpanded = false })
            Spacer(Modifier.height(8.dp))

            // Environment + Mobility side by side
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                DropdownField(
                    label = "Environment", value = environment, expanded = environmentExpanded,
                    onExpandedChange = { environmentExpanded = it }, options = environmentOptions,
                    onSelect = { environment = it; environmentExpanded = false },
                    modifier = Modifier.weight(1f),
                )
                DropdownField(
                    label = "Mobility", value = mobility, expanded = mobilityExpanded,
                    onExpandedChange = { mobilityExpanded = it }, options = mobilityOptions,
                    onSelect = { mobility = it; mobilityExpanded = false },
                    modifier = Modifier.weight(1f),
                )
            }
            Spacer(Modifier.height(12.dp))

            // Remarks
            OutlinedTextField(
                value = remarks,
                onValueChange = { remarks = it },
                modifier = Modifier.fillMaxWidth(),
                label = { Text("Remarks") },
                maxLines = 3,
            )
            Spacer(Modifier.height(24.dp))

            // Submit button
            Button(
                onClick = {
                    val imageFile = if (imageUri != null) {
                        val inputStream = context.contentResolver.openInputStream(imageUri!!)
                        val tempFile = File(context.cacheDir, "audit_${System.currentTimeMillis()}.jpg")
                        inputStream?.use { i -> tempFile.outputStream().use { o -> i.copyTo(o) } }
                        tempFile
                    } else File("")
                    viewModel.submitAudit(asset, location, condition, imageFile, environment, mobility, remarks)
                },
                modifier = Modifier.fillMaxWidth(),
                enabled = submitStatus !is AuditViewModel.SubmitStatus.Submitting,
            ) {
                if (submitStatus is AuditViewModel.SubmitStatus.Submitting) {
                    CircularProgressIndicator(Modifier.size(20.dp), color = MaterialTheme.colorScheme.onPrimary)
                    Spacer(Modifier.width(8.dp))
                }
                Text("Confirm & Save")
            }

            if (submitStatus is AuditViewModel.SubmitStatus.Error) {
                Spacer(Modifier.height(8.dp))
                Text("Error: ${(submitStatus as AuditViewModel.SubmitStatus.Error).message}", color = MaterialTheme.colorScheme.error)
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun DropdownField(
    label: String,
    value: String,
    expanded: Boolean,
    onExpandedChange: (Boolean) -> Unit,
    options: List<String>,
    onSelect: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    ExposedDropdownMenuBox(expanded = expanded, onExpandedChange = onExpandedChange) {
        OutlinedTextField(
            value = value,
            onValueChange = {},
            readOnly = true,
            modifier = modifier.fillMaxWidth().menuAnchor(),
            label = { Text(label) },
            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
        )
        ExposedDropdownMenu(expanded = expanded, onDismissRequest = { onExpandedChange(false) }) {
            options.forEach { option ->
                DropdownMenuItem(text = { Text(option) }, onClick = { onSelect(option) })
            }
        }
    }
}