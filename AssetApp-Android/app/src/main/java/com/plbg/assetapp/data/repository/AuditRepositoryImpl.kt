package com.plbg.assetapp.data.repository

import android.net.Uri
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.FirebaseStorage
import com.plbg.assetapp.data.remote.FirestorePath
import com.plbg.assetapp.domain.model.AuditData
import com.plbg.assetapp.domain.repository.AuditRepository
import com.plbg.assetapp.domain.repository.AuthRepository
import kotlinx.coroutines.tasks.await
import java.io.File
import java.time.LocalDateTime
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuditRepositoryImpl @Inject constructor(
    private val firestore: FirebaseFirestore,
    private val storage: FirebaseStorage,
    private val authRepository: AuthRepository,
) : AuditRepository {

    override suspend fun submitAudit(audit: AuditData, imageFile: File): Result<Unit> {
        return try {
            var photoUrl = ""

            if (imageFile.exists() && imageFile.length() > 0) {
                val fileName = "${audit.assetNo}_${System.currentTimeMillis()}.jpg"
                val storageRef = storage.reference.child(
                    "${FirestorePath.AUDIT_PHOTOS}/$fileName"
                )
                storageRef.putFile(Uri.fromFile(imageFile)).await()
                photoUrl = storageRef.downloadUrl.await().toString()
            }

            val auditCol = firestore.collection(
                "${FirestorePath.ASSETS}/${audit.assetNo}/audit_logs"
            )
            val auditDoc = hashMapOf(
                "auditYear" to LocalDateTime.now().year.toString(),
                "foundStatus" to if (audit.condition.contains("not found")) "not_found" else "found",
                "condition" to audit.condition,
                "locationName" to audit.location,
                "photoUrl" to photoUrl,
                "auditedAt" to com.google.firebase.Timestamp.now(),
                "auditedBy" to (authRepository.currentUser.value?.email ?: "system"),
                "remarks" to (audit.remarks ?: audit.condition),
            )
            auditCol.add(auditDoc).await()

            val assetRef = firestore.document("${FirestorePath.ASSETS}/${audit.assetNo}")
            val updateData = hashMapOf<String, Any?>(
                "lastLocationName" to audit.location,
                "lastCondition" to audit.condition,
                "lastImageUrl" to photoUrl,
                "updatedAt" to com.google.firebase.Timestamp.now(),
                "updatedBy" to (authRepository.currentUser.value?.email ?: "system"),
            )
            assetRef.update(updateData as Map<String, Any>).await()

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}