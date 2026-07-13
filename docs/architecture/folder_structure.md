// lib/screens/audit_screen.dart
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
class AuditScreen extends StatefulWidget {
  final String assetNo;

  const AuditScreen({super.key, required this.assetNo});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  AssetModel? _asset;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAsset();
  }

  Future<void> _loadAsset() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final assetProvider = context.read<AssetProvider>();
      
      // 1. ลองหาจาก assets ที่โหลดไว้แล้ว
      try {
        final found = assetProvider.assets.firstWhere(
          (a) => a.assetNo == widget.assetNo,
        );
        setState(() {
          _asset = found;
          _isLoading = false;
        });
        return;
      } catch (_) {
        // ไม่พบใน cache → ดึงจาก Firestore โดยตรง
        await assetProvider.refreshSingleAsset(widget.assetNo);
        
        // ลองหาอีกครั้งหลังจาก refresh
        final found = assetProvider.assets.firstWhere(
          (a) => a.assetNo == widget.assetNo,
        );
        setState(() {
          _asset = found;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'ไม่พบข้อมูลครุภัณฑ์: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Loading State
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('กำลังโหลด...')), // ✅ แก้ไข: ใช้ const เฉพาะ Text
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ Error State
    if (_error != null || _asset == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('เกิดข้อผิดพลาด'), // ✅ แก้ไข
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _error ?? 'ไม่พบข้อมูลครุภัณฑ์',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // กลับไปหน้าก่อนหน้า
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('กลับ'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ✅ Success State - แสดง AuditForm
    final auditProv = context.watch<AuditProvider>();
    final assetProv = context.read<AssetProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบ: ${_asset!.assetNo}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAsset,
            tooltip: 'โหลดข้อมูลใหม่',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AuditForm(
          selectedAsset: _asset!,
          isSubmitting: auditProv.submitStatus == SubmitStatus.submitting,
          onSubmit: (data) => _handleSubmit(
            context,
            assetProv,
            auditProv,
            data,
          ),
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
    try {
      final location = data['location'] as String;
      final condition = data['condition'] as String;
      final imageFile = data['imageFile'] as File;
      final environment = data['environment'] as String?;
      final mobility = data['mobility'] as String?;
      final remarks = data['remarks'] as String?;

      final authProv = context.read<AuthProvider>();
      final auditorEmail = authProv.user?.email ?? 'unknown';

      final ok = await auditProv.submitAudit(
        asset: _asset!,
        location: location,
        condition: condition,
        imageFile: imageFile,
        environment: environment,
        mobility: mobility,
        remarks: remarks,
        auditYear: DateTime.now().year.toString(),
        auditorEmail: auditorEmail,
      );

      if (ok && context.mounted) {
        assetProv.markAsAudited(_asset!.assetNo);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${_asset!.assetNo} — บันทึกสำเร็จ!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        Navigator.of(context).pop(true);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${auditProv.submitError ?? 'เกิดข้อผิดพลาด'}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}