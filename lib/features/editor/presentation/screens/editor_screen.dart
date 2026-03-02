import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';

/// Screen 4: Text Editor (محرر الكتابة)
///
/// Distraction-free writing experience with:
/// - Clean toolbar at top
/// - Full-screen text editing area
/// - Word count bar at bottom
/// - Auto-save indicator
class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _textController = TextEditingController(
    text:
        'كانت الرياح تعصف بشدة في تلك الليلة الباردة، والأشجار تتمايل كأنها تودّع شيئاً لن يعود. '
        'وقف حمد عند نافذة غرفته الصغيرة، ينظر إلى السماء التي ملأتها الغيوم الداكنة. '
        'لم يكن يعرف أن هذه الليلة ستغيّر مجرى حياته إلى الأبد.\n\n'
        'تناول كوب القهوة البارد من على الطاولة، وأخذ رشفة طويلة. '
        'كان طعم القهوة مرّاً أكثر من المعتاد، أو ربما كان المرار الذي يشعر به في صدره '
        'هو ما جعل كل شيء يبدو مختلفاً.',
  );

  final _chapterTitleController = TextEditingController(
    text: 'الفصل الثالث: ليلة العاصفة',
  );
  int _wordCount = 0;
  bool _isSaved = true;

  @override
  void initState() {
    super.initState();
    _updateWordCount();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _chapterTitleController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _updateWordCount();
    if (_isSaved) {
      setState(() => _isSaved = false);
    }
    // Auto-save debounce simulation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isSaved) {
        setState(() => _isSaved = true);
      }
    });
  }

  void _updateWordCount() {
    final text = _textController.text.trim();
    setState(() {
      _wordCount = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Toolbar ──
            _buildToolbar().animate().fadeIn(duration: 400.ms),

            const Divider(height: 1, color: Color(0xFFF0F0F0)),

            // ── Chapter Title ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: TextField(
                controller: _chapterTitleController,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'عنوان الفصل...',
                ),
              ),
            ),

            // ── Writing Area ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _textController,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    fontSize: 17,
                    height: 2.0,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ابدأ الكتابة هنا...',
                    hintStyle: TextStyle(color: AppColors.textHint),
                  ),
                ),
              ),
            ),

            // ── Bottom Status Bar ──
            _buildStatusBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Left: formatting tools
          Row(
            children: [
              _buildToolButton(Icons.format_bold_rounded),
              _buildToolButton(Icons.format_italic_rounded),
              _buildToolButton(Icons.format_underlined_rounded),
              Container(
                width: 1,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: AppColors.border,
              ),
              _buildToolButton(Icons.format_list_bulleted_rounded),
            ],
          ),
          const Spacer(),
          // Right: back + project name
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'The Silent Echo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'الفصل ٣ من ١٢',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
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
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          // Save status
          Row(
            children: [
              Icon(
                _isSaved
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_upload_outlined,
                size: 16,
                color: _isSaved ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(width: 4),
              Text(
                _isSaved ? 'تم الحفظ' : 'جارِ الحفظ...',
                style: TextStyle(
                  fontSize: 11,
                  color: _isSaved ? AppColors.success : AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Word count
          Text(
            '$_wordCount كلمة',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
