// temp_photo_validator.dart
import '../models/temp_photo_model.dart';

class TempPhotoValidator {
  /// ตรวจสอบความถูกต้องของเลขครุภัณฑ์ 12 หลัก (เทียบเท่า RegExp ใน TypeScript)
  static AcceptResult validateAssetNo(String input) {
    // ลบช่องว่างทั้งหมดออก (.replace(/\s/g, ''))
    final trimmed = input.replaceAll(RegExp(r'\s+'), '');

    if (trimmed.isEmpty) {
      return AcceptResult(ok: false, message: '❌ กรุณาใส่เลขครุภัณฑ์');
    }

    // ตรวจสอบว่าเป็นตัวเลขเท่านั้น (/^\d+$/)
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return AcceptResult(ok: false, message: '❌ เลขครุภัณฑ์ต้องเป็นตัวเลขเท่านั้น');
    }

    // ตรวจสอบความยาว 12 หลัก
    if (trimmed.length != 12) {
      return AcceptResult(ok: false, message: '❌ เลขครุภัณฑ์ต้องมีความยาว 12 หลัก');
    }

    return AcceptResult(ok: true, message: trimmed);
  }
}