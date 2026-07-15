# Asset Management App

แอปพลิเคชันสำรวจครุภัณฑ์ (Asset Survey) สำหรับองค์กร

## ฟีเจอร์หลัก

- **Login ด้วย Google** – ใช้ Firebase Authentication
- **Dashboard** – ดูภาพรวมสถานะการสำรวจ จำนวนครุภัณฑ์ที่สำรวจแล้ว/ทั้งหมด
- **Survey** – สำรวจครุภัณฑ์ตาม Cost Center / ประเภททรัพย์สิน
  - ค้นหาและกรองรายการ
  - แสดงภาพและข้อมูลครุภัณฑ์
  - บันทึก Audit (สถานที่, สภาพ, รูปถ่าย)
  - แสดง Temp Photo (รูปถ่ายชั่วคราวที่ยังไม่ยืนยัน)
- **Search** – ค้นหาครุภัณฑ์ทั่วทั้งระบบ (เลขครุภัณฑ์, ชื่อ, สถานที่)
- **ระบบสิทธิ์ (RBAC)** – ควบคุมการเข้าถึงตามบทบาทและ Cost Center
- **Temp Photo Management** – จัดการรูปถ่ายที่รอยืนยัน (Accept / Edit / Reject)

## เทคโนโลยีที่ใช้

| ส่วน | เทคโนโลยี |
|------|----------|
| Framework | Flutter (Dart) |
| State Management | Provider |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| Storage | Firebase Storage |
| Platform | iOS, Android, macOS |

## การติดตั้งและรัน

### สิ่งที่ต้องมี

- Flutter SDK >= 3.0
- โปรเจกต์ Firebase (Firestore + Authentication + Storage)
- ไฟล์กำหนดค่า Firebase สำหรับแต่ละ platform:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
  - `macos/Runner/GoogleService-Info.plist`

## ขั้นตอน

```bash
# 1. Clone repository
git clone https://github.com/jamorn/asset-manament-app.git
cd asset-manament-app

# 2. ติดตั้ง dependencies
flutter pub get

# 3. รันแอป (เลือก platform)
flutter run
flutter run -d ios
flutter run -d macos
```

> **หมายเหตุ:** ไฟล์ Firebase credential (google-services.json, GoogleService-Info.plist) ถูก ignore ไว้ใน .gitignore แล้ว ต้องวางไฟล์เหล่านี้เองในโปรเจกต์

## โครงสร้างแอป

```
lib/
├── main.dart                       # จุดเริ่มต้นแอป + Provider setup
├── firebase_options.dart           # Firebase config (สร้างโดย flutterfire configure)
│
├── config/
│   └── theme.dart                  # Light/Dark Theme + ColorScheme extensions
│
├── configs/
│   ├── constants.dart              # Firestore collection path constants
│   ├── default_values.dart         # ค่าเริ่มต้นสำหรับ Asset field
│   └── routes.dart                 # Route policy + RBAC rule engine
│
├── mappers/
│   └── asset_mapper.dart           # Map Firestore ↔ AssetModel (toJson/fromJson)
│
├── models/
│   ├── asset_model.dart            # Asset data model (Equatable)
│   ├── audit_data.dart             # Audit record model (Hive)
│   ├── audit_history.dart          # Audit history entry
│   ├── enums.dart                  # Environment / Mobility enums
│   ├── sync_status.dart            # Offline sync status (Hive)
│   └── temp_photo_model.dart       # TempPhoto model (Hive)
│
├── providers/
│   ├── asset_provider.dart         # Asset CRUD + cache + audit tracking
│   ├── audit_provider.dart         # Submit audit log
│   ├── auth_provider.dart          # Firebase Auth + RBAC rights
│   ├── temp_photo_provider.dart    # TempPhoto CRUD + RBAC
│   └── theme_provider.dart         # Theme mode persistence
│
├── screens/
│   ├── home_screen.dart            # BottomNav wrapper (4 tabs)
│   ├── survey_screen.dart          # Tab 0: Survey (asset list + filters)
│   ├── survey_dev_screen.dart      # Developer version of survey screen
│   ├── search_screen.dart          # Tab 1: Public search
│   ├── dashboard_screen.dart       # Tab 2: Progress dashboard
│   ├── temp_photo_screen.dart      # Tab 3: Temp photos
│   ├── audit_screen.dart           # Single asset audit form
│   ├── simple_audit_screen.dart    # Simplified single asset audit
│   ├── demo_screen.dart            # Demo screen for testing
│   ├── not_found_screen.dart       # 404 fallback
│
├── services/
│   ├── rbac_service.dart           # RBAC filtering logic + CostCenter/Class stats
│   └── offline_sync_service.dart   # Offline data sync manager (batch upload)
│
├── utils/
│   ├── image_picker.dart           # Image picker helper (camera/gallery)
│   └── temp_photo_utils.dart       # Temp photo utility functions
│
├── validation/
│   └── temp_photo_validator.dart   # Temp photo validation rules
│
└── widgets/
    ├── asset_class_picker.dart      # Asset class filter chips
    ├── asset_search_bar.dart        # Search bar widget
    ├── asset_table_list.dart        # Asset list with thumbnails
    ├── audit_form.dart              # Full audit form (Environment/Mobility/Location/Photo)
    ├── condition_select.dart        # Condition dropdown + custom input
    ├── cost_center_selector.dart    # Cost center filter chips
    ├── demo_form.dart               # Demo form for testing
    ├── image_modal.dart             # Full-screen image viewer
    ├── image_uploader.dart          # Image upload component
    ├── load_more_list.dart          # Paginated asset list
    ├── simple_audit_form.dart       # Simplified audit form
    ├── sync_progress_widget.dart    # Offline sync progress indicator
    ├── temp_photo_accept_modal.dart # Accept temp as asset dialog
    ├── temp_photo_card.dart         # Temp photo card
    ├── temp_photo_edit_form.dart    # Edit/create temp photo form
    └── temp_photo_panel.dart        # Temp photos list panel
```

