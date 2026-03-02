import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/create_project_sheet.dart';

/// Screen 2: Home Screen (الرئيسية)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['الكل', 'روايات', 'أفكار', 'مخططات'];

  // ── Daily Writing Goal ──
  int? _dailyGoal; // null = not set yet
  int _wordsWrittenToday = 0; // mock: words written today
  DateTime? _goalSetTime; // when goal was locked

  bool get _isGoalLocked {
    if (_goalSetTime == null) return false;
    return DateTime.now().difference(_goalSetTime!).inHours < 24;
  }

  double get _goalProgress {
    if (_dailyGoal == null || _dailyGoal == 0) return 0;
    return (_wordsWrittenToday / _dailyGoal!).clamp(0.0, 1.0);
  }

  void _showGoalPicker() {
    if (_isGoalLocked) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _GoalPickerSheet(
        onGoalSelected: (goal) {
          setState(() {
            _dailyGoal = goal;
            _goalSetTime = DateTime.now();
            _wordsWrittenToday = 0;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  final List<ProjectMock> _allProjects = [
    ProjectMock(
      'The Silent Echo',
      'روايات',
      '٤٣,٨٥٠ كلمة',
      'منذ ساعتين',
      Icons.menu_book_rounded,
      AppColors.primary,
    ),
    ProjectMock(
      'The Silent Echo (كمحرر ضيف)',
      'روايات',
      'صلاحية قراءة واقتراح',
      'الآن',
      Icons.visibility_rounded,
      AppColors.warning,
      isGuest: true,
    ),
    ProjectMock(
      'Desert Storm — Act Structure',
      'مخططات',
      '١٢ عنصر',
      'أمس',
      Icons.account_tree_rounded,
      AppColors.warning,
    ),
    ProjectMock(
      'Character motivations for Ch.7',
      'أفكار',
      '—',
      'منذ 3 أيام',
      Icons.lightbulb_outline_rounded,
      const Color(0xFFFF6B9D),
    ),
    ProjectMock(
      'Letters from Nowhere',
      'روايات',
      '١٣,٤٠٠ كلمة',
      'منذ أسبوع',
      Icons.menu_book_rounded,
      AppColors.primary,
    ),
    ProjectMock(
      'تطوير شخصية البطل',
      'أفكار',
      '—',
      'منذ أسبوعين',
      Icons.lightbulb_outline_rounded,
      const Color(0xFFFF6B9D),
    ),
    ProjectMock(
      'Timeline — Desert Storm',
      'مخططات',
      '٨ عناصر',
      'منذ أسبوع',
      Icons.account_tree_rounded,
      AppColors.warning,
    ),
    // --- Added for Pagination Demo ---
    ProjectMock(
      'Worldbuilding: Magic System',
      'أفكار',
      '—',
      'منذ شهر',
      Icons.lightbulb_outline_rounded,
      const Color(0xFFFF6B9D),
    ),
    ProjectMock(
      'The Last Stand (Draft 1)',
      'روايات',
      '٨٩,٢٠٠ كلمة',
      'منذ شهرين',
      Icons.menu_book_rounded,
      AppColors.primary,
    ),
    ProjectMock(
      'Character Arcs: The Villain',
      'مخططات',
      '٥ عناصر',
      'منذ شهرين',
      Icons.account_tree_rounded,
      AppColors.warning,
    ),
    ProjectMock(
      'Echoes of the Past',
      'روايات',
      '٢٢,١٥٠ كلمة',
      'منذ ٣ أشهر',
      Icons.menu_book_rounded,
      AppColors.primary,
    ),
    ProjectMock(
      'Plot Holes to fix',
      'أفكار',
      '—',
      'منذ ٣ أشهر',
      Icons.lightbulb_outline_rounded,
      const Color(0xFFFF6B9D),
    ),
  ];

  List<ProjectMock> get _filteredProjects {
    if (_selectedFilter == 0) return _allProjects;
    final category = _filters[_selectedFilter];
    return _allProjects.where((p) => p.category == category).toList();
  }

  void _onProjectTap(ProjectMock project) {
    if (project.category == 'أفكار') {
      context.push('/idea-editor', extra: {
        'title': project.title,
        'category': project.category,
      });
    } else if (project.category == 'مخططات') {
      context.push('/outline-editor', extra: {
        'title': project.title,
      });
    } else if (project.isGuest) {
      context.push('/editor-restricted', extra: {
        'title': project.title,
      });
    } else {
      context.push('/editor', extra: {
        'title': project.title,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 16, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: _buildTopBar().animate().fadeIn(duration: 500.ms),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildWelcomeBanner()
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: 0.05, end: 0),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader(
                  'إحصائياتك',
                  Icons.auto_awesome_rounded,
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildStatsRow()),
            SliverPadding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader(
                  'آخر النشاطات',
                  Icons.schedule_rounded,
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildActivityList()),
            SliverPadding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader('مشاريعك', Icons.folder_outlined),
              ),
            ),
            SliverToBoxAdapter(child: _buildFilterChips()),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            // Render Projects efficiently using Slivers
            _buildProjectsSliverList(),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ), // Bottom padding
          ],
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━ Top Bar ━━━━━━━━━━━━
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الخميس، ٢٦ فبراير',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                'مرحباً 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // ── + Create Button ──
          GestureDetector(
            onTap: () => CreateProjectSheet.showOptions(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9B7C), Color(0xFF2BBFA0)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━ Welcome Banner + Daily Goal ━━━━━━━━━━━━
  Widget _buildWelcomeBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D9B7C), Color(0xFF2BBFA0)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──
            Row(
              children: [
                const Icon(Icons.laptop_mac_rounded,
                    color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  'مساحة الكتابة',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'مرحباً بعودتك، كاتب ✨',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'لديك ${_allProjects.length} مشاريع نشطة · 57,250 كلمة',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 16),

            // ── Daily Goal Section ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: _dailyGoal == null
                  ? _buildGoalNotSet()
                  : _buildGoalProgress(),
            ),
          ],
        ),
      ),
    );
  }

  /// Goal not set — show call to action
  Widget _buildGoalNotSet() {
    return GestureDetector(
      onTap: _showGoalPicker,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.flag_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'حدّد هدفك اليومي!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'كم كلمة تود كتابتها اليوم؟',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: Colors.white.withValues(alpha: 0.6),
            size: 22,
          ),
        ],
      ),
    );
  }

  /// Goal set — show progress
  Widget _buildGoalProgress() {
    final remaining = (_dailyGoal! - _wordsWrittenToday).clamp(0, _dailyGoal!);
    final isDone = _wordsWrittenToday >= _dailyGoal!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isDone ? Icons.emoji_events_rounded : Icons.flag_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isDone ? 'أحسنت! حققت هدفك 🎉' : 'هدف اليوم: $_dailyGoal كلمة',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (_isGoalLocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      _getRemainingLockTime(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: _goalProgress,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              isDone ? const Color(0xFF69F0AE) : Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              '$_wordsWrittenToday / $_dailyGoal كلمة',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              isDone ? 'مكتمل ✓' : 'باقي $remaining كلمة',
              style: TextStyle(
                color: isDone
                    ? const Color(0xFF69F0AE)
                    : Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getRemainingLockTime() {
    if (_goalSetTime == null) return '';
    final elapsed = DateTime.now().difference(_goalSetTime!);
    final remaining = const Duration(hours: 24) - elapsed;
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    return '$hoursس $minutesد';
  }

  // ━━━━━━━━━━━━ Section Header ━━━━━━━━━━━━
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━ Stats Cards ━━━━━━━━━━━━
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard(
            '${_allProjects.length}',
            'مشاريع',
            Icons.folder_outlined,
          ),
          const SizedBox(width: 10),
          _buildStatCard('57,250', 'كلمة', Icons.text_fields_rounded),
          const SizedBox(width: 10),
          _buildStatCard('ساعتين', 'آخر تعديل', Icons.schedule_rounded),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━ Activity List ━━━━━━━━━━━━
  Widget _buildActivityList() {
    return SizedBox(
      height: 72,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildActivityItem(
            'عدّلت The Silent Echo',
            'منذ ساعتين',
            Icons.edit_rounded,
            AppColors.primary,
          ),
          const SizedBox(width: 10),
          _buildActivityItem(
            'أضفت فكرة جديدة',
            'أمس',
            Icons.auto_awesome_rounded,
            AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━ Filter Chips ━━━━━━━━━━━━
  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, i) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = _selectedFilter == index;
          final count = index == 0
              ? _allProjects.length
              : _allProjects.where((p) => p.category == _filters[index]).length;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: isActive
                    ? null
                    : Border.all(
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _filters[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white.withValues(alpha: 0.25)
                          : AppColors.border.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : AppColors.textHint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ━━━━━━━━━━━━ Projects List ━━━━━━━━━━━━
  Widget _buildProjectsSliverList() {
    final allProjects = _filteredProjects;

    if (allProjects.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.folder_off_outlined,
                  color: AppColors.textHint,
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  'لا توجد مشاريع في هذا القسم',
                  style: TextStyle(fontSize: 14, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ),
      );
    }

    const int maxToShow = 5;
    final bool hasMore = allProjects.length > maxToShow;
    final displayProjects = allProjects.take(maxToShow).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // If it's the last item and we have more, show the View All button
            if (index == displayProjects.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    context.push('/view-all-projects', extra: {
                      'title': _filters[_selectedFilter] == 'الكل'
                          ? 'جميع المشاريع'
                          : 'مشاريع: ${_filters[_selectedFilter]}',
                      'projects': allProjects,
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'عرض الكل (${allProjects.length})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            final p = displayProjects[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildProjectCard(p),
            );
          },
          childCount: displayProjects.length + (hasMore ? 1 : 0),
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectMock project) {
    return GestureDetector(
      onTap: () => _onProjectTap(project),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
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
            // Icon (RTL → starts on right)
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
            // Title & category
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
                  Row(
                    children: [
                      Text(
                        '✦',
                        style: TextStyle(fontSize: 8, color: project.color),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        project.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Meta + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  project.metadata,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  project.timeAgo,
                  style: TextStyle(fontSize: 10, color: AppColors.textHint),
                ),
              ],
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectMock {
  final String title;
  final String category;
  final String metadata;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final bool isGuest;

  ProjectMock(
    this.title,
    this.category,
    this.metadata,
    this.timeAgo,
    this.icon,
    this.color, {
    this.isGuest = false,
  });
}

/// Bottom sheet for picking a daily writing goal.
class _GoalPickerSheet extends StatefulWidget {
  const _GoalPickerSheet({required this.onGoalSelected});
  final ValueChanged<int> onGoalSelected;

  @override
  State<_GoalPickerSheet> createState() => _GoalPickerSheetState();
}

class _GoalPickerSheetState extends State<_GoalPickerSheet> {
  int? _selected;
  final _customController = TextEditingController();
  bool _isCustom = false;

  final List<_GoalOption> _presets = [
    _GoalOption(250, 'خفيف', '~15 دقيقة'),
    _GoalOption(500, 'معتدل', '~30 دقيقة'),
    _GoalOption(1000, 'جاد', '~1 ساعة'),
    _GoalOption(1500, 'متقدم', '~1.5 ساعة'),
    _GoalOption(2000, 'تحدي', '~2 ساعة'),
  ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.flag_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'هدف الكتابة اليومي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'يُقفل لمدة 24 ساعة بعد التحديد',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Preset options
            ...List.generate(_presets.length, (i) {
              final preset = _presets[i];
              final isActive = !_isCustom && _selected == preset.words;
              return GestureDetector(
                onTap: () => setState(() {
                  _selected = preset.words;
                  _isCustom = false;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: isActive
                        ? null
                        : Border.all(
                            color: AppColors.border.withValues(alpha: 0.4),
                          ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${preset.words}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color:
                              isActive ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ' كلمة',
                        style: TextStyle(
                          fontSize: 13,
                          color: isActive
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        preset.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? Colors.white.withValues(alpha: 0.9)
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        preset.duration,
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Custom option
            GestureDetector(
              onTap: () => setState(() => _isCustom = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _isCustom
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCustom
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : AppColors.border.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      color: _isCustom ? AppColors.primary : AppColors.textHint,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _isCustom
                          ? TextField(
                              controller: _customController,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'أدخل عدد الكلمات...',
                                hintStyle: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (v) {
                                final num = int.tryParse(v);
                                if (num != null && num > 0) {
                                  setState(() => _selected = num);
                                }
                              },
                            )
                          : Text(
                              'عدد مخصص...',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textHint,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Confirm button
            GestureDetector(
              onTap: _selected != null
                  ? () => widget.onGoalSelected(_selected!)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: _selected != null
                      ? const LinearGradient(
                          colors: [Color(0xFF0D9B7C), Color(0xFF2BBFA0)],
                        )
                      : null,
                  color: _selected == null ? AppColors.border : null,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _selected != null
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _selected != null
                        ? 'ابدأ التحدي — $_selected كلمة 🎯'
                        : 'اختر هدفك',
                    style: TextStyle(
                      color:
                          _selected != null ? Colors.white : AppColors.textHint,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalOption {
  final int words;
  final String label;
  final String duration;
  _GoalOption(this.words, this.label, this.duration);
}
