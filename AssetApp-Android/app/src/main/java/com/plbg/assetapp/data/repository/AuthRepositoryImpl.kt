package com.plbg.assetapp.data.repository

import android.content.Context
import android.content.Intent
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import com.google.firebase.firestore.FirebaseFirestore
import com.plbg.assetapp.data.remote.FirestorePath
import com.plbg.assetapp.domain.repository.AuthRepository
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import timber.log.Timber
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthRepositoryImpl @Inject constructor(
    private val auth: FirebaseAuth,
    private val firestore: FirebaseFirestore,
    @ApplicationContext private val context: Context,
) : AuthRepository {

    private val _currentUser = MutableStateFlow(auth.currentUser)
    override val currentUser: Flow<com.google.firebase.auth.FirebaseUser?> = _currentUser.asStateFlow()

    private var _allowedUsers: List<Map<String, Any?>> = emptyList()
    private var _isRightsFetched = false

    override val role: String?
        get() = currentUserEntry?.get("role")?.toString()

    override val allowedCostCenters: List<String>?
        get() {
            val entry = currentUserEntry ?: return emptyList()
            val ccList = entry["costCenters"] as? List<*> ?: return emptyList()
            if (ccList.any { it.toString().trim() == "*" }) return null
            return ccList.map { it.toString() }
        }

    override val isAuthorized: Boolean
        get() = _currentUser.value != null && currentUserEntry != null

    override val isAppLoading: Boolean
        get() = _currentUser.value != null && !_isRightsFetched && _allowedUsers.isEmpty()

    private val currentUserEntry: Map<String, Any?>?
        get() {
            val email = _currentUser.value?.email?.trim()?.lowercase() ?: return null
            return _allowedUsers.firstOrNull {
                it["email"]?.toString()?.trim()?.lowercase() == email
            }
        }

    init {
        auth.addAuthStateListener { firebaseAuth ->
            _currentUser.value = firebaseAuth.currentUser
            if (firebaseAuth.currentUser != null) {
                CoroutineScope(Dispatchers.IO).launch {
                    fetchAllowedUsers()
                }
            } else {
                _isRightsFetched = true
            }
        }
        loadCache()
    }

    private fun loadCache() {
        val prefs = context.getSharedPreferences("auth_cache", Context.MODE_PRIVATE)
        prefs.getString("allowed_users", null)?.let { json ->
            runCatching {
                @Suppress("UNCHECKED_CAST")
                _allowedUsers = org.json.JSONArray(json).toList() as List<Map<String, Any?>>
            }
        }
    }

    private suspend fun fetchAllowedUsers() {
        try {
            val doc = firestore.document(FirestorePath.SETTINGS).get().await()
            val data = doc.data ?: return
            @Suppress("UNCHECKED_CAST")
            _allowedUsers = data["allowedUsers"] as? List<Map<String, Any?>> ?: emptyList()
            context.getSharedPreferences("auth_cache", Context.MODE_PRIVATE)
                .edit()
                .putString("allowed_users", org.json.JSONArray(_allowedUsers).toString())
                .apply()
        } catch (e: Exception) {
            Timber.e(e, "Failed to fetch rights config")
        } finally {
            _isRightsFetched = true
        }
    }

    override suspend fun login() {
        // Sign-in flow should be handled via Activity result.
        // This repository provides the GoogleSignInClient for the Activity to use.
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken("YOUR_WEB_CLIENT_ID") // Replace with actual web client ID
            .requestEmail()
            .build()
        val googleSignInClient: GoogleSignInClient = GoogleSignIn.getClient(context, gso)
        val signInIntent: Intent = googleSignInClient.signInIntent
        // Note: signInIntent should be started via ActivityResultLauncher in UI layer.
        // For the ViewModel/Repository flow, handle via FirebaseAuth signInWithCredential.
    }

    suspend fun signInWithCredential(idToken: String) {
        val credential = GoogleAuthProvider.getCredential(idToken, null)
        auth.signInWithCredential(credential).await()
    }

    override suspend fun logout() {
        auth.signOut()
        // Also sign out of Google
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken("YOUR_WEB_CLIENT_ID")
            .requestEmail()
            .build()
        val googleSignInClient = GoogleSignIn.getClient(context, gso)
        googleSignInClient.signOut()
        _currentUser.value = null
    }
}