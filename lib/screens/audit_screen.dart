import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset_model.dart';
import '../providers/asset_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/audit_provider.dart';
import '../providers/temp_photo_provider.dart'; // สำหรับ SubmitStatus enum
import '../widgets/audit_form.dart';

/// หน้าสำหรับตรวจสอบครุภัณฑ์รายตัว
///
/// เปิดจาก survey_screen เมื่อเลือก asset
/// แทนที่จะเลื่อนหา form ด้านล่าง
class AuditScreen extends StatelessWidget {
  final AssetModel asset;

  const AuditScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final auditProv = context.watch<AuditProvider>();
    final assetProv = context.read<AssetProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบ: ${asset.assetNo}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AuditForm(
          selectedAsset: asset,
          isSubmitting: auditProv.submitStatus == SubmitStatus.submitting,
          onSubmit: (data) => _handleSubmit(context, assetProv, auditProv, data),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(
    BuildContext context,
    AssetProvider assetProv,
    AuditProvider auditProv,
    Map<String, dynamic> data,
  ) async {
    final location = data['location'] as String;
    final condition = data['condition'] as String;
    final imageFile = data['imageFile'] as File;
    final environment = data['environment'] as String?;
    final mobility = data['mobility'] as String?;
    final remarks = data['remarks'] as String?;

    final ok = await auditProv.submitAudit(
      asset: asset,
      location: location,
      condition: condition,
      imageFile: imageFile,
      environment: environment,
      mobility: mobility,
      remarks: remarks,
      auditYear: DateTime.now().year.toString(),
      auditorEmail: context.read<AuthProvider>().user?.email ?? 'unknown',
    );

    if (ok && context.mounted) {
      assetProv.markAsAudited(asset.assetNo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${asset.assetNo} — บันทึกสำเร็จ!')),
      );
      Navigator.of(context).pop(); // กลับมาหน้า survey
    }
  }
}
