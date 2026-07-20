# Quick Reference — Asset App

**อัปเดตล่าสุด:** 2026-07-20  
**Purpose:** รวมคำสั่งที่ใช้บ่อย + อธิบายว่าใช้ตอนไหน เพื่อป้องกัน build fail โดยไม่จำเป็น

---

## 1. คำสั่งพื้นฐาน

### `flutter clean`

```bash
cd /Users/jamorn/Desktop/asset_app
/Users/jamorn/flutter/bin/flutter clean
```

**ใช้ตอนไหน:**
- เมื่อแก้ `pubspec.yaml` (เพิ่ม/ลบ dependency)
- เมื่อ build fail ด้วย error แปลกๆ เช่น `MissingPluginException`, `Symbol not found`
- ก่อน switch branch ที่มี dependencies ต่างกัน
- อย่างน้อยทุก 2-3 สัปดาห์เพื่อลบ build artifact เก่า

**อย่าใช้ตอนไหน:**
- แค่แก้ logic ใน `lib/` — ใช้ `Hot Reload / Hot Restart` ก็พอ
- แก้แค่ UI (สี, ขนาด, padding) — `Hot Reload` พอ

**ใช้แล้วต้องทำต่อ:**
```bash
flutter pub get
# iOS: cd ios && pod install
```

---

### `flutter pub get`

```bash
cd /Users/jamorn/Desktop/asset_app
/Users/jamorn/flutter/bin/flutter pub get
```

**ใช้ตอนไหน:**
- หลังจาก `flutter clean` ทุกครั้ง (จำเป็น)
- เมื่อเพิ่ม dependency ใหม่ใน `pubspec.yaml`
- เมื่อ `git pull` แล้วมีคนอื่นแก้ `pubspec.yaml`
- เมื่อเจอ error: `Target of URI doesn't exist` หรือ `Package not found`

**อย่าใช้ตอนไหน:**
- แก้แค่ code ใน `lib/` โดยไม่แตะ `pubspec.yaml`

---

### `pod install` (iOS)

```bash
cd /Users/jamorn/Desktop/asset_app/ios
pod deintegrate   # ลบ Pods เก่าทิ้ง
pod install       # ติดตั้งใหม่
```

**ใช้ตอนไหน:**
- หลังจาก `flutter clean` + `pub get` ทุกครั้ง (จำเป็น)
- เมื่อเพิ่ม dependency ที่มี native code เช่น Firebase, camera, storage
- เมื่อ iOS build fail ด้วย error: `framework not found` หรือ `Module not found`
- เมื่อ CocoaPods version เปลี่ยน

**ไม่ต้องใช้ตอนไหน:**
- Android อย่างเดียว — คำสั่งนี้เฉพาะ iOS
- แก้เฉพาะ Dart code — ไม่มีผล

---

### `flutter analyze`

```bash
cd /Users/jamorn/Desktop/asset_app
/Users/jamorn/flutter/bin/flutter analyze lib/
```

**ใช้ตอนไหน:**
- ก่อน `git commit` ทุกครั้ง (ควรทำ)
- หลังจากแก้ไข code เสร็จแต่ละงาน
- เมื่อเจอ warning/error ใน IDE ที่ไม่แน่ใจว่าจริงหรือ IDE เพี้ยน

**ไม่ต้องใช้ตอนไหน:**
- ระหว่างกำลังแก้ code อยู่ — ใช้ IDE lint ก็พอ
- analyze ติด `No issues found` แล้วไม่ต้องทำอะไรต่อ

**ข้อควรรู้:**
- `flutter analyze` ไม่ได้ guarantee ว่า build จะผ่าน (เพราะไม่ compile จริง)
- แต่ช่วย catch error ค่อนข้างแม่นยำ (type mismatch, missing import, dead code)

---

## 2. ลำดับการ Clean Build ที่ถูกต้อง (ไม่ให้ fail)

```bash
# Step 1: Clean build artifacts
flutter clean

# Step 2: ดึง dependencies อีกครั้ง
flutter pub get

# Step 3 (iOS เท่านั้น): ลบ Pods เก่า + ติดตั้งใหม่
cd ios
pod deintegrate
pod install
cd ..

# Step 4: ตรวจสอบ code
flutter analyze lib/

# Step 5: ทดลอง build
flutter build ios --debug --no-codesign   # หรือ run บน simulator โดยตรง
```

---

## 3. วงจรการทำงานทั่วไป (ไม่ต้อง Clean ทุกครั้ง)

```
แก้ code ใน lib/
    │
    ├── แก้ UI / Logic ล้วนๆ
    │       └── Hot Reload / Hot Restart (ไม่ต้อง clean)
    │
    ├── เพิ่ม dependency ใหม่
    │       └── flutter pub get (ไม่ต้อง clean)
    │
    ├── build fail แปลกๆ / เปลี่ยน branch ที่ deps ต่างกัน
    │       └── flutter clean → pub get → pod install (iOS)
    │
    └── ก่อน commit
            └── flutter analyze lib/
```

---

## 4. Error ที่พบบ่อย + วิธีแก้

| Error | สาเหตุ | วิธีแก้ |
|-------|--------|--------|
| `Target of URI doesn't exist` | import ผิด path หรือ package ยังไม่ถูกดาวน์โหลด | `flutter pub get` |
| `MissingPluginException` | Native plugin หาย | `flutter clean` → `pub get` → `pod install` |
| `framework not found` | Pods หมดอายุ | `pod deintegrate` → `pod install` |
| `No issues found` แล้ว build fail | Firebase config หาย หรือ Xcode version mismatch | เช็ค `GoogleService-Info.plist`, clean build ใหม่ |
| `Undefined name` / `The method doesn't exist` | import ขาด หรือ rename โดยไม่เปลี่ยนชื่อเรียก | `flutter analyze` จะบอกบรรทัด |
