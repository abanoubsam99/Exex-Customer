import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
class BlinkingDot extends StatefulWidget {
  /// Dot colour: green when the service is bookable, red when it isn't.
  final Color color;

  /// Only the "available" dot pulses; the unavailable one stays solid so it
  /// reads as a static warning rather than a live slot.
  final bool blink;

  const BlinkingDot({
    super.key,
    this.color = AppColors.greenSoft,
    this.blink = true,
  });

  @override
  State<BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    if (widget.blink) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant BlinkingDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.blink == oldWidget.blink) return;
    if (widget.blink) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 13.r,
      height: 13.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
    );
    if (!widget.blink) return dot;
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 1.0).animate(_controller),
      child: dot,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}