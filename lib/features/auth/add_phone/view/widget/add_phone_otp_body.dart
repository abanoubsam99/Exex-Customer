import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/data/cubits/auth/add_phone/add_phone_cubit.dart';
import 'package:evex_user/data/cubits/auth/add_phone/add_phone_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AddPhoneOtpBody extends StatelessWidget {
  const AddPhoneOtpBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddPhoneCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 38.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ادخل الكود',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF2C262C),
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
              length: 4,
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
                borderRadius: BorderRadius.circular(16.r),
                fieldHeight: 54.r,
                fieldWidth: 66.r,
                errorBorderColor: AppColors.redAlertColor,
                errorBorderWidth: 1,
                activeColor: AppColors.blackColor,
                activeFillColor: Colors.white,
                activeBorderWidth: 1,
                selectedColor: AppColors.primaryColor,
                selectedFillColor: Colors.white,
                inactiveFillColor: const Color(0xFFF4F4F4),
                inactiveColor: const Color(0xffE8ECF4),
                inactiveBorderWidth: 1,
              ),
              onChanged: cubit.onOtpChanged,
              beforeTextPaste: (_) => true,
            ),
          ),
          18.verticalSpace,
          Row(
            children: [
              Text(
                'لم يصلنى الكود ؟  ',
                style: TextStyle(
                  color: const Color(0xFF2C262C),
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
                onPressed: cubit.resendCode,
                child: Text(
                  'إعادة الإرسال',
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
          28.verticalSpace,
          BlocBuilder<AddPhoneCubit, AddPhoneState>(
            builder: (context, state) {
              final isValid = state is OtpTimerTick ? state.isValid : false;
              return CustomButton(
                text: 'تأكيد',
                isDisabled: !isValid,
                onTap: cubit.confirmCode,
              );
            },
          ),
        ],
      ),
    );
  }
}
