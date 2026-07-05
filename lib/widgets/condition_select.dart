// lib/widgets/condition_select.dart
import 'package:flutter/material.dart';

class ConditionSelect extends StatelessWidget {
  final String value;
  final String customValue;
  final ValueChanged<String> onChange;
  final ValueChanged<String> onCustomChange;

  // รายการสถานะมาตรฐานที่ถอดแบบมาจากระบบเดิม (constants.ts)
  static const List<Map<String, String>> conditionOptions = [
    {'value': 'ใช้งานปกติ (Normal)', 'label': 'ใช้งานปกติ (Normal)'},
    {'value': 'ชำรุด/รอจำหน่าย (Damaged)', 'label': 'ชำรุด/รอจำหน่าย (Damaged)'},
    {'value': 'รอซ่อมแซม (Pending Repair)', 'label': 'รอซ่อมแซม (Pending Repair)'},
    {'value': 'ไม่พบตัวทรัพย์สิน (Missing)', 'label': 'ไม่พบตัวทรัพย์สิน (Missing)'},
  ];

  const ConditionSelect({
    Key? key,
    required this.value,
    required this.customValue,
    required this.onChange,
    required this.onCustomChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REMARK / CONDITION',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        const SizedBox(height: 6),
        
        // Dropdown เลือกสถานะหลัก
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : (conditionOptions.any((o) => o['value'] == value) ? value : 'custom'),
              hint: const Text('-- เลือกสถานะ --'),
              isExpanded: true,
              onChanged: (val) {
                if (val != null) onChange(val == 'custom' ? 'custom' : val);
              },
              items: [
                ...conditionOptions.map((opt) {
                  return DropdownMenuItem<String>(
                    value: opt['value'],
                    child: Text(opt['label']!, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                const DropdownMenuItem<String>(
                  value: 'custom',
                  child: Text('ระบุรายละเอียดเอง...', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
        
        // แสดงกล่องข้อความเมื่อเลือก "ระบุรายละเอียดเอง..."
        if (value == 'custom' || (!conditionOptions.any((o) => o['value'] == value) && value.isNotEmpty)) ...[
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.amber, width: 2),
              ),
            ),
          ),
        ]
      ],
    );
  }
}