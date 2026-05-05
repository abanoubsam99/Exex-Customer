import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionSeperator extends StatelessWidget {
  const SectionSeperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      width: 1.sw,
      height: 11.h,
      decoration: BoxDecoration(color: const Color(0x7FF4F4F4)),
    );
  }
}
