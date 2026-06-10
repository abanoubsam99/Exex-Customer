import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/local_auth_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/login_request.dart';
import 'package:evex_user/data/repos/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  final UserService _userService;
  final LocalAuthService _localAuthService;

  LoginCubit(this._loginRepo, this._userService, this._localAuthService)
      : super(LoginInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Logs in using the locally stored credentials after a successful
  /// biometric check. Used by the fingerprint / Face ID button.
  Future<void> loginWithBiometrics() async {
    if (!await _localAuthService.canUseBiometric()) {
      ToastManager.showError('البصمة غير متاحة على هذا الجهاز');
      return;
    }
    final creds = await _localAuthService.getCredentials();
    final email = creds['email'];
    final password = creds['password'];
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      ToastManager.showError('سجّل دخولك مرة أولاً لتفعيل البصمة');
      return;
    }
    final authenticated = await _localAuthService.authenticateWithBiometrics();
    if (!authenticated) return;
    // Reuse the normal login flow with the cached credentials.
    emailController.text = email;
    passwordController.text = password;
    await login();
  }

  Future<void> login() async {
    emit(LoginLoading());
    final user = await _loginRepo.login(
      LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
    if (user != null) {
      await _localAuthService.saveCredentials(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      await _userService.saveUser(user);
      emit(LoginSuccess());
      ToastManager.showSuccess(user.message ?? 'تم تسجيل الدخول بنجاح');
      if (!user.hasPhone) {
        NavigationHelper.pushNamedAndRemoveUntil(Routes.addPhoneScreen);
      } else if (!user.isPhoneVerified) {
        NavigationHelper.pushNamed(Routes.addPhoneOptScreen);
      } else if (!user.isAccountComplete) {
        NavigationHelper.pushNamedAndRemoveUntil(Routes.addClientScreen);
      } else {
        NavigationHelper.pushNamedAndRemoveUntil(Routes.mainScreen);
      }
    } else {
      emit(LoginError('فشل تسجيل الدخول'));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
