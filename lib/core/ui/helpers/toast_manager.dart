import 'package:evex_user/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ToastManager {
  /// SUCCESS NOTIFICATION
  static showSuccess(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.rawSnackbar(
      message: message.tr,
      barBlur: 5,
      maxWidth: Get.width - 32,
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.greenColor.withOpacity(0.7),
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
    );
  }
  /// ERROR NOTIFICATION
  static showError(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.rawSnackbar(
      message: message,
      barBlur: 5,
      maxWidth: Get.width - 32,
      borderRadius: 10,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.withOpacity(0.7),
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
    );
  }
}
