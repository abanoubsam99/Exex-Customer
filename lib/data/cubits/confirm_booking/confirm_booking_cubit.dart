import 'dart:async';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'confirm_booking_state.dart';

class ConfirmBookingCubit extends Cubit<ConfirmBookingState> {
  final ConfirmBookingRepo _repo;

  ConfirmBookingCubit(this._repo) : super(const ConfirmBookingState());

  final cardNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  Timer? _timer;

  /// تهيئة الشاشة بالمبلغ + رصيد المحفظة + بدء العدّاد التنازلي.
  void init({
    num totalAmount = 2989.99,
    num walletBalance = 201,
    int countdownSeconds = 15 * 60,
  }) {
    emit(state.copyWith(
      totalAmount: totalAmount,
      walletBalance: walletBalance,
      remainingSeconds: countdownSeconds,
    ));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 0) {
        _timer?.cancel();
        return;
      }
      emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
    });
  }

  void selectMethod(BookingPaymentMethod method) =>
      emit(state.copyWith(selectedMethod: method));

  void toggleTerms(bool value) => emit(state.copyWith(termsAccepted: value));

  void rechargeWallet() {
    // TODO: نقل لشاشة شحن المحفظة لما تتوفر.
    ToastManager.showSuccess('قريباً: شحن المحفظة');
  }

  Future<void> confirmPayment() async {
    if (!state.termsAccepted) {
      ToastManager.showError('برجاء الموافقة على الشروط والسياسات أولاً');
      return;
    }
    emit(state.copyWith(isLoading: true));
    final ok = await _repo.confirmPayment(
      method: state.selectedMethod,
      cardName: cardNameController.text.trim(),
      cardNumber: cardNumberController.text.trim(),
      expiryDate: expiryController.text.trim(),
      cvv: cvvController.text.trim(),
    );
    if (ok) {
      emit(state.copyWith(isLoading: false, success: true));
      ToastManager.showSuccess('تم تأكيد الدفع بنجاح');
      NavigationHelper.pop();
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
      ToastManager.showError('تعذّر تأكيد الدفع، حاول مرة أخرى');
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    cardNameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    return super.close();
  }
}
