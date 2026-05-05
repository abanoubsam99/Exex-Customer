// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/MyColors.dart';
import '../constants/app_images.dart';
import '../constants/app_text_styles.dart';
import 'custom_circle.dart';
import 'custom_image_handler.dart';
class TopBackround extends StatelessWidget {
  final double? height;
  const TopBackround({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white, height: 1.sh),
        Positioned(
          top: -52.r,
          left: -46.r,
          child: CustomCircle(radius: 107.r, color: Color(0xFF79E2B2)),
        ),
        Positioned(
          top: -91.h,
          left: 146.w,
          child: CustomCircle(radius: 163.r, color: Color(0xFFF38B4A)),
        ),
        Positioned(
          top: 105.h,
          left: 321.w,
          child: CustomCircle(radius: 107.r, color: Color(0xFFFFBC2B)),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 141,
            sigmaY: 141,
            tileMode: TileMode.clamp,
          ),
          child: Container(
            width: 1.sw,
            height: height ?? 279.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8).withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
