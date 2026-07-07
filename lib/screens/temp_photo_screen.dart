import 'package:flutter/material.dart';
import '../widgets/temp_photo_panel.dart';

/// หน้า Temp Photos — ใช้พื้นที่เต็มจอ ไม่ซ้อน modal
class TempPhotoScreen extends StatelessWidget {
  const TempPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 Temp Photos'),
      ),
      body: const TempPhotoPanel(),
    );
  }
}
