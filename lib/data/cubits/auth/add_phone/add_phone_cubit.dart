import 'dart:async';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/add_phone_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_phone_state.dart';

/// What the OTP screen needs from the previous screen: the raw phone + country
/// code (so the code can be re-sent) and the formatted number shown in the
/// header. The OTP screen builds its own cubit, so the text controllers from
/// the add-phone screen are gone by then and this has to travel via the route.
class AddPhoneOtpArgs {
  final String phoneNumber;
  final String countryCode;
  final String displayPhone;

  const AddPhoneOtpArgs({
    required this.phoneNumber,
    required this.countryCode,
    required this.displayPhone,
  });
}

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

  /// The phone as the API wants it — the raw local number and the dial code
  /// kept apart, so "resend" can call AddPhoneNumber again.
  String _rawPhone = '';
  String _countryCode = '';

  Timer? _timer;
  int _seconds = 60;
  bool _otpValid = false;
  bool _resending = false;

  /// The formatted number shown in the OTP screen header.
  String get displayPhone => _sentPhone;

  // ── Send Phone ─────────────────────────────────────────────
  Future<void> addPhone() async {
    emit(AddPhoneLoading());
    final phone = phoneController.text.trim();
    final countryCode = countryCodeController.text.trim();
    final result = await _addPhoneRepo.addPhone(
      phoneNumber: phone,
      countryCode: countryCode,
    );
    if (result != null) {
      _rawPhone = phone;
      _countryCode = countryCode;
      _sentPhone = countryCode + phone.substring(1);
      emit(AddPhoneSent(_sentPhone));
      NavigationHelper.pushNamed(
        Routes.addPhoneOptScreen,
        arguments: AddPhoneOtpArgs(
          phoneNumber: phone,
          countryCode: countryCode,
          displayPhone: _sentPhone,
        ),
      );
    } else {
      emit(AddPhoneError('فشل إرسال رقم الهاتف'));
      ToastManager.showError('تعذّر إرسال رقم الهاتف، حاول مرة أخرى');
    }
  }

  // ── OTP Screen ─────────────────────────────────────────────
  /// [args] is null when the user lands here straight from login with an
  /// unverified phone — in that case the number already on the account is used.
  void initOtpScreen(AddPhoneOtpArgs? args) {
    if (args != null) {
      _rawPhone = args.phoneNumber;
      _countryCode = args.countryCode;
      _sentPhone = args.displayPhone;
    } else {
      final view = _userService.currentUser?.userViewModel;
      _rawPhone = view?.phoneNumber?.trim() ?? '';
      _countryCode = view?.countryCode?.trim() ?? '';
      _sentPhone = _formatPhone(_rawPhone, _countryCode);
    }
    _seconds = 60;
    _otpValid = false;
    _resending = false;
    _startTimer();
  }

  /// Joins the dial code and the local number the way the header displays it
  /// (`+20` + `1284623066`), tolerating a number that already carries its code.
  String _formatPhone(String phone, String countryCode) {
    if (phone.isEmpty || countryCode.isEmpty || phone.startsWith('+')) {
      return phone;
    }
    return countryCode + (phone.startsWith('0') ? phone.substring(1) : phone);
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
    OtpTimerTick(seconds: _seconds, isValid: _otpValid, isResending: _resending),
  );

  void onOtpChanged(String value) {
    _otpValid = value.length == 6;
    _emitTick();
  }

  /// Asks the backend for a fresh code (AddPhoneNumber re-sends the SMS) and
  /// only restarts the countdown once it actually went out.
  Future<void> resendCode() async {
    if (_resending) return;
    if (_rawPhone.isEmpty) {
      ToastManager.showError('رقم الهاتف غير متاح، ارجع وأدخله مرة أخرى');
      return;
    }
    _resending = true;
    _emitTick();

    final result = await _addPhoneRepo.addPhone(
      phoneNumber: _rawPhone,
      countryCode: _countryCode,
    );
    _resending = false;

    if (result != null) {
      _seconds = 60;
      _startTimer();
    } else {
      // Only a fallback — when the backend sends a `message` the interceptor
      // has already shown it, and this one is suppressed.
      ToastManager.showError('تعذّر إعادة إرسال الكود، حاول مرة أخرى');
    }
    _emitTick();
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
      // Suppressed when the backend already explained why (wrong / expired code).
      ToastManager.showError('الكود غير صحيح، تأكد منه وحاول مرة أخرى');
      // Back to the tick state so the confirm button is tappable again.
      _emitTick();
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
