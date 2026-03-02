import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/nawah_suggestion_sheet.dart';

/// Screen 8: Editor Restricted View (واجهة المحرر الخاصة بالضيوف المحررين)
///
/// Features:
/// - READ-ONLY text view (SelectableText).
/// - Custom Context Menu: When text is selected, shows "اقترح تعديل" (Suggest Edit).
/// - Opens a BottomSheet to write the suggestion, which will be sent to the owner.
/// - NO text formatting toolbar, NO typing directly in the editor.
class EditorRestrictedScreen extends StatefulWidget {
  const EditorRestrictedScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<EditorRestrictedScreen> createState() => _EditorRestrictedScreenState();
}

class _EditorRestrictedScreenState extends State<EditorRestrictedScreen> {
  final String _content = '''الفصل الثالث: ليلة العاصفة

كانت الرياح تعصف بشدة في تلك الليلة الباردة، ولم يكن هناك سوى ضوء خافت ينبعث من نافذة الكوخ القديم. جلس بطلنا الصغير أمام الموقد، يتأمل النيران المتراقصة، ويفكر في الرحلة الطويلة التي تنتظره في الصباح.

قرر أن يكتب رسالة وداع، لعل وعسى أن يقرأها أحدهم بعد غيابه. أخذ القلم المكسور وقطعة من الورق البالي، وبدأ يخط كلماته الأخيرة...''';

  String _currentSelectedText = '';

  void _showSuggestionSheet(String selectedText) {
    if (selectedText.trim().isEmpty) return;
    NawahSuggestionSheet.show(
      context,
      title: 'اقتراح تعديل',
      subtitle: 'عدّل النص المظلل واقترحه على الكاتب',
      originalText: selectedText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _currentSelectedText.isNotEmpty
          ? TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              builder: (context, val, child) {
                return Transform.scale(
                  scale: val,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      _showSuggestionSheet(_currentSelectedText);
                    },
                    backgroundColor: AppColors.primary,
                    elevation: 6,
                    icon: const Icon(Icons.auto_awesome,
                        color: Colors.white, size: 20),
                    label: const Text(
                      'اقترح تعديلاً ✨',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  // Back button
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
                  const Spacer(),
                  // Read-Only Badges
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.visibility_rounded,
                          size: 14,
                          color: AppColors.warning,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'وضع المحرر (للقراءة)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Title Area ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'رواية',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Instructions Banner ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'لاقتراح تعديل: قم بتظليل (تحديد) الكلمة أو الجملة المطلوبة من النص، ثم اضغط على الزر العائم "اقترح تعديلاً ✨" الذي سيظهر بالأسفل.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Content Area with Custom Context Menu ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 100,
                ),
                child: SelectableText(
                  _content,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: AppColors.textPrimary.withValues(alpha: 0.9),
                  ),
                  onSelectionChanged: (selection, cause) {
                    if (!selection.isCollapsed &&
                        selection.start >= 0 &&
                        selection.end <= _content.length) {
                      setState(() {
                        _currentSelectedText =
                            _content.substring(selection.start, selection.end);
                      });
                    } else {
                      if (_currentSelectedText.isNotEmpty) {
                        setState(() {
                          _currentSelectedText = '';
                        });
                      }
                    }
                  },
                  contextMenuBuilder: (BuildContext context,
                      EditableTextState editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems = [
                      // Our custom "اقترح تعديل" button
                      ContextMenuButtonItem(
                        label: 'اقترح تعديل ✨',
                        onPressed: () {
                          // Get selected text
                          final value = editableTextState.textEditingValue;
                          final selectedText =
                              value.selection.textInside(value.text);

                          // Hide menu
                          ContextMenuController.removeAny();

                          // Show bottom sheet
                          _showSuggestionSheet(selectedText);
                        },
                      ),

                      // Also provide the native "Copy" action (for user convenience, no cut/paste)
                      ContextMenuButtonItem(
                        label: 'نسخ',
                        onPressed: () {
                          editableTextState
                              .copySelection(SelectionChangedCause.toolbar);
                        },
                      ),
                    ];

                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
