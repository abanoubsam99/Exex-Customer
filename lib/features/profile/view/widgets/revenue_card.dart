import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class RevenueCard extends StatelessWidget {
  final String title;
  final String amount;
  final String currency;
  final Color backgroundColor;
  final Color titleColor;
  final bool isShadow;

  const RevenueCard({
    super.key,
    required this.title,
    required this.amount,
    this.currency = '',
    required this.backgroundColor,
    required this.titleColor,
    this.isShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.r,
      height: 90.r,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isShadow
            ? [
                const BoxShadow(
                  color: AppColors.blackAlpha1E,
                  blurRadius: 30,
                  offset: Offset(0, 8),
                  spreadRadius: -10,
                )
              ]
            : null,
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Expanded(
            child: Center(
              child: Text(
                overflow: TextOverflow.visible,
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.r,
                  height: 1.2,
                  fontWeight: FontWeight.normal,
                  color: titleColor,
                ),
              ),
            ),
          ),
          12.verticalSpace,
          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: amount,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: currency,
                    style: TextStyle(
                      color: AppColors.blueGrey,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
