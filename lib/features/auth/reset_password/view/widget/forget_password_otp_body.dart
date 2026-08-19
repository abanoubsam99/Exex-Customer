import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/otp_code_field.dart';
import 'package:evex_user/core/ui/widgets/otp_resend_row.dart';
import 'package:evex_user/data/cubits/auth/forget_password/forget_password_cubit.dart';
import 'package:evex_user/data/cubits/auth/forget_password/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ForgetPasswordOtpBody extends StatelessWidget {
  const ForgetPasswordOtpBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 38.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ادخل الكود',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.blacksoft,
              fontSize: 14.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          24.verticalSpace,
          OtpCodeField(
            controller: cubit.codeController,
            onChanged: cubit.onOtpChanged,
            // Auto-check: the code is submitted the moment the boxes fill up,
            // whether it was typed or autofilled from the SMS.
            onCompleted: (_) => cubit.confirmOtp(),
          ),
          18.verticalSpace,
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            builder: (context, state) {
              final tick = state is OtpForgetTimerTick ? state : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OtpResendRow(
                    isResending: tick?.isResending ?? false,
                    onResend: cubit.resendCode,
                  ),
                  28.verticalSpace,
                  CustomButton(
                    text: 'تأكيد',
                    isDisabled: !(tick?.isValid ?? false),
                    onTap: cubit.confirmOtp,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
