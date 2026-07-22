package com.plbg.assetapp.di

import android.content.Context
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.auth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.firestore
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.storage
import com.plbg.assetapp.data.local.AssetCache
import com.plbg.assetapp.data.remote.FirebaseAssetDataSource
import com.plbg.assetapp.data.repository.AssetRepositoryImpl
import com.plbg.assetapp.data.repository.AuditRepositoryImpl
import com.plbg.assetapp.data.repository.AuthRepositoryImpl
import com.plbg.assetapp.data.repository.OfflineSyncRepositoryImpl
import com.plbg.assetapp.data.repository.TempPhotoRepositoryImpl
import com.plbg.assetapp.domain.repository.AssetRepository
import com.plbg.assetapp.domain.repository.AuditRepository
import com.plbg.assetapp.domain.repository.AuthRepository
import com.plbg.assetapp.domain.repository.OfflineSyncRepository
import com.plbg.assetapp.domain.repository.TempPhotoRepository
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.serialization.json.Json
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides @Singleton
    fun provideFirebaseAuth(): FirebaseAuth = Firebase.auth

    @Provides @Singleton
    fun provideFirestore(): FirebaseFirestore = Firebase.firestore

    @Provides @Singleton
    fun provideStorage(): FirebaseStorage = Firebase.storage

    @Provides @Singleton
    fun provideJson(): Json = Json {
        ignoreUnknownKeys = true
        isLenient = true
    }

    @Provides @Singleton
    fun provideAuthRepository(
        auth: FirebaseAuth,
        firestore: FirebaseFirestore,
        @ApplicationContext context: Context,
    ): AuthRepository = AuthRepositoryImpl(auth, firestore, context)

    @Provides @Singleton
    fun provideAssetRepository(
        firebase: FirebaseAssetDataSource,
        cache: AssetCache,
        authRepository: AuthRepository,
    ): AssetRepository = AssetRepositoryImpl(firebase, cache, authRepository)

    @Provides @Singleton
    fun provideAuditRepository(
        firestore: FirebaseFirestore,
        storage: FirebaseStorage,
        authRepository: AuthRepository,
    ): AuditRepository = AuditRepositoryImpl(firestore, storage, authRepository)

    @Provides @Singleton
    fun provideTempPhotoRepository(
        firestore: FirebaseFirestore,
        storage: FirebaseStorage,
    ): TempPhotoRepository = TempPhotoRepositoryImpl(firestore, storage)

    @Provides @Singleton
    fun provideFirebaseAssetDataSource(
        firestore: FirebaseFirestore,
    ): FirebaseAssetDataSource = FirebaseAssetDataSource(firestore)

    @Provides @Singleton
    fun provideAssetCache(
        @ApplicationContext context: Context,
        authRepository: AuthRepository,
        json: Json,
    ): AssetCache = AssetCache(context, authRepository, json)

    @Provides @Singleton
    fun provideOfflineSyncRepository(
        @ApplicationContext context: Context,
        json: Json,
    ): OfflineSyncRepository = OfflineSyncRepositoryImpl(context, json)
}