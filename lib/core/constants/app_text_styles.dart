import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Nawah Design System — Typography
///
/// Uses 'Cairo' for Arabic text and 'Inter' for English text.
/// All styles extracted from the UI designs.
abstract final class AppTextStyles {
  // ── Base Font Families ──
  static String get _arabicFamily => GoogleFonts.cairo().fontFamily!;
  static String get _englishFamily => GoogleFonts.inter().fontFamily!;

  // ── Headlines ──
  static TextStyle get headlineLarge => TextStyle(
    fontFamily: _arabicFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontFamily: _arabicFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Titles ──
  static TextStyle get titleLarge => TextStyle(
    fontFamily: _englishFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: _arabicFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Body ──
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: _englishFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.7,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: _arabicFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: _arabicFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ── Labels ──
  static TextStyle get labelMedium => TextStyle(
    fontFamily: _arabicFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: _arabicFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // ── Button ──
  static TextStyle get button => TextStyle(
    fontFamily: _arabicFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.3,
  );
}
