import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../widgets/audit_form.dart';

class AuditScreen extends StatelessWidget {
  final AssetModel asset;

  const AuditScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DEV — ตรวจสอบ: ${asset.assetNo}'),
      ),
      body: AuditForm(
        selectedAsset: asset,
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
