import 'dart:io';
import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/temp_photo_model.dart';
import '../providers/temp_photo_provider.dart';
import '../providers/asset_provider.dart';
import '../models/asset_model.dart';
import '../utils/image_picker.dart';

/// ฟอร์มสำหรับแก้ไข / เพิ่ม Temp Photo
///
/// พอร์ตจาก TempPhotoEditForm ใน app/components/temp/
/// ใช้ได้ทั้ง "เพิ่มใหม่" (existing == null) และ "แก้ไข" (existing != null)
class TempPhotoEditForm extends StatefulWidget {
  /// ถ้า null = โหมดเพิ่มใหม่, ถ้ามีค่า = โหมดแก้ไข
  final TempPhoto? existing;

  /// Callback เมื่อ save สำเร็จ
  final VoidCallback? onSaved;

  const TempPhotoEditForm({
    super.key,
    this.existing,
    this.onSaved,
  });

  @override
  State<TempPhotoEditForm> createState() => _TempPhotoEditFormState();
}

class _TempPhotoEditFormState extends State<TempPhotoEditForm> {
  late final TextEditingController _descCtrl;
  late final TextEditingController _locCtrl;
  late final TextEditingController _refCtrl;
  late final FocusNode _refFocusNode;

  /// Asset ที่ถูกเลือกจาก Reference Search (Auto-fill)
  AssetModel? _selectedRefAsset;

  /// เก็บรายการ assets ที่ filter ตามข้อความค้นหา
  List<AssetModel> _filteredAssets = [];

  /// แสดง/ซ่อน dropdown ผลการค้นหา
  bool _showSearchResults = false;

  File? _imageFile;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(text: widget.existing?.description ?? '');
    _locCtrl = TextEditingController(text: widget.existing?.location ?? '');
    _refCtrl = TextEditingController(text: widget.existing?.referenceAssetNo ?? '');
    _refFocusNode = FocusNode();

    // ถ้ามี referenceAssetNo จาก existing ให้โหลด AssetModel
    if (widget.existing?.referenceAssetNo != null &&
        widget.existing!.referenceAssetNo.isNotEmpty) {
      _loadReferenceAsset(widget.existing!.referenceAssetNo);
    }

