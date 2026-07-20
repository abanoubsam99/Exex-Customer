import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// Dialog showing the vendor's pending message for a reservation request.
/// Read-only: opening it marks the message as read (handled by the caller).
class PendingMessageDialog {
  PendingMessageDialog._();

  static Future<void> show(
    BuildContext context, {
    required String message,
    String title = 'رسالة من مقدم الخدمة',
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.r,
                height: 56.r,
                decoration: const BoxDecoration(
                  color: AppColors.redSoftAlpha1A,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppImages.iconsMessage,
                  width: 26.r,
                  height: 26.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              16.verticalSpace,
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blacksoft,
                  fontSize: 16.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w800,
                ),
              ),
              8.verticalSpace,
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  height: 1.6,
                ),
              ),
              20.verticalSpace,
              CustomButton(
                text: 'تم',
                height: 48.h,
                width: double.infinity,
                backgroundColor: AppColors.primaryColor,
                bordereColor: AppColors.primaryColor,
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
