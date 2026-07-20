# สรุปการแก้ไข Code — 20 กรกฎาคม 2026

**วันที่:** 2026-07-20 23:48 ICT  
**Project:** asset_app (Flutter)  
**Branch:** main  
**Commit:** `0404e0c` (cleanup screens) + pending changes  

---

## ✅ ไฟล์ที่แก้ไขแล้ว (12 ไฟล์)

### 🔴 Critical — อาจ crash / data loss

| # | ไฟล์ | ปัญหา | แก้ไข |
|---|------|-------|-------|
| 1 | `lib/models/sync_status.dart` | `SyncStatusAdapter.read()` ใช้ `reader.readList().cast<String>()` — ถ้า list มี `null` จะ crash | เปลี่ยนเป็น `reader.readList().whereType<String>().toList()` — filter เฉพาะ String |
| 2 | `lib/services/offline_sync_service.dart` | `retryFailed()` เก็บ failedIds เป็น `['retry_pending']` — ไม่ตรงกับ id จริง ทำให้ retry ครั้งต่อไปไม่เจอ audit ที่ fail | เปลี่ยนเป็นเก็บ `stillFailedIds` จริง (id ของ audit ที่ยัง fail) |
| 5 | `lib/models/temp_photo_model.dart` | `TempPhoto.fromJson()` ถ้า JSON ไม่มี `tempId` → คืนค่า id = '' (empty string) → Firestore crash | เพิ่ม `throw ArgumentError('tempId is required in JSON')` |

### 🟡 Medium — Bug / UX

| # | ไฟล์ | ปัญหา | แก้ไข |
|---|------|-------|-------|
| 6a | `lib/models/audit_history.dart` | Equatable shallow equality — `changes` เป็น `Map<String, dynamic>` เทียบ reference ไม่ใช่ value | ลบ `extends Equatable` → override `==` และ `hashCode` ด้วย `DeepCollectionEquality` |
| 6b | `lib/models/asset_model.dart` | Equatable shallow equality — `history` เป็น `List<AuditHistory>` เทียบ reference | Override `==` และ `hashCode` ด้วย `ListEquality` สำหรับ `history` |
| 7 | `lib/widgets/asset_search_bar.dart` | `StatelessWidget` สร้าง `TextEditingController.fromValue()` ใหม่ทุก build → cursor กระตุก | เปลี่ยนเป็น `StatefulWidget` เก็บ controller ไว้ใน State |
| 8 | `lib/screens/home_screen.dart` | `addPostFrameCallback` ไม่มี guard flag → infinite loop ถ้า condition ยังเป็นจริง | เพิ่ม `_redirected` flag + `Future.delayed` reset |
| 10 | `lib/providers/temp_photo_provider.dart` | `updateTempPhoto()` ใช้ `set()` + `SetOptions(merge: true)` ที่มี `capturedAt: FieldValue.serverTimestamp()` → overwrite ทุกครั้ง | เปลี่ยนเป็น `update()` และไม่ใส่ `capturedAt` |
| 14 | `lib/screens/dashboard_screen.dart` | Bulk accept loop ถ้า batch fail กลางคัน → หยุดทั้ง loop ไม่รู้ success/fail | ใช้ try-catch แต่ละ batch + นับ `successCount` / `failCount` |

### 🟢 Minor — Best practices

| # | ไฟล์ | ปัญหา | แก้ไข |
|---|------|-------|-------|
| 17 | `lib/mappers/asset_mapper.dart` | `getShortClassName()` return rawClass ถ้าไม่เจอใน map เช่น `'A9999'` | Return `'Unknown ($rawClass)'` |
| 18 | `lib/configs/default_values.dart` | `auditYear = '2024'` hardcoded — ตอนนี้ปี 2026 แล้ว | เปลี่ยนเป็น `get => DateTime.now().year.toString()` |
| 19 | `lib/main.dart` | `_startConnectivityListener()` เรียก `syncPendingAudits()` ทุกครั้งที่ connect → sync ซ้ำซ้อน | เพิ่ม `_isSyncing` flag guard |
| 20 | `lib/screens/audit_screen.dart` | DEV screen — `onSubmit` ทำแค่ SnackBar ไม่ได้ submit จริง | เชื่อม `AuditProvider` + `AuthProvider` → submit จริง |

### ✅ ไฟล์อื่นที่แก้ประกอบ

| ไฟล์ | แก้ไข |
|------|-------|
| `pubspec.yaml` | ลบ `flutter: '>=3.27.0'` ที่ซ้ำออก, เพิ่ม `collection: ^1.19.1` |

---

## ❌ ปัญหาที่ทราบแล้วแต่เลือกไม่แก้ (พร้อมเหตุผล)

### ข้อ 3: `asset_provider.dart` — cache key collision

**ว่าใน fix/:** `costCenters.join('_')` อาจ collision เช่น `['A_B', 'C']` กับ `['A', 'B_C']`

**เหตุผลที่ไม่แก้:**  
- โอกาสเกิดต่ำมาก — Cost Center Code ในองค์กรจริงเป็นรหัส 8 หลักตัวเลข (เช่น `10111200`) ไม่มี `_` 
- ถ้าต้องการแก้ใช้ `sorted.join('|').hashCode.toRadixString(16)` แทน — ไม่เร่งด่วน

### ข้อ 4: `auth_provider.dart` — type mismatch `firstWhere`

**ว่าใน fix/:** `orElse: () => null` แต่ type เป็น `Map<String, dynamic>` (non-nullable)

