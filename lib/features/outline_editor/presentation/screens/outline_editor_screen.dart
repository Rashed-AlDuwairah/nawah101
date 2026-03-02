import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/nawah_suggestion_sheet.dart';

class OutlineNode {
  String id;
  String title;
  String description;
  List<String> tags;
  bool isExpanded;

  OutlineNode({
    required this.id,
    required this.title,
    this.description = '',
    this.tags = const [],
    this.isExpanded = false,
  });
}

class OutlineEditorScreen extends StatefulWidget {
  const OutlineEditorScreen({
    super.key,
    required this.title,
    this.isGuest = false,
  });

  final String title;
  final bool isGuest;

  @override
  State<OutlineEditorScreen> createState() => _OutlineEditorScreenState();
}

class _OutlineEditorScreenState extends State<OutlineEditorScreen> {
  // Mock data for the timeline
  late List<OutlineNode> _nodes;

  final List<String> _availableTags = [
    'نقطة تحول',
    'ذروة الأحداث',
    'الصراع الداخلي',
    'الموقع',
    'الدافع',
    'مشهد حواري'
  ];

  @override
  void initState() {
    super.initState();
    _nodes = [
      OutlineNode(
        id: '1',
        title: 'الفصل الأول: البداية الهادئة',
        description:
            'تقديم شخصية البطل وحياته اليومية الروتينية قبل وصول الرسالة الغامضة.',
        tags: ['الموقع', 'مشهد حواري'],
      ),
      OutlineNode(
        id: '2',
        title: 'نقطة التحول: الرسالة',
        description:
            'وصول طرد غريب يحمل ختيم العائلة القديم الذي اعتقد البطل أنه ضاع للأبد.',
        tags: ['نقطة تحول'],
      ),
      OutlineNode(
        id: '3',
        title: 'الفصل الثاني: الرحلة',
        description: 'البطل يقرر مغادرة قريته للبحث عن مرسل الطرد السري.',
        tags: ['الدافع'],
      ),
    ];
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final node = _nodes.removeAt(oldIndex);
      _nodes.insert(newIndex, node);
    });
  }

  void _addNewNode() {
    setState(() {
      _nodes.add(
        OutlineNode(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'حدث جديد',
          isExpanded: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: widget.isGuest
          ? null
          : FloatingActionButton(
              onPressed: _addNewNode,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.account_tree_rounded,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'مخطط',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.dashboard_customize_rounded,
                    color: AppColors.textHint,
                    size: 24,
                  ),
                ],
              ),
            ),

            // Helpful Banner
            if (!widget.isGuest)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'لإعادة ترتيب الأحداث، اضغط مطولاً على البطاقة ثم قم بسحبها.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Interactive Timeline ──
            Expanded(
              child: ReorderableListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: _nodes.length,
                onReorder: widget.isGuest ? (_, __) {} : _onReorder,
                itemBuilder: (context, index) {
                  final node = _nodes[index];
                  // Using ReorderableDragStartListener wrapped card
                  return _buildTimelineNode(
                    key: ValueKey(node.id),
                    node: node,
                    index: index,
                    isLast: index == _nodes.length - 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineNode({
    required Key key,
    required OutlineNode node,
    required int index,
    required bool isLast,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline Visual ──
          SizedBox(
            width: 30,
            child: Column(
              children: [
                // Circle indicator
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                // Fixed height connecting line to avoid IntrinsicHeight issues
                if (!isLast)
                  Container(
                    width: 2,
                    height: 50, // Fixed height connector instead of Expanded
                    margin: const EdgeInsets.only(top: 8),
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // ── Card Content ──
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  node.isExpanded = !node.isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header showing Title exactly when collapsed
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: node.isExpanded
                              ? TextFormField(
                                  initialValue: node.title,
                                  onChanged: (val) => node.title = val,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'عنوان الحدث...',
                                    hintStyle: TextStyle(
                                      color: AppColors.textHint,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  readOnly: widget.isGuest,
                                )
                              : Text(
                                  node.title.isEmpty ? 'حدث جديد' : node.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          node.isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 8),
                        if (!widget.isGuest)
                          ReorderableDragStartListener(
                            index: index,
                            child: Icon(
                              Icons.drag_handle_rounded,
                              color: AppColors.textHint.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),

                    // Description input (Accordion)
                    if (node.isExpanded) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          // Transparent background to look good in dark/light mode
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.5),
                          ),
                        ),
                        child: TextFormField(
                          initialValue: node.description,
                          onChanged: (val) => node.description = val,
                          maxLines: null, // Auto-expand horizontally
                          minLines: 3,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.6,
                          ),
                          decoration: InputDecoration(
                            hintText: 'تفاصيل أو مسودة المشهد...',
                            hintStyle: TextStyle(
                              color: AppColors.textHint,
                              height: 1.6,
                            ),
                            border: InputBorder.none,
                          ),
                          readOnly: widget.isGuest,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tags row
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...node.tags.map((tag) => _buildTagChip(tag, node)),
                          if (!widget.isGuest) _buildAddTagButton(node),
                        ],
                      ),
                      if (widget.isGuest) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _showSuggestionSheet(context, node),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.edit_note_rounded, size: 18),
                            label: const Text(
                              'اقترح تعديلاً على المخطط',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ] else if (node.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      // Show tags compactly when collapsed
                      Wrap(
                        spacing: 6,
                        children: node.tags
                            .take(3)
                            .map(
                              (t) => const Text(
                                '#\$t',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                            .toList(),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag, OutlineNode node) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          if (!widget.isGuest) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                setState(() {
                  node.tags.remove(tag);
                });
              },
              child: const Icon(
                Icons.close_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddTagButton(OutlineNode node) {
    return GestureDetector(
      onTap: () {
        _showTagSelector(node);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              'وسم',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTagSelector(OutlineNode node) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إضافة وسم للحدث',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _availableTags.map((tag) {
                  final isSelected = node.tags.contains(tag);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          node.tags.remove(tag);
                        } else {
                          node.tags.add(tag);
                        }
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showSuggestionSheet(BuildContext context, OutlineNode node) {
    if (node.title.trim().isEmpty && node.description.trim().isEmpty) return;
    NawahSuggestionSheet.show(
      context,
      title: 'اقتراح على المخطط',
      subtitle: 'اكتب اقتراحك لهذا المخطط ليراجعه الكاتب',
    );
  }
}
