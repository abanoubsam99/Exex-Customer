import 'package:flutter/material.dart';

/// A single-line text that scrolls horizontally in a continuous loop **only
/// when** its content is wider than the available space. When the text fits,
/// it is rendered as a normal static [Text] with the given [textAlign].
///
/// Direction-aware: in RTL it scrolls so the left-hidden part is revealed, in
/// LTR the right-hidden part. Two copies separated by [gap] make the loop seamless.
class LoopingMarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  /// Scroll speed in logical pixels per second.
  final double velocity;

  /// Empty space between the two repeated copies of the text.
  final double gap;

  const LoopingMarqueeText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.velocity = 30,
    this.gap = 40,
  });

  @override
  State<LoopingMarqueeText> createState() => _LoopingMarqueeTextState();
}

class _LoopingMarqueeTextState extends State<LoopingMarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final textWidth = _measureTextWidth(context);

        // Fits → static text, keep the animation idle.
        if (textWidth <= maxWidth || maxWidth == double.infinity) {
          if (_controller.isAnimating) _controller.stop();
          return Text(
            widget.text,
            maxLines: 1,
            textAlign: widget.textAlign,
            overflow: TextOverflow.ellipsis,
            style: widget.style,
          );
        }

        return _buildMarquee(context, textWidth);
      },
    );
  }

  double _measureTextWidth(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    return painter.width;
  }

  Widget _buildMarquee(BuildContext context, double textWidth) {
    final scrollExtent = textWidth + widget.gap;
    final durationMs =
        (scrollExtent / widget.velocity * 1000).round().clamp(1, 1 << 30);

    // Configure & (re)start the loop after layout to avoid mutating the
    // controller during the build/layout phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_controller.duration?.inMilliseconds != durationMs) {
        _controller.duration = Duration(milliseconds: durationMs);
        _controller
          ..reset()
          ..repeat();
      } else if (!_controller.isAnimating) {
        _controller.repeat();
      }
    });

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    Widget copy() => Text(
          widget.text,
          maxLines: 1,
          softWrap: false,
          style: widget.style,
        );

    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final dx = _controller.value * scrollExtent;
          return Transform.translate(
            offset: Offset(isRtl ? dx : -dx, 0),
            child: child,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            copy(),
            SizedBox(width: widget.gap),
            copy(),
          ],
        ),
      ),
    );
  }
}
