package com.plbg.assetapp.ui.audit

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.plbg.assetapp.domain.model.AuditData
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.repository.AuditRepository
import com.plbg.assetapp.domain.repository.AuthRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.io.File
import java.time.LocalDateTime
import javax.inject.Inject

@HiltViewModel
class AuditViewModel @Inject constructor(
    private val auditRepository: AuditRepository,
    private val authRepository: AuthRepository,
) : ViewModel() {

    sealed class SubmitStatus {
        data object Idle : SubmitStatus()
        data object Submitting : SubmitStatus()
        data object Success : SubmitStatus()
        data class Error(val message: String) : SubmitStatus()
    }

    private val _submitStatus = MutableStateFlow<SubmitStatus>(SubmitStatus.Idle)
    val submitStatus: StateFlow<SubmitStatus> = _submitStatus.asStateFlow()

    fun submitAudit(
        asset: AssetModel,
        location: String,
        condition: String,
        imageFile: File,
        environment: String?,
        mobility: String?,
        remarks: String?,
    ) {
        viewModelScope.launch {
            _submitStatus.value = SubmitStatus.Submitting

            try {
                val audit = AuditData(
                    id = "audit_${System.currentTimeMillis()}",
                    assetNo = asset.assetNo,
                    location = location,
                    condition = condition,
                    imageUrl = "",
                    auditorEmail = authRepository.currentUser.value?.email ?: "",
                    timestamp = LocalDateTime.now(),
                    remarks = remarks,
                    environment = environment,
                    mobility = mobility,
                )

                val result = auditRepository.submitAudit(audit, imageFile)

                result.fold(
                    onSuccess = { _submitStatus.value = SubmitStatus.Success },
                    onFailure = { e -> _submitStatus.value = SubmitStatus.Error(e.message ?: "Unknown error") }
                )
            } catch (e: Exception) {
                _submitStatus.value = SubmitStatus.Error(e.message ?: "Unknown error")
            }
        }
    }

    fun resetStatus() {
        _submitStatus.value = SubmitStatus.Idle
    }
}