    // เมื่อพิมพ์ในช่องค้นหา
    _refCtrl.addListener(_onRefChanged);
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _locCtrl.dispose();
    _refCtrl.removeListener(_onRefChanged);
    _refCtrl.dispose();
    _refFocusNode.dispose();
    super.dispose();
  }

  void _onRefChanged() {
    final query = _refCtrl.text.trim();
    if (query.isEmpty) {
      setState(() {
        _selectedRefAsset = null;
        _filteredAssets = [];
        _showSearchResults = false;
      });
      return;
    }

    final assetProv = context.read<AssetProvider>();
    final q = query.toUpperCase();
    final results = assetProv.assets.where((a) =>
      a.assetNo.toUpperCase().contains(q) ||
      a.description.toUpperCase().contains(q)
    ).take(10).toList();

    setState(() {
      _filteredAssets = results;
      _showSearchResults = results.isNotEmpty;
    });
  }

  void _loadReferenceAsset(String assetNo) async {
    // ใช้ context หลัง build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final assetProv = context.read<AssetProvider>();
      final found = assetProv.assets.where(
        (a) => a.assetNo == assetNo
      ).firstOrNull;
      if (found != null && mounted) {
        setState(() {
          _selectedRefAsset = found;
          _autoFillFromAsset(found);
        });
      }
    });
  }

  void _selectAsset(AssetModel asset) {
    setState(() {
      _selectedRefAsset = asset;
      _showSearchResults = false;
      _refCtrl.text = asset.assetNo;
      _autoFillFromAsset(asset);
    });
    _refFocusNode.unfocus();
  }

  void _autoFillFromAsset(AssetModel asset) {
    // ถ้ายังไม่ได้กรอก description ให้เติมจาก asset
    if (_descCtrl.text.trim().isEmpty) {
      _descCtrl.text = asset.description;
    }
    // ถ้ายังไม่ได้กรอก location ให้เติมจาก asset
    if (_locCtrl.text.trim().isEmpty) {
      _locCtrl.text = asset.lastLocationName.isNotEmpty
          ? asset.lastLocationName
          : asset.mainLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TempPhotoProvider>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                _isEditMode ? '✏️ แก้ไข Temp Photo' : '📸 เพิ่ม Temp Photo',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (_isEditMode)
                Chip(
                  label: const Text('แก้ไข', style: TextStyle(fontSize: 10)),
                  backgroundColor: Colors.orange[100],
                ),
            ],
          ),
          const SizedBox(height: 12),

          // รูป
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: context.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.borderLight),
                ),
                child: _buildImagePreview(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt, size: 16),
              label: const Text('ถ่ายรูป / เลือกรูป'),
            ),
          ),

          const SizedBox(height: 12),

          // ──────────────────────────────────────────
          // 🔍 Reference Asset Search — พิมพ์เพื่อค้นหาครุภัณฑ์อ้างอิง
          // พร้อม Auto-fill description/location เมื่อเลือก
          // ──────────────────────────────────────────
          Text(
            '🔍 ค้นหาครุภัณฑ์อ้างอิง (Reference Asset)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _refCtrl,
            focusNode: _refFocusNode,
            decoration: InputDecoration(
              hintText: 'พิมพ์เลขครุภัณฑ์หรือชื่อเพื่อค้นหา...',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: context.surfaceCard,
              isDense: true,
              suffixIcon: _selectedRefAsset != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        setState(() {
                          _selectedRefAsset = null;
                          _refCtrl.clear();
                          _filteredAssets = [];
                          _showSearchResults = false;
                        });
                      },
                    )
                  : null,
            ),
            style: const TextStyle(fontSize: 13),
          ),
          // Results Box
          if (_showSearchResults && _filteredAssets.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: context.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.primary.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _filteredAssets.length && i < 5; i++)
                    Column(
                      children: [
                        if (i > 0) Divider(height: 1, color: context.borderLight),
                        InkWell(
                          onTap: () => _selectAsset(_filteredAssets[i]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: context.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _filteredAssets[i].assetNo,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: context.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _filteredAssets[i].description.length > 50
                                        ? '${_filteredAssets[i].description.substring(0, 50)}...'
                                        : _filteredAssets[i].description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: context.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 12, color: context.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
          const SizedBox(height: 6),
          // Description
          TextField(
            controller: _descCtrl,
            decoration: const InputDecoration(
              labelText: 'คำอธิบาย',
              hintText: 'รายละเอียดของสิ่งของ',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
            maxLines: 2,
          ),
          const SizedBox(height: 12),

          // Location
          TextField(
            controller: _locCtrl,
            decoration: const InputDecoration(
              labelText: 'สถานที่',
              hintText: 'เช่น อาคาร1 ชั้น2 ห้อง203',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting
                  ? null
                  : () => _handleSubmit(context, prov),
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Icon(_isEditMode ? Icons.save : Icons.add_a_photo),
              label: Text(_isEditMode ? '💾 บันทึกการแก้ไข' : '💾 เพิ่ม Temp Photo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // Error message
          if (prov.submitError != null) ...[
            const SizedBox(height: 8),
            Text(
              '❌ ${prov.submitError}',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Image.file(_imageFile!, fit: BoxFit.cover),
      );
    }
    if (_isEditMode && widget.existing!.photoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Image.network(
          widget.existing!.photoUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 48, color: context.textSecondary),
        SizedBox(height: 4),
        Text('แตะเพื่อเลือกรูป', style: TextStyle(fontSize: 11, color: context.textSecondary)),
      ],
    );
  }

  Future<void> _pickImage() async {
    // แสดง bottom sheet ให้เลือก กล้อง / แกลเลอรี
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('ถ่ายรูป'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('เลือกจากแกลเลอรี'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final file = source == ImageSource.camera
        ? await ImagePickerUtil.pickFromCamera()
        : await ImagePickerUtil.pickFromGallery();
    if (file != null && mounted) {
      setState(() => _imageFile = file);
    }
  }

  Future<void> _handleSubmit(BuildContext context, TempPhotoProvider prov) async {
    if (_descCtrl.text.trim().isEmpty && _refCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ กรุณากรอกคำอธิบายหรือเลขครุภัณฑ์')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    bool ok;
    if (_isEditMode) {
      ok = await prov.updateTempPhoto(
        tempId: widget.existing!.tempId,
        referenceAssetNo: _refCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        location: _locCtrl.text.trim(),
        imageFile: _imageFile,
        assetClass: widget.existing!.assetClass,
        assetClassName: widget.existing!.assetClassName,
        costCenter: widget.existing!.costCenter,
        costCenterName: widget.existing!.costCenterName,
      );
    } else {
      ok = await prov.saveTempPhoto(
        referenceAssetNo: _refCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        location: _locCtrl.text.trim(),
        imageFile: _imageFile!,
        assetClass: '',
        assetClassName: '',
        costCenter: '',
        costCenterName: '',
      );
    }

    setState(() => _isSubmitting = false);

    if (ok && mounted) {
      widget.onSaved?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode ? '✅ แก้ไข Temp Photo สำเร็จ' : '✅ เพิ่ม Temp Photo สำเร็จ'),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
