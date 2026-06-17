// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/theme/app_colors.dart';

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
          child: CustomCircle(radius: 107.r, color: AppColors.greenSoft),
        ),
        Positioned(
          top: -91.h,
          left: 146.w,
          child: CustomCircle(radius: 163.r, color: AppColors.primaryColor),
        ),
        Positioned(
          top: 105.h,
          left: 321.w,
          child: CustomCircle(radius: 107.r, color: AppColors.amber),
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
              color: AppColors.bgLightGrey.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
