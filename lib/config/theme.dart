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

  Color get textPrimary => colorScheme.onSurface;
  Color get textSecondary => colorScheme.onSurfaceVariant;
  Color get surfaceCard => colorScheme.surface;
  Color get borderLight => colorScheme.outlineVariant;
  Color get surfaceSubtle => colorScheme.surfaceContainerLowest;
  Color get surfaceContainer => colorScheme.surfaceContainerHighest;
  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;
  Color get onPrimary => colorScheme.onPrimary;
  Color get error => colorScheme.error;
  Color get primary => colorScheme.primary;
  Color get surfaceDarkest => colorScheme.surfaceDim;

  /// Overlay ทึบปานกลาง (แทน context.overlay)
  Color get overlay => Colors.black.withValues(alpha: 0.54);

  /// Overlay จาง (แทน context.overlayLight)
  Color get overlayLight => Colors.black.withValues(alpha: 0.45);
}