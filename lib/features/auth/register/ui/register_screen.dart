import 'package:evex_user/core/ui/widgets/top_backround.dart';
import 'package:evex_user/features/auth/register/ui/widgets/register_body_widget.dart';
import 'package:evex_user/features/auth/register/ui/widgets/register_top_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No nested ScreenUtilInit here: the root one in main.dart (Size(375, 812))
    // governs the whole app. A second ScreenUtilInit with a different design
    // size re-initialised the global singleton, leaving every screen opened
    // afterwards scaled with the wrong design height (squished UI until restart).
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Stack(
            children: [
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
                        child: RegisterTopPart(),
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
                        child: RegisterBodyWidget(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
