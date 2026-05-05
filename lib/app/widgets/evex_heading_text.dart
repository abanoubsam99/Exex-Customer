import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EvexHeadingText extends StatelessWidget {
  final String title;
  final double? fontSize;
  const EvexHeadingText({super.key, required this.title, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: Color(0xFF121212),
        fontSize: fontSize ?? 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
