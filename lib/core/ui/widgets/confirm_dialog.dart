import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// Reusable confirmation dialog for destructive / cancel actions.
/// Returns `true` when the user confirms, `false` otherwise.
///
/// Usage:
/// ```dart
/// if (await ConfirmDialog.show(context, message: '...')) { /* proceed */ }
/// ```
class ConfirmDialog {
  ConfirmDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String message,
    String title = 'تأكيد',
    String confirmText = 'موافق',
    String cancelText = 'رجوع',
  }) async {
    final result = await showDialog<bool>(
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
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: const BoxDecoration(
                    color: AppColors.redSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.priority_high_rounded,
                    color: Colors.white,
                    size: 24.r,
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
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: confirmText,
                      height: 48.h,
                      backgroundColor: AppColors.redSoft,
                      bordereColor: AppColors.redSoft,
                      onTap: () => Navigator.pop(ctx, true),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: CustomButton(
                      text: cancelText,
                      isfilled: false,
                      height: 48.h,
                      onTap: () => Navigator.pop(ctx, false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }
}
