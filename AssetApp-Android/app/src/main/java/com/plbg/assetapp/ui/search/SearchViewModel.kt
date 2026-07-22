package com.plbg.assetapp.ui.search

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.model.RBACContext
import com.plbg.assetapp.domain.repository.AssetRepository
import com.plbg.assetapp.domain.repository.AuthRepository
import com.plbg.assetapp.domain.usecase.RbacService
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class SearchViewModel @Inject constructor(
    private val assetRepository: AssetRepository,
    private val authRepository: AuthRepository,
) : ViewModel() {

    private val _assets = MutableStateFlow<List<AssetModel>>(emptyList())
    val assets: StateFlow<List<AssetModel>> = _assets.asStateFlow()

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    private val _auditedAssetNos = MutableStateFlow<Set<String>>(emptySet())
    val auditedAssetNos: StateFlow<Set<String>> = _auditedAssetNos.asStateFlow()

    val filteredAssets: StateFlow<List<AssetModel>> = combine(
        _assets, _searchQuery, _auditedAssetNos
    ) { assets, query, audited ->
        val role = authRepository.role
        val allowedCostCenters = authRepository.allowedCostCenters

        val visibleAssets = RbacService.filterAssets(
            assets,
            RBACContext(
                role = role,
                allowedCostCenters = allowedCostCenters,
                skipFilter = true,
            )
        )

        if (query.isEmpty()) {
            visibleAssets
        } else {
            val q = query.uppercase()
            visibleAssets.filter { asset ->
                asset.assetNo.uppercase().contains(q) ||
                asset.description.uppercase().contains(q) ||
                asset.lastLocationName.uppercase().contains(q) ||
                asset.mainLocation.uppercase().contains(q) ||
                asset.costCenter.uppercase().contains(q) ||
                asset.costCenterName.uppercase().contains(q) ||
                asset.assetOwner.uppercase().contains(q) ||
                (asset.remarks?.uppercase() ?: "").contains(q)
            }
        }
    }.stateIn(viewModelScope, kotlinx.coroutines.flow.SharingStarted.Lazily, emptyList())

    init {
        loadData()
    }

    fun loadData() {
        viewModelScope.launch {
            try {
                _assets.value = assetRepository.getAssets()
                _auditedAssetNos.value = assetRepository.getAuditedAssetNos(
                    java.time.LocalDateTime.now().year.toString()
                )
            } catch (_: Exception) { }
        }
    }

    fun setSearchQuery(query: String) {
        _searchQuery.value = query
    }
}