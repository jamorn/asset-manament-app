# 📂 Branch Review Guide

วิธีใช้งานสำหรับ AI เมื่อกลับมาทำงานใน session ใหม่

---

## 1. ตรวจสอบ Branch ปัจจุบัน

```powershell
git branch --show-current
```

## 2. ดู Branch ทั้งหมด (Local + Remote)

```powershell
git branch -a
```

## 3. ดูประวัติ Commit ล่าสุด

```powershell
git log --oneline -10
```

## 4. สลับไป Branch ที่ต้องการ

```powershell
git checkout feature/audit-form-enhancements
```

กลับไป main:

```powershell
git checkout main
```

---

## 5. เปรียบเทียบ main กับ feature branch

### 5.1 ดูรายชื่อไฟล์ที่แตกต่าง

```powershell
git diff main..feature/audit-form-enhancements --name-only
```

### 5.2 ดูภาพรวมสถิติ (จำนวนบรรทัดที่เปลี่ยน)

```powershell
git diff main..feature/audit-form-enhancements --stat
```

### 5.3 ดู diff แบบละเอียดเฉพาะ lib/

```powershell
git diff main..feature/audit-form-enhancements -- lib/
```

### 5.4 ดู diff ทุกไฟล์

```powershell
git diff main..feature/audit-form-enhancements
```

### 5.5 ดูเฉพาะ commit และ message

```powershell
git log main..feature/audit-form-enhancements --oneline
```

---

## 6. เนื้อหาใน Branch `feature/audit-form-enhancements`

| Commit | Message |
|--------|---------|
| `605a821` | docs: add design reference - Next.js color tokens & Flutter theme config guide |
| `0eb774b` | docs: add changelog for feature-audit-form-enhancements branch |
| `6037ecf` | feat: เพิ่ม Environment/Mobility/Remarks fields ใน Audit Form + Reference Asset Search ใน Temp Photo Edit Form |

### ไฟล์ที่ถูกแก้ไข (5 ไฟล์)

| ไฟล์ | การเปลี่ยนแปลง |
|------|---------------|
| `lib/widgets/audit_form.dart` | เพิ่ม Asset Info Card, Environment/Mobility Dropdown, Remarks TextArea |
| `lib/providers/audit_provider.dart` | รองรับ environment, mobility, remarks ในการ update Firestore |
| `lib/screens/survey_screen.dart` | ส่ง environment/mobility/remarks + search 8 fields |
| `lib/screens/search_screen.dart` | search 8 fields เหมือน Next.js |
| `lib/widgets/temp_photo_edit_form.dart` | Reference Asset Search + Auto-fill costCenter/assetClass |

### ไฟล์เอกสารที่เพิ่ม (3 ไฟล์)

| ไฟล์ | คำอธิบาย |
|------|---------|
| `docs/changelog/feature-audit-form-enhancements.md` | สรุปการแก้ไขโค้ดทั้งหมด |
| `docs/design/nextjs-color-tokens.md` | สี Light/Dark ทั้งหมด + Component-specific (NavBar, Table, Cost Center, Asset Class Picker, Audit Form, Font Sizes, Border Radius) |
| `docs/design/flutter-theme-config-guide.md` | Flutter Theme Config พร้อมใช้ (AppColors, AppFontSizes, AppRadius, AppTheme.light/dark) |

---

## 7. วิธีให้ AI อ่านเมื่อเริ่ม session ใหม่

บอก AI ว่า:

```
โปรดอ่านไฟล์ใน branch feature/audit-form-enhancements เพื่อดู:
1. การแก้ไข Audit Form (lib/widgets/audit_form.dart)
2. Design Tokens (docs/design/nextjs-color-tokens.md)
3. Flutter Theme Config Guide (docs/design/flutter-theme-config-guide.md)

ใช้คำสั่ง:
git checkout feature/audit-form-enhancements
git diff main..feature/audit-form-enhancements --name-only
```

หรือถ้าต้องการให้ AI อ่านไฟล์โดยตรง:

```
Read the following files:
- docs/design/nextjs-color-tokens.md
- docs/design/flutter-theme-config-guide.md
- docs/workflow/branch-review-guide.md
```
