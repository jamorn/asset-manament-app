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
├── main.dart                   # จุดเริ่มต้นแอป + Provider setup
├── firebase_options.dart       # Firebase config (สร้างโดย flutterfire configure)
├── config/
│   └── theme.dart              # Light/Dark Theme + ColorScheme
├── configs/
│   ├── constants.dart          # Firestore collection path constants
│   └── routes.dart             # Route policy + RBAC rule engine
├── models/
│   ├── asset_model.dart        # Asset data model
│   └── temp_photo_model.dart   # TempPhoto model
├── providers/
│   ├── auth_provider.dart      # Firebase Auth + RBAC rights
│   ├── asset_provider.dart     # Asset CRUD + cache + audit tracking
│   ├── temp_photo_provider.dart# TempPhoto CRUD + RBAC
│   ├── audit_provider.dart     # Submit audit log
│   └── theme_provider.dart     # Theme mode persistence
├── services/
│   └── rbac_service.dart       # RBAC filtering logic
├── screens/
│   ├── home_screen.dart        # BottomNav wrapper (4 tabs)
│   ├── survey_screen.dart      # Tab 0: Survey (asset list + filters)
│   ├── search_screen.dart      # Tab 1: Public search
│   ├── dashboard_screen.dart   # Tab 2: Progress dashboard
│   ├── temp_photo_screen.dart  # Tab 3: Temp photos
│   ├── audit_screen.dart       # Single asset audit form
│   └── temp_photo_accept_dialog.dart # Accept temp as asset
├── widgets/
│   ├── asset_class_picker.dart
│   ├── asset_search_bar.dart
│   ├── asset_table_list.dart
│   ├── audit_form.dart
│   ├── condition_select.dart
│   ├── cost_center_selector.dart
│   ├── image_modal.dart
│   ├── image_uploader.dart
│   ├── load_more_list.dart
│   ├── temp_photo_accept_modal.dart
│   ├── temp_photo_card.dart
│   ├── temp_photo_edit_form.dart
│   └── temp_photo_panel.dart
├── utils/
│   ├── image_picker.dart
│   └── temp_photo_utils.dart
└── Validation/
    └── temp_photo_validator.dart
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
## License

MIT License
