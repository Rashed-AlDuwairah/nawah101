import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/nawah_suggestion_sheet.dart';

/// Screen: Idea Editor (محرر الأفكار)
///
/// A colorful, highly customized board for capturing ideas, characters, scenes, etc.
/// Uses a modern gradient background similar to the Home screen banner.
class IdeaEditorScreen extends StatefulWidget {
  const IdeaEditorScreen({
    super.key,
    required this.title,
    required this.category,
    this.isGuest = false,
  });

  final String title;
  final String category;
  final bool isGuest;

  @override
  State<IdeaEditorScreen> createState() => _IdeaEditorScreenState();
}

class _IdeaEditorScreenState extends State<IdeaEditorScreen> {
  final List<IdeaCardModel> _cards = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isGuest) {
      // Show the existing idea content for the guest to review
      _cards.addAll([
        IdeaCardModel(
          content:
              'البطل يكتشف أن العالم الذي يعيش فيه ليس حقيقياً، وأن هناك عالماً موازياً يتحكم في كل شيء من خلف الكواليس.',
          category: 'حبكة',
        ),
        IdeaCardModel(
          content:
              'شخصية الحكيم العجوز الذي يظهر في اللحظات الحاسمة ويقدم نصائح غامضة للبطل.',
          category: 'شخصية',
        ),
        IdeaCardModel(
          content:
              'مشهد المواجهة الأخيرة فوق الجبل أثناء عاصفة رعدية، حيث تتكشف الحقيقة كاملة.',
          category: 'مشهد',
        ),
      ]);
    } else {
      // Default initial card for the writer
      _cards.add(
        IdeaCardModel(
          content: '',
          category: widget.category.isEmpty ? 'فكرة' : widget.category,
        ),
      );
    }
  }

  void _simulateSave() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isSaving = false);
    });
  }

  void _addCard(String category) {
    setState(() {
      _cards.add(IdeaCardModel(content: '', category: category));
    });
    _simulateSave();
  }

  void _removeCard(int index) {
    setState(() {
      _cards.removeAt(index);
    });
    _simulateSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            _buildTopBar(),

            // ── Header (Title) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title.isEmpty ? 'فكرة جديدة' : widget.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.05, end: 0),
            ),

            const SizedBox(height: 8),

            // ── Main Body (Cards List) ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 80,
                ),
                itemCount: _cards.length + 1,
                itemBuilder: (context, index) {
                  if (index == _cards.length) {
                    if (widget.isGuest) return const SizedBox(height: 24);
                    return _buildAddCardButton().animate().fadeIn(
                          delay: 400.ms,
                        );
                  }
                  return _buildIdeaCard(index, _cards[index])
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 150 + (index * 100)),
                      )
                      .slideY(begin: 0.1, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'رجوع',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Save Indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isSaving
                  ? AppColors.warning.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (_isSaving) ...[
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'يحفظ...',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.cloud_done_rounded,
                    color: AppColors.success,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'تم الحفظ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdeaCard(int index, IdeaCardModel card) {
    Color catColor = _getCategoryColor(card.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    card.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: catColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (_cards.length > 1 &&
                    !widget.isGuest) // Allow delete only if not guest
                  GestureDetector(
                    onTap: () => _removeCard(index),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),

          // Card Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(minHeight: 120),
              child: TextField(
                controller: card.controller,
                maxLines: null,
                minLines: 5, // Make the default box larger like an iPhone note
                onChanged: (_) => _simulateSave(),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.8,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب تفاصيل ${card.category} هنا...',
                  hintStyle: TextStyle(color: AppColors.textHint, height: 1.8),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                readOnly: widget.isGuest,
              ),
            ),
          ),
          // Suggest Edit Button for Guests
          if (widget.isGuest)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showSuggestionSheet(context, card),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: catColor.withValues(alpha: 0.1),
                    foregroundColor: catColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: const Text(
                    'اقترح تعديلاً على الفكرة',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddCardButton() {
    return GestureDetector(
      onTap: () => _showCategoryPicker(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.5),
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'إضافة بطاقة جديدة',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker() {
    final categories = ['شخصية', 'حبكة', 'مشهد', 'حوار', 'عالم', 'ملاحظة'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'اختر نوع البطاقة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final catColor = _getCategoryColor(cat);
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: catColor.withValues(alpha: 0.1),
                      radius: 16,
                      child: Icon(
                        Icons.label_important_rounded,
                        color: catColor,
                        size: 16,
                      ),
                    ),
                    title: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addCard(cat);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    if (cat.contains('شخصية')) return const Color(0xFF00BCD4);
    if (cat.contains('حبكة')) return const Color(0xFFFF5252);
    if (cat.contains('عالم')) return const Color(0xFF4CAF50);
    if (cat.contains('حوار')) return const Color(0xFFFF9800);
    if (cat.contains('ملاحظة')) return const Color(0xFF9C27B0);
    return const Color(0xFFFF6B9D); // Default
  }

  void _showSuggestionSheet(BuildContext context, IdeaCardModel card) {
    if (card.content.trim().isEmpty) return;
    NawahSuggestionSheet.show(
      context,
      title: 'اقتراح على الفكرة',
      subtitle: 'اكتب اقتراحك بخصوص هذه الفكرة ليراجعه الكاتب',
    );
  }
}

class IdeaCardModel {
  final String category;
  String content;
  final TextEditingController controller;

  IdeaCardModel({required this.category, this.content = ''})
      : controller = TextEditingController(text: content);
}
