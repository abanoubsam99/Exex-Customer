import 'dart:async';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/auth/reset_password/data/model/forget_password_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repo/forget_password_repo.dart';

class ForgetPasswordController extends GetxController {
  ForgetPasswordRepo forgetPasswordRepo;

  ForgetPasswordController(this.forgetPasswordRepo);

  String code = '';
  var phoneController = TextEditingController();
  var countryCodeController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var newPasswordKormKey = GlobalKey<FormState>();

  ForgetPasswordResponse? forgetPasswordResponse;
  //sendPhone
  forgetPassword() async {
    startLoading();
    var result = await forgetPasswordRepo.forgetPassword(
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text.trim(),
    );
    stopLoading();
    result.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) async {
        forgetPasswordResponse = r;
        ToastManager.showSuccess(r.message ?? '');
        Get.toNamed(
          Routes.forgetPasswordOtpScreen,
          arguments:
              countryCodeController.text.trim() +
              phoneController.text.substring(1).trim(),
        );
      },
    );
  }

  RxBool isValid = RxBool(false);

  Future<void> resetPassword() async {
    startLoading();
    var result = await forgetPasswordRepo.resetPassword(
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text.trim(),
      code: code,
      newPassword: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
    stopLoading();
    result.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) {
        ToastManager.showSuccess(r);
        Get.offAllNamed(Routes.loginScreen);
      },
    );
  }
}
