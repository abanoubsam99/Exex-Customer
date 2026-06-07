import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/register_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(RegisterInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> register() async {
    emit(RegisterLoading());
    final message = await _registerRepo.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmpassword: confirmPasswordController.text.trim(),
    );
    if (message != null) {
      emit(RegisterSuccess(message));
      ToastManager.showSuccess(message);
      NavigationHelper.pushNamedAndRemoveUntil(Routes.loginScreen);
    } else {
      emit(RegisterError('حدث خطأ، يرجى المحاولة مرة أخرى'));
      ToastManager.showError('حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
