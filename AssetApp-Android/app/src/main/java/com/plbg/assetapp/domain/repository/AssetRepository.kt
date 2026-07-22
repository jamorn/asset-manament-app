package com.plbg.assetapp.domain.repository

import com.google.firebase.auth.FirebaseUser
import com.plbg.assetapp.domain.model.AcceptResult
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.model.AuditData
import com.plbg.assetapp.domain.model.SyncStatus
import com.plbg.assetapp.domain.model.TempPhoto
import kotlinx.coroutines.flow.Flow
import java.io.File

interface AssetRepository {
    suspend fun getAssets(): List<AssetModel>
    suspend fun refreshAssets()
    suspend fun getAuditedAssetNos(year: String): Set<String>
    suspend fun refreshSingleAsset(assetNo: String): AssetModel?
}

interface AuthRepository {
    val currentUser: Flow<FirebaseUser?>
    val role: String?
    val allowedCostCenters: List<String>?
    val isAuthorized: Boolean
    val isAppLoading: Boolean

    suspend fun login()
    suspend fun logout()
}

interface AuditRepository {
    suspend fun submitAudit(audit: AuditData, imageFile: File): Result<Unit>
}

interface TempPhotoRepository {
    suspend fun getTempPhotos(): List<TempPhoto>
    suspend fun saveTempPhoto(photo: TempPhoto, imageFile: File): Result<TempPhoto>
    suspend fun updateTempPhoto(photo: TempPhoto, imageFile: File?): Result<Unit>
    suspend fun deleteTempPhoto(tempId: String): Result<Unit>
    suspend fun acceptAsAsset(tempId: String, newAssetNo: String): Result<AcceptResult>
}

interface OfflineSyncRepository {
    suspend fun saveAuditOffline(audit: AuditData)
    suspend fun syncPendingAudits(): SyncStatus
    suspend fun getCurrentStatus(): SyncStatus
    suspend fun retryFailed(): SyncStatus
}