import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_text_styles.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class EvexFilledButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  /// When true the button shows a spinner and ignores taps,
  /// preventing duplicate API calls.
  final bool isLoading;

  const EvexFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blacksoft,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.blacksoft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(text, style: AppTextStyles.font16WhiteBoldButton),
      ),
    );
  }
}
