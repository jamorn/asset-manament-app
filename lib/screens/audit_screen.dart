import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset_model.dart';
import '../widgets/audit_form.dart';
import '../providers/audit_provider.dart';
import '../providers/temp_photo_provider.dart';
import '../providers/auth_provider.dart';

class AuditScreen extends StatefulWidget {
  final AssetModel asset;

  const AuditScreen({super.key, required this.asset});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  @override
  Widget build(BuildContext context) {
    final auditProv = context.watch<AuditProvider>();
    final authProv = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบ: ${widget.asset.assetNo}'),
      ),
      body: AuditForm(
        selectedAsset: widget.asset,
        isSubmitting: auditProv.submitStatus == SubmitStatus.submitting,
        onSubmit: (data) async {
          final success = await auditProv.submitAudit(
            asset: widget.asset,
            location: data['location'] as String,
            condition: data['condition'] as String,
            imageFile: data['imageFile'],
            auditYear: DateTime.now().year.toString(),
            auditorEmail: authProv.user?.email ?? '',
            environment: data['environment'] as String,
            mobility: data['mobility'] as String,
            remarks: data['remarks'] as String,
          );

          if (success && context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ บันทึกสำเร็จ')),
            );
          }
        },
      ),
    );
  }
}
