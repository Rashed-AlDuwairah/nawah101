import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';

/// Screen 7: Review Edits (مراجعة التعديلات)
///
/// Displays suggestions from editors with:
/// - Diff blocks (original → suggested)
/// - Accept / Reject buttons
/// - Reject reason dialog
class ReviewEditsScreen extends StatefulWidget {
  const ReviewEditsScreen({super.key});

  @override
  State<ReviewEditsScreen> createState() => _ReviewEditsScreenState();
}

class _ReviewEditsScreenState extends State<ReviewEditsScreen> {
  final List<_SuggestionMock> _suggestions = [
    _SuggestionMock(
      editorName: 'أحمد محمد',
      chapterTitle: 'الفصل الثالث: ليلة العاصفة',
      originalText: 'كانت الرياح تعصف بشدة في تلك الليلة الباردة',
      suggestedText: 'كانت الرياح تزأر كوحش جريح في تلك الليلة القارسة',
      timeAgo: 'منذ 10 دقائق',
      status: _SuggestionStatus.pending,
    ),
    _SuggestionMock(
      editorName: 'سارة علي',
      chapterTitle: 'الفصل الخامس: الرحيل',
      originalText: 'وقف عند باب البيت ينظر إلى الخلف',
      suggestedText:
          'وقف عند عتبة البيت القديم، يلقي نظرة أخيرة على ما كان يوماً وطناً',
      timeAgo: 'منذ ساعة',
      status: _SuggestionStatus.pending,
    ),
    _SuggestionMock(
      editorName: 'أحمد محمد',
      chapterTitle: 'الفصل الأول: البداية',
      originalText: 'كان الصباح هادئاً',
      suggestedText: 'كان الصباح يتسلل بهدوء من بين ستائر النافذة المغبرّة',
      timeAgo: 'أمس',
      status: _SuggestionStatus.accepted,
    ),
  ];

  void _acceptSuggestion(int index) {
    setState(() {
      _suggestions[index] = _suggestions[index].copyWith(
        status: _SuggestionStatus.accepted,
      );
    });
  }

  void _showRejectDialog(int index) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'سبب الرفض',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: AppColors.danger,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'أخبر المحرر لماذا رفضت اقتراحه',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
                child: TextField(
                  controller: reasonController,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  minLines: 3,
                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'اكتب السبب هنا...',
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _suggestions[index] = _suggestions[index].copyWith(
                            status: _SuggestionStatus.rejected,
                          );
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'رفض الاقتراح',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Stats
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_suggestions.where((s) => s.status == _SuggestionStatus.pending).length} بانتظار المراجعة',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'مراجعة التعديلات',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // ── Suggestions List ──
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _suggestions.length,
                separatorBuilder: (_, i) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildSuggestionCard(_suggestions[index], index)
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: Duration(milliseconds: 100 + index * 100),
                      )
                      .slideY(begin: 0.03, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(_SuggestionMock suggestion, int index) {
    final isPending = suggestion.status == _SuggestionStatus.pending;
    final isAccepted = suggestion.status == _SuggestionStatus.accepted;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPending
              ? AppColors.warning.withValues(alpha: 0.3)
              : isAccepted
                  ? AppColors.success.withValues(alpha: 0.3)
                  : AppColors.danger.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Header ──
          Row(
            children: [
              Text(
                suggestion.timeAgo,
                style: TextStyle(fontSize: 11, color: AppColors.textHint),
              ),
              if (!isPending)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isAccepted
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isAccepted ? 'مقبول ✓' : 'مرفوض ✗',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isAccepted ? AppColors.success : AppColors.danger,
                    ),
                  ),
                ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    suggestion.editorName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    suggestion.chapterTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    suggestion.editorName[0],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Diff Block — Original ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: const Border(
                right: BorderSide(color: AppColors.danger, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'النص الأصلي',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  suggestion.originalText,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary.withValues(alpha: 0.7),
                    decoration: TextDecoration.lineThrough,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),

          // ── Diff Block — Suggested ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: const Border(
                right: BorderSide(color: AppColors.success, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'التعديل المقترح',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  suggestion.suggestedText,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),

          // ── Action Buttons ──
          if (isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showRejectDialog(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'رفض',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.danger,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.close_rounded,
                              color: AppColors.danger,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _acceptSuggestion(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'قبول',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

enum _SuggestionStatus { pending, accepted, rejected }

class _SuggestionMock {
  final String editorName;
  final String chapterTitle;
  final String originalText;
  final String suggestedText;
  final String timeAgo;
  final _SuggestionStatus status;

  _SuggestionMock({
    required this.editorName,
    required this.chapterTitle,
    required this.originalText,
    required this.suggestedText,
    required this.timeAgo,
    required this.status,
  });

  _SuggestionMock copyWith({_SuggestionStatus? status}) {
    return _SuggestionMock(
      editorName: editorName,
      chapterTitle: chapterTitle,
      originalText: originalText,
      suggestedText: suggestedText,
      timeAgo: timeAgo,
      status: status ?? this.status,
    );
  }
}
