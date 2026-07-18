import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/asset_model.dart';
import '../models/enums.dart';
import '../configs/default_values.dart';
import '../utils/image_picker.dart';
import 'condition_select.dart';
import '../config/theme.dart';

class AuditForm extends StatefulWidget {
  final AssetModel? selectedAsset;
  final bool isSubmitting;
  final Function(Map<String, dynamic> data) onSubmit;

  const AuditForm({
    super.key,
    required this.selectedAsset,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  State<AuditForm> createState() => _AuditFormState();
}

class _AuditFormState extends State<AuditForm> {
  Environment? _selectedEnvironment;
  Mobility? _selectedMobility;
  final _remarksController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedCondition = '';
  String _customCondition = '';
  File? _pickedImage;
  String _existingImageUrl = '';

  @override
  void initState() {
    super.initState();
    _initFromAsset(widget.selectedAsset);
  }

  void _initFromAsset(AssetModel? a) {
    if (a == null) return;
    _selectedEnvironment = a.environment;
    _selectedMobility = a.mobility;
    _selectedCondition = a.lastCondition.isNotEmpty
        ? a.lastCondition
        : DefaultValues.condition;
    _customCondition = '';
    _remarksController.text = a.remarks ?? '';
    _locationController.text = a.lastLocationName.isNotEmpty
        ? a.lastLocationName
        : a.mainLocation;
    _existingImageUrl = a.lastImageUrl;
    _pickedImage = null;
  }

  @override
  void didUpdateWidget(covariant AuditForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedAsset?.assetNo != widget.selectedAsset?.assetNo) {
      _initFromAsset(widget.selectedAsset);
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleImagePick(ImageSource source) async {
    File? image;
    if (source == ImageSource.camera) {
      image = await ImagePickerUtil.pickFromCamera();
    } else {
      image = await ImagePickerUtil.pickFromGallery();
    }
    if (image != null && mounted) {
      setState(() {
        _pickedImage = image;
        _existingImageUrl = '';
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ ไม่สามารถเลือกรูปได้')),
      );
    }
  }

  void _handleSubmit() {
    final location = _locationController.text.trim();
    final finalCondition =
        _selectedCondition == 'custom' ? _customCondition : _selectedCondition;

    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ กรุณาระบุสถานที่จัดวาง')),
      );
      return;
    }
    if (finalCondition.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ กรุณาเลือกสถานะความสมบูรณ์')),
      );
      return;
    }
    if (_pickedImage == null && _existingImageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ กรุณาถ่ายรูปครุภัณฑ์เพื่อเป็นหลักฐาน')),
      );
      return;
    }

    widget.onSubmit({
      'location': location,
      'condition': finalCondition,
      'environment': _selectedEnvironment?.toJson() ?? '',
      'mobility': _selectedMobility?.toJson() ?? '',
      'remarks': _remarksController.text.trim(),
      'imageFile': _pickedImage,
      'existingImageUrl': _existingImageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedAsset == null) {
      return const Center(child: Text('👈 กรุณาเลือกครุภัณฑ์'));
    }

    final bool hasPreview = _pickedImage != null || _existingImageUrl.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Asset Info Card ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedAsset!.description.isNotEmpty
                      ? widget.selectedAsset!.description
                      : '(No Description)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text('เลขครุภัณฑ์: ${widget.selectedAsset!.assetNo}',
                    style: TextStyle(color: context.textSecondary, fontSize: 13)),
                if (widget.selectedAsset!.costCenterName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('หน่วยงาน: ${widget.selectedAsset!.costCenterName}',
                        style: TextStyle(color: context.textSecondary, fontSize: 13)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Environment ───
          Text('ENVIRONMENT',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textSecondary)),
          const SizedBox(height: 6),
          Row(
            children: Environment.values.map((env) {
              final selected = env == _selectedEnvironment;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedEnvironment = env),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? context.primary : context.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: selected ? context.primary : context.borderLight),
                      ),
                      child: Center(
                        child: Text(env.display,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: selected ? context.onPrimary : context.textSecondary)),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // ─── Mobility ───
          Text('MOBILITY',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textSecondary)),
          const SizedBox(height: 6),
          Row(
            children: Mobility.values.map((mob) {
              final selected = mob == _selectedMobility;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMobility = mob),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? context.primary : context.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: selected ? context.primary : context.borderLight),
                      ),
                      child: Center(
                        child: Text(mob.display,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: selected ? context.onPrimary : context.textSecondary)),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // ─── Remarks ───
          Text('REMARKS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _remarksController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'หมายเหตุเพิ่มเติม (ถ้ามี) ...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: context.surfaceCard,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // ─── Location ───
          Text('LOCATION NAME',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'เช่น ตึกนวัตกรรม ชั้น 2, ห้องเซิร์ฟเวอร์...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: context.surfaceCard,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // ─── Condition ───
          ConditionSelect(
            value: _selectedCondition,
            customValue: _customCondition,
            onChange: (val) => setState(() => _selectedCondition = val),
            onCustomChange: (val) => setState(() => _customCondition = val),
          ),
          const SizedBox(height: 16),

          // ─── Evidence Photo ───
          Text('EVIDENCE PHOTO',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textSecondary)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            constraints: hasPreview
                ? const BoxConstraints(minHeight: 250, maxHeight: 400)
                : const BoxConstraints(minHeight: 140, maxHeight: 220),
            decoration: BoxDecoration(
              color: context.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderLight),
            ),
            child: hasPreview
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _pickedImage != null
                            ? Image.file(_pickedImage!, fit: BoxFit.contain, width: double.infinity)
                            : Image.network(_existingImageUrl, fit: BoxFit.contain, width: double.infinity,
                                errorBuilder: (_, __, ___) => const Center(child: Text('รูปไม่แสดง'))),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: context.overlay,
                          child: IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            onPressed: () => setState(() {
                              _pickedImage = null;
                              _existingImageUrl = '';
                            }),
                          ),
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => _handleImagePick(ImageSource.camera),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt, size: 40, color: context.primary),
                              const SizedBox(height: 8),
                              const Text('ถ่ายรูปภาพสด',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(width: 1, thickness: 1, indent: 40, endIndent: 40, color: context.borderLight),
                      InkWell(
                        onTap: () => _handleImagePick(ImageSource.gallery),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_library, size: 40, color: context.primary),
                              const SizedBox(height: 8),
                              const Text('เลือกจากคลังภาพ',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),

          // ─── Submit Button ───
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: widget.isSubmitting ? null : _handleSubmit,
              child: widget.isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text('SAVING DATA...',
                            style: TextStyle(fontWeight: FontWeight.bold, color: context.onPrimary)),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('CONFIRM & SAVE',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.onPrimary)),
                        const SizedBox(width: 8),
                        const Text('💾', style: TextStyle(fontSize: 16)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}