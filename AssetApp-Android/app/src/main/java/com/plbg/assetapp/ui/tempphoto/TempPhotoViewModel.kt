package com.plbg.assetapp.ui.tempphoto

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.plbg.assetapp.domain.model.TempPhoto
import com.plbg.assetapp.domain.repository.TempPhotoRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.io.File
import javax.inject.Inject

@HiltViewModel
class TempPhotoViewModel @Inject constructor(
    private val tempPhotoRepository: TempPhotoRepository,
) : ViewModel() {

    private val _tempPhotos = MutableStateFlow<List<TempPhoto>>(emptyList())
    val tempPhotos: StateFlow<List<TempPhoto>> = _tempPhotos.asStateFlow()

    private val _loading = MutableStateFlow(false)
    val loading: StateFlow<Boolean> = _loading.asStateFlow()

    init { loadTempPhotos() }

    fun loadTempPhotos() {
        viewModelScope.launch {
            _loading.value = true
            try { _tempPhotos.value = tempPhotoRepository.getTempPhotos() }
            catch (_: Exception) { }
            _loading.value = false
        }
    }

    fun saveTempPhoto(
        tempId: String,
        refAssetNo: String,
        description: String,
        location: String,
        assetClass: String,
        costCenter: String,
    ) {
        viewModelScope.launch {
            _loading.value = true
            try {
                val photo = TempPhoto(
                    tempId = tempId,
                    referenceAssetNo = refAssetNo,
                    description = description,
                    photoUrl = "",
                    location = location,
                    assetClass = assetClass,
                    assetClassName = "",
                    costCenter = costCenter,
                    costCenterName = "",
                )
                // Try to update first
                val existing = _tempPhotos.value.find { it.tempId == tempId }
                if (existing != null) {
                    tempPhotoRepository.updateTempPhoto(photo, imageFile = null)
                } else {
                    tempPhotoRepository.saveTempPhoto(photo, File(""))
                }
                loadTempPhotos()
            } catch (_: Exception) { }
            _loading.value = false
        }
    }

    fun acceptAsAsset(tempId: String, newAssetNo: String) {
        viewModelScope.launch {
            try {
                val result = tempPhotoRepository.acceptAsAsset(tempId, newAssetNo)
                if (result.isSuccess && (result.getOrNull()?.ok == true)) {
                    loadTempPhotos()
                }
            } catch (_: Exception) { }
        }
    }

    fun deleteTempPhoto(tempId: String) {
        viewModelScope.launch {
            tempPhotoRepository.deleteTempPhoto(tempId)
            loadTempPhotos()
        }
    }
}