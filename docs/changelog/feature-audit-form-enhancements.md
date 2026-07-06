# 🚀 Feature: Audit Form Enhancements

Branch: `feature/audit-form-enhancements`

---

## สรุปการแก้ไขทั้งหมด

### 🟥 Priority #1 — `audit_form.dart` (lib/widgets/audit_form.dart)

| ก่อน | หลัง |
|------|------|
| ❌ ไม่มี Asset Info Card | ✅ เพิ่ม **Asset Info Card** แสดง `assetNo + description + costCenter` |
| ❌ ไม่มี Environment select | ✅ เพิ่ม **Dropdown "Environment"** (Outdoor/Indoor) |
| ❌ ไม่มี Mobility select | ✅ เพิ่ม **Dropdown "Mobility"** (Fixed/Portable) |
| ❌ ไม่มี Remarks field | ✅ เพิ่ม **TextArea "REMARK / NOTE"** |
| ❌ ส่งแค่ `location, condition, imageFile` | ✅ ส่ง **`environment, mobility, remarks`** ไปด้วย |
| Label `"LOCATION NAME"` | ✅ ปรับเป็น **`"CURRENT LOCATION"`** ตามต้นฉบับ |

### 🟥 Priority #1 — `audit_provider.dart` (lib/providers/audit_provider.dart)

| ก่อน | หลัง |
|------|------|
| ❌ ไม่มี params `environment/mobility/remarks` | ✅ **รับค่าเพิ่ม** `environment?, mobility?, remarks?` |
| ❌ ส่งแค่ 4 fields (`lastLocationName, lastCondition, lastImageUrl, updatedAt, updatedBy`) | ✅ **ส่ง 7 fields** (เพิ่ม `environment, mobility, remarks` ถ้ามีค่า) |

### 🟥 Priority #1 — `survey_screen.dart` (lib/screens/survey_screen.dart)

| ก่อน | หลัง |
|------|------|
| ❌ ส่งแค่ `location/condition/imageFile` ไป AuditProvider | ✅ **ส่ง `environment, mobility, remarks`** เพิ่มไปด้วย |
| ❌ Search fields แค่ 3 fields | ✅ **เพิ่มเป็น 8 fields** (รวม `mainLocation, costCenter, costCenterName, assetOwner, remarks`) |

### 🟧 Priority #3 — `search_screen.dart` (lib/screens/search_screen.dart)

| ก่อน | หลัง |
|------|------|
| ❌ Search แค่ 5 fields | ✅ **เพิ่มเป็น 8 fields** (เหมือน Next.js ทุกประการ) |

### 🟧 Priority #4 — `temp_photo_edit_form.dart` (lib/widgets/temp_photo_edit_form.dart)

| ก่อน | หลัง |
|------|------|
| ❌ Reference Asset พิมพ์เลขเอาเอง | ✅ **มี Reference Asset Search** (ค้นหาจาก `assetNo, description, assetClassName, costCenterName`) |
| ❌ ส่ง `costCenter/assetClass` เป็น `''` เปล่า | ✅ **ส่งค่าจาก Reference Asset ที่เลือก** ครบถ้วน |
| ❌ ไม่มี Auto-filled Info card | ✅ **แสดง Asset Info** เมื่อเลือกแล้ว (`assetNo, description, costCenter, assetClass`) |

---

## ไฟล์ที่แก้ไข

| ไฟล์ | จำนวนเปลี่ยนแปลง |
|------|-----------------|
| `lib/widgets/audit_form.dart` | +210 / -24 |
| `lib/providers/audit_provider.dart` | +26 / -8 |
| `lib/screens/survey_screen.dart` | +20 / -2 |
| `lib/screens/search_screen.dart` | +4 / -2 |
| `lib/widgets/temp_photo_edit_form.dart` | +158 / -16 |

---

## เปรียบเทียบกับ Next.js (ต้นฉบับ)

ฟังก์ชันที่ตรงกันแล้วหลังจากแก้ไข:
- ✅ Audit Form มี Asset Info Card (เหมือน `AuditForm.tsx`)
- ✅ Environment Dropdown (เหมือน `AuditForm.tsx`)
- ✅ Mobility Dropdown (เหมือน `AuditForm.tsx`)
- ✅ Remarks TextArea (เหมือน `AuditForm.tsx`)
- ✅ ส่ง `environment/mobility/remarks` ไป Firestore (เหมือน `useAudit.ts`)
- ✅ Search 8 fields (เหมือน `useAssets.ts`)
- ✅ Temp Photo: Reference Asset Search + Auto-fill (เหมือน `TempPhotoForm.tsx`)
