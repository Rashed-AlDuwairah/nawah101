import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/nawah_top_notification.dart';

/// Screen 6: Profile Screen (حسابي)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'حسابي',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 28),

              // ── Avatar & Name ──
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D9B7C), Color(0xFF2BBFA0)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'ر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'راشد الدويرة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'rashid@example.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'كاتب',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: 28),

              // ── Stats Row ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildProfileStat('5', 'مشاريع'),
                    const SizedBox(width: 10),
                    _buildProfileStat('57K', 'كلمة'),
                    const SizedBox(width: 10),
                    _buildProfileStat('3', 'محررين'),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

              const SizedBox(height: 28),

              // ── Settings Menu ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildMenuItem(
                      'تعديل الملف الشخصي',
                      Icons.edit_outlined,
                      AppColors.primary,
                      onTap: _showComingSoon,
                    ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                    _buildMenuItem(
                      'إعدادات الإشعارات',
                      Icons.notifications_outlined,
                      AppColors.warning,
                      onTap: _showComingSoon,
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

                    _buildMenuItem(
                      'الأمان والخصوصية',
                      Icons.shield_outlined,
                      AppColors.success,
                      onTap: _showComingSoon,
                    ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

                    _buildMenuItem(
                      'عن نواة',
                      Icons.info_outline_rounded,
                      AppColors.textSecondary,
                      onTap: _showComingSoon,
                    ).animate().fadeIn(duration: 400.ms, delay: 600.ms),

                    const SizedBox(height: 10),

                    _buildMenuItem(
                      'تسجيل الخروج',
                      Icons.logout_rounded,
                      AppColors.danger,
                      isDanger: true,
                      onTap: _confirmLogout,
                    ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

                    const SizedBox(height: 24),

                    // ── Beta Version Label ──
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.science_rounded,
                                size: 14, color: AppColors.warning),
                            SizedBox(width: 6),
                            Text(
                              'نسخة تجريبية 0.1.0',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 800.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon() {
    NawahTopNotification.show(
      context,
      message: 'هذه الميزة قيد التطوير • النسخة التجريبية',
    );
  }

  // ━━━━━━━━━━━━ Logout ━━━━━━━━━━━━
  void _confirmLogout() {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('تسجيل الخروج؟'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━ Helpers ━━━━━━━━━━━━
  Widget _buildProfileStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    Color color, {
    bool isDanger = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDanger
                ? AppColors.danger.withValues(alpha: 0.2)
                : AppColors.border.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDanger ? AppColors.danger : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
