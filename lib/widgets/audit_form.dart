import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/enums.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedEnvironment = widget.selectedAsset?.environment;
    _selectedMobility = widget.selectedAsset?.mobility;
    _remarksController.text = widget.selectedAsset?.remarks ?? '';
    _locationController.text = widget.selectedAsset?.lastLocationName.isNotEmpty == true
        ? widget.selectedAsset!.lastLocationName
        : (widget.selectedAsset?.mainLocation ?? '');
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedAsset == null) {
      return const Center(child: Text('👈 กรุณาเลือกครุภัณฑ์'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Asset Info Card ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade400),
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

          // ─── Submit Button ───
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: widget.isSubmitting ? null : () {
                widget.onSubmit({
                  'location': _locationController.text.trim(),
                  'condition': _selectedCondition == 'custom' ? _customCondition : _selectedCondition,
                  'environment': _selectedEnvironment?.toJson(),
                  'mobility': _selectedMobility?.toJson(),
                  'remarks': _remarksController.text.trim(),
                });
              },
              child: Text('CONFIRM & SAVE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.onPrimary)),
            ),
          ),
          const SizedBox(height: 16),

          const Center(
            child: Text('✅ AUDIT FORM — +Submit Button',
                style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
