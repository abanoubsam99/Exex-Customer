import 'package:evexcustomer/app/constants/app_images.dart';
import 'package:evexcustomer/app/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BiometricAuthWidget extends StatelessWidget{
  const BiometricAuthWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // controller.biometricLogin();
            },
            child: Column(
              children: [
                const CustomImageHandler(AppImages.iconsLocalAuth),
                Text(
                  'المس مستشعر البصمة',
                  style: TextStyle(
                    color: const Color(0xFF6F767E),
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

