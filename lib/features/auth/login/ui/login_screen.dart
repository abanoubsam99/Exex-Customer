import 'package:evex_user/core/ui/widgets/top_backround.dart';
import 'package:evex_user/features/auth/login/ui/widgets/login_body_widget.dart';
import 'package:evex_user/features/auth/login/ui/widgets/login_top_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 899),
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
              //         color: Color(0xFF79E2B2),
              //       ),
              //     ),
              //     Positioned(
              //       top: -91.h,
              //       left: 146.w,
              //       child: CustomCircle(
              //         radius: 163.r,
              //         color: Color(0xFFF38B4A),
              //       ),
              //     ),
              //     Positioned(
              //       top: 67.h,
              //       left: 321.w,
              //       child: CustomCircle(
              //         radius: 107.r,
              //         color: Color(0xFFFFBC2B),
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
              //           color: const Color(0xFFF8F8F8).withOpacity(0.5),
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
                              color: Color(0x19000000),
                              blurRadius: 54,
                              offset: Offset(0, -6),
                              spreadRadius: -30,
                            ),
                          ],
                        ),
                        child: LoginBodyWidget(),
                      ),
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
