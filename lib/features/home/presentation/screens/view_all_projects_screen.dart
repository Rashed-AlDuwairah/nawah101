import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import 'home_screen.dart' show ProjectMock;

class ViewAllProjectsScreen extends StatefulWidget {
  const ViewAllProjectsScreen({
    super.key,
    required this.title,
    required this.projects,
  });

  final String title;
  final List<ProjectMock> projects;

  @override
  State<ViewAllProjectsScreen> createState() => _ViewAllProjectsScreenState();
}

class _ViewAllProjectsScreenState extends State<ViewAllProjectsScreen> {
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  int get _totalPages => (widget.projects.length / _itemsPerPage).ceil();

  List<ProjectMock> get _currentProjects {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= widget.projects.length) return [];
    return widget.projects.sublist(
      startIndex,
      endIndex > widget.projects.length ? widget.projects.length : endIndex,
    );
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // ── Grid Area ──
            Expanded(
              child: _currentProjects.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد عناصر',
                        style: TextStyle(color: AppColors.textHint),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _currentProjects.length,
                      itemBuilder: (context, index) {
                        return _buildGridCard(context, _currentProjects[index]);
                      },
                    ),
            ),

            // ── Pagination Controls ──
            if (_totalPages > 1)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.background.withValues(alpha: 0.9),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Prev Button
                    _buildPageArrow(
                      icon: Icons.chevron_right_rounded, // Right arrow for RTL
                      isActive: _currentPage > 1,
                      onTap: () => _goToPage(_currentPage - 1),
                    ),
                    const SizedBox(width: 16),
                    // Page Numbers
                    ...List.generate(_totalPages, (index) {
                      final page = index + 1;
                      return _buildPageNumber(page);
                    }),
                    const SizedBox(width: 16),
                    // Next Button
                    _buildPageArrow(
                      icon: Icons.chevron_left_rounded, // Left arrow for RTL
                      isActive: _currentPage < _totalPages,
                      onTap: () => _goToPage(_currentPage + 1),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageNumber(int page) {
    final isSelected = page == _currentPage;
    return GestureDetector(
      onTap: () => _goToPage(page),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageArrow({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColors.card : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? AppColors.border
                : AppColors.border.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? AppColors.textPrimary : AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, ProjectMock project) {
    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: project.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(project.icon, color: project.color, size: 24),
            ),
            const Spacer(),
            // Title
            Text(
              project.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            // Subtitle / word count
            Text(
              project.metadata,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            // Time ago
            Text(
              project.timeAgo,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
