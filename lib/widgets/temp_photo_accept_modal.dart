// temp_photo_accept_modal.dart
import 'package:flutter/material.dart';
import '../models/temp_photo_model.dart';
import '../Validation/temp_photo_validator.dart';

void showTempPhotoAcceptModal({
  required BuildContext context,
  required TempPhoto tempPhoto,
  required Future<AcceptResult> Function(String newAssetNo) onAcceptSubmit,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      String assetNoInput = '';
      String? errorMessage;
      bool isSubmitting = false;

      // ใช้ StatefulBuilder เพื่อให้ Re-render เฉพาะภายในโมดอลเวลามีการเปลี่ยนแปลง State
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('✅ ผูกเลขครุภัณฑ์ใหม่ (${tempPhoto.tempId})'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ระบุเลขครุภัณฑ์ 12 หลัก',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => assetNoInput = val,
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ]
              ],
            ),
            actions: [
              TextButton(
                child: const Text('✕ CLOSE', style: TextStyle(color: Colors.red)),
                onPressed: isSubmitting ? null : () => Navigator.of(ctx).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: isSubmitting
                    ? null
                    : () async {
                        setState(() {
                          errorMessage = null;
                        });

                        // 1. ตรวจสอบเงื่อนไขผ่าน Validator คลาสที่เราสร้างไว้
                        final validation = TempPhotoValidator.validateAssetNo(assetNoInput);
                        if (!validation.ok) {
                          setState(() => errorMessage = validation.message);
                          return;
                        }

                        // 2. เรียกใช้งาน Backend / Handler
                        setState(() => isSubmitting = true);
                        final result = await onAcceptSubmit(validation.message);
                        setState(() => isSubmitting = false);

                        if (result.ok) {
                          Navigator.of(ctx).pop(); // ปิด Modal เมื่อสำเร็จ
                        } else {
                          setState(() => errorMessage = result.message);
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('✅ ACCEPT & CREATE', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}