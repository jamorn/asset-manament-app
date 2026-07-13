// lib/widgets/sync_progress_widget.dart
import 'package:flutter/material.dart';
import '../services/offline_sync_service.dart';
import '../models/sync_status.dart';

class SyncProgressWidget extends StatefulWidget {
  const SyncProgressWidget({super.key});

  @override
  State<SyncProgressWidget> createState() => _SyncProgressWidgetState();
}

class _SyncProgressWidgetState extends State<SyncProgressWidget> {
  final OfflineSyncService _syncService = OfflineSyncService();
  SyncStatus? _status;
  
  @override
  void initState() {
    super.initState();
    _loadStatus();
  }
  
  Future<void> _loadStatus() async {
    final status = await _syncService.getCurrentStatus();
    setState(() => _status = status);
  }
  
  @override
  Widget build(BuildContext context) {
    if (_status == null || _status!.total == 0) {
      return const SizedBox.shrink();
    }
    
    final status = _status!;
    
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status.isCompleted 
            ? Colors.green.shade50 
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status.isCompleted 
              ? Colors.green 
              : Colors.blue,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header
          Row(
            children: [
              Icon(
                status.isCompleted 
                    ? Icons.check_circle 
                    : Icons.sync,
                color: status.isCompleted 
                    ? Colors.green 
                    : Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                status.isCompleted 
                    ? '✅ Sync เสร็จสมบูรณ์' 
                    : '🔄 กำลัง Sync ข้อมูล...',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                status.detailText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // ✅ Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: status.progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: status.isCompleted ? Colors.green : Colors.blue,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // ✅ Status Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.statusText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              if (!status.isCompleted)
                Text(
                  '${(status.progress * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          
          // ✅ แสดงรายละเอียดเพิ่มเติม
          if (status.failed > 0) ...[
            const SizedBox(height: 8),
            Text(
              '⚠️ ล้มเหลว ${status.failed} รายการ (แตะเพื่อลองใหม่)',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}