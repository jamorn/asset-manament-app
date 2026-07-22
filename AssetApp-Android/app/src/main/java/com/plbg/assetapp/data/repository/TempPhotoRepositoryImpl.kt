package com.plbg.assetapp.data.repository

import android.net.Uri
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import com.google.firebase.firestore.Source
import com.google.firebase.storage.FirebaseStorage
import com.plbg.assetapp.data.remote.FirestorePath
import com.plbg.assetapp.domain.model.AcceptResult
import com.plbg.assetapp.domain.model.TempPhoto
import com.plbg.assetapp.domain.model.TempPhotoStatus
import com.plbg.assetapp.domain.repository.TempPhotoRepository
import kotlinx.coroutines.tasks.await
import java.io.File
import java.time.ZoneId
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class TempPhotoRepositoryImpl @Inject constructor(
    private val firestore: FirebaseFirestore,
    private val storage: FirebaseStorage,
) : TempPhotoRepository {

    override suspend fun getTempPhotos(): List<TempPhoto> {
        val col = firestore.collection(FirestorePath.TEMP_PHOTOS)
            .orderBy("capturedAt", Query.Direction.DESCENDING)
            .get(Source.SERVER)
            .await()

        return col.documents.mapNotNull { doc ->
            val data = doc.data ?: return@mapNotNull null
            TempPhoto(
                tempId = data["tempId"]?.toString() ?: doc.id,
                referenceAssetNo = data["referenceAssetNo"]?.toString() ?: "",
                description = data["description"]?.toString() ?: "",
                photoUrl = data["photoUrl"]?.toString() ?: "",
                location = data["location"]?.toString() ?: "",
                capturedAt = (data["capturedAt"] as? com.google.firebase.Timestamp)
                    ?.toDate()?.toInstant()?.atZone(ZoneId.systemDefault())?.toLocalDateTime(),
                assetClass = data["assetClass"]?.toString() ?: "",
                assetClassName = data["assetClassName"]?.toString() ?: "",
                costCenter = data["costCenter"]?.toString() ?: "",
                costCenterName = data["costCenterName"]?.toString() ?: "",
                status = if (data["status"]?.toString() == "merged") TempPhotoStatus.MERGED
                         else TempPhotoStatus.PENDING,
            )
        }
    }

    override suspend fun saveTempPhoto(photo: TempPhoto, imageFile: File): Result<TempPhoto> {
        return try {
            var photoUrl = photo.photoUrl

            if (imageFile.exists() && imageFile.length() > 0) {
                val storageRef = storage.reference.child(
                    "${FirestorePath.TEMP_PHOTOS_STORAGE}/${photo.tempId}.jpg"
                )
                storageRef.putFile(Uri.fromFile(imageFile)).await()
                photoUrl = storageRef.downloadUrl.await().toString()
            }

            val docRef = firestore.collection(FirestorePath.TEMP_PHOTOS).document(photo.tempId)
            docRef.set(mapOf(
                "tempId" to photo.tempId,
                "referenceAssetNo" to photo.referenceAssetNo,
                "description" to photo.description,
                "photoUrl" to photoUrl,
                "location" to photo.location,
                "capturedAt" to com.google.firebase.Timestamp.now(),
                "assetClass" to photo.assetClass,
                "assetClassName" to photo.assetClassName,
                "costCenter" to photo.costCenter,
                "costCenterName" to photo.costCenterName,
                "status" to "pending",
            )).await()

            Result.success(photo.copy(photoUrl = photoUrl))
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun updateTempPhoto(photo: TempPhoto, imageFile: File?): Result<Unit> {
        return try {
            var photoUrl = photo.photoUrl

            if (imageFile != null && imageFile.exists()) {
                val storageRef = storage.reference.child(
                    "${FirestorePath.TEMP_PHOTOS_STORAGE}/${photo.tempId}.jpg"
                )
                storageRef.putFile(Uri.fromFile(imageFile)).await()
                photoUrl = storageRef.downloadUrl.await().toString()
            }

            val docRef = firestore.collection(FirestorePath.TEMP_PHOTOS).document(photo.tempId)
            docRef.update(mapOf(
                "referenceAssetNo" to photo.referenceAssetNo,
                "description" to photo.description,
                "photoUrl" to photoUrl,
                "location" to photo.location,
                "capturedAt" to com.google.firebase.Timestamp.now(),
                "assetClass" to photo.assetClass,
                "assetClassName" to photo.assetClassName,
                "costCenter" to photo.costCenter,
                "costCenterName" to photo.costCenterName,
            )).await()

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun deleteTempPhoto(tempId: String): Result<Unit> {
        return try {
            try {
                val storageRef = storage.reference.child(
                    "${FirestorePath.TEMP_PHOTOS_STORAGE}/${tempId}.jpg"
                )
                storageRef.delete().await()
            } catch (_: Exception) { }

            firestore.collection(FirestorePath.TEMP_PHOTOS).document(tempId).delete().await()
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun acceptAsAsset(tempId: String, newAssetNo: String): Result<AcceptResult> {
        return try {
            val existing = firestore.collection(FirestorePath.ASSETS)
                .document(newAssetNo)
                .get(Source.SERVER)
                .await()

            if (existing.exists()) {
                return Result.success(AcceptResult(false, "Asset $newAssetNo already exists"))
            }

            val tempDoc = firestore.collection(FirestorePath.TEMP_PHOTOS)
                .document(tempId)
                .get(Source.SERVER)
                .await()

            val tempData = tempDoc.data ?: return Result.success(
                AcceptResult(false, "Temp Photo not found: $tempId")
            )

            val assetRef = firestore.collection(FirestorePath.ASSETS).document(newAssetNo)
            assetRef.set(mapOf(
                "assetNo" to newAssetNo,
                "description" to (tempData["description"]?.toString() ?: ""),
                "lastLocationName" to (tempData["location"]?.toString() ?: ""),
                "lastCondition" to "GOOD",
                "lastImageUrl" to (tempData["photoUrl"]?.toString() ?: ""),
                "environment" to "INDOOR",
                "mobility" to "FIXED",
                "remarks" to "Created from temp photo: $tempId",
                "createdAt" to com.google.firebase.Timestamp.now(),
                "updatedAt" to com.google.firebase.Timestamp.now(),
                "updatedBy" to "system",
                "assetClass" to (tempData["assetClass"]?.toString() ?: ""),
                "assetClassName" to (tempData["assetClassName"]?.toString() ?: ""),
                "costCenter" to (tempData["costCenter"]?.toString() ?: ""),
                "costCenterName" to (tempData["costCenterName"]?.toString() ?: ""),
            )).await()

            firestore.collection(FirestorePath.TEMP_PHOTOS).document(tempId)
                .update("status", "merged", "mergedAssetNo", newAssetNo)
                .await()

            Result.success(AcceptResult(true, "Asset $newAssetNo created successfully!"))
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}