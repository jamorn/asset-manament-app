# Module Map — Asset App

**อัปเดตล่าสุด:** 2026-07-20  
**ภาษา:** Dart / Flutter  
**State Management:** Provider + ChangeNotifier  
**Backend:** Firebase (Firestore, Auth, Storage)  
**Offline:** Hive  

---

## สารบัญ

1. [Provider Dependency Chain](#1-provider-dependency-chain)
2. [Data Flow — โหลด Assets](#2-data-flow--โหลด-assets)
3. [Data Flow — Submit Audit](#3-data-flow--submit-audit)
4. [Data Flow — Temp Photos](#4-data-flow--temp-photos)
5. [Data Flow — Offline Sync](#5-data-flow--offline-sync)
6. [Screen → Provider Mapping](#6-screen--provider-mapping)
7. [Hive Boxes](#7-hive-boxes)
8. [Folder Tree (ย่อ)](#8-folder-tree-ย่อ)

---

## 1. Provider Dependency Chain

```
ThemeProvider          ← standalone (ไม่พึ่ง Provider อื่น)
AuthProvider           ← standalone (FirebaseAuth + Firestore allowedUsers)

AssetProvider          ← ใช้ AuthProvider.role + .allowedCostCenters → filter assets
TempPhotoProvider      ← ใช้ AuthProvider.role + .allowedCostCenters → filter temp photos
AuditProvider          ← ใช้ AuthProvider.role + .allowedCostCenters → RBAC check
```

**หลักการ:** `AuthProvider` เป็น single source of truth สำหรับ role + สิทธิ์  
Provider อื่นๆ รับ context จาก `AuthProvider` ผ่าน `ChangeNotifierProxyProvider`

---

## 2. Data Flow — โหลด Assets

```
Firestore (assets collection)
    │
    ▼
AssetProvider.loadAssetsWithCacheLogic()
    │
    ├── SharedPreferences (cache 30 วัน) ←─ key: "assetapp-assets-cache_{uid}"
    │                                       uid = hash(sorted costCenters)
    │
    └── Firestore query ←─ where('costCenter', whereIn: allowedCostCenters) [ถ้าไม่ใช่ owner]
                              orderBy('assetNo')
    │
    ▼
List<AssetModel>  ←── AssetMapper.fromFirestore()
    │
    ▼
context.watch<AssetProvider>() ที่:
    ├── SurveyScreen      → รายการ assets ให้เลือก audit
    ├── SearchScreen      → ค้นหา assets (public)
    ├── DashboardScreen   → สถิติ + bulk accept
    └── AuditScreen       → asset ตัวเดียว รอ audit
```

---

## 3. Data Flow — Submit Audit

```
User กด Submit ใน AuditForm
    │
    ▼
AuditScreen._handleSubmit()
    │
    ▼
AuditProvider.submitAudit()
    │
    ├── 1) RBAC check ←── _canAuditAsset() (check ก่อน upload)
    │       ├── role == 'owner' → ผ่าน
    │       └── asset.costCenter อยู่ใน allowedCostCenters → ผ่าน
    │
    ├── 2) Upload รูป → Firebase Storage
    │       path: audit_photos/{assetNo}_{timestamp}.jpg
    │
    └── 3) Firestore Transaction
            ├── audit_logs/{autoId} → set audit log
            └── assets/{assetNo}    → update lastLocationName, lastCondition, etc.
    │
    ▼
AssetProvider.markAsAudited() → อัปเดต UI ทันที
```

---

## 4. Data Flow — Temp Photos

```
TempPhotoScreen → TempPhotoEditForm
    │
    ├── saveTempPhoto() → Firebase Storage + Firestore (status: 'pending')
    │
    └── acceptTempPhotoAsAsset() → สร้าง Asset ใหม่ใน Firestore + เปลี่ยน status เป็น 'merged'
```

**หมายเหตุ:** `TempPhoto` ยังไม่ sync กับ `AssetModel` โดยตรง — accept แล้วถึงจะกลายเป็น asset จริง

---

## 5. Data Flow — Offline Sync

```
User Audit ตอน Offline
    │
    ▼
OfflineSyncService.saveAuditOffline()
    │
    ├── Hive Box: pending_audits (AuditData)
    │
    └── ลอง sync ทันทีถ้ามี internet (connectivity_plus)
    │
    ▼
OfflineSyncService.syncPendingAudits()
    │
    ├── Batch 500 รายการต่อครั้ง
    ├── แต่ละรายการ → Firestore Transaction
    ├── ลบออกจาก Hive เมื่อ sync สำเร็จ
    └── อัปเดต SyncStatus ใน Hive Box: sync_status
```

---

## 6. Screen → Provider Mapping

| Screen | Provider ที่ watch | Provider ที่ read |
|--------|-------------------|------------------|
| `HomeScreen` | `AuthProvider`, `AssetProvider` | - |
| `SurveyScreen` | `AssetProvider` | - |
| `SearchScreen` | `AssetProvider` | - |
| `DashboardScreen` | `AssetProvider`, `AuthProvider`, `ThemeProvider` | - |
| `TempPhotoScreen` | `TempPhotoProvider` | - |
| `AuditScreen` | `AuditProvider` | `AuthProvider`, `AssetProvider` |

---

## 7. Hive Boxes

| Box Name | Type | เปิดตอน | ใช้สำหรับ |
|----------|------|---------|----------|
| `pending_audits` | `AuditData` | `main()` | เก็บ audit ที่ยังไม่ได้ sync |
| `sync_status` | `SyncStatus` | `main()` | ติดตาม progress การ sync |

**Adapter:** เขียนเอง (`AuditDataAdapter`, `SyncStatusAdapter`) — ใช้ `@HiveField` index

---

## 8. Folder Tree (ย่อ)

```
lib/
├── main.dart                     # Entry + Hive init + Provider tree
├── configs/                      # Constants, Routes, DefaultValues
├── models/                       # Data classes (AssetModel, AuditData, SyncStatus, ฯลฯ)
├── mappers/                      # AssetMapper — แปลง Firestore ↔ Model
├── providers/                    # State management (5 ตัว)
├── services/                     # RBAC + Offline sync
├── screens/                      # 7 หน้าจอ
├── widgets/                      # 14 reusable widgets
├── utils/                        # Image picker helpers
└── validation/                   # Form validators
```

> สำหรับ **folder tree แบบเต็ม** → เปิด IDE ดู หรือ `find lib -type f -name "*.dart"`
