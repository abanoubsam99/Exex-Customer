import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkelton extends StatelessWidget {
  final double? height, width;
  final BoxShape shape;
  final double? borderRadius;
  const ShimmerSkelton({
    super.key,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });

  const ShimmerSkelton.rectangluar({
    super.key,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });
  const ShimmerSkelton.circular({
    super.key,
    this.height,
    this.width,
    this.shape = BoxShape.circle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      period: Duration(milliseconds: 3000),
      enabled: false,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          // color: Colors.black.withValues(alpha: 0.04),
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          shape: shape,
        ),
      ),
    );
  }
}
