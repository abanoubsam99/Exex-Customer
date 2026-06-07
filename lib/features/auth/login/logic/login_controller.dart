import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/local_auth_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/auth/login/data/models/login_request.dart';
import 'package:evex_user/features/auth/login/data/repos/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LoginRepo _loginRepo;
  LoginController(this._loginRepo);

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _localAuthService = LocalAuthService();

  Future<void> login() async {
    startLoading();
    final result = await _loginRepo.login(
      LoginRequest(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
    stopLoading();
    result.fold(
      (error) {
        ToastManager.showError(error.message);
      },
      (user) {
        _localAuthService.saveCredentials(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        UserService.to.saveUser(user);
        ToastManager.showSuccess(user.message ?? 'sucssess login');
        if (user.userViewModel?.phoneNumber == null) {
          Get.offAllNamed(Routes.addPhoneScreen);
        } else if (!(user.userViewModel?.phoneVerified ?? true)) {
          Get.toNamed(Routes.addPhoneOptScreen);
        } else {
          if (user.modelId == 0 || user.modelId == null) {
            Get.offAllNamed(Routes.addClientScreen);
          } else {
            Get.offAllNamed(Routes.mainScreen);
          }
        }
      },
    );
  }
}
