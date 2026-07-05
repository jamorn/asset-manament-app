import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  bool _loading = true;
  bool _isRightsFetched = false;
  List<dynamic> _allowedUsers = [];

  // Getters ล้อตาม Next.js เป๊ะๆ
  User? get user => _user;
  bool get loading => _loading;
  
  // โหลดจาก cache ทันทีหรือเช็คว่าสิทธิ์จาก Firestore โหลดเสร็จแล้วยัง
  bool get authorized => _user != null && _currentUserEntry != null && (_isRightsFetched || _allowedUsers.isNotEmpty);
  
  bool get isAppLoading => _loading || (_user != null && !_isRightsFetched && _allowedUsers.isEmpty);

  static const String _usersCacheKey = 'assetapp-allowed-users-cache';
  static const String _allowedUsersDoc = 'artifacts/irpc-asset-audit/config/settings';

  AuthProvider() {
    _initAuthListener();
  }

  // เฝ้าดูสถานะการ Login ของผู้ใช้
  void _initAuthListener() async {
    // 1. โหลดข้อมูลสิทธิ์จาก Local Storage ก่อน (ลอกโลจิกดึง cache ของคุณมาเลย)
    final prefs = await SharedPreferences.getInstance();
    final cachedUsers = prefs.getString(_usersCacheKey);
    if (cachedUsers != null) {
      _allowedUsers = jsonDecode(cachedUsers);
      notifyListeners();
    }

    // 2. ดักฟังการสลับสถานะจาก Firebase Auth หลัก
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      _loading = false;
      
      if (user != null) {
        _isRightsFetched = false;
        notifyListeners();
        await _fetchAllowedUsersFromFirestore(); // ล็อกอินแล้ว ไปดึงสิทธิ์ล่าสุดมาตรวจ
      } else {
        _isRightsFetched = true;
        notifyListeners();
      }
    });
  }

  // ดึงค่าการตั้งค่าสิทธิ์ผู้ใช้ทั้งหมดจาก Firestore
  Future<void> _fetchAllowedUsersFromFirestore() async {
    try {
      final docRef = _db.doc(_allowedUsersDoc);
      final snapshot = await docRef.get();
      
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        // ในระบบคุณ ก้อนข้อมูลชื่อ 'allowedUsers' เป็นอาเรย์รวมสิทธิ์พนักงาน
        if (data['allowedUsers'] != null) {
          _allowedUsers = data['allowedUsers'] as List<dynamic>;
          
          // เซฟลง Cache ทันทีเผื่อเปิดแอปออฟไลน์รอบหน้า
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_usersCacheKey, jsonEncode(_allowedUsers));
        }
      }
    } catch (e) {
      print('❌ Failed to fetch rights config: $e');
    } finally {
      _isRightsFetched = true;
      notifyListeners(); // สั่งให้ UI ถอดวงกลมโหลดออก
    }
  }

  // หาตัวตนของผู้ใช้ปัจจุบันในก้อนสิทธิ์
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

  // ถอดบทบาท (Role)
  String? get role => _currentUserEntry?['role']?.toString();

  // คำนวณสิทธิ์เข้าถึงคลังข้อมูลเพื่อไปส่งต่อให้ระบบฟิลเตอร์ RBAC
  List<String>? get allowedCostCenters {
    if (_loading) return null; // ส่ง undefined (ในภาษา Dart ใช้ null แทน)
    if (_user == null) return []; // ยังไม่ล็อกอิน ส่งอาเรย์ว่างกันเหนี่ยวด้านความปลอดภัย
    if (_allowedUsers.isEmpty && !_isRightsFetched) return null; // โหลดสิทธิ์ยังไม่เสร็จ
    if (_currentUserEntry == null) return []; // ไม่มีรายชื่ออยู่ในระบบ ห้ามเข้าดู

    final List<dynamic> ccList = _currentUserEntry!['costCenters'] as List<dynamic>;
    
    // พอร์ตโลจิก: หากเจอรหัส '*' (สิทธิ์สูงสุด Owner) -> ส่งค่ากลับเป็น null เพื่อมองข้ามการฟิลเตอร์
    if (ccList.any((cc) => cc.toString().trim() == '*')) {
      return null;
    }

    return ccList.map((e) => e.toString()).toList();
  }

  // ฟังก์ชัน Login ด้วย Google 
  Future<void> login() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    await _auth.signInWithProvider(googleProvider);
  }

  // ฟังก์ชัน Logout ล้างค่าออกจากระบบ
  Future<void> logout() async {
    await _auth.signOut();
  }
}