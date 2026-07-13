// lib/widgets/asset_table_list.dart
import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/enums.dart';
import '../config/theme.dart';

class AssetTableList extends StatelessWidget {
  final List<AssetModel> assets;
  final String? selectedAssetNo;
  final ValueChanged<AssetModel> onSelect;
  final ValueChanged<String> onImageClick;
  final Set<String> auditedSet;
  final bool showCostCenter;

  const AssetTableList({
    super.key,
    required this.assets,
    required this.selectedAssetNo,
    required this.onSelect,
    required this.onImageClick,
    required this.auditedSet,
    this.showCostCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Text(
          'ไม่พบรายการทรัพย์สิน',
          style: TextStyle(color: context.textSecondary, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assets.length,
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 0.5),
      itemBuilder: (context, index) {
        final asset = assets[index];
        final bool isSelected = selectedAssetNo == asset.assetNo;
        final bool isAudited = auditedSet.contains(asset.assetNo);

        return InkWell(
          onTap: () => onSelect(asset),
          child: Container(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                GestureDetector(
                  onTap: () {
                    if (asset.lastImageUrl.isNotEmpty) {
                      onImageClick(asset.lastImageUrl);
                    }
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: context.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: asset.lastImageUrl.isNotEmpty
                        ? Image.network(
                            asset.lastImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.image_not_supported,
                              size: 20,
                              color: context.textSecondary,
                            ),
                          )
                        : Icon(
                            Icons.image,
                            size: 20,
                            color: context.textSecondary,
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                // Asset Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            asset.assetNo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (isAudited &&
                              (asset.remarks == null || asset.remarks!.isEmpty))
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text('🏷️', style: TextStyle(fontSize: 11)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        asset.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Badges
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          _buildBadge(
                            text: asset.environmentDisplay,
                            bgColor: asset.environment == Environment.outdoor
                                ? Colors.orange.shade50
                                : Colors.blue.shade50,
                            textColor: asset.environment == Environment.outdoor
                                ? Colors.orange.shade700
                                : Colors.blue.shade700,
                          ),
                          _buildBadge(
                            text: asset.mobilityDisplay,
                            bgColor: asset.mobility == Mobility.fixed
                                ? Colors.purple.shade50
                                : Colors.teal.shade50,
                            textColor: asset.mobility == Mobility.fixed
                                ? Colors.purple.shade700
                                : Colors.teal.shade700,
                          ),
                        ],
                      ),

                      // Condition
                      if (asset.lastCondition.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '🔧 ${asset.lastCondition}',
                            style: TextStyle(
                              fontSize: 10,
                              color: context.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Location / Cost Center
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      asset.lastLocationName.isNotEmpty
                          ? asset.lastLocationName
                          : (asset.mainLocation.isNotEmpty
                              ? asset.mainLocation
                              : 'N/A'),
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: context.textSecondary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    if (showCostCenter)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'CC: ${asset.costCenter}',
                          style: TextStyle(
                            fontSize: 10,
                            color: context.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    if (text.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}