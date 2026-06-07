import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/top_backround.dart';
import 'package:evex_user/features/auth/reset_password/logic/controller/forget_password_controller.dart';
import 'package:evex_user/features/auth/reset_password/logic/controller/forget_password_otp_controller.dart';
import 'package:evex_user/features/auth/reset_password/view/widget/forget_password_otp_body.dart';
import 'package:evex_user/features/auth/reset_password/view/widget/forget_password_otp_top_part.dart';
import 'package:evex_user/features/auth/reset_password/view/widget/obfuscated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/localization/app_strings.dart';

class ForgetPasswordOtpScreen extends GetView<ForgetPasswordOtpController> {
  const ForgetPasswordOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            TopBackround(height: 390.h),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // color: Colors.red,
                      // height: 200.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ForgetPasswordOtpTopPart(),
                    ),
                    24.verticalSpace,
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
                      child: ForgetPasswordOtpBody(),
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
