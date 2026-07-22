package com.plbg.assetapp.ui.auth

import android.content.Intent
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import com.plbg.assetapp.domain.repository.AuthRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import javax.inject.Inject

@HiltViewModel
class AuthViewModel @Inject constructor(
    private val authRepository: AuthRepository,
) : ViewModel() {

    sealed class UiState {
        data object Loading : UiState()
        data object NotLoggedIn : UiState()
        data class Unauthorized(val email: String) : UiState()
        data class LoggedIn(val user: AuthUser) : UiState()
    }

    private val _uiState = MutableStateFlow<UiState>(UiState.Loading)
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    init {
        observeAuthState()
    }

    private fun observeAuthState() {
        viewModelScope.launch {
            authRepository.currentUser.collect { user ->
                if (user == null) {
                    _uiState.value = UiState.NotLoggedIn
                } else {
                    if (authRepository.isAppLoading) {
                        _uiState.value = UiState.Loading
                    } else if (authRepository.isAuthorized) {
                        _uiState.value = UiState.LoggedIn(
                            AuthUser(
                                email = user.email ?: "",
                                displayName = user.displayName,
                                photoUrl = user.photoUrl,
                                role = authRepository.role,
                                allowedCostCenters = authRepository.allowedCostCenters,
                            )
                        )
                    } else {
                        _uiState.value = UiState.Unauthorized(user.email ?: "")
                    }
                }
            }
        }
    }

    fun login() {
        viewModelScope.launch {
            try { authRepository.login() } catch (_: Exception) { }
        }
    }

    fun logout() {
        viewModelScope.launch { authRepository.logout() }
    }

    suspend fun handleSignInResult(data: Intent?) {
        val task = GoogleSignIn.getSignedInAccountFromIntent(data)
        val account = task.getResult(ApiException::class.java) ?: return
        val credential = GoogleAuthProvider.getCredential(account.idToken!!, null)
        FirebaseAuth.getInstance().signInWithCredential(credential).await()
    }
}