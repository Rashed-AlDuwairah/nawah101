import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Global theme notifier for light/dark mode switching.
///
/// When switching theme, sets [isSwitching] to true, which triggers
/// a splash overlay in the app. After a short delay, the splash
/// dismisses and the app rebuilds with new colors.
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier._() : super(ThemeMode.system);

  static final ThemeNotifier instance = ThemeNotifier._();

  bool get isDark => value == ThemeMode.dark;

  /// True during theme switch animation (shows splash)
  bool isSwitching = false;

  /// Switch theme with splash overlay
  void setDark(bool dark) {
    if (AppColors.isDark == dark) return;
    isSwitching = true;
    notifyListeners(); // show splash

    // After a brief delay, apply the actual color change
    Future.delayed(const Duration(milliseconds: 400), () {
      value = dark ? ThemeMode.dark : ThemeMode.light;
      // isSwitching will be set to false when splash completes
    });
  }

  void toggle() => setDark(!isDark);

  void onSplashDone() {
    isSwitching = false;
    notifyListeners();
  }
}
