// lib/services/offline_sync_service.dart
import 'package:flutter/foundation.dart';  // ✅ debugPrint
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/audit_data.dart';
import '../models/sync_status.dart';

class OfflineSyncService {
  static const String _auditBox = 'pending_audits';
  static const String _syncBox = 'sync_status';
  static const int batchSize = 500; // ✅ 500 รายการต่อครั้ง
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // ✅ 1. บันทึก Audit (พร้อมอัปเดตสถานะ)
  Future<void> saveAuditOffline(AuditData audit) async {
    final box = await Hive.openBox<AuditData>(_auditBox);
    await box.add(audit);
    
    // ✅ อัปเดตจำนวนที่รอ sync
    await _updatePendingCount();
    
    // ✅ ลอง sync ทันทีถ้ามีเน็ต
    await _trySyncIfOnline();
  }
  
  // ✅ 2. อัปเดตจำนวนที่รอ Sync
  Future<void> _updatePendingCount() async {
    final box = await Hive.openBox<AuditData>(_auditBox);
    final statusBox = await Hive.openBox<SyncStatus>(_syncBox);
    
    final status = statusBox.get('current_status') ?? SyncStatus(
      id: 'current_status',
      lastSyncAt: DateTime.now(),
    );
    
    final updated = status.copyWith(
      total: box.length,
      remaining: box.length - status.synced - status.failed,
      progress: box.isEmpty ? 1.0 : status.synced / box.length,
      isCompleted: box.isEmpty,
    );
    
    await statusBox.put('current_status', updated);
  }
  
