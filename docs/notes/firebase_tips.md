# Firebase Tips — Asset App

**อัปเดตล่าสุด:** 2026-07-20  
**Firebase SDK:** 4.11.0 (core), 6.5.4 (auth), 6.6.0 (firestore), 13.4.3 (storage)

---

## สารบัญ

1. [Collection Group Query + Index Exemption](#1-collection-group-query--index-exemption)
2. [FieldValue.serverTimestamp()](#2-fieldvalueservertimestamp)
3. [Transaction vs Batch](#3-transaction-vs-batch)
4. [FirebaseStorage — upload vs delete](#4-firebasestorage--upload-vs-delete)
5. [Firestore Security Rules](#5-firestore-security-rules)
6. [Firebase Storage Security Rules](#6-firebase-storage-security-rules)

---

## 1. Collection Group Query + Index Exemption

### ปัญหา

ใน `AssetProvider._loadAuditedAssetNos()` ต้อง query `audit_logs` ข้าม document:

```dart
final auditQuery = await _db
    .collectionGroup('audit_logs')
    .where('auditYear', isEqualTo: _auditYear)
    .get();
```

Firestore ต้องการ index สำหรับ `collectionGroup` + `where` ซึ่ง **index ปกติใช้ไม่ได้** ต้องใช้ **Single-Field Index Exemption**

### วิธีแก้ — ใน Firebase Console

1. ไปที่ **Firebase Console → Firestore → Indexes**
2. Tab: **Single Field Index Exemptions**
3. กด **Add Exemption**
4. ตั้งค่า:
   - **Collection ID:** `audit_logs`
   - **Field path:** `auditYear`
   - **Scope:** `Collection Group` ✅ (สำคัญมาก!)
   - **Ascending:** ✅
   - **Descending:** ✅
5. กด **Save**

### ข้อควรรู้

- Index exemption **ไม่เสียเงิน** — ต่างจาก composite index ที่มีค่าใช้จ่าย
- ใช้ `Collection Group` scope เท่านั้นถึงจะใช้กับ `collectionGroup()` query ได้
- ถ้าตั้งเป็น `Collection` scope (default) → query จะ fail ด้วย error: `FAILED_PRECONDITION: missing index`

### ✅ สถานะปัจจุบัน

> **ตั้งค่าเรียบร้อยแล้ว** — 2026-07-20  
> Single-field index exemption สำหรับ `audit_logs.auditYear` (Collection Group Scope, Ascending + Descending)  
> Query ทำงานได้ปกติ ไม่มี error

---

## 2. FieldValue.serverTimestamp()

### ใช้ตอนไหน

```dart
// ✅ ตอนสร้าง document
transaction.set(docRef, {
  'createdAt': FieldValue.serverTimestamp(),
});

// ✅ ตอนอัปเดต
transaction.update(assetRef, {
  'updatedAt': FieldValue.serverTimestamp(),
});
```

### ข้อควรระวัง

- `serverTimestamp()` **เขียนเฉพาะตอน document ถูกสร้าง/อัปเดต** — ไม่ได้เปลี่ยนเรื่อยๆ
- เมื่อใช้ `SetOptions(merge: true)` → ระวัง `serverTimestamp()` จะ overwrite ค่าเดิมทุกครั้ง
- ค่าที่เขียนเป็น `Timestamp` object — เวลาอ่านใช้ `.toDate()` → `DateTime`
- ใช้ใน `Transaction` ได้ปกติ

### ตัวอย่างผิด (ที่เคยเจอ)

```dart
// ❌ ผิด — updateTempPhoto ใช้ set() + merge + serverTimestamp()
// ทำให้ capturedAt ถูก overwrite ทุกครั้งที่แก้ไข
await _db.collection('temp_photos').doc(tempId).set({
  'capturedAt': FieldValue.serverTimestamp(),
}, SetOptions(merge: true));

// ✅ แก้ — ใช้ update() แทน และไม่ใส่ capturedAt
await _db.collection('temp_photos').doc(tempId).update({
  'description': description,
  'photoUrl': photoUrl,
});
```

---

## 3. Transaction vs Batch

### Transaction — ใช้อ่านก่อนเขียน (atomic)

```dart
await _db.runTransaction((transaction) async {
  final doc = await transaction.get(assetRef);
  final data = doc.data();
  transaction.set(logRef, auditLogData);
  transaction.update(assetRef, updateData);
});
```

**ใช้เมื่อ:** ต้องอ่านค่าปัจจุบันก่อนตัดสินใจเขียน (เช่น เช็ค ownership, นับจำนวน)

### Batch — เขียนอย่างเดียว (atomic)

```dart
final batch = firestore.batch();
for (final asset in chunk) {
  batch.set(logRef, auditLogData);
}
await batch.commit();
```

**ใช้เมื่อ:** เขียนหลายๆ document โดยไม่อ่านก่อน (เช่น bulk accept, bulk delete)

### ข้อควรรู้

- Transaction: สูงสุด **500 writes**
- Batch: สูงสุด **500 operations** (set + update + delete รวมกัน)
- ทั้งสอง **rollback อัตโนมัติ** ถ้า operation ใด fail
- ใน `dashboard_screen.dart` ตอน bulk accept — ใช้ try-catch แต่ละ batch เพื่อกัน fail ทีเดียวทั้ง loop

---

## 4. FirebaseStorage — upload vs delete

### Upload

```dart
final storageRef = _storage.ref().child('audit_photos/$imageName');
await storageRef.putFile(imageFile);
final String imageUrl = await storageRef.getDownloadURL();
```

### Delete

```dart
try {
  await _storage.ref().child('audit_photos/$imageName').delete();
} catch (_) {
  // รูปอาจถูกลบไปแล้ว — ignore error
}
```

### ข้อควรระวัง

- `delete()` จะ throw exception ถ้าไฟล์ไม่มีอยู่ → ต้อง try-catch เสมอ
- `getDownloadURL()` ต้องรอ `putFile()` เสร็จก่อน (await ทั้งคู่)
- ถ้า upload fail → ไม่มี orphan file เพราะ `putFile()` ล้มเหลวตั้งแต่แรก
- **RBAC check ควรทำก่อน upload** เสมอ (ปัจจุบัน `audit_provider.dart` ทำ `_canAuditAsset()` ก่อน `putFile()` อยู่แล้ว)

---

## 5. Firestore Security Rules

### โครงสร้าง Path

```
/artifacts/irpc-asset-audit/config/settings                              ← ข้อมูลผู้ใช้ + สิทธิ์
/artifacts/irpc-asset-audit/public/data/assets/{id}                      ← Assets หลัก
/artifacts/irpc-asset-audit/public/data/assets/{id}/audit_logs/{logId}   ← Audit logs (sub-collection)
/artifacts/irpc-asset-audit/public/data/temp_photos/{id}                 ← Temp photos
```

### Helper Functions

```firestore
function getSettingsData() {
  return get(
    /databases/$(database)/documents/artifacts/irpc-asset-audit/config/settings
  ).data;
}

function isOwner() {
  return request.auth != null &&
    getSettingsData().allowedUsers.hasAny([{
      "email": request.auth.token.email,
      "role": "owner",
      "costCenters": ["*"]
    }]);
}

function isCostCenterAllowed(cc) {
  return isOwner() || (
    request.auth != null && (
      getSettingsData().allowedUsers.hasAny([{
        "email": request.auth.token.email,
        "role": "admin",
        "costCenters": ["*"]
      }]) ||
      getSettingsData().allowedUsers.hasAny([{
        "email": request.auth.token.email,
        "role": "admin",
        "costCenters": [cc]
      }]) ||
      getSettingsData().allowedUsers.hasAny([{
        "email": request.auth.token.email,
        "role": "owner",
        "costCenters": [cc]
      }])
    )
  );
}

function getAssetCostCenter(assetId) {
  return get(
    /databases/$(database)/documents/artifacts/irpc-asset-audit/public/data/assets/$(assetId)
  ).data.costCenter;
}

function isAssetAllowed(assetId) {
  return isCostCenterAllowed(getAssetCostCenter(assetId));
}
```

### Collection Rules

| Collection | read | write |
|------------|------|-------|
| `assets/{assetId}` | auth != null + Owner หรือ CostCenter ตรง | Owner เท่านั้น |
| `assets/{id}/audit_logs/{logId}` | auth != null + AssetAllowed | create: AssetAllowed, update/delete: Owner |
| `temp_photos/{photoId}` | auth != null + Owner หรือ CostCenter ตรง | Owner หรือ CostCenter ตรง |
| `config/{doc}` | auth != null | Owner เท่านั้น |
| `{path=**}/audit_logs/{doc}` (collection group) | auth != null + CostCenterAllowed | ❌ ปิดทั้งหมด |

### ข้อควรระวัง

- `getSettingsData()` อ่าน document `/config/settings` **ทุกครั้งที่มี request** → อาจเพิ่ม latency เล็กน้อย
- `getAssetCostCenter()` ใช้ `get()` ใน security rules → มี limit **10 gets ต่อ request** สำหรับ collection group query
- Collection group rule ใช้ `/{path=**}/audit_logs/{doc}` → `$(path)` จะเป็น path เต็ม

### ✅ สถานะ

> **ใช้งานได้ปกติ** — Rules deploy แล้ว

---

## 6. Firebase Storage Security Rules

### Rules ปัจจุบัน

```firestore
rules_version = '2';

service firebase.storage {

  match /b/{bucket}/o {

    // 📸 Audit Photos
    match /artifacts/{appId}/audit_photos/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // 📸 Temp Photos
    match /artifacts/{appId}/temp_photos/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### คำอธิบาย

| Path | ช่วยอ่าน | เขียน |
|------|---------|-------|
| `artifacts/{appId}/audit_photos/{fileName}` | auth != null | auth != null |
| `artifacts/{appId}/temp_photos/{fileName}` | auth != null | auth != null |

**หมายเหตุ:** `{appId}` คือ `irpc-asset-audit` (คงที่) — ใช้ wildcard เผื่อมีหลาย app ในอนาคต

### ข้อควรรู้

- Rules **ทั้งอ่านและเขียน ให้เฉพาะ user ที่ login เท่านั้น** — ไม่มี RBAC เฉพาะ asset
- การ check RBAC ละเอียด (Cost Center) ทำใน **Flutter code** ก่อน upload ผ่าน `_canAuditAsset()`
- ถ้าต้องการเพิ่ม Security → สามารถเพิ่ม check ใน Storage Rules ได้ เช่น เช็ค email ใน path หรือ custom metadata

### ✅ สถานะ

> **ใช้งานได้ปกติ** — Rules deploy แล้ว
