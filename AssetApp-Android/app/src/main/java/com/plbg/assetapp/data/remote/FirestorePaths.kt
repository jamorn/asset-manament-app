package com.plbg.assetapp.data.remote

import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import com.google.firebase.firestore.Source
import com.plbg.assetapp.data.mapper.AssetMapper
import com.plbg.assetapp.domain.model.AssetModel
import kotlinx.coroutines.tasks.await
import javax.inject.Inject

object FirestorePath {
    const val ASSETS = "artifacts/irpc-asset-audit/public/data/assets"
    const val TEMP_PHOTOS = "artifacts/irpc-asset-audit/public/data/temp_photos"
    const val SETTINGS = "artifacts/irpc-asset-audit/config/settings"
    const val AUDIT_PHOTOS = "artifacts/irpc-asset-audit/audit_photos"
    const val TEMP_PHOTOS_STORAGE = "artifacts/irpc-asset-audit/temp_photos"
}

class FirebaseAssetDataSource @Inject constructor(
    private val firestore: FirebaseFirestore,
) {
    private val collection get() = firestore.collection(FirestorePath.ASSETS)

    suspend fun fetchAssets(costCenters: List<String>?, role: String?): List<AssetModel> {
        var query: Query = collection.orderBy("assetNo")

        if (role != "owner" && !costCenters.isNullOrEmpty()) {
            query = query.whereIn("costCenter", costCenters)
        }

        return query.get(Source.SERVER)
            .await()
            .documents
            .mapNotNull { doc ->
                doc.data?.let { AssetMapper.fromFirestore(it, doc.id) }
            }
    }

    suspend fun getAuditedAssetNos(year: String): Set<String> =
        firestore.collectionGroup("audit_logs")
            .whereEqualTo("auditYear", year)
            .get()
            .await()
            .documents
            .mapNotNull { doc ->
                val segments = doc.reference.path.split("/")
                val assetIdx = segments.indexOf("assets")
                if (assetIdx != -1 && segments.size >= assetIdx + 2) {
                    segments[assetIdx + 1]
                } else null
            }
            .toSet()

    suspend fun refreshSingleAsset(assetNo: String): AssetModel? {
        val doc = collection.document(assetNo).get(Source.SERVER).await()
        return if (doc.exists && doc.data != null) {
            AssetMapper.fromFirestore(doc.data!!, doc.id)
        } else null
    }
}