import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EvexBackButton extends StatelessWidget {
  const EvexBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.r,
      height: 40.r,
      child: IconButton(
        padding: EdgeInsets.zero,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFFD8DADC), width: 1.03.r),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),

        onPressed: () {
          //better than pop to avoid black screen and also work well with WillPopScope
          Navigator.maybePop(context);
        },
        icon: Transform.rotate(
          angle: math.pi,
          child: SvgPicture.asset(
            'assets/icons/chevron-left-solid.svg',
            height: 20.r,
            width: 20.r,
          ),
        ),
      ),
    );
  }
}
