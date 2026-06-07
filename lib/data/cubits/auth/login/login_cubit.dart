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
      if (user.userViewModel?.phoneNumber == null) {
        NavigationHelper.pushNamedAndRemoveUntil(Routes.addPhoneScreen);
      } else if (!(user.userViewModel?.phoneVerified ?? true)) {
        NavigationHelper.pushNamed(Routes.addPhoneOptScreen);
      } else if (user.modelId == null || user.modelId == 0) {
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
