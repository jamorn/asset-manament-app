import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  final String assetNo;
  
  const DemoScreen({super.key, required this.assetNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบ: $assetNo'),
      ),
      body: Container(
        height: 400,
        color: Colors.green,
        child: const Center(
          child: Text(
            '✅ DEMO — ถ้าเห็นอันนี้ แสดงว่า AuditForm มีปัญหา',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
