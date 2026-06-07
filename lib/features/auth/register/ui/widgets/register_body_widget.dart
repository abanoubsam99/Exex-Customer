import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/evex_filled_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/localization/app_strings.dart';
import '../../logic/register_controller.dart';
import 'all_scoial_media_widget.dart';

class RegisterBodyWidget extends GetView<RegisterController> {
  const RegisterBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 38.w),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldBuilder(
              title: AppStrings.email.tr,
              hintText: AppStrings.email.tr,
              controller: controller.emailController,
              fillColor: Color(0xFFF4F4F4),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'الرجاء إدخال إسم المستخدم';
              //   } else if (!AppRegex.isEmailValid(value)) {
              //     return 'الرجاء إدخال إيميل صحيح';
              //   }
              //   return null;
              // },
            ),

            16.verticalSpace,
            TextFieldBuilder(
              isPassword: true,
              title: AppStrings.password.tr,
              hintText: AppStrings.password.tr,
              controller: controller.passwordController,
              fillColor: Color(0xFFF4F4F4),

              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'الرجاء إدخال كلمة المرور';
              //   } else if (!AppRegex.isPasswordValid(value)) {
              //     return 'الرجاء إدخال كلمة مرور صحيح';
              //   }
              //   return null;
              // },
            ),
            16.verticalSpace,

            TextFieldBuilder(
              isPassword: true,
              title: AppStrings.confirmPassword.tr,
              controller: controller.confirmPasswordController,
              validator: (value) {
                if (value != controller.passwordController.text) {
                  return 'كلمة المرور غير متطابقة';
                }
                return null;
              },
            ),

            28.verticalSpace,
            EvexFilledButton(
              text: AppStrings.signUp.tr,
              onPressed: () async {
                if (controller.formKey.currentState!.validate()) {
                  controller.register();
                }
              },
            ),
            24.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Diva()),
                Text(
                  'أو تسجيل سريع بـ',
                  style: TextStyle(
                    color: const Color(0xFF6F767E),
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                Expanded(child: Diva()),
              ],
            ),

            16.verticalSpace,
            const AllSocalMediaWidget(),
            24.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'لدي حساب بالفعل ؟  ',
                  style: TextStyle(
                    color: const Color(0xFF6F767E),
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size.zero,
                  ),
                  onPressed: () async {
                    Get.offNamed(Routes.loginScreen);
                  },
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      color: const Color(0xFFF38B4A),
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 42.h),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                ),
                onPressed: () async {
                  // Get.toNamed(Routes.singup);
                },
                child: Text(
                  'تخطي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.85),
                    fontSize: 16.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Diva extends StatelessWidget {
  const Diva({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,

      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15.r),
      ),
    );
  }
}
