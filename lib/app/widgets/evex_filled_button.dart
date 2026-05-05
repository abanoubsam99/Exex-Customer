import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/MyColors.dart';
import '../constants/app_images.dart';
import '../constants/app_text_styles.dart';
import 'custom_image_handler.dart';
class EvexFilledButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const EvexFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2C262C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(text, style: AppTextStyles.font16WhiteBoldButton),
      ),
    );
  }
}
