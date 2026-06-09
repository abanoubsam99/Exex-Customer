import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import 'custom_image_handler.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? fontColor;
  final Color? bordereColor;
  final double? fontSize;
  final double? height;
  final double? width;
  final bool isDisabled;

  /// When true the button shows a spinner and ignores taps,
  /// preventing duplicate API calls.
  final bool isLoading;
  final String? icon;
  final bool isfilled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.borderRadius,
    this.backgroundColor = AppColors.blacksoft,
    this.fontColor,
    this.bordereColor = AppColors.blacksoft,
    this.fontSize,
    this.height,
    this.width,
    this.isDisabled = false,
    this.isLoading = false,
    this.icon,
    this.isfilled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Loading also disables the button to block duplicate taps.
    final bool disabled = isDisabled || isLoading;
    return SizedBox(
      height: height ?? 46.h,
      width: width,
      child: isfilled
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: backgroundColor,
                foregroundColor: fontColor,
                overlayColor: AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
                  side: BorderSide(color: bordereColor!, width: 1.5),
                ),
              ),
              onPressed: disabled ? null : onTap,
              child: _buildContent(fontColor ?? Colors.white),
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                // backgroundColor: backgroundColor,
                foregroundColor: AppColors.blacksoft,
                overlayColor: AppColors.blacksoft,
                side: BorderSide(
                  color: bordereColor ?? AppColors.blacksoft,
                  width: 1.5,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
                ),
              ),
              onPressed: disabled ? null : onTap,
              child: _buildContent(fontColor ?? AppColors.blacksoft),
            ),
    );
  }

  /// Shows a spinner while [isLoading], otherwise the label (and optional icon).
  Widget _buildContent(Color contentColor) {
    if (isLoading) {
      return SizedBox(
        width: 22.r,
        height: 22.r,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: contentColor,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: contentColor,
            fontSize: fontSize ?? 16.r,
            fontFamily: 'Almarai',
            height: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (icon != null) ...[
          SizedBox(width: 4.w),
          CustomImageHandler(icon, width: 24),
        ],
      ],
    );
  }
}