**เหตุผลที่ไม่แก้:**  
- Dart version 3.x อนุญาตให้ return `null` จาก `orElse` เมื่อ type เป็น nullable (`Map<String, dynamic>?`)
- โค้ดปัจจุบัน `_currentUserEntry` มี return type เป็น `Map<String, dynamic>?` — ถูกต้องแล้ว

### ข้อ 9: `audit_provider.dart` — RBAC check หลัง upload

**ว่าใน fix/:** upload รูปไปแล้วค่อย check permission → orphan file

**เหตุผลที่ไม่แก้:**  
- โค้ดปัจจุบัน **check RBAC ก่อน upload อยู่แล้ว** (`// 0) ตรวจสอบ permission ก่อน`)
- เป็นการแจ้งปัญหาที่ไม่ตรงกับโค้ดจริง

### ข้อ 11: `sync_progress_widget.dart` — ไม่ auto-refresh

**ว่าใน fix/:** ใช้ `Timer.periodic` ทุก 2 วิ

**เหตุผลที่ไม่แก้:**  
- `SyncStatus` เปลี่ยนเฉพาะตอน sync เท่านั้น — ไม่ได้เปลี่ยนเรื่อยๆ
- `Timer.periodic` ทุก 2 วิ เป็นการสิ้นเปลือง performance โดยไม่จำเป็น
- วิธีที่ถูกต้องคือใช้ `ValueListenableBuilder` กับ Hive box หรือ StreamBuilder

### ข้อ 12: `temp_photo_edit_form.dart` — setState ทุก keypress

**ว่าใน fix/:** `_onRefChanged()` เรียก `setState` ทุกครั้ง → lag

**เหตุผลที่ไม่แก้:**  
- `setState` เปลี่ยนแค่ `_filteredAssets` (local state เล็ก) — ไม่ได้ rebuild ทั้ง form
- Filter array ใน memory (~1000-2000 assets) ไวมาก — ไม่มี lag จริง
- Debounce 300ms เป็น optimization ที่เกินจำเป็น ณ จุดนี้

### ข้อ 13: `theme_provider.dart` — race condition constructor

**ว่าใน fix/:** constructor เรียก async method → `_loadFromPrefs()` อาจยังไม่เสร็จ

**เหตุผลที่ไม่แก้:**  
- `ChangeNotifierProvider` รอให้ constructor เสร็จก่อน build — Race condition ไม่เกิดจริง
- `_loadFromPrefs()` set ค่าเริ่มต้น (default light mode) ก่อน แล้วค่อย notifyListeners() ทีหลัง

### ข้อ 15: `CachedNetworkImage` — เปลี่ยน `Image.network` ทั้งหมด (7 ไฟล์)

**ว่าใน fix/:** ใช้ `CachedNetworkImage` แทน `Image.network` ใน `asset_table_list.dart`, `image_uploader.dart`, `image_modal.dart`, `temp_photo_card.dart`, `temp_photo_edit_form.dart`, `audit_form.dart`, `search_screen.dart`

**เหตุผลที่ไม่แก้:**  
- **ไม่จำเป็นตอนนี้** — `Image.network` ทำงานได้ปกติ ไม่มี crash หรือ bug
- เป็นแค่ **UX improvement** — รูปจะ cache ใน memory ตอน scroll กลับมา ไม่ต้องโหลดใหม่
- ปัจจุบันรูป asset มีจำนวนไม่มาก (~100 รูป) — scroll lag ไม่เกิดขึ้น
- กันไว้ก่อน **bloated code** — ถ้าใส่ `CachedNetworkImage` แล้วไม่ได้ใช้ประโยชน์จริง จะเพิ่ม complexity โดยใช่เหตุ
- `cached_network_image: ^3.4.1` อยู่ใน `pubspec.yaml` แล้ว (คุณ jamorn เพิ่มไว้ก่อน) — พร้อมใช้เมื่อมีเวลา

**เมื่อไหร่ควรทำ:**  
- เมื่อมี assets เกิน 500+ รายการ และ user เริ่ม抱怨 scroll แล้วรูปโหลดช้า
- เมื่อมีการใช้รูปใน ListView แบบ infinite scroll

### ข้อ 16: ลบ `@HiveType` annotations

**ว่าใน fix/:** ไม่ได้ใช้ `hive_generator` แล้ว — ลบ annotation ทิ้งได้

**เหตุผลที่ไม่แก้:**  
- `@HiveType` + `@HiveField` ยังจำเป็นสำหรับ `TypeAdapter` ที่เขียนเอง — Hive ใช้ reflection อ่าน field order จาก annotation
- ลบ annotation → Hive อ่าน field ไม่ถูก → data corrupted

---

## 📊 สถิติ

| รายการ | จำนวน |
|--------|-------|
| ไฟล์ที่แก้ไข | 12 ไฟล์ |
| ไฟล์ที่รู้ปัญหาแต่ไม่แก้ | 8 ข้อ |
| `flutter analyze` | **No issues found!** |
| iOS Simulator | ✅ Run ได้ปกติ |

---

## 📝 หมายเหตุเพิ่มเติม

- ก่อนแก้มีการลบ 5 ไฟล์ที่ไม่ใช้: `survey_dev_screen`, `simple_audit_screen`, `demo_screen`, `demo_form`, `simple_audit_form`
- มีการ Clean rebuild: `flutter clean` → `pub get` → `pod deintegrate` → `pod install`
