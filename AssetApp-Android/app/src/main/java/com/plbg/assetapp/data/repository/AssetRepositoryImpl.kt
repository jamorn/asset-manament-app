package com.plbg.assetapp.data.repository

import com.plbg.assetapp.data.local.AssetCache
import com.plbg.assetapp.data.remote.FirebaseAssetDataSource
import com.plbg.assetapp.domain.model.AssetModel
import com.plbg.assetapp.domain.repository.AssetRepository
import com.plbg.assetapp.domain.repository.AuthRepository
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AssetRepositoryImpl @Inject constructor(
    private val firebase: FirebaseAssetDataSource,
    private val cache: AssetCache,
    private val authRepository: AuthRepository,
) : AssetRepository {

    override suspend fun getAssets(): List<AssetModel> {
        cache.get()?.let { return it }
        return fetchFromServer().also { cache.save(it) }
    }

    override suspend fun refreshAssets() {
        val assets = fetchFromServer()
        cache.save(assets)
    }

    private suspend fun fetchFromServer(): List<AssetModel> {
        val costCenters = authRepository.allowedCostCenters
        val role = authRepository.role
        return firebase.fetchAssets(costCenters, role)
    }

    override suspend fun getAuditedAssetNos(year: String): Set<String> =
        firebase.getAuditedAssetNos(year)

    override suspend fun refreshSingleAsset(assetNo: String): AssetModel? =
        firebase.refreshSingleAsset(assetNo)
}