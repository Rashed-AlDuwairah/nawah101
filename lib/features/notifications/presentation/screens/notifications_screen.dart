import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/nawah_top_notification.dart';

/// Notifications Screen (التنبيهات)
///
/// All types: goal, streak, reminders, suggestion accept/reject, system.
/// Read/unread state, mark all as read, iOS-style rejection reason sheet.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<_NotifMock> _notifications;
  final Set<int> _readIndices = {};

  @override
  void initState() {
    super.initState();
    _notifications = [
      _NotifMock(
        type: _NotifType.goalComplete,
        title: 'كفو! بطل اليوم 🎉',
        body: 'وصلت لـ 500 كلمة. كمل إبداعك، لا توقف!',
        time: 'منذ دقيقتين',
        isToday: true,
      ),
      _NotifMock(
        type: _NotifType.editReminder,
        title: 'وحشتنا روايتك',
        body: 'مرت 4 ساعات منذ آخر لقاء بينك وبين "The Silent Echo".',
        time: 'منذ ساعة',
        isToday: true,
      ),
      _NotifMock(
        type: _NotifType.suggestionAccepted,
        title: 'اقتراحك في محلة ✓',
        body: 'راشد اعتمد تعديلك في الفصل الثالث.',
        time: 'منذ 3 ساعات',
        isToday: true,
      ),
      _NotifMock(
        type: _NotifType.suggestionRejected,
        title: 'رأيك يحترم، لكن..',
        body: 'راشد تراجع عن تعديلك في الفصل الخامس.',
        rejectionReason:
            'التعديل ممتاز لغوياً، لكنني أتعمد ترك المشهد غامضاً هنا للمفاجأة التي ستحصل في الفصل التاسع. شكراً لتركيزك العالي!',
        time: 'منذ 5 ساعات',
        isToday: true,
      ),
      _NotifMock(
        type: _NotifType.streak,
        title: '5 أيام وراء بعض 🔥',
        body: 'شعلتك مستمرة، كمل كتابة ولا تكسر السلسلة.',
        time: 'أمس',
        isToday: false,
      ),
      _NotifMock(
        type: _NotifType.newSuggestion,
        title: 'لمسة جديدة على نصك',
        body: 'أحمد ترك لك ملاحظة في الفصل الثاني.',
        time: 'أمس',
        isToday: false,
      ),
      _NotifMock(
        type: _NotifType.projectCreated,
        title: 'بداية قصة جديدة',
        body: 'تم تجهيز مساحة "Letters from Nowhere".',
        time: 'أمس',
        isToday: false,
      ),
      _NotifMock(
        type: _NotifType.ideaReminder,
        title: 'فكرة تنتظر دورها',
        body: 'كتبت فكرة "تطوير شخصية البطل" من أسبوع، هل حان وقتها؟',
        time: 'منذ 3 أيام',
        isToday: false,
      ),
      _NotifMock(
        type: _NotifType.editorAdded,
        title: 'انضميت للفريق 🤝',
        body: 'راشد وثق في قلمك وأضافك كمحرر لمشاريعه.',
        time: 'منذ أسبوع',
        isToday: false,
      ),
      _NotifMock(
        type: _NotifType.system,
        title: 'كل شيء في الحفظ والصون',
        body: 'تم أخذ نسخة سحابية آمنة لكل كتاباتك.',
        time: 'منذ أسبوع',
        isToday: false,
      ),
    ];
  }

  int get _unreadCount => _notifications.length - _readIndices.length;

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _readIndices.add(i);
      }
    });
    NawahTopNotification.show(
      context,
      message: 'الوضع تمام، قرأت كل شيء! ✓',
      isError: false,
    );
  }

  void _markAsRead(int index) {
    if (!_readIndices.contains(index)) {
      setState(() => _readIndices.add(index));
    }
  }

  void _showRejectionReason(BuildContext context, _NotifMock notif) {
    _markAsRead(_notifications.indexOf(notif));
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => _RejectionReasonSheet(
        writerName: 'راشد الدويرة',
        projectName: 'الفصل الخامس',
        reason: notif.rejectionReason!,
        onDismiss: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayNotifs = _notifications.where((n) => n.isToday).toList();
    final olderNotifs = _notifications.where((n) => !n.isToday).toList();

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
                      Icons.notifications_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'التنبيهات',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$_unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    // Mark all as read
                    if (_unreadCount > 0)
                      GestureDetector(
                        onTap: _markAllAsRead,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'تحديد الكل كمقروء',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 20),

              // ── Today ──
              if (todayNotifs.isNotEmpty) ...[
                _buildSectionLabel(
                  'اليوم',
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                const SizedBox(height: 8),
                ...todayNotifs.asMap().entries.map((entry) {
                  final globalIdx = _notifications.indexOf(entry.value);
                  return _buildNotifCard(entry.value, globalIdx)
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: Duration(milliseconds: 150 + entry.key * 80),
                      )
                      .slideY(begin: 0.03, end: 0);
                }),
              ],

              const SizedBox(height: 16),

              // ── Older ──
              if (olderNotifs.isNotEmpty) ...[
                _buildSectionLabel(
                  'سابقاً',
                ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
                const SizedBox(height: 8),
                ...olderNotifs.asMap().entries.map((entry) {
                  final globalIdx = _notifications.indexOf(entry.value);
                  return _buildNotifCard(
                    entry.value,
                    globalIdx,
                  ).animate().fadeIn(
                        duration: 400.ms,
                        delay: Duration(milliseconds: 550 + entry.key * 80),
                      );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNotifCard(_NotifMock notif, int index) {
    final config = _getNotifConfig(notif.type);
    final isRead = _readIndices.contains(index);
    final hasReason = notif.type == _NotifType.suggestionRejected &&
        notif.rejectionReason != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: GestureDetector(
        onTap: () {
          _markAsRead(index);
          if (hasReason) {
            _showRejectionReason(context, notif);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isRead ? AppColors.card.withValues(alpha: 0.7) : AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isRead
                  ? AppColors.border.withValues(alpha: 0.2)
                  : config.color.withValues(alpha: 0.2),
            ),
            boxShadow: isRead
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Unread dot ──
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, left: 4),
                  decoration: BoxDecoration(
                    color: config.color,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 12),

              const SizedBox(width: 8),

              // ── Icon ──
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isRead ? 0.5 : 1.0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: config.color.withValues(alpha: isRead ? 0.05 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(config.icon, color: config.color, size: 20),
                ),
              ),
              const SizedBox(width: 12),

              // ── Content ──
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isRead ? 0.6 : 1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isRead ? FontWeight.w500 : FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        notif.body,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      // ── Tap to view reason hint ──
                      if (hasReason) ...[
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primary,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'اضغط لعرض سبب الرفض',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Time ──
              Text(
                notif.time,
                style: TextStyle(fontSize: 10, color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _NotifConfig _getNotifConfig(_NotifType type) {
    switch (type) {
      case _NotifType.goalComplete:
        return _NotifConfig(
          Icons.emoji_events_rounded,
          const Color(0xFF69F0AE),
        );
      case _NotifType.streak:
        return _NotifConfig(
          Icons.local_fire_department_rounded,
          const Color(0xFFFF6D00),
        );
      case _NotifType.editReminder:
        return _NotifConfig(Icons.schedule_rounded, AppColors.warning);
      case _NotifType.ideaReminder:
        return _NotifConfig(
          Icons.lightbulb_outline_rounded,
          const Color(0xFFFF6B9D),
        );
      case _NotifType.projectCreated:
        return _NotifConfig(Icons.folder_rounded, AppColors.primary);
      case _NotifType.newSuggestion:
        return _NotifConfig(Icons.edit_note_rounded, AppColors.primary);
      case _NotifType.suggestionAccepted:
        return _NotifConfig(
          Icons.check_circle_rounded,
          const Color(0xFF4CAF50),
        );
      case _NotifType.suggestionRejected:
        return _NotifConfig(Icons.cancel_rounded, const Color(0xFFEF5350));
      case _NotifType.editorAdded:
        return _NotifConfig(Icons.person_add_rounded, AppColors.primary);
      case _NotifType.system:
        return _NotifConfig(Icons.cloud_done_rounded, AppColors.textSecondary);
    }
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// iOS-style Rejection Reason Bottom Sheet
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _RejectionReasonSheet extends StatelessWidget {
  const _RejectionReasonSheet({
    required this.writerName,
    required this.projectName,
    required this.reason,
    required this.onDismiss,
  });

  final String writerName;
  final String projectName;
  final String reason;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF5350).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.cancel_rounded,
                      color: Color(0xFFEF5350),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ليش تم الرفض؟',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '$writerName · $projectName',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Divider ──
            Divider(height: 1, color: AppColors.border.withValues(alpha: 0.5)),

            // ── Reason content ──
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          color: AppColors.warning,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'رسالة الكاتب:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reason,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Dismiss button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: GestureDetector(
                onTap: onDismiss,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'حسناً',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
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

// ── Data Models ──

enum _NotifType {
  goalComplete,
  streak,
  editReminder,
  ideaReminder,
  projectCreated,
  newSuggestion,
  suggestionAccepted,
  suggestionRejected,
  editorAdded,
  system,
}

class _NotifMock {
  final _NotifType type;
  final String title;
  final String body;
  final String time;
  final bool isToday;
  final String? rejectionReason;

  _NotifMock({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isToday,
    this.rejectionReason,
  });
}

class _NotifConfig {
  final IconData icon;
  final Color color;
  _NotifConfig(this.icon, this.color);
}
