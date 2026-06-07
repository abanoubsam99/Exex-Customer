import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/auth/forget_password/forget_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordBody extends StatelessWidget {
  const ResetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 38.0.w),
      child: Form(
        key: cubit.newPasswordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldBuilder(
              title: 'كلمة المرور الجديدة',
              controller: cubit.passwordController,
              padding: const EdgeInsets.only(bottom: 8),
              isPassword: true,
              validator: (p0) {
                if (p0!.isEmpty) return 'الرجاء ادخال كلمة المرور';
                return null;
              },
            ),
            15.verticalSpace,
            TextFieldBuilder(
              title: 'تأكيد كلمة المرور الجديدة',
              controller: cubit.confirmPasswordController,
              isPassword: true,
              validator: (p0) {
                if (p0 != cubit.passwordController.text) {
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
                if (cubit.newPasswordFormKey.currentState!.validate()) {
                  await cubit.resetPassword();
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
