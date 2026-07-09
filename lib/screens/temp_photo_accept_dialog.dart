import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'package:flutter/services.dart';
import '../models/temp_photo_model.dart';

class TempPhotoAcceptDialog extends StatefulWidget {
  final TempPhoto acceptingTemp;
  const TempPhotoAcceptDialog({super.key, required this.acceptingTemp});

  @override
  State<TempPhotoAcceptDialog> createState() => _TempPhotoAcceptDialogState();
}

class _TempPhotoAcceptDialogState extends State<TempPhotoAcceptDialog> {
  final _formKey = GlobalKey<FormState>();
  final _assetNoController = TextEditingController();
  bool _isSubmitting = false;

  void _handleSubmit() async {
    // ฟังก์ชันนี้จะสั่งให้ validator ของเครื่องทำงานอัตโนมัติ
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // TODO: เรียกใช้งาน Provider เพื่อยิงข้อมูลไปหา Firebase ตรงนี้
      // เหมือนใน Next.js: await onAccept(...)

      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('✅ ยอมรับ Temp Photo → สร้าง Asset'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // ให้หดขนาดหน้าต่างตามคอนเทนต์แบบ Modal
          children: [
            // แสดงข้อมูลสถิติของ Temp ลอกมาจากกล่อง Info ใน Next.js
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                  'Temp ID: ${widget.acceptingTemp.tempId}\nDescription: ${widget.acceptingTemp.description}'),
            ),
            const SizedBox(height: 16),

            // 📝 กล่องกรอกข้อมูลที่กันบล็อกประเภทตัวอักษรให้ตั้งแต่แรก!
            TextFormField(
              controller: _assetNoController,
              keyboardType: TextInputType.number,
              maxLength: 12, // ล็อกความยาวสูงสุดในอินพุตเลย
              inputFormatters: [
                FilteringTextInputFormatter
                    .digitsOnly, // พิมพ์ตัวอักษรไม่ขึ้นแน่นอน!
              ],
              decoration: const InputDecoration(
                labelText: 'เลขครุภัณฑ์ใหม่ (Asset No)',
                hintText: 'เช่น 900200024805',
                border: OutlineInputBorder(),
              ),
              // ตัวตรวจเช็คเงื่อนไข (Validation) สั้นๆ จบในตัวไม่ต้องเขียน if ซ้อนเยอะ
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return '❌ กรุณาใส่เลขครุภัณฑ์';
                if (value.trim().length != 12)
                  return '❌ เลขครุภัณฑ์ต้องมีความยาว 12 หลัก';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('✕ CLOSE', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('✅ ACCEPT & CREATE'),
        ),
      ],
    );
  }
}
