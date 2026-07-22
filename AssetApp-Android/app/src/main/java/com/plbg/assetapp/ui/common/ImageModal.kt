package com.plbg.assetapp.ui.common

import android.net.Uri
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import coil.request.ImageRequest

@Composable
fun ImageModal(
    imageUrl: String?,
    onClose: () -> Unit,
) {
    if (imageUrl == null) return

    AlertDialog(
        onDismissRequest = onClose,
        confirmButton = {},
        dismissButton = {
            TextButton(onClick = onClose) { Text("Close") }
        },
        title = null,
        text = {
            val context = LocalContext.current
            AsyncImage(
                model = ImageRequest.Builder(context)
                    .data(imageUrl)
                    .crossfade(true)
                    .build(),
                contentDescription = "Image",
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable(onClick = onClose),
                contentScale = ContentScale.Fit,
            )
        },
        shape = RoundedCornerShape(16.dp),
    )
}