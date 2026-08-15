import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/otp_resend_row.dart';
import 'package:evex_user/data/cubits/auth/forget_password/forget_password_cubit.dart';
import 'package:evex_user/data/cubits/auth/forget_password/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
          Directionality(
            textDirection: TextDirection.ltr,
            child: PinCodeTextField(
              appContext: context,
              autoDisposeControllers: false,
              controller: cubit.codeController,
              length: 6,
              obscureText: false,
              autoFocus: true,
              animationType: AnimationType.scale,
              animationDuration: const Duration(milliseconds: 300),
              keyboardType: TextInputType.number,
              enableActiveFill: true,
              cursorHeight: 20,
              errorTextSpace: 5,
              autovalidateMode: AutovalidateMode.always,
              textStyle: Theme.of(context).textTheme.headlineMedium,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12.r),
                fieldHeight: 54.r,
                fieldWidth: 42.r,
                errorBorderColor: AppColors.redAlertColor,
                errorBorderWidth: 1,
                activeColor: AppColors.blackColor,
                activeFillColor: Colors.white,
                activeBorderWidth: 1,
                selectedColor: AppColors.primaryColor,
                selectedFillColor: Colors.white,
                inactiveFillColor: AppColors.boarderFillColor,
                inactiveColor: AppColors.blueGreyBg,
                inactiveBorderWidth: 1,
              ),
              onChanged: cubit.onOtpChanged,
              beforeTextPaste: (_) => true,
            ),
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
