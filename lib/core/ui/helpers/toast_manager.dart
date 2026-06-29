import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App-wide messages (success / error). Shown as a banner anchored to the **top**
/// of the screen via the navigator's [Overlay] — SnackBars can only sit at the
/// bottom, which the client didn't want.
class ToastManager {
  ToastManager._();

  // Kept so MaterialApp.scaffoldMessengerKey stays valid (legacy SnackBars).
  static final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<ScaffoldMessengerState> get messengerKey => _messengerKey;

  /// The toast currently on screen (replaced when a new one is shown).
  static OverlayEntry? _current;

  /// When the network layer last surfaced a message that came straight from the
  /// backend. Used so a generic app-side toast fired right after (e.g. a cubit's
  /// "تعذّر ..." fallback) doesn't replace the more specific server message.
  static DateTime? _lastServerMessageAt;
  static const _serverMessageWindow = Duration(milliseconds: 1500);

  static bool get _serverMessageRecent {
    final last = _lastServerMessageAt;
    return last != null &&
        DateTime.now().difference(last) < _serverMessageWindow;
  }

  static void showSuccess(String message) {
    // A backend message just shown for this request wins over a generic one.
    if (_serverMessageRecent) return;
    _showSuccess(message);
  }

  static void showError(String message) {
    if (_serverMessageRecent) return;
    _showError(message);
  }

  /// Shows a message that came directly from the backend (`message` field).
  /// Always shown, and records the time so a generic toast fired right after
  /// for the same request won't override it. Call this from the network layer.
  static void showServerMessage(String message, {bool isError = true}) {
    _lastServerMessageAt = DateTime.now();
    isError ? _showError(message) : _showSuccess(message);
  }

  static void _showSuccess(String message) {
    _show(message, AppColors.greenColor.withValues(alpha: 0.95),
        Icons.check_circle_rounded);
  }

  static void _showError(String message) {
    _show(message, Colors.red.withValues(alpha: 0.95), Icons.error_rounded);
  }

  static void _show(String message, Color color, IconData icon) {
    final overlay = NavigationHelper.navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    // Only one toast at a time — drop the previous one.
    _current?.remove();
    _current = null;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TopToast(
        message: message,
        color: color,
        icon: icon,
        onDismiss: () {
          if (_current == entry) {
            entry.remove();
            _current = null;
          }
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }
}

/// The animated top banner: slides down + fades in, waits, then reverses out.
class _TopToast extends StatefulWidget {
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismiss;

  const _TopToast({
    required this.message,
    required this.color,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _run();
  }

  Future<void> _run() async {
    await _controller.forward();
    if (!mounted) return;
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    await _controller.reverse();
    if (!mounted) return;
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topInset + 8.h,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                if (mounted) widget.onDismiss();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(widget.icon, color: Colors.white, size: 20.r),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
