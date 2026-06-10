import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/evex_filled_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/auth/login/login_cubit.dart';
import 'package:evex_user/data/cubits/auth/login/login_state.dart';
import 'package:evex_user/features/auth/login/ui/widgets/biometric_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/app_strings.dart';
import 'all_scoial_media_widget.dart';

class LoginBodyWidget extends StatelessWidget {
  const LoginBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
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
              fillColor: const Color(0xFFF4F4F4),
            ),
            16.verticalSpace,
            TextFieldBuilder(
              isPassword: true,
              title: AppStrings.password.tr(),
              hintText: AppStrings.password.tr(),
              controller: cubit.passwordController,
              fillColor: const Color(0xFFF4F4F4),
            ),
            13.verticalSpace,
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.forgetPasswordScreen);
              },
              child: Text(
                AppStrings.forgotPassword.tr(),
                style: TextStyle(
                  color: const Color(0xFFF38B4A),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
            ),
            28.verticalSpace,
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return EvexFilledButton(
                  text: AppStrings.signIn.tr(),
                  isLoading: state is LoginLoading,
                  onPressed: () {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.login();
                    }
                  },
                );
              },
            ),
            // 25.verticalSpace,
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Expanded(child: _Divider()),
            //     Text(
            //       'أو تسجيل سريع بـ',
            //       style: TextStyle(
            //         color: const Color(0xFF6F767E),
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
                  'ليس لدي حساب  ؟ ',
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
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Routes.registerScreen),
                  child: Text(
                    'انشاء حساب',
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
            SizedBox(height: 16.h),
            const BiometricAuthWidget(),
            SizedBox(height: 16.h),
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
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15.r),
      ),
    );
  }
}
