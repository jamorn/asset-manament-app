import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Utility สำหรับจัดการ Image Picking (กล้อง / แกลเลอรี)
///
/// พอร์ตจาก Next.js: ส่ง raw image ให้ Firebase Storage จัดการ resize ทีหลัง
class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// เปิดกล้องถ่ายรูป — คืนค่า File หรือ null ถ้าผู้ใช้ยกเลิก
  static Future<File?> pickFromCamera({
    double maxWidth = 1200,
    double maxHeight = 1200,
    int imageQuality = 70,
  }) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
      if (picked == null) return null;
      return File(picked.path);
    } catch (e) {
      debugPrint('❌ pickFromCamera error: $e');
      return null;
    }
  }

  /// เลือกรูปจากแกลเลอรี — คืนค่า File หรือ null
  static Future<File?> pickFromGallery({
    double maxWidth = 1200,
    double maxHeight = 1200,
    int imageQuality = 70,
  }) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
      if (picked == null) return null;
      return File(picked.path);
    } catch (e) {
      debugPrint('❌ pickFromGallery error: $e');
      return null;
    }
  }

  /// ดึง metadata: { size, type, width, height }
  static Future<Map<String, dynamic>?> getImageMeta(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final dims = _parseImageDimensions(bytes);
      return {
        'size': bytes.length,
        'type': 'image/jpeg',
        'width': dims?['width'] ?? 0,
        'height': dims?['height'] ?? 0,
      };
    } catch (e) {
      print('❌ getImageMeta error: $e');
      return null;
    }
  }

  /// แยก dimension จาก byte header (JPEG / PNG)
  static Map<String, int>? _parseImageDimensions(List<int> bytes) {
    try {
      // JPEG
      if (bytes.length > 200 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
        int offset = 2;
        while (offset < bytes.length - 1) {
          if (bytes[offset] == 0xFF && bytes[offset + 1] == 0xC0) {
            final h = (bytes[offset + 5] << 8) | bytes[offset + 6];
            final w = (bytes[offset + 7] << 8) | bytes[offset + 8];
            return {'width': w, 'height': h};
          }
          offset++;
        }
      }
      // PNG
      if (bytes.length > 24 && bytes[0] == 0x89 && bytes[1] == 0x50) {
        final w = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
        final h = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
        return {'width': w, 'height': h};
      }
    } catch (_) {}
    return null;
  }
}
