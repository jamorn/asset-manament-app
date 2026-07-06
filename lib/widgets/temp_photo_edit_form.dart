import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/asset_model.dart';
import '../models/temp_photo_model.dart';
import '../providers/asset_provider.dart';
import '../providers/temp_photo_provider.dart';
import '../utils/image_picker.dart';

/// ฟอร์มสำหรับแก้ไข / เพิ่ม Temp Photo
///
/// พอร์ตจาก TempPhotoEditForm ใน app/components/temp/
/// ใช้ได้ทั้ง "เพิ่มใหม่" (existing == null) และ "แก้ไข" (existing != null)
///
/// โหมดเพิ่มใหม่:
///   - มีช่องค้นหา Reference Asset (ค้นหาจาก assetNo, description, assetClassName, costCenterName)
///   - เมื่อเลือก Reference Asset แล้ว costCenter/assetClass จะถูกเติมอัตโนมัติ
///   - และส่งต่อให้ saveTempPhoto เพื่อบันทึกครบถ้วน
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
  late final TextEditingController _refSearchCtrl;

  File? _imageFile;
  bool _isSubmitting = false;

  // State สำหรับ Reference Asset ที่เลือก
  AssetModel? _selectedRefAsset;

  // State เก็บค่า costCenter/assetClass ที่จะส่งไป save (กรณีเลือก ref asset หรือกรอกเอง)
  String _assetClass = '';
  String _assetClassName = '';
  String _costCenter = '';
  String _costCenterName = '';

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(text: widget.existing?.description ?? '');
    _locCtrl = TextEditingController(text: widget.existing?.location ?? '');
    _refCtrl = TextEditingController(text: widget.existing?.referenceAssetNo ?? '');
    _refSearchCtrl = TextEditingController();

    // ถ้าเป็น edit mode ให้ดึงค่าจาก existing temp photo มาใส่
    if (_isEditMode) {
      _assetClass = widget.existing!.assetClass;
      _assetClassName = widget.existing!.assetClassName;
      _costCenter = widget.existing!.costCenter;
      _costCenterName = widget.existing!.costCenterName;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _locCtrl.dispose();
    _refCtrl.dispose();
    _refSearchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tempProv = context.watch<TempPhotoProvider>();

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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
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

          // ---- โหมดเพิ่มใหม่: Reference Asset Search ----
          if (!_isEditMode) ..._buildRefAssetSearch(),

          // ---- ข้อมูล Reference Asset ที่เลือกแล้ว ----
          if (!_isEditMode && _selectedRefAsset != null)
            _buildSelectedAssetInfo(),
          if (!_isEditMode && _selectedRefAsset != null) const SizedBox(height: 12),

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
                  : () => _handleSubmit(context, tempProv),
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
          if (tempProv.submitError != null) ...[
            const SizedBox(height: 8),
            Text(
              '❌ ${tempProv.submitError}',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  // ==================================================================
  // Reference Asset Search
  // ==================================================================

  List<Widget> _buildRefAssetSearch() {
    return [
      TextField(
        controller: _refSearchCtrl,
        onChanged: (_) => setState(() {}), // rebuild suggestions
        decoration: InputDecoration(
          labelText: 'ค้นหา Reference Asset',
          hintText: 'เลขครุภัณฑ์, ชื่อ, ประเภท, Cost Center...',
          prefixIcon: const Icon(Icons.search, size: 20),
          border: OutlineInputBorder(),
          isDense: true,
          suffixIcon: _selectedRefAsset != null
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    setState(() {
                      _selectedRefAsset = null;
                      _refSearchCtrl.clear();
                      _refCtrl.clear();
                      _assetClass = '';
                      _assetClassName = '';
                      _costCenter = '';
                      _costCenterName = '';
                    });
                  },
                )
              : null,
        ),
        style: const TextStyle(fontSize: 13),
      ),
      const SizedBox(height: 4),

      // ---- Suggestions dropdown ----
      if (_refSearchCtrl.text.isNotEmpty && _selectedRefAsset == null)
        _buildRefAssetSuggestions(),

      const SizedBox(height: 8),
    ];
  }

  Widget _buildRefAssetSuggestions() {
    final query = _refSearchCtrl.text.trim().toUpperCase();

    // ดึง asset ทั้งหมดจาก AssetProvider
    final assetProv = context.read<AssetProvider>();
    final allAssets = assetProv.assets;

    final suggestions = allAssets
        .where((a) =>
            a.assetNo.toUpperCase().contains(query) ||
            a.description.toUpperCase().contains(query) ||
            a.assetClassName.toUpperCase().contains(query) ||
            a.costCenterName.toUpperCase().contains(query))
        .take(20)
        .toList();

    if (suggestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          'ไม่พบรายการที่ตรงกัน',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
        itemBuilder: (context, index) {
          final asset = suggestions[index];
          return ListTile(
            dense: true,
            leading: asset.lastImageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      asset.lastImageUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image, size: 20, color: Colors.grey),
                    ),
                  )
                : const Icon(Icons.image, size: 20, color: Colors.grey),
            title: Text(
              asset.assetNo,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${asset.description} · ${asset.costCenter} · ${asset.assetClassName}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
            onTap: () => _selectRefAsset(asset),
          );
        },
      ),
    );
  }

  void _selectRefAsset(AssetModel asset) {
    setState(() {
      _selectedRefAsset = asset;
      _refSearchCtrl.text = '${asset.assetNo} — ${asset.description}';
      _refCtrl.text = asset.assetNo;

      // ✅ เติม costCenter / assetClass จาก Reference Asset
      _assetClass = asset.assetClass;
      _assetClassName = asset.assetClassName;
      _costCenter = asset.costCenter;
      _costCenterName = asset.costCenterName;
    });
  }

  Widget _buildSelectedAssetInfo() {
    final asset = _selectedRefAsset!;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅ เลือกแล้ว: ${asset.assetNo}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 2),
                Text('${asset.description}',
                    style: const TextStyle(fontSize: 11)),
                Text('🏢 ${asset.costCenter} · ${asset.costCenterName}  |  🔧 ${asset.assetClassName}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () {
              setState(() {
                _selectedRefAsset = null;
                _refSearchCtrl.clear();
                _refCtrl.clear();
                _assetClass = '';
                _assetClassName = '';
                _costCenter = '';
                _costCenterName = '';
              });
            },
          ),
        ],
      ),
    );
  }

  // ==================================================================
  // Image
  // ==================================================================

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
      children: const [
        Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
        SizedBox(height: 4),
        Text('แตะเพื่อเลือกรูป', style: TextStyle(fontSize: 11, color: Colors.grey)),
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

  // ==================================================================
  // Submit
  // ==================================================================

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
        // ✅ ส่งค่าจาก Reference Asset ที่เลือก
        assetClass: _assetClass,
        assetClassName: _assetClassName,
        costCenter: _costCenter,
        costCenterName: _costCenterName,
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
