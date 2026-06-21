import 'dart:async';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/data/repos/add_phone_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_phone_state.dart';

class AddPhoneCubit extends Cubit<AddPhoneState> {
  final AddPhoneRepo _addPhoneRepo;
  final UserService _userService;

  AddPhoneCubit(this._addPhoneRepo, this._userService)
      : super(AddPhoneInitial());

  final phoneController = TextEditingController();
  final countryCodeController = TextEditingController();
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String _sentPhone = '';
  Timer? _timer;
  int _seconds = 60;
  bool _otpValid = false;

  // ── Send Phone ─────────────────────────────────────────────
  Future<void> addPhone() async {
    emit(AddPhoneLoading());
    final result = await _addPhoneRepo.addPhone(
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text.trim(),
    );
    if (result != null) {
      _sentPhone =
          countryCodeController.text.trim() +
          phoneController.text.substring(1).trim();
      emit(AddPhoneSent(_sentPhone));
      NavigationHelper.pushNamed(Routes.addPhoneOptScreen, arguments: _sentPhone);
    } else {
      emit(AddPhoneError('فشل إرسال رقم الهاتف'));
    }
  }

  // ── OTP Screen ─────────────────────────────────────────────
  void initOtpScreen(String phone) {
    _sentPhone = phone;
    _seconds = 60;
    _otpValid = false;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds > 0) {
        _seconds--;
        emit(OtpTimerTick(seconds: _seconds, isValid: _otpValid));
      } else {
        _timer?.cancel();
      }
    });
  }

  void onOtpChanged(String value) {
    _otpValid = value.length == 4;
    emit(OtpTimerTick(seconds: _seconds, isValid: _otpValid));
  }

  Future<void> resendCode() async {
    _seconds = 60;
    _startTimer();
  }

  Future<void> confirmCode() async {
    emit(OtpConfirmLoading());
    final result = await _addPhoneRepo.confirmPhone(
      code: codeController.text.trim(),
    );
    if (result != null) {
      final user = _userService.currentUser!;
      user.userViewModel?.phoneNumber = _sentPhone;
      // Persist the verified flag so re-opening the app doesn't send the user
      // back to this OTP screen (getInitialRoute checks isPhoneVerified).
      user.userViewModel?.phoneVerified = true;
      await _userService.saveUser(user);
      emit(OtpConfirmSuccess());
      NavigationHelper.pushNamedAndRemoveUntil(Routes.addClientScreen);
    } else {
      emit(OtpConfirmError('فشل تأكيد الكود'));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    phoneController.dispose();
    countryCodeController.dispose();
    codeController.dispose();
    return super.close();
  }
}
