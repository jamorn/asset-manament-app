import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../config/theme.dart';

class SimpleAuditForm extends StatelessWidget {
  final AssetModel asset;
  final bool isSubmitting;
  final void Function(Map<String, dynamic>) onSubmit;

  const SimpleAuditForm({
    super.key,
    required this.asset,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📋 Asset: ${asset.assetNo}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _field('description', asset.description),
          _field('assetClass', '${asset.assetClass} (${asset.assetClassName})'),
          _field('capDate', '${asset.capDate}'),
          _field('assetOwner', asset.assetOwner),
          _field('costCenter', '${asset.costCenter} (${asset.costCenterName})'),
          _field('mainLocation', asset.mainLocation),
          _field('lastLocationName', asset.lastLocationName),
          _field('environment', '${asset.environment}'),
          _field('mobility', '${asset.mobility}'),
          _field('status', asset.status),
          _field('currentStatus', '${asset.currentStatus}'),
          _field('lastImageUrl', asset.lastImageUrl),
          _field('lastCondition', asset.lastCondition),
          _field('remarks', '${asset.remarks}'),
          _field('updatedBy', asset.updatedBy),
          _field('updatedAt', '${asset.updatedAt}'),
          _field('history count', '${asset.history.length}'),
          _field('isAudited', '${asset.isAudited}'),
          const SizedBox(height: 16),
          const Center(
            child: Text('✅ ALL FIELDS DISPLAYED',
                style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
