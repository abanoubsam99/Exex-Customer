import 'dart:math' as Math;

import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/helpers/navigation_helper.dart';
import '../../../../core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class JoinUsSection extends StatelessWidget {
  const JoinUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 6.r,
              height: 18.r,
              decoration: ShapeDecoration(
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              'انضم الينا !',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        Stack(
          children: [
            Container(
              width: 1.sw,
              height: 95.h,
              decoration: ShapeDecoration(
                color: AppColors.primaryAlpha23,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Transform.rotate(
              angle: -4.5 * Math.pi / 180,
              child: Container(
                width: 1.sw,
                height: 95.h,
                decoration: ShapeDecoration(
                  color: AppColors.primaryAlpha23,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 95.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    Text(
                      'انضم الينا  كتاجر ..',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.blacksoft,
                        fontSize: 14.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.24,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'يمكنك أن تصبح شريكاً حقيقياً للنجاح \n انضم الآن لشبكة evex وتمتع بمميزات حصرية',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.grey2,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.46,
                        letterSpacing: -0.24,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        // Account action — a guest is prompted to sign in first.
                        if (!AuthGuard.requireLogin(context)) return;
                        NavigationHelper.pushNamed(Routes.requestToJoinScreen);
                      },
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            'عرض المزيد',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 13.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                              height: -0.0002,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
