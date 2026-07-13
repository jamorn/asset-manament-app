// lib/widgets/temp_photo_accept_modal.dart
import 'package:flutter/material.dart';
import '../models/temp_photo_model.dart';
import '../validation/temp_photo_validator.dart';
import '../config/theme.dart';

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

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: context.error,
                      fontSize: 13,
                    ),
                  ),
                ]
              ],
            ),
            actions: [
                            TextButton(
                onPressed: isSubmitting ? null : () => Navigator.of(ctx).pop(),
                child: Text(
                  '✕ CLOSE',
                  style: TextStyle(color: context.error),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primary,
                ),
                onPressed: isSubmitting
                    ? null
                    : () async {
                        setState(() {
                          errorMessage = null;
                        });

                        final validation =
                            TempPhotoValidator.validateAssetNo(assetNoInput);
                        if (!validation.ok) {
                          setState(() => errorMessage = validation.message);
                          return;
                        }

                        setState(() => isSubmitting = true);
                        final result = await onAcceptSubmit(validation.message);
                        setState(() => isSubmitting = false);

                        if (result.ok) {
                          Navigator.of(ctx).pop();
                        } else {
                          setState(() => errorMessage = result.message);
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text(
                        '✅ ACCEPT & CREATE',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          );
        },
      );
    },
  );
}
