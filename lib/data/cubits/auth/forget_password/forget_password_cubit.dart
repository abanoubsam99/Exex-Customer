import 'dart:async';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/auth/reset_password/data/repo/forget_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepo _repo;

  ForgetPasswordCubit(this._repo) : super(ForgetPasswordInitial());

  final phoneController = TextEditingController();
  final countryCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final newPasswordFormKey = GlobalKey<FormState>();

  String _otpCode = '';
  Timer? _timer;
  int _seconds = 60;
  bool _otpValid = false;

  // ── Forget Password ───────────────────────────────────────
  Future<void> forgetPassword() async {
    emit(ForgetPasswordLoading());
    final result = await _repo.forgetPassword(
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text.trim(),
    );
    result.fold(
      (error) {
        emit(ForgetPasswordError(error.message));
        ToastManager.showError(error.message);
      },
      (response) {
        final phone =
            countryCodeController.text.trim() +
            phoneController.text.substring(1).trim();
        emit(ForgetPasswordSent(phone));
        ToastManager.showSuccess(response.message ?? '');
        NavigationHelper.pushNamed(
          Routes.forgetPasswordOtpScreen,
          arguments: phone,
        );
      },
    );
  }

  // ── OTP Screen ────────────────────────────────────────────
  void initOtpScreen(String phone) {
    _seconds = 60;
    _otpValid = false;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds > 0) {
        _seconds--;
        emit(OtpForgetTimerTick(seconds: _seconds, isValid: _otpValid));
      } else {
        _timer?.cancel();
      }
    });
  }

  void onOtpChanged(String value) {
    _otpValid = value.length == 4;
    _otpCode = value;
    emit(OtpForgetTimerTick(seconds: _seconds, isValid: _otpValid));
  }

  void confirmOtp() {
    if (_otpValid) {
      NavigationHelper.pushNamed(Routes.resetPasswordScreen);
    }
  }

  // ── Reset Password ────────────────────────────────────────
  Future<void> resetPassword() async {
    emit(ResetPasswordLoading());
    final result = await _repo.resetPassword(
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text.trim(),
      code: _otpCode.isNotEmpty ? _otpCode : codeController.text.trim(),
      newPassword: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
    result.fold(
      (error) {
        emit(ResetPasswordError(error.message));
        ToastManager.showError(error.message);
      },
      (message) {
        emit(ResetPasswordSuccess());
        ToastManager.showSuccess(message);
        NavigationHelper.pushNamedAndRemoveUntil(Routes.loginScreen);
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    phoneController.dispose();
    countryCodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    codeController.dispose();
    return super.close();
  }
}
