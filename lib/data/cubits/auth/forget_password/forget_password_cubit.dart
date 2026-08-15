import 'dart:async';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/forget_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forget_password_state.dart';

/// Data carried across the forget-password flow screens
/// (forget -> OTP -> reset). Each screen builds its own cubit instance, so the
/// phone / country code / OTP code must be passed forward via navigation args.
class ForgetPasswordArgs {
  final String phoneNumber;
  final String countryCode;
  final String displayPhone;
  final String code;

  const ForgetPasswordArgs({
    required this.phoneNumber,
    required this.countryCode,
    required this.displayPhone,
    this.code = '',
  });
}

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
  String _displayPhone = '';
  Timer? _timer;
  int _seconds = 60;
  bool _otpValid = false;
  bool _resending = false;

  /// Seeds this cubit's fields from the args passed by the previous screen,
  /// so the phone / country code / OTP code survive across the flow.
  void initFromArgs(ForgetPasswordArgs args) {
    phoneController.text = args.phoneNumber;
    countryCodeController.text = args.countryCode;
    _displayPhone = args.displayPhone;
    if (args.code.isNotEmpty) {
      codeController.text = args.code;
      _otpCode = args.code;
      _otpValid = args.code.length == 6;
    }
  }

  // ── Forget Password ───────────────────────────────────────
  Future<void> forgetPassword() async {
    emit(ForgetPasswordLoading());
    final response = await _repo.forgetPassword(
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text.trim(),
    );
    // A 2xx can still be a business failure (`isSuccess: false`); the backend
    // message is already on screen via the interceptor.
    if (response != null && response.isSuccess != false) {
      final phone =
          countryCodeController.text.trim() +
          phoneController.text.substring(1).trim();
      _displayPhone = phone;
      emit(ForgetPasswordSent(phone));
      ToastManager.showSuccess(response.message ?? '');
      NavigationHelper.pushNamed(
        Routes.forgetPasswordOtpScreen,
        arguments: ForgetPasswordArgs(
          phoneNumber: phoneController.text.trim(),
          countryCode: countryCodeController.text.trim(),
          displayPhone: phone,
        ),
      );
    } else {
      emit(ForgetPasswordError('فشل إرسال رمز التحقق'));
      ToastManager.showError('فشل إرسال رمز التحقق، حاول مرة أخرى');
    }
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
        _emitTick();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _emitTick() => emit(
    OtpForgetTimerTick(
      seconds: _seconds,
      isValid: _otpValid,
      isResending: _resending,
    ),
  );

  void onOtpChanged(String value) {
    _otpValid = value.length == 6;
    _otpCode = value;
    _emitTick();
  }

  /// Re-runs ForgetPassword so a fresh code is sent, restarting the countdown
  /// only once the backend confirms it went out.
  Future<void> resendCode() async {
    if (_resending) return;
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ToastManager.showError('رقم الهاتف غير متاح، ارجع وأدخله مرة أخرى');
      return;
    }
    _resending = true;
    _emitTick();

    final response = await _repo.forgetPassword(
      phoneNumber: phone,
      countryCode: countryCodeController.text.trim(),
    );
    _resending = false;

    if (response != null && response.isSuccess != false) {
      _seconds = 60;
      _startTimer();
    } else {
      // Only a fallback — a backend `message` is already shown by the interceptor.
      ToastManager.showError('تعذّر إعادة إرسال الكود، حاول مرة أخرى');
    }
    _emitTick();
  }

  void confirmOtp() {
    if (_otpValid) {
      NavigationHelper.pushNamed(
        Routes.resetPasswordScreen,
        arguments: ForgetPasswordArgs(
          phoneNumber: phoneController.text.trim(),
          countryCode: countryCodeController.text.trim(),
          displayPhone: _displayPhone,
          code: _otpCode,
        ),
      );
    }
  }

  // ── Reset Password ────────────────────────────────────────
  Future<void> resetPassword() async {
    emit(ResetPasswordLoading());
    final message = await _repo.resetPassword(
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text.trim(),
      code: _otpCode.isNotEmpty ? _otpCode : codeController.text.trim(),
      newPassword: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
    if (message != null) {
      emit(ResetPasswordSuccess());
      ToastManager.showSuccess(message);
      NavigationHelper.pushNamedAndRemoveUntil(Routes.loginScreen);
    } else {
      emit(ResetPasswordError('فشل تغيير كلمة المرور'));
      ToastManager.showError('فشل تغيير كلمة المرور، حاول مرة أخرى');
    }
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
