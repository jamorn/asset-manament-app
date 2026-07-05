import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/asset_provider.dart';
import '../providers/auth_provider.dart';
import '../services/rbac_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _expandedCostCenter;
  bool _isBulkAccepting = false;
  int _bulkProgress = 0;
  int _bulkTotal = 0;

  @override
  Widget build(BuildContext context) {
    final assetProv = context.watch<AssetProvider>();
    final auth = context.watch<AuthProvider>();

    if (assetProv.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (assetProv.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('เกิดข้อผิดพลาด: ${assetProv.error}',
                  style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                  onPressed: () => assetProv.retry(),
                  child: const Text('ลองใหม่อีกครั้ง')),
            ],
          ),
        ),
      );
    }

    final remaining = assetProv.totalCount - assetProv.auditedCount;

    final costCenterStats = RbacService.getCostCenterStats(
      assetProv.assets,
      assetProv.auditedAssetNos,
      RBACContext(
        role: auth.role,
        allowedCostCenters: null,
      ),
    );

    final costCenterAssetClassStats = RbacService.getCostCenterAssetClassStats(
      assetProv.assets,
      assetProv.auditedAssetNos,
      RBACContext(
        role: auth.role,
        allowedCostCenters: null,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButton<String>(
              value: assetProv.auditYear,
              items: ['2024', '2025', '2026'].map((year) {
                return DropdownMenuItem(value: year, child: Text(year));
              }).toList(),
              onChanged: (val) {
                if (val != null) assetProv.setAuditYear(val);
              },
            ),
          ),
          const SizedBox(width: 12),

          if (auth.role == 'owner')
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                icon: _isBulkAccepting
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_circle_outline, size: 16),
                label: Text(
                  _isBulkAccepting
                      ? '⏳ $_bulkProgress/$_bulkTotal'
                      : remaining == 0
                          ? '✅ Done'
                          : '✅ Accept All',
                ),
                onPressed: (_isBulkAccepting || remaining == 0)
                    ? null
                    : () => _handleBulkAccept(context, assetProv, remaining),
              ),
            ),

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => assetProv.retry(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallSummaryCard(assetProv, remaining),
            const SizedBox(height: 20),

            const Text('ความคืบหน้าแยกตาม Cost Center',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildCostCenterList(
                costCenterStats, costCenterAssetClassStats),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'ข้อมูล ณ เวลาที่โหลดหน้า · ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style:
                    const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallSummaryCard(AssetProvider provider, int remaining) {
    final progress = provider.totalCount > 0
        ? provider.auditedCount / provider.totalCount
        : 0.0;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ภาพรวมทั้งหมด',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                    'ทั้งหมด', provider.totalCount.toString(), Colors.blue),
                _buildStatColumn('สำรวจแล้ว',
                    provider.auditedCount.toString(), Colors.green),
                _buildStatColumn(
                    'คงเหลือ', remaining.toString(), Colors.orange),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color)),
        Text(label,
            style:
                const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCostCenterList(
    List<CostCenterStats> costCenters,
    Map<String, List<AssetClassStats>> classStats,
  ) {
    if (costCenters.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('ไม่พบข้อมูล Cost Center')),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: costCenters.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final cc = costCenters[index];
          final isExpanded = _expandedCostCenter == cc.costCenter;
          final acList = classStats[cc.costCenter] ?? [];

          return Column(
            children: [
              ListTile(
                title: Text('${cc.costCenter} - ${cc.costCenterName}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'รวม: ${cc.total} | สำรวจ: ${cc.audited} | เหลือ: ${cc.total - cc.audited}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(
                        value:
                            cc.total > 0 ? (cc.audited / cc.total) : 0,
                        minHeight: 4,
                        color: Colors.green,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 18,
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _expandedCostCenter =
                        isExpanded ? null : cc.costCenter;
                  });
                },
              ),
              if (isExpanded)
                Container(
                  padding: const EdgeInsets.only(
                      left: 24, right: 16, bottom: 12),
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      ...acList.map((ac) => Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${ac.assetClass} · ${ac.assetClassName}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black87),
                                  ),
                                ),
                                Text(
                                  '${ac.total} / ${ac.audited} / ${ac.total - ac.audited}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleBulkAccept(
      BuildContext context, AssetProvider provider, int totalNeed) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันคำสั่งบิ๊กคลีนนิ่ง?'),
        content: Text(
          'คุณต้องการกดยอมรับทรัพย์สินคงเหลือทั้งหมดจำนวน $totalNeed รายการ สำหรับปี ${provider.auditYear} ใช่หรือไม่?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('ยกเลิก')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('ใช่, ยอมรับทั้งหมด')),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isBulkAccepting = true;
      _bulkTotal = totalNeed;
      _bulkProgress = 0;
    });

    try {
      final needAccept = provider.assets
          .where((a) => !provider.auditedAssetNos.contains(a.assetNo))
          .toList();
      final firestore = FirebaseFirestore.instance;

      const int batchSize = 500;
      int successCount = 0;

      for (int i = 0; i < needAccept.length; i += batchSize) {
        final chunk = needAccept.skip(i).take(batchSize).toList();
        final batch = firestore.batch();

        for (final asset in chunk) {
          final logRef = firestore
              .collection(
                  'artifacts/irpc-asset-audit/public/data/assets')
              .doc(asset.assetNo)
              .collection('audit_logs')
              .doc();

          batch.set(logRef, {
            'auditYear': provider.auditYear,
            'foundStatus': 'found',
            'condition': 'ใช้งานได้ปกติ (Normal)',
            'locationName': asset.lastLocationName,
            'photoUrl': asset.lastImageUrl,
            'auditedAt': FieldValue.serverTimestamp(),
            'auditedBy': 'system',
            'remarks': 'Auto-accepted via Dashboard',
          });
          successCount++;
        }

        await batch.commit();
        setState(() {
          _bulkProgress = successCount;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '🎉 ยอมรับทั้งหมด (${provider.auditYear}) สำเร็จ $successCount รายการ!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('❌ เกิดข้อผิดพลาด: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        _isBulkAccepting = false;
      });
      provider.retry();
    }
  }
}
