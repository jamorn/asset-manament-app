# 🚀 AssetApp Port: Dart (Flutter) → Kotlin (Android Native)

> **สถานะ:** ✅ เสร็จสิ้นการ Port source code แล้ว  
> **เป้าหมาย:** ย้ายจาก Flutter → Android Native (Kotlin + Compose + Hilt)  
> **ผู้ทำ:** AI Assistant @ PC ที่ทำงาน  
> **วันที่:** $(Get-Date -Format "dd/MM/yyyy")

---

## 📂 โครงสร้างใหม่: `AssetApp-Android/`

```
AssetApp-Android/
├── build.gradle.kts                 # Project-level Gradle
├── settings.gradle.kts
├── gradle.properties
├── local.properties                 # ← ต้องแก้ sdk.dir ให้ตรงกับ Mac
├── gradlew / gradlew.bat
├── gradle/wrapper/
│   ├── gradle-wrapper.properties
│   └── gradle-wrapper.jar          # ❌ ต้องสร้าง (flutter build apk --debug)
├── app/
│   ├── build.gradle.kts             # App-level Gradle
│   ├── proguard-rules.pro
│   ├── google-services.json         # ← Firebase config
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── res/values/themes.xml
│       └── java/com/plbg/assetapp/
│           ├── AssetApp.kt          # Hilt Application
│           ├── MainActivity.kt      # Entry point
│           ├── data/
│           │   ├── local/AssetCache.kt
│           │   ├── mapper/AssetMapper.kt, AuditHistoryMapper.kt
│           │   ├── remote/FirestorePaths.kt
│           │   └── repository/ (5 impls)
│           ├── domain/
│           │   ├── model/ (7 files)
│           │   ├── repository/ (interfaces)
│           │   └── usecase/RbacService.kt
│           ├── di/AppModule.kt
│           ├── ui/ (15+ files)
│           └── worker/SyncWorker.kt
```

---

## ✅ สิ่งที่ Port เสร็จแล้ว

### Data Layer

- [x] `FirestorePaths.kt` — Firebase collection/document paths
- [x] `AssetMapper.kt` — Firestore ↔ AssetModel mapping
- [x] `AuditHistoryMapper.kt` — History JSON ↔ AuditHistory
- [x] `AssetCache.kt` — SharedPrefs cache with 30-day TTL + RBAC key
- [x] `AssetRepositoryImpl` — Assets fetch + cache logic
- [x] `AuditRepositoryImpl` — Audit submission with photo upload
- [x] `AuthRepositoryImpl` — Google Sign-In + RBAC + allowed users
- [x] `TempPhotoRepositoryImpl` — Temp photo CRUD + accept as asset
- [x] `OfflineSyncRepositoryImpl` — Pending audits in SharedPrefs + sync

### Domain Layer

- [x] `AssetModel` — Core data model (with isAudited, display properties)
- [x] `AuditHistory` — Audit log entry
- [x] `Environment`, `Mobility`, `AuditStatus`, `TempPhotoStatus` — Enums
- [x] `SyncStatus`, `AuditData`, `TempPhoto`, `AcceptResult` — Data classes
- [x] `DefaultValues` — Constants
- [x] `AppRoutes` — Route policy (PUBLIC/HYBRID/PRIVATE) + RBAC
- [x] `RBACContext`, `CostCenterInfo`, `CostCenterStats`, `AssetClassStats` — RBAC models
- [x] `RbacService` — Filtering assets/photos by role + cost centers

### UI Layer

- [x] `MainActivity.kt` — `@AndroidEntryPoint` + Compose setContent
- [x] `AssetApp.kt` — `@HiltAndroidApp` + Timber init
- [x] `AssetNavHost.kt` — Navigation with 5 routes
- [x] `Theme.kt` + `Type.kt` — Material3 theme (light/dark/dynamic)
- [x] `SurveyScreen` — Main screen: cost center filter, asset class picker, search, LoadMoreList
- [x] `SurveyTopBar`, `CostCenterSelector`, `AssetClassPicker`
- [x] `AssetViewModel` — Survey logic with UiState (Loading/Success/Error)
- [x] `AuditScreen` — Full form: photo picker, location, condition dropdown (5 options), env/mobility, remarks
- [x] `AuditViewModel` — Submit with status tracking
- [x] `DashboardScreen` — Progress + per-cost-center stats
- [x] `DashboardViewModel` — Combine assets + audited stats
- [x] `SearchScreen` — Real-time search with LazyColumn
- [x] `SearchViewModel` — Filter with RBAC
- [x] `LoginScreen` — Google Sign-In with ActivityResultLauncher
- [x] `AuthViewModel` — Auth state flow + handleSignInResult
- [x] `Badge`, `ImageModal`, `AssetSearchBar`, `AssetCard`, `LoadMoreList` — Reusable components
- [x] `TempPhotoScreen` — List + Add/Edit dialog + Accept dialog + Delete confirm
- [x] `TempPhotoViewModel` — CRUD operations

