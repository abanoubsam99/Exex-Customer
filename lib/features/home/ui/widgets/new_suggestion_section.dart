import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/helpers/navigation_helper.dart';
import '../../../../core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class NewSuggestionSection extends StatelessWidget {
  const NewSuggestionSection({super.key});

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
              'اقتراح جديد !',
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
              height: 85.h,
              decoration: ShapeDecoration(
                color: AppColors.lightBlue3Alpha33,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: AppColors.lightBlue3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Transform.rotate(
            //   angle: -4.5 * Math.pi / 180,
            //   child: Container(
            //     width: 1.sw,
            //     height: 89.h,
            //     decoration: ShapeDecoration(
            //       color: AppColors.primaryAlpha23,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(16),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 76.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    Text(
                      'اقترح تاجر جديد ..',
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
                      'يمكنك اقتراح تاجر أو مقدم خدمة جديد \nوالحصول على خصم عند الحجز',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color.fromRGBO(102, 129, 175, 1),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.46,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10.r,
              left: 8.r,
              child: Center(
                child: CustomButton(
                  height: 26.h,
                  width: 75.w,
                  borderRadius: 8.r,
                  fontSize: 13.r,
                  backgroundColor: AppColors.lightBlue1,
                  fontColor: AppColors.blueGrey2,
                  bordereColor: AppColors.lightBlue1,
                  text: 'اقترح الآن',
                  onTap: () {
                    // Account action — a guest is prompted to sign in first.
                    if (!AuthGuard.requireLogin(context)) return;
                    NavigationHelper.pushNamed(Routes.newSuggestionScreen);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
