import 'package:easy_localization/easy_localization.dart';
import 'package:evex_user/core/localization/app_strings.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/evex_filled_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/auth/register/register_cubit.dart';
import 'package:evex_user/data/cubits/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

// import 'all_scoial_media_widget.dart';

class RegisterBodyWidget extends StatelessWidget {
  const RegisterBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 38.w),
      child: Form(
        key: cubit.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldBuilder(
              title: AppStrings.email.tr(),
              hintText: AppStrings.email.tr(),
              controller: cubit.emailController,
              fillColor: AppColors.boarderFillColor,
            ),
            16.verticalSpace,
            TextFieldBuilder(
              isPassword: true,
              title: AppStrings.password.tr(),
              hintText: AppStrings.password.tr(),
              controller: cubit.passwordController,
              fillColor: AppColors.boarderFillColor,
            ),
            16.verticalSpace,
            TextFieldBuilder(
              isPassword: true,
              title: AppStrings.confirmPassword.tr(),
              controller: cubit.confirmPasswordController,
              validator: (value) {
                if (value != cubit.passwordController.text) {
                  return 'كلمة المرور غير متطابقة';
                }
                return null;
              },
            ),
            28.verticalSpace,
            BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                return EvexFilledButton(
                  text: AppStrings.signUp.tr(),
                  isLoading: state is RegisterLoading,
                  onPressed: () {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.register();
                    }
                  },
                );
              },
            ),
            // 24.verticalSpace,
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Expanded(child: _Divider()),
            //     Text(
            //       'أو تسجيل سريع بـ',
            //       style: TextStyle(
            //         color: AppColors.grey,
            //         fontSize: 14.r,
            //         fontFamily: 'Almarai',
            //         fontWeight: FontWeight.w400,
            //         height: 1.50,
            //       ),
            //     ),
            //     Expanded(child: _Divider()),
            //   ],
            // ),
            // 16.verticalSpace,
            // const AllSocalMediaWidget(),
            24.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'لدي حساب بالفعل ؟  ',
                  style: TextStyle(
                    color: AppColors.grey,
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
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Routes.loginScreen),
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 42.h),
            // Center(
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //       padding: EdgeInsets.zero,
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //       minimumSize: Size.zero,
            //     ),
            //     onPressed: () {},
            //     child: Text(
            //       'تخطي',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         color: Colors.black.withValues(alpha: 0.85),
            //         fontSize: 16.r,
            //         fontFamily: 'Almarai',
            //         fontWeight: FontWeight.w700,
            //         letterSpacing: -0.24,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.dividerGrey,
        borderRadius: BorderRadius.circular(15.r),
      ),
    );
  }
}
