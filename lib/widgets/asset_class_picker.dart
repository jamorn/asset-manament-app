// lib/widgets/asset_class_picker.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';

class AssetClassInfo {
  final String assetClass;
  final String assetClassName;
  int count;

  AssetClassInfo({
    required this.assetClass,
    required this.assetClassName,
    required this.count,
  });
}

class AssetClassPicker extends StatelessWidget {
  final List<AssetClassInfo> classes;
  final String? selectedClass;
  final Function(String?) onSelect;
  final Map<String, int> auditedCounts;

  const AssetClassPicker({
    Key? key,
    required this.classes,
    required this.selectedClass,
    required this.onSelect,
    this.auditedCounts = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalCount = classes.fold<int>(0, (sum, item) => sum + item.count);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT ASSET CLASS',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            // ปุ่มเลือกทั้งหมด (All Asset Classes)
            InkWell(
              onTap: () => onSelect(null),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selectedClass == null
                      ? Colors.amber.shade800
                      : context.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedClass == null
                        ? Colors.amber.shade800
                        : context.borderLight,
                    width: 2,
                  ),
                ),
                child: Text(
                  'All ($totalCount)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selectedClass == null
                        ? Colors.white
                        : context.textSecondary,
                  ),
                ),
              ),
            ),

            // รายการปุ่ม Asset Class
            ...classes.map((ac) {
              final audited = auditedCounts[ac.assetClass] ?? 0;
              final remaining = ac.count - audited;
              final isSelected = selectedClass == ac.assetClass;

              return InkWell(
                onTap: () => onSelect(ac.assetClass),
                borderRadius: BorderRadius.circular(12),
                child: Opacity(
                  opacity: remaining == 0
                      ? 0.6
                      : 1.0, // ถ้าทำครบแล้วจะจางลงเล็กน้อยตาม UI ต้นฉบับ
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 100),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.amber.shade800
                          : context.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.amber.shade800
                            : context.borderLight,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: Colors.amber.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2))
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${ac.assetClass} (${ac.count})',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? Colors.white : context.textPrimary,
                          ),
                        ),
                        Text(
                          ac.assetClassName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white.withOpacity(0.7)
                                : context.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          remaining > 0 ? '$remaining left' : '✅ All done',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ],
    );
  }
}
