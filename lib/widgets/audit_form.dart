// lib/widgets/audit_form.dart
// import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asset_model.dart';
import 'condition_select.dart';
import '../config/theme.dart';

class AuditForm extends StatefulWidget {
  final AssetModel? selectedAsset;
  final bool isSubmitting;
  final Function(Map<String, dynamic> data) onSubmit;

  const AuditForm({
    Key? key,
    required this.selectedAsset,
    required this.isSubmitting,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AuditForm> createState() => _AuditFormState();
}

class _AuditFormState extends State<AuditForm> {
  final _locationController = TextEditingController();
  String _selectedCondition = '';
  String _customCondition = '';
  String _selectedEnvironment = '';
  String _selectedMobility = '';
  final _remarksController = TextEditingController();
  File? _pickedImage;
  List<String> _savedLocations = [];

  final ImagePicker _picker = ImagePicker();
  static const String _locationsKey = 'assetapp_locations';

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
    // ดึงค่าตำแหน่งเริ่มต้นของครุภัณฑ์มาใส่ในฟอร์มรอไว้ล่วงหน้าเพื่อความรวดเร็ว
    if (widget.selectedAsset != null) {
      final asset = widget.selectedAsset!;
      _locationController.text = asset.lastLocationName.isNotEmpty
          ? asset.lastLocationName
          : asset.mainLocation;
      _selectedEnvironment =
          asset.environment.isNotEmpty ? asset.environment.toLowerCase() : '';
      _selectedMobility =
          asset.mobility.isNotEmpty ? asset.mobility.toLowerCase() : '';
      _remarksController.text = asset.remarks ?? '';
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AuditForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // รีเซ็ตค่าฟอร์มบางส่วนเมื่อผู้ใช้เปลี่ยนไปเลือกครุภัณฑ์ตัวใหม่
    if (oldWidget.selectedAsset?.assetNo != widget.selectedAsset?.assetNo) {
      setState(() {
        final a = widget.selectedAsset;
        _locationController.text = a?.lastLocationName ?? a?.mainLocation ?? '';
        _selectedCondition = '';
        _customCondition = '';

        // ใช้การดึงค่าแล้วทำ lowercase ถ้าไม่มีค่าให้เป็น string ว่าง
        _selectedEnvironment = a?.environment.toLowerCase() ?? '';
        _selectedMobility = a?.mobility.toLowerCase() ?? '';
        _remarksController.text = a?.remarks ?? '';

        _pickedImage = null;
      });
    }
  }

  // 💾 ดึงและบันทึกข้อมูล Location ประวัติลงใน Local Storage (Shared Preferences)
  Future<void> _loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedLocations = prefs.getStringList(_locationsKey) ?? [];
    });
  }

  Future<void> _saveLocationToCache(String loc) async {
    if (loc.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(_locationsKey) ?? [];
    currentList.remove(loc);
    currentList.insert(0, loc); // เอาขึ้นอันดับแรก

    // จำกัดเก็บไว้ไม่เกิน 50 รายการเหมือนระบบเดิม
    if (currentList.length > 50) {
      currentList = currentList.sublist(0, 50);
    }
    await prefs.setStringList(_locationsKey, currentList);
    _loadSavedLocations();
  }

  // 📸 ฟังก์ชันเรียกใช้งานกล้อง หรือ คลังภาพของ iPad mini
  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200, // อ้างอิงตาม IMAGE_MAX_SIZE ในระบบเดิม
        imageQuality: 70, // อ้างอิงตาม IMAGE_QUALITY (0.7) ในระบบเดิม
      );
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _handleSubmit() {
    final location = _locationController.text.trim();
    final finalCondition =
        _selectedCondition == 'custom' ? _customCondition : _selectedCondition;

    // ตรวจสอบความถูกต้องของข้อมูล (Validation)
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
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ กรุณาถ่ายรูปครุภัณฑ์เพื่อเป็นหลักฐาน')),
      );
      return;
    }

    // เซฟลง Cache เพื่อเก็บเป็น Autocomplete ครั้งถัดไป
    _saveLocationToCache(location);

    // ส่งชุดข้อมูลกลับขึ้นไปจัดเตรียมการ Write ลง Firestore
    widget.onSubmit({
      'location': location,
      'condition': finalCondition,
      'environment': _selectedEnvironment,
      'mobility': _selectedMobility,
      'remarks': _remarksController.text.trim(),
      'imageFile': _pickedImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedAsset == null) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              '👈 กรุณาเลือกครุภัณฑ์จากรายการฝั่งซ้ายเพื่อเริ่มตรวจนับ',
              style: TextStyle(
                  color: context.textSecondary, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ──────────────────────────────────────────
          // 🏷️ Asset Info Card (แสดงข้อมูลครุภัณฑ์ที่เลือก)
          // ──────────────────────────────────────────
          if (widget.selectedAsset != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'เลขครุภัณฑ์: ${widget.selectedAsset!.assetNo}',
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  if (widget.selectedAsset!.costCenterName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'หน่วยงาน: ${widget.selectedAsset!.costCenterName}',
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // ──────────────────────────────────────────
          // 🌳 Environment (INDOOR / OUTDOOR)
          // ──────────────────────────────────────────
          Text('ENVIRONMENT',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textSecondary)),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildToggleChip(
                label: '🏠 INDOOR',
                value: 'indoor',
                groupValue: _selectedEnvironment,
                onSelected: (v) => setState(() => _selectedEnvironment = v),
              ),
              const SizedBox(width: 12),
              _buildToggleChip(
                label: '🌳 OUTDOOR',
                value: 'outdoor',
                groupValue: _selectedEnvironment,
                onSelected: (v) => setState(() => _selectedEnvironment = v),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ──────────────────────────────────────────
          // 🚚 Mobility (FIXED / PORTABLE)
          // ──────────────────────────────────────────
          Text('MOBILITY',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textSecondary)),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildToggleChip(
                label: '📌 FIXED',
                value: 'fixed',
                groupValue: _selectedMobility,
                onSelected: (v) => setState(() => _selectedMobility = v),
              ),
              const SizedBox(width: 12),
              _buildToggleChip(
                label: '🔄 PORTABLE',
                value: 'portable',
                groupValue: _selectedMobility,
                onSelected: (v) => setState(() => _selectedMobility = v),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ──────────────────────────────────────────
          // 📝 Remarks (หมายเหตุเพิ่มเติม)
          // ──────────────────────────────────────────
          Text('REMARKS',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _remarksController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'หมายเหตุเพิ่มเติม (ถ้ามี) ...',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // 📍 ส่วนระบุสถานที่จัดวางครุภัณฑ์
          Text('LOCATION NAME',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textSecondary)),
          const SizedBox(height: 6),
          RawAutocomplete<String>(
            textEditingController: _locationController,
            focusNode: FocusNode(),
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return _savedLocations;
              }
              return _savedLocations.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'เช่น ตึกนวัตกรรม ชั้น 2, ห้องเซิร์ฟเวอร์...',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.4, // ควบคุมขนาดให้พอดีหน้าจอด้านขวาของแท็บเล็ต
                    constraints: BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return ListTile(
                          title: Text(option,
                              style: const TextStyle(fontSize: 13)),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 🔧 ส่วนเลือกสถานะสภาพครุภัณฑ์ (ดึง Custom Widget ข้อ 1 มาประยุกต์)
          ConditionSelect(
            value: _selectedCondition,
            customValue: _customCondition,
            onChange: (val) => setState(() => _selectedCondition = val),
            onCustomChange: (val) => setState(() => _customCondition = val),
          ),
          const SizedBox(height: 16),

          // 📸 ส่วนจัดการกล้อง/หลักฐานภาพถ่าย
          Text('EVIDENCE PHOTO',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textSecondary)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: context.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: context.borderLight, style: BorderStyle.solid),
            ),
            child: _pickedImage != null
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_pickedImage!, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: context.overlay,
                          child: IconButton(
                            icon:
                                const Icon(Icons.refresh, color: Colors.white),
                            onPressed: () => setState(() => _pickedImage =
                                null), // ล้างภาพถ่ายเพื่อเริ่มใหม่
                          ),
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMediaButton(
                        icon: Icons.camera_alt,
                        label: 'ถ่ายรูปภาพสด',
                        onTap: () => _handleImagePick(ImageSource.camera),
                      ),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          indent: 40,
                          endIndent: 40,
                          color: context.borderLight),
                      _buildMediaButton(
                        icon: Icons.photo_library,
                        label: 'เลือกจากคลังภาพ',
                        onTap: () => _handleImagePick(ImageSource.gallery),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),

          // 🔘 ปุ่มยืนยันและส่งผลข้อมูล (Submit Button)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 2,
              ),
              onPressed: widget.isSubmitting ? null : _handleSubmit,
              child: widget.isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white)),
                        SizedBox(width: 12),
                        Text('SAVING DATA...',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('CONFIRM & SAVE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                        SizedBox(width: 8),
                        Text('💾', style: TextStyle(fontSize: 16)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────
  // 🏷️ Helper: _buildToggleChip สำหรับ Environment / Mobility
  // ────────────────────────────────────────
  Widget _buildToggleChip({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String> onSelected,
  }) {
    final selected = value == groupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelected(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).primaryColor
                : context.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Theme.of(context).primaryColor
                  : context.borderLight,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : context.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
