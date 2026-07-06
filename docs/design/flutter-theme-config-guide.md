# 🎨 Flutter Theme Config Guide

Based on Next.js color tokens from `globals.css`

---

## File: `lib/config/theme_config.dart`

```dart
// =============================================================
// Asset Audit System — Flutter Theme Configuration
// =============================================================
// สร้างจาก Next.js Design System (globals.css)
// Light / Dark Theme via ThemeData
// =============================================================

import 'package:flutter/material.dart';

// ==================================================================
// Color Palette
// ==================================================================

class AppColors {
  // ---- Light Mode ----
  static const bgPage = Color(0xFFF1F5F9);           // slate-100
  static const bgCard = Color(0xFFFFFFFF);            // white
  static const bgCardAlt = Color(0xFFF8FAFC);         // slate-50
  static const bgInput = Color(0xFFF8FAFC);           // slate-50

  static const fgPrimary = Color(0xFF0F172A);         // slate-900
  static const fgSecondary = Color(0xFF475569);        // slate-600
  static const fgMuted = Color(0xFF94A3B8);           // slate-400

  static const accent = Color(0xFF2563EB);            // blue-600
  static const accentHover = Color(0xFF1D4ED8);       // blue-700
  static const accentLight = Color(0xFFDBEAFE);       // blue-100
  static const accentText = Color(0xFF1E40AF);        // blue-800

  static const success = Color(0xFF059669);            // emerald-600
  static const successLight = Color(0xFFD1FAE5);      // emerald-100
  static const warning = Color(0xFFD97706);            // amber-600
  static const warningLight = Color(0xFFFEF3C7);      // amber-100
  static const danger = Color(0xFFDC2626);             // red-600
  static const dangerLight = Color(0xFFFEE2E2);       // red-100

  static const border = Color(0xFFE2E8F0);            // slate-200
  static const borderAccent = Color(0xFFBFDBFE);      // blue-200

  // Selector Colors
  static const selectorActiveBlue = Color(0xFF1D4ED8); // blue-700 (Cost Center)
  static const selectorActiveAmber = Color(0xFFB45309); // amber-700 (Asset Class)

  // ---- Dark Mode ----
  static const bgPageDark = Color(0xFF0F172A);         // slate-900
  static const bgCardDark = Color(0xFF1E293B);         // slate-800
  static const bgCardAltDark = Color(0xFF334155);      // slate-700
  static const bgInputDark = Color(0xFF1E293B);        // slate-800

  static const fgPrimaryDark = Color(0xFFF1F5F9);     // slate-100
  static const fgSecondaryDark = Color(0xFF94A3B8);   // slate-400
  static const fgMutedDark = Color(0xFF64748B);        // slate-500

  static const accentDark = Color(0xFF3B82F6);         // blue-500
  static const accentHoverDark = Color(0xFF60A5FA);   // blue-400
  static const accentLightDark = Color(0xFF1E3A5F);
  static const accentTextDark = Color(0xFF93C5FD);    // blue-300

  static const successDark = Color(0xFF10B981);        // emerald-500
  static const successLightDark = Color(0xFF064E3B);  // emerald-900
  static const warningDark = Color(0xFFF59E0B);        // amber-500
  static const warningLightDark = Color(0xFF78350F);  // amber-900
  static const dangerDark = Color(0xFFEF4444);         // red-500
  static const dangerLightDark = Color(0xFF7F1D1D);   // red-900

  static const borderDark = Color(0xFF334155);         // slate-700
  static const borderAccentDark = Color(0xFF1E40AF);  // blue-800
}

// ==================================================================
// Font Sizes Constants
// ==================================================================

class AppFontSizes {
  static const double tiny = 8;       // lastCondition, remaining counter
  static const double mini = 9;       // assetClassName, Badge, CC name
  static const double small = 10;     // description, table header, lastLocation, subtext, email
  static const double xs = 12;       // labels, button text, nav link
  static const double sm = 14;       // body text
  static const double base = 16;     // title "AssetApp", submit button
}

// ==================================================================
// Border Radius Constants
// ==================================================================

class AppRadius {
  static const double sm = 8;        // rounded-lg (thumbnail, badge)
  static const double md = 12;       // rounded-xl (card, input, button)
  static const double lg = 16;       // rounded-2xl (large container)
  static const double xl = 24;       // rounded-3xl (modal)
}

// ==================================================================
// Theme Data Builder
// ==================================================================

class AppTheme {
  // ------------------------------------------------------------
  // Light Theme
  // ------------------------------------------------------------
  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: AppColors.accent,
      onPrimary: Colors.white,
      primaryContainer: AppColors.accentLight,
      onPrimaryContainer: AppColors.accentText,
      secondary: AppColors.accentText,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.accentLight,
      surface: AppColors.bgCard,
      onSurface: AppColors.fgPrimary,
      error: AppColors.danger,
      onError: Colors.white,
      errorContainer: AppColors.dangerLight,
      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgPage,

      // ---- AppBar / NavBar ----
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgCard,
        foregroundColor: AppColors.fgPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: AppFontSizes.base,
          fontWeight: FontWeight.bold,
          color: AppColors.fgPrimary,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // ---- Card ----
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // ---- Text ----
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: AppFontSizes.base,
          fontWeight: FontWeight.bold,
          color: AppColors.fgPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: AppFontSizes.sm,
          fontWeight: FontWeight.w600,
          color: AppColors.fgPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: AppFontSizes.xs,
          fontWeight: FontWeight.w600,
          color: AppColors.fgPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppFontSizes.sm,
          color: AppColors.fgPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppFontSizes.xs,
          color: AppColors.fgPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: AppFontSizes.small,
          color: AppColors.fgSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: AppFontSizes.xs,
          fontWeight: FontWeight.bold,
          color: AppColors.fgSecondary,
          letterSpacing: 0.05,
        ),
        labelMedium: TextStyle(
          fontSize: AppFontSizes.small,
          color: AppColors.fgMuted,
        ),
        labelSmall: const TextStyle(
          fontSize: AppFontSizes.mini,
          color: AppColors.fgMuted,
        ),
      ),

      // ---- Input Decoration (TextField, Dropdown) ----
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: const TextStyle(
          fontSize: AppFontSizes.xs,
          color: AppColors.fgMuted,
        ),
        labelStyle: const TextStyle(
          fontSize: AppFontSizes.xs,
          fontWeight: FontWeight.bold,
          color: AppColors.fgSecondary,
        ),
      ),

      // ---- ElevatedButton ----
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.fgMuted,
          disabledForegroundColor: Colors.white70,
          elevation: 2,
          shadowColor: AppColors.accent.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: const TextStyle(
            fontSize: AppFontSizes.base,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ---- Divider ----
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 0.5,
        space: 0,
      ),

      // ---- Dropdown ----
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgInput,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),

      // ---- Bottom Sheet (Search detail) ----
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      // ---- Dialog ----
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      // ---- SnackBar ----
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.fgPrimary,
        contentTextStyle: const TextStyle(
          fontSize: AppFontSizes.xs,
          color: AppColors.fgPrimaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ---- Progress Indicator (Linear) ----
      linearProgressIndicatorTheme: LinearProgressIndicatorThemeData(
        backgroundColor: AppColors.border,
        color: AppColors.accent,
      ),
    );
  }

  // ------------------------------------------------------------
  // Dark Theme
  // ------------------------------------------------------------
  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.accentDark,
      onPrimary: Colors.white,
      primaryContainer: AppColors.accentLightDark,
      onPrimaryContainer: AppColors.accentTextDark,
      secondary: AppColors.accentTextDark,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.accentLightDark,
      surface: AppColors.bgCardDark,
      onSurface: AppColors.fgPrimaryDark,
      error: AppColors.dangerDark,
      onError: Colors.white,
      errorContainer: AppColors.dangerLightDark,
      outline: AppColors.borderDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgPageDark,

      // ---- AppBar / NavBar ----
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgCardDark,
        foregroundColor: AppColors.fgPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: AppFontSizes.base,
          fontWeight: FontWeight.bold,
          color: AppColors.fgPrimaryDark,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // ---- Card ----
      cardTheme: CardThemeData(
        color: AppColors.bgCardDark,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.borderDark),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // ---- Text ----
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: AppFontSizes.base,
          fontWeight: FontWeight.bold,
          color: AppColors.fgPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontSize: AppFontSizes.sm,
          fontWeight: FontWeight.w600,
          color: AppColors.fgPrimaryDark,
        ),
        titleSmall: TextStyle(
          fontSize: AppFontSizes.xs,
          fontWeight: FontWeight.w600,
          color: AppColors.fgPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: AppFontSizes.sm,
          color: AppColors.fgPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: AppFontSizes.xs,
          color: AppColors.fgPrimaryDark,
        ),
        bodySmall: TextStyle(
          fontSize: AppFontSizes.small,
          color: AppColors.fgSecondaryDark,
        ),
        labelLarge: TextStyle(
          fontSize: AppFontSizes.xs,
          fontWeight: FontWeight.bold,
          color: AppColors.fgSecondaryDark,
          letterSpacing: 0.05,
        ),
        labelMedium: TextStyle(
          fontSize: AppFontSizes.small,
          color: AppColors.fgMutedDark,
        ),
        labelSmall: TextStyle(
          fontSize: AppFontSizes.mini,
          color: AppColors.fgMutedDark,
        ),
      ),

      // ---- Input Decoration ----
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgInputDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.accentDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.dangerDark),
        ),
        hintStyle: const TextStyle(
          fontSize: AppFontSizes.xs,
          color: AppColors.fgMutedDark,
        ),
        labelStyle: const TextStyle(
          fontSize: AppFontSizes.xs,
          fontWeight: FontWeight.bold,
          color: AppColors.fgSecondaryDark,
        ),
      ),

      // ---- ElevatedButton ----
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.fgMutedDark,
          disabledForegroundColor: Colors.white70,
          elevation: 2,
          shadowColor: AppColors.accentDark.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: const TextStyle(
            fontSize: AppFontSizes.base,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ---- Divider ----
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 0.5,
        space: 0,
      ),

      // ---- Bottom Sheet ----
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgCardDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      // ---- Dialog ----
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgCardDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      // ---- SnackBar ----
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.fgPrimaryDark,
        contentTextStyle: const TextStyle(
          fontSize: AppFontSizes.xs,
          color: AppColors.fgPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ---- Progress Indicator ----
      linearProgressIndicatorTheme: LinearProgressIndicatorThemeData(
        backgroundColor: AppColors.borderDark,
        color: AppColors.accentDark,
      ),
    );
  }
}

// ==================================================================
// Usage in main.dart
// ==================================================================
//
// ```dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'config/theme_config.dart';
//
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => ThemeProvider(),
//       child: const MyApp(),
//     ),
//   );
// }
//
// class ThemeProvider extends ChangeNotifier {
//   ThemeMode _mode = ThemeMode.system;
//   ThemeMode get mode => _mode;
//
//   void toggle() {
//     _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
//
//   void setMode(ThemeMode mode) {
//     _mode = mode;
//     notifyListeners();
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProv = context.watch<ThemeProvider>();
//     return MaterialApp(
//       title: 'Asset Management',
//       theme: AppTheme.light,
//       darkTheme: AppTheme.dark,
//       themeMode: themeProv.mode,
//       home: const MainScreen(),
//     );
//   }
// }
// ```
```

---

## วิธีนำไปใช้

1. **สร้างไฟล์** `lib/config/theme_config.dart`
2. **คัดลอก**โค้ดด้านบนทั้งหมดลงไป
3. **ปรับ `main.dart`** ให้ใช้ `AppTheme.light` และ `AppTheme.dark` ตามตัวอย่าง
4. **สร้าง `ThemeProvider`** สำหรับ toggle dark/light mode
5. **ใน widget ต่างๆ** ใช้ `Theme.of(context)` และ `colorScheme` แทนการ Hardcode สี

## สีที่ต้องการเพิ่มเติมสำหรับ Selector ต่างๆ

สำหรับ Cost Center Selector และ Asset Class Picker ที่ต้องการสีเฉพาะ:

```dart
// Cost Center — Active Button
Container(
  decoration: BoxDecoration(
    color: isSelected
        ? AppColors.selectorActiveBlue     // #1D4ED8
        : (isDark ? AppColors.bgCardDark : AppColors.bgCard),
    borderRadius: BorderRadius.circular(AppRadius.md),
    border: Border.all(
      color: isSelected
          ? AppColors.selectorActiveBlue
          : (isDark ? AppColors.borderDark : AppColors.border),
    ),
  ),
)

// Asset Class — Active Button
Container(
  decoration: BoxDecoration(
    color: isSelected
        ? AppColors.selectorActiveAmber    // #B45309
        : (isDark ? AppColors.bgCardDark : AppColors.bgCard),
    borderRadius: BorderRadius.circular(AppRadius.md),
    border: Border.all(
      color: isSelected
          ? AppColors.selectorActiveAmber
          : (isDark ? AppColors.borderDark : AppColors.border),
    ),
  ),
)
```
