import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/rbac_service.dart';

class CostCenterSelector extends StatelessWidget {
  final List<CostCenterInfo> costCenters;
  final String? selectedCostCenter;
  final Function(String?) onSelect;
  final Map<String, int> auditedCounts;
  final bool hideAll;

  const CostCenterSelector({
    super.key,
    required this.costCenters,
    required this.selectedCostCenter,
    required this.onSelect,
    this.auditedCounts = const {},
    this.hideAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalAssets =
        costCenters.fold<int>(0, (sum, item) => sum + item.count);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT COST CENTER',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.primary,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 2),
        Text(
          '${costCenters.length} cost centers · $totalAssets total assets',
          style: TextStyle(fontSize: 10, color: context.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            if (!hideAll)
              InkWell(
                onTap: () => onSelect(null),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedCostCenter == null
                        ? context.primary
                        : context.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedCostCenter == null
                          ? context.primary
                          : context.borderLight,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'All ($totalAssets)',
                    style: TextStyle(
                      fontSize: 13,
                      color: selectedCostCenter == null
                          ? context.onPrimary
                          : context.textPrimary,
                    ),
                  ),
                ),
              ),
            ...costCenters.map((cc) {
              final audited = auditedCounts[cc.costCenter] ?? 0;
              final remaining = cc.count - audited;
              final isSelected = selectedCostCenter == cc.costCenter;

              return InkWell(
                onTap: () => onSelect(cc.costCenter),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 130),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? context.primary : context.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? context.primary : context.borderLight,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: context.primary.withValues(alpha: 0.2),
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
                        cc.costCenter,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? context.onPrimary
                              : context.textPrimary,
                        ),
                      ),
                      Text(
                        cc.costCenterName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          color: isSelected
                              ? context.onPrimary.withValues(alpha: 0.7)
                              : context.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        remaining > 0 ? '$remaining remaining' : 'Done',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? context.onPrimary.withValues(alpha: 0.8)
                              : (remaining > 0
                                  ? Colors.orange.shade700
                                  : Colors.green.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
