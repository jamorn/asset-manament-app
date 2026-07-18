import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/constants.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  bool _loading = true;
  bool _isRightsFetched = false;
  List<dynamic> _allowedUsers = [];

  User? get user => _user;
  bool get loading => _loading;

  bool get authorized =>
      _user != null &&
      _currentUserEntry != null &&
      (_isRightsFetched || _allowedUsers.isNotEmpty);

  bool get isAppLoading =>
      _loading || (_user != null && !_isRightsFetched && _allowedUsers.isEmpty);

  static const String _usersCacheKey = 'assetapp-allowed-users-cache';
  static const String _allowedUsersDoc = FirestorePath.settings;

  AuthProvider() {
    _initAuthListener();
  }

  void _initAuthListener() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedUsers = prefs.getString(_usersCacheKey);
    if (cachedUsers != null) {
      _allowedUsers = jsonDecode(cachedUsers);
      notifyListeners();
    }

    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      _loading = false;

      if (user != null) {
        _isRightsFetched = false;
        notifyListeners();
        await _fetchAllowedUsersFromFirestore();
      } else {
        _isRightsFetched = true;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchAllowedUsersFromFirestore() async {
    try {
      final docRef = _db.doc(_allowedUsersDoc);
      final snapshot = await docRef.get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        if (data['allowedUsers'] != null) {
          _allowedUsers = data['allowedUsers'] as List<dynamic>;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_usersCacheKey, jsonEncode(_allowedUsers));
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to fetch rights config: $e');
    } finally {
      _isRightsFetched = true;
      notifyListeners();
    }
  }

  Map<String, dynamic>? get _currentUserEntry {
    if (_user == null || _user!.email == null) return null;
    final email = _user!.email!.trim().toLowerCase();

    try {
      return _allowedUsers.firstWhere(
        (u) => u['email'].toString().trim().toLowerCase() == email,
        orElse: () => null,
      );
    } catch (_) {
      return null;
    }
  }

  String? get role => _currentUserEntry?['role']?.toString();

  List<String>? get allowedCostCenters {
    if (_loading) return null;
    if (_user == null) {
      return [];
    }
    if (_allowedUsers.isEmpty && !_isRightsFetched) {
      return null;
    }
    if (_currentUserEntry == null) {
      return [];
    }

    final List<dynamic> ccList =
        _currentUserEntry!['costCenters'] as List<dynamic>;

    if (ccList.any((cc) => cc.toString().trim() == '*')) {
      return null;
    }

    return ccList.map((e) => e.toString()).toList();
  }

  Future<void> login() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    await _auth.signInWithProvider(googleProvider);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
