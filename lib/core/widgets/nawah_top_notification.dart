import 'package:flutter/material.dart';

/// Nawah notification system.
///
/// Features:
/// - Slides in from the right side (RTL: left)
/// - Positioned slightly above center
/// - Square/box design, no border, solid background
/// - Multiple notifications stack below each other
/// - Auto-dismiss after 3 seconds
/// - Smooth slide-in and slide-out animations
class NawahTopNotification {
  NawahTopNotification._();

  static final List<_NotificationEntry> _activeNotifications = [];
  static OverlayEntry? _containerEntry;

  /// Show a notification.
  ///
  /// [isError] = true → red error style (default)
  /// [isError] = false → green success style
  static void show(
    BuildContext context, {
    required String message,
    bool isError = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);

    final entry = _NotificationEntry(message: message, isError: isError);

    _activeNotifications.add(entry);
    _rebuildContainer(overlay);

    // Auto-dismiss
    Future.delayed(duration, () {
      entry.animOut();
      Future.delayed(const Duration(milliseconds: 350), () {
        _activeNotifications.remove(entry);
        if (_activeNotifications.isEmpty) {
          _containerEntry?.remove();
          _containerEntry = null;
        } else {
          _rebuildContainer(overlay);
        }
      });
    });
  }

  static void _rebuildContainer(OverlayState overlay) {
    _containerEntry?.remove();
    _containerEntry = OverlayEntry(
      builder: (_) =>
          _NotificationStack(entries: List.of(_activeNotifications)),
    );
    overlay.insert(_containerEntry!);
  }
}

/// Holds data + animation state for one notification.
class _NotificationEntry {
  final String message;
  final bool isError;
  final ValueNotifier<bool> _visible = ValueNotifier(true);

  _NotificationEntry({required this.message, required this.isError});

  void animOut() => _visible.value = false;
  ValueNotifier<bool> get visible => _visible;
}

/// Renders a vertical stack of notifications.
class _NotificationStack extends StatelessWidget {
  const _NotificationStack({required this.entries});
  final List<_NotificationEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  entries.map((e) => _NotificationCard(entry: e)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single animated notification card.
class _NotificationCard extends StatefulWidget {
  const _NotificationCard({required this.entry});
  final _NotificationEntry entry;

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(1.2, 0), // Slide from right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Listen for dismiss
    widget.entry.visible.addListener(_onVisibilityChanged);
  }

  void _onVisibilityChanged() {
    if (!widget.entry.visible.value) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    widget.entry.visible.removeListener(_onVisibilityChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.entry.isError;

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color:
                    isError ? const Color(0xFFE53935) : const Color(0xFF43A047),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (isError
                            ? const Color(0xFFE53935)
                            : const Color(0xFF43A047))
                        .withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      widget.entry.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isError
                          ? Icons.error_outline_rounded
                          : Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
