import 'package:flutter/material.dart';

class DemoForm extends StatelessWidget {
  const DemoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Colors.green,
      child: const Center(
        child: Text(
          '✅ DEMO FORM — ถ้าเห็นอันนี้ แสดงว่า AuditForm มีปัญหา',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
