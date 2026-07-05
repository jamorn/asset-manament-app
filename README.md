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
├── configs/          # ค่ากำหนดและ route
├── models/           # ข้อมูลโมเดล
├── providers/        # State management (Provider)
├── screens/          # หน้าจอหลัก
├── services/         # บริการติดต่อ Firebase และ RBAC
├── utils/            # Utility functions
├── widgets/          # Widget ย่อยที่ใช้ร่วมกัน
└── main.dart         # จุดเริ่มต้น
```

## การตั้งค่า Firebase

1. สร้างโปรเจกต์ Firebase Console
2. เปิดใช้งาน Authentication (Google Sign-In)
3. เปิดใช้งาน Cloud Firestore และ Firebase Storage
4. ดาวน์โหลดไฟล์กำหนดค่า (google-services.json / GoogleService-Info.plist)
5. วางไฟล์ในโฟลเดอร์ที่ถูกต้องตาม platform

## License

MIT License
