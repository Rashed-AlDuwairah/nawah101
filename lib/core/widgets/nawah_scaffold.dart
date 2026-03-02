import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Main app shell with Bottom Navigation Bar.
///
/// 4 or 5 items depending on whether user is linked as editor:
/// الرئيسية, التنبيهات, [التحرير], التحكم, حسابي
/// No center FAB — create is handled via + button on Home.
class NawahScaffold extends StatelessWidget {
  const NawahScaffold({
    super.key,
    required this.currentIndex,
    required this.body,
    required this.onTabChanged,
    this.isLinkedAsEditor = false,
  });

  final int currentIndex;
  final Widget body;
  final ValueChanged<int> onTabChanged;
  final bool isLinkedAsEditor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: body,
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    final items = <_NavItem>[
      _NavItem(0, Icons.home_rounded, 'الرئيسية'),
      _NavItem(1, Icons.notifications_outlined, 'التنبيهات'),
      if (isLinkedAsEditor) _NavItem(2, Icons.edit_document, 'التحرير'),
      _NavItem(isLinkedAsEditor ? 3 : 2, Icons.tune_rounded, 'التحكم'),
      _NavItem(isLinkedAsEditor ? 4 : 3, Icons.person_outline_rounded, 'حسابي'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBar,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items
                .map((item) => _buildNavItem(item.index, item.icon, item.label))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 4 : 0,
              height: isActive ? 4 : 0,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final int index;
  final IconData icon;
  final String label;
  _NavItem(this.index, this.icon, this.label);
}
