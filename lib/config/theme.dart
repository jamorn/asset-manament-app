// lib/config/theme.dart — ธีมกลางของแอป รองรับ Light / Dark Mode
import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = Colors.blue;

  // ── Light Theme ──
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seedColor,
    brightness: Brightness.light,
  );

  // ── Dark Theme ──
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seedColor,
    brightness: Brightness.dark,
  );
}

/// Semantic color helpers — ใช้แทน hardcode context.textSecondary / black87 / white
/// เรียกผ่าน `context.textPrimary` , `context.borderLight` ฯลฯ
extension AppThemeColors on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// ข้อความหลัก (แทน context.textPrimary)
  Color get textPrimary => colorScheme.onSurface;

  /// ข้อความรอง / muted (แทน context.textSecondary)
  Color get textSecondary => colorScheme.onSurfaceVariant;

  /// พื้นหลังการ์ด (แทน Colors.white)
  Color get surfaceCard => colorScheme.surface;

  /// เส้นขอบอ่อน (แทน context.borderLight)
  Color get borderLight => colorScheme.outlineVariant;

  /// พื้นหลังจางสุด (แทน context.surfaceSubtle)
  Color get surfaceSubtle => colorScheme.surfaceContainerLowest;

  /// พื้นหลังคอนเทนเนอร์ (แทน context.surfaceContainer)
  Color get surfaceContainer => colorScheme.surfaceContainerHighest;

  /// พื้นหลังเข้มขึ้นอีกนิด (แทน context.surfaceContainerHigh)
  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;

  /// ข้อความบนพื้นหลัก (แทน Colors.white บนปุ่ม)
  Color get onPrimary => colorScheme.onPrimary;

  /// สี error (แทน Colors.red)
  Color get error => colorScheme.error;

  /// สีหลัก (แทน context.primary)
  Color get primary => colorScheme.primary;

  /// พื้นหลังเข้มมาก (แทน context.surfaceDarkest)
  Color get surfaceDarkest => colorScheme.surfaceDim;

  /// Overlay ทึบปานกลาง (แทน context.overlay)
  Color get overlay => Colors.black.withOpacity(0.54);

  /// Overlay จาง (แทน context.overlayLight)
  Color get overlayLight => Colors.black.withOpacity(0.45);
}