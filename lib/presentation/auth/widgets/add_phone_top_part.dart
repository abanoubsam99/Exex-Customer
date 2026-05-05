import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evexcustomer/app/constants/app_images.dart';
import 'package:evexcustomer/app/widgets/custom_image_handler.dart';

class AddPhoneTopPart extends StatelessWidget {
  const AddPhoneTopPart({super.key});

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
        Text(
          'اكتب رقم الهاتف الخاص بالحساب وسوف نرسل لك\nالرمز التأكيدي',
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
      ],
    );
  }
}

