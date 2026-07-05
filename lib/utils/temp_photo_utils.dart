import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TempPhotoUtils {
  static const String _locationsStorageKey = 'assetapp_locations';

  // ดึงประวัติสถานที่ๆเคยเซฟไว้ขึ้นมาสร้าง Autocomplete List
  static Future<List<String>> getSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_locationsStorageKey);
    if (raw == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  // บันทึกสถานที่ใหม่ ดันขึ้นหน้าสุด คุมโควตาไม่เกิน 50 รายการ
  static Future<void> saveLocation(String loc) async {
    if (loc.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    
    List<String> list = await getSavedLocations();
    // เอาตัวที่ชื่อซ้ำออกก่อน แล้วใส่ตัวล่าสุดเข้าไปที่หัวขบวน (unshift)
    list.removeWhere((x) => x == loc);
    list.insert(0, loc);

    // ตัดส่วนปลายทิ้ง ล็อกจำนวนไม่เกิน 50 รายการตามกฎเดิมของคุณ
    if (list.length > 50) {
      list = list.sublist(0, 50);
    }

    await prefs.setString(_locationsStorageKey, jsonEncode(list));
  }
}