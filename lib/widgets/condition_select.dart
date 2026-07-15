// lib/widgets/condition_select.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';

class ConditionSelect extends StatelessWidget {
  final String value;
  final String customValue;
  final ValueChanged<String> onChange;
  final ValueChanged<String> onCustomChange;

  static const List<Map<String, String>> conditionOptions = [
    {'value': 'ใช้งานปกติ (Normal)', 'label': 'ใช้งานปกติ (Normal)'},
    {
      'value': 'ชำรุด/รอจำหน่าย (Damaged)',
      'label': 'ชำรุด/รอจำหน่าย (Damaged)'
    },
    {
      'value': 'รอซ่อมแซม (Pending Repair)',
      'label': 'รอซ่อมแซม (Pending Repair)'
    },
    {
      'value': 'ไม่พบตัวทรัพย์สิน (Missing)',
      'label': 'ไม่พบตัวทรัพย์สิน (Missing)'
    },
  ];

  const ConditionSelect({
    super.key,
    required this.value,
    required this.customValue,
    required this.onChange,
    required this.onCustomChange,
  });

  /// ดึงคำภาษาอังกฤษในวงเล็บ เช่น "ใช้งานได้ปกติ (Normal)" → "normal"
  static String? _extractKeyword(String s) {
    final match = RegExp(r'\((.+?)\)').firstMatch(s);
    return match?.group(1)?.toLowerCase();
  }

  /// หาว่า value ตรงกับ option ไหน (เทียบ keyword ภาษาอังกฤษในวงเล็บ)
  static String? _bestMatch(String val) {
    if (val.isEmpty) return null;
    final key = _extractKeyword(val);
    if (key == null) return null;
    for (final opt in conditionOptions) {
      if (_extractKeyword(opt['value']!) == key) {
        return opt['value'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final matched = _bestMatch(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REMARK / CONDITION',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: context.primary,
          ),
        ),
        const SizedBox(height: 6),

        // Dropdown เลือกสถานะหลัก
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: context.borderLight, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty
                  ? null
                  : (matched ?? 'custom'),
              hint: const Text('-- เลือกสถานะ --'),
              isExpanded: true,
              onChanged: (val) {
                if (val != null) onChange(val == 'custom' ? 'custom' : val);
              },
              items: [
                ...conditionOptions.map((opt) {
                  return DropdownMenuItem<String>(
                    value: opt['value'],
                    child: Text(opt['label']!,
                        style: const TextStyle(fontSize: 14)),
                  );
                }),
                const DropdownMenuItem<String>(
                  value: 'custom',
                  child: Text('ระบุรายละเอียดเอง...',
                      style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),

        // แสดงกล่องข้อความเมื่อเลือก "ระบุรายละเอียดเอง..."
        if (value == 'custom' || (matched == null && value.isNotEmpty)) ...[
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: customValue,
                selection: TextSelection.collapsed(offset: customValue.length),
              ),
            ),
            onChanged: onCustomChange,
            decoration: InputDecoration(
              hintText: 'พิมพ์รายละเอียดเพิ่มเติม...',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderLight, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: context.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
