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

  /// Sets up the screen (deposit + request id + wallet balance) and starts
  /// the countdown.
  void init({
    ConfirmBookingArgs? args,
    num walletBalance = 201,
    int countdownSeconds = 15 * 60,
  }) {
    emit(state.copyWith(
      totalAmount: args?.totalAmount ?? 0,
      depositAmount: args?.depositAmount ?? 0,
      reservationRequestId: args?.reservationRequestId ?? 0,
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
    // TODO: navigate to the wallet top-up screen once it exists.
    ToastManager.showSuccess('قريباً: شحن المحفظة');
  }

  Future<void> confirmPayment() async {
    if (!state.termsAccepted) {
      ToastManager.showError('برجاء الموافقة على الشروط والسياسات أولاً');
      return;
    }
    if (state.reservationRequestId <= 0) {
      ToastManager.showError('رقم طلب الحجز غير صالح');
      return;
    }
    emit(state.copyWith(isLoading: true));
    final ok = await _repo.confirmClientReservation(
      depositAmount: state.depositAmount,
      reservationRequestId: state.reservationRequestId,
    );
    if (ok) {
      emit(state.copyWith(isLoading: false, success: true));
      ToastManager.showSuccess('تم تأكيد الحجز بنجاح');
      NavigationHelper.pop();
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
      ToastManager.showError('تعذّر تأكيد الحجز، حاول مرة أخرى');
    }
  }

  /// Verifies a Paymob card payment once the gateway returns its order id.
  /// TODO: wire [paymobOrderId] from the Paymob checkout result.
  Future<bool> verifyPayment(int paymobOrderId) async {
    emit(state.copyWith(isLoading: true));
    final ok = await _repo.verifyPayment(paymobOrderId);
    emit(state.copyWith(isLoading: false));
    if (ok) {
      ToastManager.showSuccess('تم تأكيد الدفع بنجاح');
    } else {
      ToastManager.showError('تعذّر تأكيد الدفع، حاول مرة أخرى');
    }
    return ok;
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