  // ✅ 3. Sync แบบ Batch (หัวใจสำคัญ!)
  Future<SyncStatus> syncPendingAudits({bool showProgress = true}) async {
    final box = await Hive.openBox<AuditData>(_auditBox);
    final statusBox = await Hive.openBox<SyncStatus>(_syncBox);
    
    if (box.isEmpty) {
      debugPrint('📭 ไม่มีข้อมูลรอ Sync');
      return SyncStatus(
        id: 'current_status',
        total: 0,
        synced: 0,
        failed: 0,
        remaining: 0,
        progress: 1.0,
        lastSyncAt: DateTime.now(),
        isCompleted: true,
      );
    }
    
    // ✅ โหลดสถานะเดิม (ถ้ามี)
    var status = statusBox.get('current_status') ?? SyncStatus(
      id: 'current_status',
      total: box.length,
      lastSyncAt: DateTime.now(),
    );
    
    debugPrint('🔄 เริ่ม Sync: ${box.length} รายการ');
    debugPrint('📊 สถานะเดิม: ${status.synced}/${status.total} รายการ');
    
    // ✅ ดึงรายการที่ยังไม่ได้ sync
    final pendingItems = _getPendingItems(box, status);
    
    if (pendingItems.isEmpty) {
      final completed = status.copyWith(
        isCompleted: true,
        progress: 1.0,
        remaining: 0,
        lastSyncAt: DateTime.now(),
      );
      await statusBox.put('current_status', completed);
      debugPrint('✅ Sync เสร็จสมบูรณ์!');
      return completed;
    }
    
    // ✅ แบ่งเป็น Batch (ครั้งละ 500)
    final batches = _splitIntoBatches(pendingItems, batchSize);
    int syncedCount = status.synced;
    int failedCount = status.failed;
    List<String> failedIds = List.from(status.failedIds);
    
    for (int i = 0; i < batches.length; i++) {
      final batch = batches[i];
      final batchNumber = i + 1;
      
      debugPrint('📦 Batch $batchNumber/${batches.length}: ${batch.length} รายการ');
      
      // ✅ ส่งทีละรายการใน Batch
      for (final entry in batch) {
        final audit = entry.value;
        final key = entry.key;
        
        try {
          await _uploadAuditToFirebase(audit);
          syncedCount++;
          
          // ✅ ลบออกจาก Hive หลังจากส่งสำเร็จ
          await box.delete(key);
          
          debugPrint('  ✅ [${syncedCount}/${status.total}] ${audit.assetNo}');
          
        } catch (e) {
          failedCount++;
          failedIds.add(audit.id);
          debugPrint('  ❌ ${audit.assetNo}: $e');
        }
        
        // ✅ อัปเดตสถานะทุกๆ 10 รายการ (หรือทุก Batch)
        if (syncedCount % 10 == 0 || syncedCount == status.total) {
          final remaining = status.total - syncedCount - failedCount;
          final progress = status.total > 0 
              ? (syncedCount + failedCount) / status.total
              : 1.0;
          
          final updated = status.copyWith(
            synced: syncedCount,
            failed: failedCount,
            remaining: remaining > 0 ? remaining : 0,
            progress: progress,
            lastSyncAt: DateTime.now(),
            isCompleted: remaining <= 0 && failedIds.isEmpty,
            failedIds: failedIds,
          );
          
          await statusBox.put('current_status', updated);
          
          // ✅ แสดง Progress
          if (showProgress) {
            debugPrint('📊 Progress: ${(progress * 100).toStringAsFixed(1)}% '
                  '(Synced: $syncedCount, Failed: $failedCount, Remaining: $remaining)');
          }
        }
      }
      
      // ✅ พักระหว่าง Batch (ป้องกัน overload)
      if (i < batches.length - 1) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    
    // ✅ สรุปผล
    final finalStatus = status.copyWith(
      synced: syncedCount,
      failed: failedCount,
      remaining: 0,
      progress: 1.0,
      isCompleted: true,
      lastSyncAt: DateTime.now(),
      failedIds: failedIds,
    );
    
    await statusBox.put('current_status', finalStatus);
    
    debugPrint('''
    ┌─────────────────────────────────────────────
    │ ✅ Sync สรุปผล
    ├─────────────────────────────────────────────
    │ 📊 รวมทั้งหมด: ${status.total} รายการ
    │ ✅ สำเร็จ: $syncedCount รายการ
    │ ❌ ล้มเหลว: $failedCount รายการ
    │ 📁 เหลือ: 0 รายการ
    └─────────────────────────────────────────────
    ''');
    
    return finalStatus;
  }
  
  // ✅ 4. ดึงเฉพาะรายการที่ยังไม่ได้ sync
  List<MapEntry<dynamic, AuditData>> _getPendingItems(
    Box<AuditData> box,
    SyncStatus status,
  ) {
    // ✅ ถ้าไม่มีรายการเลย → return empty
    final allItems = box.values.toList();
    if (allItems.isEmpty) return [];
    
    // ✅ ดึงเฉพาะรายการที่ยังไม่ได้ sync (ไม่รวม failedIds)
    return box.toMap().entries
        .where((entry) => !status.failedIds.contains(entry.value.id))
        .toList();
  }
  
  // ✅ 5. แบ่งข้อมูลเป็น Batch
  List<List<MapEntry<dynamic, AuditData>>> _splitIntoBatches(
    List<MapEntry<dynamic, AuditData>> items,
    int batchSize,
  ) {
    final batches = <List<MapEntry<dynamic, AuditData>>>[];
    for (var i = 0; i < items.length; i += batchSize) {
      final end = (i + batchSize < items.length) ? i + batchSize : items.length;
      batches.add(items.sublist(i, end));
    }
    return batches;
  }
  
  // ✅ 6. ส่งข้อมูลขึ้น Firebase (audit log + update asset)
  Future<void> _uploadAuditToFirebase(AuditData audit) async {
    final assetRef = _db.collection('assets').doc(audit.assetNo);
    final auditLogRef = assetRef.collection('audit_logs').doc();
    
    await _db.runTransaction((transaction) async {
      transaction.set(auditLogRef, {
        ...audit.toJson(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      transaction.update(assetRef, {
        'lastLocationName': audit.location,
        'lastCondition': audit.condition,
        'lastImageUrl': audit.imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': audit.auditorEmail,
        if (audit.environment != null && audit.environment!.isNotEmpty)
          'environment': audit.environment,
        if (audit.mobility != null && audit.mobility!.isNotEmpty)
          'mobility': audit.mobility,
      });
    });
  }
  
  // ✅ 7. ตรวจจับ Internet และ Sync
  Future<void> _trySyncIfOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      await syncPendingAudits(showProgress: true);
    }
  }
  
  // ✅ 8. ดึงสถานะปัจจุบัน
  Future<SyncStatus> getCurrentStatus() async {
    final statusBox = await Hive.openBox<SyncStatus>(_syncBox);
    return statusBox.get('current_status') ?? SyncStatus(
      id: 'current_status',
      lastSyncAt: DateTime.now(),
    );
  }
  
  // ✅ 9. Retry เฉพาะรายการที่ล้มเหลว
  Future<void> retryFailed() async {
    final status = await getCurrentStatus();
    if (status.failedIds.isEmpty) {
      debugPrint('✅ ไม่มีรายการที่ล้มเหลว');
      return;
    }
    
    debugPrint('🔄 Retry ${status.failedIds.length} รายการที่ล้มเหลว...');
    
    final box = await Hive.openBox<AuditData>(_auditBox);
    int retrySuccess = 0;
    int retryFailed = 0;
    
    for (final auditId in status.failedIds) {
      // หา audit ใน box ที่ตรงกับ failedId
      final entry = box.toMap().entries.cast<MapEntry<dynamic, AuditData>>().where(
        (e) => e.value.id == auditId
      ).firstOrNull;
      
      if (entry == null) continue;
      
      try {
        await _uploadAuditToFirebase(entry.value);
        await box.delete(entry.key);
        retrySuccess++;
        debugPrint('  ✅ Retry สำเร็จ: ${entry.value.assetNo}');
      } catch (e) {
        retryFailed++;
        debugPrint('  ❌ Retry ล้มเหลว: ${entry.value.assetNo}: $e');
      }
    }
    
    // ✅ อัปเดตสถานะ
    final statusBox = await Hive.openBox<SyncStatus>(_syncBox);
    final updated = status.copyWith(
      synced: status.synced + retrySuccess,
      failed: retryFailed,
      failedIds: retryFailed > 0 ? ['retry_pending'] : [],
      isCompleted: retryFailed == 0,
      lastSyncAt: DateTime.now(),
    );
    await statusBox.put('current_status', updated);
    
    debugPrint('📊 Retry สรุป: สำเร็จ $retrySuccess, ล้มเหลว $retryFailed');
  }
}