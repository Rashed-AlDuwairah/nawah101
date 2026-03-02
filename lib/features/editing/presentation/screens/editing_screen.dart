import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

/// Screen: Editing (التحرير) — Only visible when linked as editor.
///
/// Shows projects from the writer(s) who added this user as editor.
class EditingScreen extends StatelessWidget {
  const EditingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_document,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'التحرير',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'المشاريع التي تحررها لآخرين',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

              const SizedBox(height: 24),

              // ── Writer Section ──
              _buildWriterSection(
                context: context,
                writerName: 'راشد الدويرة',
                projects: [
                  _EditProjectMock(
                    'The Silent Echo (الفصل ٣)',
                    'رواية',
                    '٣٤٠ كلمة معدلة',
                    'منذ ساعتين',
                    Icons.menu_book_rounded,
                    AppColors.primary,
                    ['اقتراحات معلقة'],
                  ),
                  _EditProjectMock(
                    'رسائل لم تصل',
                    'رواية',
                    'تم قبول التعديلات',
                    'منذ يومين',
                    Icons.check_circle_outline_rounded,
                    AppColors.success,
                    [],
                  ),
                  // Added Outline mock for testing
                  _EditProjectMock(
                    'Timeline — Desert Storm',
                    'مخططات',
                    '٨ عناصر مبدئية',
                    'منذ يومين',
                    Icons.account_tree_rounded,
                    AppColors.warning,
                    ['يحتاج مراجعة'],
                  ),
                  // Added Idea mock for testing
                  _EditProjectMock(
                    'Character motivations for Ch.7',
                    'أفكار',
                    '—',
                    'منذ ٤ أيام',
                    Icons.lightbulb_outline_rounded,
                    const Color(0xFFFF6B9D),
                    [],
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: 0.03, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWriterSection({
    required BuildContext context,
    required String writerName,
    required List<_EditProjectMock> projects,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Writer header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9B7C), Color(0xFF2BBFA0)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      writerName[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        writerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${projects.length} مشاريع',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 24,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Project cards
          ...projects.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildEditProjectCard(context, p),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProjectCard(BuildContext context, _EditProjectMock project) {
    final hasPending = project.pendingStatus.contains('اقتراحات معلقة');
    return GestureDetector(
      onTap: () {
        if (project.type == 'أفكار') {
          context.push('/idea-editor', extra: {
            'title': project.title,
            'category': project.type,
            'isGuest': true,
          });
        } else if (project.type == 'مخططات') {
          context.push('/outline-editor', extra: {
            'title': project.title,
            'isGuest': true,
          });
        } else {
          // Default to restricted novel editor
          context.push('/editor-restricted', extra: {
            'title': project.title,
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasPending
                ? AppColors.warning.withValues(alpha: 0.3)
                : AppColors.border.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: project.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(project.icon, color: project.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${project.type} · ${project.wordCount}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (hasPending)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  project.pendingStatus,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
              ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_left_rounded,
                color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}

class _EditProjectMock {
  final String title;
  final String type;
  final String wordCount;
  final String pendingStatus;
  final IconData icon;
  final Color color;
  final List<String> pendingActions;

  _EditProjectMock(
    this.title,
    this.type,
    this.wordCount,
    this.pendingStatus,
    this.icon,
    this.color,
    this.pendingActions,
  );
}
