import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_images.dart';
import '../../../../../core/ui/widgets/custom_image_handler.dart';
import '../../logic/controller/forget_password_otp_controller.dart';

class ForgetPasswordOtpTopPart extends GetView<ForgetPasswordOtpController> {
  const ForgetPasswordOtpTopPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        74.verticalSpace,
        CustomImageHandler(AppImages.imagesNewLogo, width: 112.w),
        4.verticalSpace,
        Text(
          'تأكيد رقم الهاتف',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w800,
            letterSpacing: -0.24,
          ),
        ),
        16.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تم إرسال كود التحقق على رقم  ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6F767E),
                fontSize: 14.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.24,
              ),
            ),
            Text(
              controller.phone.value,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: const Color(0xFF6F767E),
                fontSize: 14.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.24,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              onPressed: () async {
                Get.back();
              },
              child: Text(
                'تعديل',
                style: TextStyle(
                  color: const Color(0xFFF38B4A),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                  letterSpacing: -0.24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
