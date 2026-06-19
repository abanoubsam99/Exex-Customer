import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/evex_filled_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/auth/login/login_cubit.dart';
import 'package:evex_user/data/cubits/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/app_strings.dart';
import 'all_scoial_media_widget.dart';
import 'package:evex_user/core/theme/app_colors.dart';

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
            12.verticalSpace,
            // ── "نسيت كلمة المرور؟" + "ليس لدي حساب؟" on one row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _link(
                  AppStrings.forgotPassword.tr(),
                  () => Navigator.pushNamed(
                      context, Routes.forgetPasswordScreen),
                ),
                _link(
                  'ليس لدي حساب؟',
                  () => Navigator.pushReplacementNamed(
                      context, Routes.registerScreen),
                ),
              ],
            ),
            22.verticalSpace,
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
            24.verticalSpace,
            // ── "أو دخول سريع بـ" divider ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: _Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'أو دخول سريع بـ',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                const Expanded(child: _Divider()),
              ],
            ),
            20.verticalSpace,
            const AllSocalMediaWidget(),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }

  /// An orange text link used for the forgot-password / no-account actions.
  Widget _link(String text, VoidCallback onTap) => TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
      );
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
