import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../widgets/simple_audit_form.dart';

class SimpleAuditScreen extends StatelessWidget {
  final AssetModel asset;

  const SimpleAuditScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIMPLE — ตรวจสอบ: ${asset.assetNo}'),
      ),
      body: SimpleAuditForm(
        asset: asset,
        isSubmitting: false,
        onSubmit: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Test Submit OK')),
          );
        },
      ),
    );
  }
}
