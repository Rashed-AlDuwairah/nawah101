import 'package:flutter/material.dart';
import '../../core/theme/theme_notifier.dart';
import '../../core/widgets/nawah_scaffold.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/access_control/presentation/screens/access_control_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/editing/presentation/screens/editing_screen.dart';

/// Main navigation shell managing tab switching.
///
/// Listens to [ThemeNotifier] and forces a full rebuild of all
/// child screens when the theme changes, using a [ValueKey].
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // TODO: This will come from Supabase/Riverpod later
  // For now, set to true to preview the editing tab
  final bool _isLinkedAsEditor = true;

  @override
  void initState() {
    super.initState();
    ThemeNotifier.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeNotifier.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    // Force rebuild of all screens when theme changes
    setState(() {});
  }

  List<Widget> _buildScreens() {
    if (_isLinkedAsEditor) {
      return [
        const HomeScreen(), // 0
        const NotificationsScreen(), // 1
        const EditingScreen(), // 2
        const AccessControlScreen(), // 3
        const ProfileScreen(), // 4
      ];
    }
    return [
      const HomeScreen(), // 0
      const NotificationsScreen(), // 1
      const AccessControlScreen(), // 2
      const ProfileScreen(), // 3
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Use ValueKey to force IndexedStack to rebuild all children
    // when theme mode changes
    final themeKey = ValueKey(ThemeNotifier.instance.isDark);

    return NawahScaffold(
      currentIndex: _currentIndex,
      isLinkedAsEditor: _isLinkedAsEditor,
      onTabChanged: (index) => setState(() => _currentIndex = index),
      body: IndexedStack(
        key: themeKey,
        index: _currentIndex,
        children: _buildScreens(),
      ),
    );
  }
}
