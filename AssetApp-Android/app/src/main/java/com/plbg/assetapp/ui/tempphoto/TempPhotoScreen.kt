package com.plbg.assetapp.ui.tempphoto

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.plbg.assetapp.domain.model.TempPhoto
import com.plbg.assetapp.domain.model.TempPhotoStatus

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TempPhotoScreen(
    viewModel: TempPhotoViewModel = hiltViewModel(),
    onBack: () -> Unit,
) {
    val tempPhotos by viewModel.tempPhotos.collectAsState()
    val loading by viewModel.loading.collectAsState()

    var showDeleteDialog by remember { mutableStateOf<String?>(null) }
    var showAcceptDialog by remember { mutableStateOf<TempPhoto?>(null) }
    var showFormDialog by remember { mutableStateOf(false) }
    var editingTempPhoto by remember { mutableStateOf<TempPhoto?>(null) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Temp Photos") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
            )
        },
        floatingActionButton = {
            FloatingActionButton(onClick = {
                editingTempPhoto = null
                showFormDialog = true
            }) {
                Icon(Icons.Default.Add, contentDescription = "Add")
            }
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text(
                    "Temp Photos",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                )
                Spacer(modifier = Modifier.width(8.dp))
                com.plbg.assetapp.ui.common.Badge(text = "${tempPhotos.size}")
            }

            Spacer(modifier = Modifier.height(8.dp))

            if (loading) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
            } else if (tempPhotos.isEmpty()) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("No Temp Photos")
                        Spacer(modifier = Modifier.height(8.dp))
                        Button(onClick = {
                            editingTempPhoto = null
                            showFormDialog = true
                        }) { Text("Add New Temp Photo") }
                    }
                }
            } else {
                LazyColumn {
                    items(tempPhotos, key = { it.tempId }) { tempPhoto ->
                        TempPhotoCard(
                            tempPhoto = tempPhoto,
                            onImageClick = { /* TODO: Show image modal */ },
                            onAccept = { showAcceptDialog = tempPhoto },
                            onEdit = {
                                editingTempPhoto = tempPhoto
                                showFormDialog = true
                            },
                            onDelete = { showDeleteDialog = tempPhoto.tempId },
                        )
                    }
                }
            }
        }
    }

    // Delete confirmation
    showDeleteDialog?.let { tempId ->
        AlertDialog(
            onDismissRequest = { showDeleteDialog = null },
            title = { Text("Delete Temp Photo") },
            text = { Text("Are you sure you want to delete this temp photo?") },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.deleteTempPhoto(tempId)
                    showDeleteDialog = null
                }) { Text("Delete", color = MaterialTheme.colorScheme.error) }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteDialog = null }) { Text("Cancel") }
            },
        )
    }

    // Accept dialog
    showAcceptDialog?.let { tempPhoto ->
        var newAssetNo by remember { mutableStateOf(tempPhoto.referenceAssetNo) }
        AlertDialog(
            onDismissRequest = { showAcceptDialog = null },
            title = { Text("Accept as Asset") },
            text = {
                Column {
                    Text("Create a new asset from this temp photo?")
                    Spacer(Modifier.height(8.dp))
                    OutlinedTextField(
                        value = newAssetNo,
                        onValueChange = { newAssetNo = it },
                        label = { Text("New Asset No") },
                        modifier = Modifier.fillMaxWidth(),
                    )
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.acceptAsAsset(tempPhoto.tempId, newAssetNo)
                    showAcceptDialog = null
                }) { Text("Accept") }
            },
            dismissButton = {
                TextButton(onClick = { showAcceptDialog = null }) { Text("Cancel") }
            },
        )
    }

    // Add / Edit form dialog
    if (showFormDialog) {
        val editing = editingTempPhoto
        var refAssetNo by remember { mutableStateOf(editing?.referenceAssetNo ?: "") }
        var description by remember { mutableStateOf(editing?.description ?: "") }
        var location by remember { mutableStateOf(editing?.location ?: "") }
        var assetClass by remember { mutableStateOf(editing?.assetClass ?: "") }
        var costCenter by remember { mutableStateOf(editing?.costCenter ?: "") }

        AlertDialog(
            onDismissRequest = { showFormDialog = false },
            title = { Text(if (editing != null) "Edit Temp Photo" else "New Temp Photo") },
            text = {
                Column {
                    OutlinedTextField(
                        value = refAssetNo,
                        onValueChange = { refAssetNo = it },
                        label = { Text("Reference Asset No") },
                        modifier = Modifier.fillMaxWidth(),
                    )
                    Spacer(Modifier.height(8.dp))
                    OutlinedTextField(
                        value = description,
                        onValueChange = { description = it },
                        label = { Text("Description") },
                        modifier = Modifier.fillMaxWidth(),
                        maxLines = 3,
                    )
                    Spacer(Modifier.height(8.dp))
                    OutlinedTextField(
                        value = location,
                        onValueChange = { location = it },
                        label = { Text("Location") },
                        modifier = Modifier.fillMaxWidth(),
                    )
                    Spacer(Modifier.height(8.dp))
                    OutlinedTextField(
                        value = assetClass,
                        onValueChange = { assetClass = it },
                        label = { Text("Asset Class") },
                        modifier = Modifier.fillMaxWidth(),
                    )
                    Spacer(Modifier.height(8.dp))
                    OutlinedTextField(
                        value = costCenter,
                        onValueChange = { costCenter = it },
                        label = { Text("Cost Center") },
                        modifier = Modifier.fillMaxWidth(),
                    )
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    if (editing != null) {
                        viewModel.saveTempPhoto(
                            tempId = editing.tempId,
                            refAssetNo = refAssetNo,
                            description = description,
                            location = location,
                            assetClass = assetClass,
                            costCenter = costCenter,
                        )
                    } else {
                        viewModel.saveTempPhoto(
                            tempId = "temp_${System.currentTimeMillis()}",
                            refAssetNo = refAssetNo,
                            description = description,
                            location = location,
                            assetClass = assetClass,
                            costCenter = costCenter,
                        )
                    }
                    showFormDialog = false
                }) { Text(if (editing != null) "Save" else "Create") }
            },
            dismissButton = {
                TextButton(onClick = { showFormDialog = false }) { Text("Cancel") }
            },
        )
    }
}

@Composable
private fun TempPhotoCard(
    tempPhoto: TempPhoto,
    onImageClick: () -> Unit,
    onAccept: () -> Unit,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
) {
    Card(
        modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
    ) {
        Row(modifier = Modifier.padding(12.dp)) {
            Spacer(Modifier.width(12.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    tempPhoto.tempId,
                    style = MaterialTheme.typography.labelSmall,
                    fontWeight = FontWeight.Bold,
                )
                Text(
                    "Ref: ${tempPhoto.referenceAssetNo}",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.primary,
                )
                Text(
                    tempPhoto.description,
                    style = MaterialTheme.typography.bodyMedium,
                    maxLines = 2,
                )
            }

            Column {
                if (tempPhoto.status == TempPhotoStatus.PENDING) {
                    TextButton(onClick = onAccept) { Text("Accept") }
                }
                TextButton(onClick = onEdit) { Text("Edit") }
                TextButton(onClick = onDelete) { Text("Delete") }
            }
        }
    }
}