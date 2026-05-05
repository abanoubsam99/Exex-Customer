import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../../app/widgets/custom_button.dart';


class AddPhoneOtpBody extends StatelessWidget  {
  const AddPhoneOtpBody({super.key});

  @override
  Widget build(BuildContext context) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Directionality(
              //   textDirection: TextDirection.ltr,
              //   child: PinCodeTextField(
              //     appContext: context,
              //     autoDisposeControllers: false,
              //     controller: controller.codeController,
              //     length: 4,
              //     obscureText: false,
              //     autoFocus: true,
              //     animationType: AnimationType.scale,
              //     animationDuration: const Duration(milliseconds: 300),
              //     keyboardType: TextInputType.number,
              //     enableActiveFill: true,
              //     cursorHeight: 20,
              //     errorTextSpace: 5,
              //     autovalidateMode: AutovalidateMode.always,
              //     textStyle: Theme.of(context).textTheme.headlineMedium,
              //
              //     pinTheme: PinTheme(
              //       shape: PinCodeFieldShape.box,
              //       borderRadius: BorderRadius.circular(16.r),
              //       fieldHeight: 54.r,
              //       fieldWidth: 66.r,
              //       // Error
              //       errorBorderColor: AppColors.redAlertColor,
              //       errorBorderWidth: 1,
              //       // Active
              //       activeColor: AppColors.blackColor,
              //       activeFillColor: Colors.white,
              //       activeBorderWidth: 1,
              //       // Selected
              //       selectedColor: AppColors.primaryColor,
              //       selectedFillColor: Colors.white,
              //       // Inactive
              //       inactiveFillColor: const Color(0xFFF4F4F4),
              //       inactiveColor: const Color(0xffE8ECF4),
              //       inactiveBorderWidth: 1,
              //     ),
              //     onChanged: (String value) {
              //       if (value.length == 4) {
              //         controller.isValid.value = true;
              //       } else {
              //         controller.isValid.value = false;
              //       }
              //     },
              //     beforeTextPaste: (text) {
              //       return true;
              //     },
              //   ),
              // ),
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
                    onPressed: () async {},
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
              CustomButton(
                text: 'تأكيد',
                // isDisabled: !controller.isValid.value,
                  onTap: () {}
                // onTap: () {
                //   controller.confirmCode();
                // },
              )
            ],
          ),
        ],
      ),
    );
  }

  String formatSeconds(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return ' ($minutes:$remainingSeconds) ';
  }
}
