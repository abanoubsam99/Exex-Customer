import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/auth/register/data/repos/register_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final RegisterRepo registerRepo;
  RegisterController(this.registerRepo);

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> register() async {
    startLoading();
    final result = await registerRepo.register(
      email: emailController.text,
      password: passwordController.text,
      confirmpassword: confirmPasswordController.text,
    );
    stopLoading();

    result.fold(
      (error) {
        ToastManager.showError(error.message);
      },
      (message) {
        ToastManager.showSuccess(message);
        Get.offAllNamed(Routes.loginScreen);
      },
    );
  }
}
