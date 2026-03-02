import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/nawah_top_notification.dart';

/// Bottom sheet for creating a new project (Novel, Idea, or Plan).
///
/// Shows iOS-style modal with form fields.
/// Novel → navigates to editor after creation.
/// Idea/Plan → shows success message (their editors will be built later).
class CreateProjectSheet extends StatefulWidget {
  const CreateProjectSheet({super.key, required this.projectType});

  /// 'رواية' | 'فكرة' | 'مخطط'
  final String projectType;

  /// Show the creation options popup from a + button.
  static void showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'إنشاء مشروع جديد',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                ctx,
                title: 'إنشاء رواية',
                subtitle: 'ابدأ كتابة رواية جديدة',
                icon: Icons.menu_book_rounded,
                color: AppColors.primary,
                type: 'رواية',
              ),
              _buildOptionTile(
                ctx,
                title: 'إنشاء فكرة',
                subtitle: 'فكرة سريعة أو ملاحظة',
                icon: Icons.lightbulb_outline_rounded,
                color: const Color(0xFFFF6B9D),
                type: 'فكرة',
              ),
              _buildOptionTile(
                ctx,
                title: 'إنشاء مخطط',
                subtitle: 'خريطة أحداث أو تسلسل',
                icon: Icons.account_tree_rounded,
                color: AppColors.warning,
                type: 'مخطط',
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildOptionTile(
    BuildContext ctx, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String type,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        _showCreateForm(ctx, type);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
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

  static void _showCreateForm(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
      builder: (ctx) => CreateProjectSheet(projectType: type),
    );
  }

  @override
  State<CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends State<CreateProjectSheet> {
  final _titleController = TextEditingController();

  // ── Categories based on project type ──
  late final List<String> _availableCategories;
  final Set<String> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _availableCategories = _getCategoriesForType(widget.projectType);
  }

  List<String> _getCategoriesForType(String type) {
    switch (type) {
      case 'رواية':
        return [
          'خيال علمي',
          'رومانسي',
          'غموض',
          'تاريخي',
          'رعب',
          'مغامرة',
          'دراما',
          'كوميدي',
          'اجتماعي',
          'فلسفي',
        ];
      case 'فكرة':
        return []; // Categories are now picked inside the idea editor
      case 'مخطط':
        return [
          'تسلسل زمني',
          'خريطة شخصيات',
          'بنية فصول',
          'خريطة عالم',
          'مسار أحداث',
        ];
      default:
        return [];
    }
  }

  /// Whether this type uses single-select (true) or multi-select 2-5 (false)
  bool get _isSingleSelect => widget.projectType != 'رواية';

  String get _typeLabel {
    switch (widget.projectType) {
      case 'رواية':
        return 'الرواية';
      case 'فكرة':
        return 'الفكرة';
      case 'مخطط':
        return 'المخطط';
      default:
        return 'المشروع';
    }
  }

  IconData get _typeIcon {
    switch (widget.projectType) {
      case 'رواية':
        return Icons.menu_book_rounded;
      case 'فكرة':
        return Icons.lightbulb_outline_rounded;
      case 'مخطط':
        return Icons.account_tree_rounded;
      default:
        return Icons.note;
    }
  }

  Color get _typeColor {
    switch (widget.projectType) {
      case 'رواية':
        return AppColors.primary;
      case 'فكرة':
        return const Color(0xFFFF6B9D);
      case 'مخطط':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  void _handleCreate() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      NawahTopNotification.show(context, message: 'يرجى إدخال اسم $_typeLabel');
      return;
    }
    if (_availableCategories.isNotEmpty) {
      if (_isSingleSelect && _selectedCategories.isEmpty) {
        NawahTopNotification.show(context, message: 'اختر تصنيفاً واحداً');
        return;
      }
      if (!_isSingleSelect && _selectedCategories.length < 2) {
        NawahTopNotification.show(context, message: 'اختر تصنيفين على الأقل');
        return;
      }
    }

    Navigator.pop(context);

    if (widget.projectType == 'رواية') {
      // Navigate to editor for novels
      context.push('/editor');
    } else if (widget.projectType == 'فكرة') {
      // Navigate to Idea Editor with parameters
      context.push(
        '/idea-editor',
        extra: {
          'title': title,
          'category': _selectedCategories.isNotEmpty
              ? _selectedCategories.first
              : 'فكرة',
        },
      );
    } else {
      // For plans — show success (their editors come later)
      NawahTopNotification.show(
        context,
        message: 'تم إنشاء $_typeLabel بنجاح! 🎉',
        isError: false,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_typeIcon, color: _typeColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إنشاء ${widget.projectType}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'أدخل التفاصيل الأساسية',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Title field
              Text(
                'اسم $_typeLabel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
                child: TextField(
                  controller: _titleController,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'مثال: The Silent Echo',
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (_availableCategories.isNotEmpty) ...[
                // Categories
                Row(
                  children: [
                    Text(
                      'التصنيف',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isSingleSelect ? '(اختر واحد)' : '(اختر ٢ – ٥)',
                      style: TextStyle(fontSize: 12, color: AppColors.textHint),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableCategories.map((cat) {
                    final isSelected = _selectedCategories.contains(cat);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedCategories.remove(cat);
                          } else if (_isSingleSelect) {
                            // Single select: replace
                            _selectedCategories.clear();
                            _selectedCategories.add(cat);
                          } else if (_selectedCategories.length < 5) {
                            _selectedCategories.add(cat);
                          } else {
                            NawahTopNotification.show(
                              context,
                              message: 'الحد الأقصى 5 تصنيفات',
                            );
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _typeColor
                              : _typeColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: _typeColor.withValues(alpha: 0.2),
                                ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 28),

              // Create button
              GestureDetector(
                onTap: _handleCreate,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_typeColor, _typeColor.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _typeColor.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'إنشاء ${widget.projectType}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
