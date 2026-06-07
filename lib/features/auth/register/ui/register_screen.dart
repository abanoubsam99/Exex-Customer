import 'package:evex_user/core/ui/widgets/top_backround.dart';
import 'package:evex_user/features/auth/register/ui/widgets/register_body_widget.dart';
import 'package:evex_user/features/auth/register/ui/widgets/register_top_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 899),
      child: Scaffold(
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
                              color: Color(0x19000000),
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
      ),
    );
  }
}
