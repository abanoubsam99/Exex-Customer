import 'package:evex_user/core/ui/widgets/top_backround.dart';
import 'package:evex_user/data/cubits/auth/login/login_cubit.dart';
import 'package:evex_user/features/auth/login/ui/widgets/login_body_widget.dart';
import 'package:evex_user/features/auth/login/ui/widgets/login_top_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:upgrader/upgrader.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No nested ScreenUtilInit here: the root one in main.dart (Size(375, 812))
    // governs the whole app. A second ScreenUtilInit with a different design
    // size re-initialised the global singleton, leaving every screen opened
    // afterwards scaled with the wrong design height (squished UI until restart).
    return UpgradeAlert(
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              // Stack(
              //   children: [
              //     Positioned(
              //       top: -52.r,
              //       left: -46.r,
              //       child: CustomCircle(
              //         radius: 107.r,
              //         color: AppColors.greenSoft,
              //       ),
              //     ),
              //     Positioned(
              //       top: -91.h,
              //       left: 146.w,
              //       child: CustomCircle(
              //         radius: 163.r,
              //         color: AppColors.primaryColor,
              //       ),
              //     ),
              //     Positioned(
              //       top: 67.h,
              //       left: 321.w,
              //       child: CustomCircle(
              //         radius: 107.r,
              //         color: AppColors.amber,
              //       ),
              //     ),
              //     BackdropFilter(
              //       filter: ImageFilter.blur(
              //         sigmaX: 141,
              //         sigmaY: 141,
              //         tileMode: TileMode.clamp,
              //       ),
              //       child: Container(
              //         width: 1.sw,
              //         height: 240.h,
              //         decoration: BoxDecoration(
              //           color: AppColors.bgLightGrey.withOpacity(0.5),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              TopBackround(height: 390.h),
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        // color: Colors.red,
                        // height: 200.h,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: LoginTopPart(),
                      ),
                      40.verticalSpace,
                      Container(
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.r),
                              topRight: Radius.circular(40.r),
                            ),
                          ),
                          shadows: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 54,
                              offset: Offset(0, -6),
                              spreadRadius: -30,
                            ),
                          ],
                        ),
                        child: LoginBodyWidget(),
                      ),
                      // ── "تخطي" — browse as guest. Kept inside the scroll
                      // view (right-aligned) so it scrolls with the page
                      // instead of floating above the keyboard when a field is
                      // focused. The user scrolls down to reach it.
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () =>
                              context.read<LoginCubit>().continueAsGuest(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: AppColors.blacksoft,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.r),
                                bottomLeft: Radius.circular(30.r),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back_ios_new_sharp,
                                    color: AppColors.primaryColor, size: 14.r),
                                8.horizontalSpace,
                                Text(
                                  'تخطي',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.r,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      24.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
    );
  }
}
