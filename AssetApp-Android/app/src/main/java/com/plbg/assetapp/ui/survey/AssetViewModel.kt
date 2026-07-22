package com.plbg.assetapp.ui.survey

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.repository.AssetRepository
import com.plbg.assetapp.domain.repository.AuthRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import java.time.LocalDateTime
import javax.inject.Inject

@HiltViewModel
class AssetViewModel @Inject constructor(
    private val repository: AssetRepository,
    private val authRepository: AuthRepository,
) : ViewModel() {

    sealed class UiState {
        data object Loading : UiState()
        data class Success(val assets: List<AssetModel>) : UiState()
        data class Error(val message: String) : UiState()
    }

    private val _uiState = MutableStateFlow<UiState>(UiState.Loading)
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    private val _auditYear = MutableStateFlow(LocalDateTime.now().year.toString())
    val auditYear: StateFlow<String> = _auditYear.asStateFlow()

    private val _auditedAssetNos = MutableStateFlow<Set<String>>(emptySet())
    val auditedAssetNos: StateFlow<Set<String>> = _auditedAssetNos.asStateFlow()

    val auditedCount: StateFlow<Int> = combine(uiState, auditedAssetNos) { state, audited ->
        when (state) {
            is UiState.Success -> state.assets.count { audited.contains(it.assetNo) }
            else -> 0
        }
    }.stateIn(viewModelScope, SharingStarted.Lazily, 0)

    val totalCount: StateFlow<Int> = uiState.map { state ->
        when (state) {
            is UiState.Success -> state.assets.size
            else -> 0
        }
    }.stateIn(viewModelScope, SharingStarted.Lazily, 0)

    init {
        loadData()
    }

    fun loadData() {
        viewModelScope.launch {
            _uiState.value = UiState.Loading
            try {
                val assets = repository.getAssets()
                _uiState.value = UiState.Success(assets)
                loadAuditedAssetNos()
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "Unknown error")
            }
        }
    }

    private suspend fun loadAuditedAssetNos() {
        _auditedAssetNos.value = repository.getAuditedAssetNos(_auditYear.value)
    }

    fun setAuditYear(year: String) {
        if (_auditYear.value == year) return
        _auditYear.value = year
        viewModelScope.launch { loadAuditedAssetNos() }
    }

    fun retry() {
        viewModelScope.launch {
            repository.refreshAssets()
            loadData()
        }
    }

    suspend fun refreshSingleAsset(assetNo: String): AssetModel? =
        repository.refreshSingleAsset(assetNo)
}