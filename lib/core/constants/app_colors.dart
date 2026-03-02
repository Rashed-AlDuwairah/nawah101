import 'package:flutter/material.dart';

/// Nawah Design System — Color Palette
///
/// Supports Light and Dark mode via [isDark] flag.
/// All colors auto-switch when isDark changes.
/// Usage: AppColors.primary, AppColors.background, etc.
abstract final class AppColors {
  /// Theme toggle — set to true for dark mode
  static bool isDark = false;

  // ── Primary (same in both modes) ──
  static const Color primary = Color.fromARGB(255, 13, 155, 124);
  static const Color primaryLight = Color(0xFF2BBFA0);

  // ── Gradients (same in both modes) ──
  static const Color gradientStart = Color.fromARGB(255, 13, 155, 124);
  static const Color gradientEnd = Color(0xFF2BBFA0);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ── Backgrounds ──
  static Color get background => isDark
      ? const Color(0xFF000000)
      : const Color(0xFFFFFFFF); // Deep black for iOS Dark Mode
  static Color get surface => isDark
      ? const Color(0xFF1C1C1E)
      : const Color(0xFFFFFFFF); // iOS System Gray 6
  static Color get surfaceVariant => isDark
      ? const Color(0xFF2C2C2E)
      : const Color(0xFFF2F2F7); // iOS System Gray 5

  // ── Card ──
  static Color get card => isDark ? const Color(0xFF1E1E2A) : Colors.white;
  static Color get cardElevated =>
      isDark ? const Color(0xFF252535) : Colors.white;

  // ── Text ──
  static Color get textPrimary =>
      isDark ? Colors.white : const Color(0xFF1A1A2E);
  static Color get textSecondary =>
      isDark ? const Color(0xFF9E9EA8) : const Color(0xFF8E8E93);
  static Color get textHint =>
      isDark ? const Color(0xFF5C5C6C) : const Color(0xFFBDBDC7);

  // ── Status ──
  static const Color success = Color(0xFF34C759);
  static Color get successLight =>
      isDark ? const Color(0xFF1A3A25) : const Color(0xFFE8F9EE);
  static const Color danger = Color(0xFFFF3B30);
  static Color get dangerLight =>
      isDark ? const Color(0xFF3A1A1A) : const Color(0xFFFFF0EF);
  static const Color warning = Color(0xFFFF9500);

  // ── Borders & Dividers ──
  static Color get border =>
      isDark ? const Color(0xFF2A2A3A) : const Color(0xFFE5E5EA);
  static Color get divider =>
      isDark ? const Color(0xFF222233) : const Color(0xFFF2F2F7);

  // ── Bottom Nav ──
  static Color get navBar => isDark ? const Color(0xFF161620) : Colors.white;
  static Color get navBarInactive =>
      isDark ? const Color(0xFF5C5C6C) : const Color(0xFFBDBDC7);

  // ── Notification Icon Backgrounds ──
  static Color get notifPurple =>
      isDark ? const Color(0xFF2A2040) : const Color(0xFFEDE7FF);
  static Color get notifGreen =>
      isDark ? const Color(0xFF1A3A25) : const Color(0xFFE8F9EE);
  static Color get notifPink =>
      isDark ? const Color(0xFF3A1A25) : const Color(0xFFFFF0F5);
  static Color get notifBlue =>
      isDark ? const Color(0xFF1A2A3A) : const Color(0xFFE8F4FD);
}