### DI & Build

- [x] `AppModule.kt` — Hilt module: Firebase, Json, Repositories, DataSource, Cache
- [x] `build.gradle.kts` (project) — Plugins: AGP 8.7.3, Kotlin 2.1.0, GMS 4.4.2, Hilt 2.53.1
- [x] `build.gradle.kts` (app) — Dependencies: Firebase BOM, Compose BOM, Coil, Hilt, WorkManager
- [x] `AndroidManifest.xml` — Permissions + Activity + Application
- [x] `proguard-rules.pro` — Firebase + Kotlin Serialization + Hilt rules

### Worker

- [x] `SyncWorker.kt` — HiltWorker + SyncScheduler with connectivity listener

---

## ❌ สิ่งที่ต้องทำก่อน Build (บน Mac)

### 1. สร้าง `gradle-wrapper.jar`

```bash
cd /path/to/flutter/asset-manament-app
flutter build apk --debug
cp android/gradle/wrapper/gradle-wrapper.jar AssetApp-Android/gradle/wrapper/
```

### 2. แก้ `local.properties`

เปิด `AssetApp-Android/local.properties` → เปลี่ยน:

```properties
sdk.dir=C:\Users\...\Android\Sdk
```

เป็น path SDK ของ Mac:

```properties
sdk.dir=/Users/yourname/Library/Android/sdk
```

### 3. แก้ Web Client ID สำหรับ Google Sign-In

เปิด `AuthRepositoryImpl.kt` → หา:

```kotlin
.requestIdToken("YOUR_WEB_CLIENT_ID")
```

เปลี่ยนเป็น client ID จริงจาก **Firebase Console** → Authentication → Sign-in method → Google → **Web SDK configuration**

### 4. Build!

```bash
cd AssetApp-Android
./gradlew assembleDebug
```

APK จะอยู่ที่: `app/build/outputs/apk/debug/app-debug.apk`

---

## 📝 หมายเหตุสำคัญสำหรับ AI/Developer ที่มาใหม่

1. **Package:** `com.plbg.assetapp` (ทั้งหมด)
2. **Architecture:** MVVM + Hilt DI + Repository pattern
3. **Auth:** ใช้ Google Sign-In → Firebase Auth → ตรวจสอบ allowedUsers จาก Firestore collection `settings`
4. **RBAC:** จำกัดสิทธิ์ตาม role + costCenters ต่อ screen ผ่าน `AppRoutes`
5. **Cache:** SharedPrefs 30 วัน, key ตาม role + costCenters
6. **Offline:** Pending audits เก็บใน SharedPrefs, sync เมื่อมี network
7. **Navigation:** `AssetNavHost` ใช้ compose navigation → `survey` → `search`, `dashboard`, `tempphoto`, `audit/{assetNo}`
8. **API Keys ทั้งหมด** อยู่ใน `google-services.json` แล้ว

---

## 📊 สถิติ

| หมวด         | จำนวนไฟล์     |
| ------------ | ------------- |
| Data Layer   | 9 files       |
| Domain Layer | 10 files      |
| UI Layer     | 21 files      |
| DI + Build   | 8 files       |
| Worker       | 1 file        |
| **รวม**      | **~49 files** |

===============================================

# Mac

# # ที่ Flutter project

cd asset-manament-app

# Pull ล่าสุด

git fetch origin
git reset --hard origin/main # หรือ origin/port-to-kotlin

# สร้าง gradle-wrapper.jar

flutter build apk --debug

# Copy ไป AssetApp-Android

cp android/gradle/wrapper/gradle-wrapper.jar AssetApp-Android/gradle/wrapper/

# Build!

cd AssetApp-Android
./gradlew assembleDebug