## การตั้งค่า Firebase

1. สร้างโปรเจกต์ Firebase Console
2. เปิดใช้งาน Authentication (Google Sign-In)
3. เปิดใช้งาน Cloud Firestore และ Firebase Storage
4. ดาวน์โหลดไฟล์กำหนดค่า (google-services.json / GoogleService-Info.plist)
5. วางไฟล์ในโฟลเดอร์ที่ถูกต้องตาม platform


# Xcode Run Destinations
└── Xcode Run Destinations
    ├── Recent
    │   ├── ✓ 💻 My Mac (Designed for iPad)
    │   ├── 📱 iPad ของ ลิขิต (Network)
    │   └── 📱 iPhone 17 Pro
    │   ├── ✓ 💻 My Mac (Designed for iPad)
    │   ├── 📱 iPad ของ ลิขิต (Network)
    │   └── 📱 iPhone 17 Pro
    ├── Mac
    │   └── ✓ 💻 My Mac (Designed for iPad)
    ├── iOS Device
    │   └── 📱 iPad ของ ลิขิต (Network)
    ├── Build
    │   ├── 🛠️ Any iOS Device (arm64)
    │   └── 🛠️ Any iOS Simulator Device (arm64)
    └── iOS Simulators
        ├── 📱 iPad (A16)
        ├── 📱 iPad Air 11-inch (M4)
        ├── 🟩 iPad Air 13-inch (M4) [Selected]
        ├── 📱 iPad Pro 11-inch (M5)
        ├── 📱 iPad Pro 13-inch (M5)
        ├── 📱 iPad mini (A17 Pro)
        ├── 📱 iPhone 17
        ├── 📱 iPhone 17 Pro
        ├── 📱 iPhone 17 Pro Max
        ├── 📱 iPhone 17e
        └── 📱 iPhone Air
## Example Firestore Document

ตัวอย่างข้อมูลครุภัณฑ์ใน Cloud Firestore collection `assets`:

```json
{
"assetNo": "200400012609",
"description": "35W020 JUMBO BAG PACKER",
"assetClass": "A2004",
"assetClassName": "Machine - Straight Line",
"capDate": "2016-10-01",
"assetOwner": "จตุพร ธีระนิติกุล",
"costCenter": "10111200",
"costCenterName": "PLEB (BIC)-Sub",
"mainLocation": "",
"lastLocationName": "PLEB HD",
"environment": "outdoor",
"mobility": "fixed",
"status": "",
"currentStatus": 0,
"lastCondition": "ใช้งานได้ปกติ (Normal)",
"remarks": "35W050B",
"lastImageUrl": "https://firebasestorage.googleapis.com/v0/b/asset-audit-95195.firebasestorage.app/o/artifacts%2Firpc-asset-audit%2Faudit_photos%2F200400012609_1781770907328.jpg?alt=media&token=6c3641a9-f936-4870-aa14-483e5d508993",
"updatedAt": "2026-06-30T02:11:42.148Z",
"updatedBy": "system",
"history": []
}
```

> หมายเหตุ: ฟิลด์ `history` จะมีข้อมูลเมื่อมีการบันทึก Audit แล้ว

## License

MIT License
