
import 'package:flutter/material.dart';

class SpeechBubbleBorder extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double tailWidth;
  final double tailHeight;
  final double tailPosition; // 0.0 to 1.0, where 0.5 is center
  final double borderRadius;
  final double tailTipRadius; // How rounded the tail tip is (1.0 to 5.0)

  const SpeechBubbleBorder({
    this.borderColor = const Color(0xffF38B4A),
    this.borderWidth = 1.5,
    this.tailWidth = 14.0,
    this.tailHeight = 11.0, // Increased from 8.0 to 12.0
    this.tailPosition = 0.70, // 70% from left (biased right)
    this.borderRadius = 12.0,
    this.tailTipRadius = 1.5, // Default roundness
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _createPath(rect.deflate(borderWidth / 2));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Deflate rect by half border width to prevent clipping
    return _createPath(rect.deflate(borderWidth / 2));
  }

  Path _createPath(Rect rect) {
    final width = rect.width;
    final height = rect.height;
    final left = rect.left;
    final top = rect.top;

    final tailCenter = left + (width * tailPosition);

    // Ensure tailTipRadius doesn't exceed available space
    final safeTailTipRadius = tailTipRadius
        .clamp(0.0, tailHeight / 2)
        .clamp(0.0, tailWidth / 4);

    Path path = Path();

    // Start from top-left corner
    path.moveTo(left + borderRadius, top);

    // Top edge
    path.lineTo(left + width - borderRadius, top);

    // Top-right corner (using arc for better rendering)
    path.arcToPoint(
      Offset(left + width, top + borderRadius),
      radius: Radius.circular(borderRadius),
    );

    // Right edge
    path.lineTo(left + width, top + height - borderRadius);

    // Bottom-right corner (using arc for better rendering)
    path.arcToPoint(
      Offset(left + width - borderRadius, top + height),
      radius: Radius.circular(borderRadius),
    );

    // Bottom edge (right side before tail)
    path.lineTo(tailCenter + tailWidth / 2, top + height);

    // Right side of tail going down - but stop before the tip
    path.lineTo(
      tailCenter + safeTailTipRadius,
      top + height + tailHeight - safeTailTipRadius,
    );

    // Smooth rounded tip
    path.quadraticBezierTo(
      tailCenter,
      top + height + tailHeight - (safeTailTipRadius * 0.25),
      tailCenter - safeTailTipRadius,
      top + height + tailHeight - safeTailTipRadius,
    );

    // Left side of tail going back up
    path.lineTo(tailCenter - tailWidth / 2, top + height);

    // Bottom edge (left side after tail)
    path.lineTo(left + borderRadius, top + height);

    // Bottom-left corner (using arc for better rendering)
    path.arcToPoint(
      Offset(left, top + height - borderRadius),
      radius: Radius.circular(borderRadius),
    );

    // Left edge
    path.lineTo(left, top + borderRadius);

    // Top-left corner (using arc for better rendering)
    path.arcToPoint(
      Offset(left + borderRadius, top),
      radius: Radius.circular(borderRadius),
    );

    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect, textDirection: textDirection);

    // Draw border with centered stroke
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return SpeechBubbleBorder(
      borderColor: borderColor,
      borderWidth: borderWidth * t,
      tailWidth: tailWidth * t,
      tailHeight: tailHeight * t,
      tailPosition: tailPosition,
      borderRadius: borderRadius * t,
      tailTipRadius: tailTipRadius * t,
    );
  }
}