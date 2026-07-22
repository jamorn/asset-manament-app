package com.plbg.assetapp.ui.dashboard

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.model.CostCenterStats
import com.plbg.assetapp.domain.model.RBACContext
import com.plbg.assetapp.domain.repository.AssetRepository
import com.plbg.assetapp.domain.repository.AuthRepository
import com.plbg.assetapp.domain.usecase.RbacService
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
class DashboardViewModel @Inject constructor(
    private val assetRepository: AssetRepository,
    private val authRepository: AuthRepository,
) : ViewModel() {

    private val _assets = MutableStateFlow<List<AssetModel>>(emptyList())
    val assets: StateFlow<List<AssetModel>> = _assets.asStateFlow()

    private val _auditYear = MutableStateFlow(LocalDateTime.now().year.toString())
    val auditYear: StateFlow<String> = _auditYear.asStateFlow()

    private val _auditedAssetNos = MutableStateFlow<Set<String>>(emptySet())
    val auditedAssetNos: StateFlow<Set<String>> = _auditedAssetNos.asStateFlow()

    val costCenterStats: StateFlow<List<CostCenterStats>> = combine(
        _assets, _auditedAssetNos
    ) { assets, audited ->
        RbacService.getCostCenterStats(
            assets,
            audited,
            RBACContext(role = authRepository.role, allowedCostCenters = null)
        )
    }.stateIn(viewModelScope, SharingStarted.Lazily, emptyList())

    val totalCount: StateFlow<Int> = _assets.map { it.size }
        .stateIn(viewModelScope, SharingStarted.Lazily, 0)

    val auditedCount: StateFlow<Int> = combine(
        _assets, _auditedAssetNos
    ) { assets, audited ->
        assets.count { audited.contains(it.assetNo) }
    }.stateIn(viewModelScope, SharingStarted.Lazily, 0)

    init { loadData() }

    fun loadData() {
        viewModelScope.launch {
            try {
                _assets.value = assetRepository.getAssets()
                _auditedAssetNos.value = assetRepository.getAuditedAssetNos(_auditYear.value)
            } catch (_: Exception) { }
        }
    }

    fun setAuditYear(year: String) {
        _auditYear.value = year
        viewModelScope.launch {
            _auditedAssetNos.value = assetRepository.getAuditedAssetNos(year)
        }
    }

    fun refresh() {
        viewModelScope.launch {
            assetRepository.refreshAssets()
            loadData()
        }
    }
}