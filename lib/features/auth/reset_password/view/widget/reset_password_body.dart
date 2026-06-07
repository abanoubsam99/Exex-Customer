import 'package:evex_user/core/localization/app_strings.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../logic/controller/forget_password_controller.dart';

class ResetPasswordBody extends GetView<ForgetPasswordController> {
  const ResetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 38.0.w),
      child: Form(
        key: controller.newPasswordKormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldBuilder(
              title: 'كلمة المرور الجديدة',
              controller: controller.passwordController,
              padding: const EdgeInsets.only(bottom: 8),
              isPassword: true,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return 'الرجاء ادخال كلمة المرور';
                }
                return null;
              },
            ),
            15.verticalSpace,
            TextFieldBuilder(
              title: 'تأكيد كلمة المرور الجديدة',
              controller: controller.confirmPasswordController,
              isPassword: true,
              validator: (p0) {
                if (p0 != controller.passwordController.text) {
                  return 'كلمة المرور غير متطابقة';
                }
                return null;
              },
            ),
            60.verticalSpace,
            CustomButton(
              backgroundColor: AppColors.lightPrimaryColor,
              text: 'حفظ',
              onTap: () async {
                if (controller.newPasswordKormKey.currentState!
                    .validate()) {
                  await controller.resetPassword();
                }
              },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
