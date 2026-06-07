import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastManager {
  static final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get messengerKey => _messengerKey;

  static void showSuccess(String message) {
    _show(message, AppColors.greenColor.withOpacity(0.85));
  }

  static void showError(String message) {
    _show(message, Colors.red.withOpacity(0.85));
  }

  static void _show(String message, Color color) {
    _messengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
  }
}
