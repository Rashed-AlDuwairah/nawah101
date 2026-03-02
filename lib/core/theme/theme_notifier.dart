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

  bool get isDark => AppColors.isDark;

  /// True during theme switch animation (shows splash)
  bool isSwitching = false;

  void onSplashDone() {
    isSwitching = false;
    notifyListeners();
  }
}
