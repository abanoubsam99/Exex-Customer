import 'dart:async';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/payment_gateway_result.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'confirm_booking_state.dart';

class ConfirmBookingCubit extends Cubit<ConfirmBookingState> {
  final ConfirmBookingRepo _repo;

  ConfirmBookingCubit(this._repo) : super(const ConfirmBookingState());

  // Hidden per request — card payment fields (kept for when the gateway is wired).
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
      reservationRequestIds: args?.reservationRequestIds ?? const [],
      walletBalance: walletBalance,
      remainingSeconds: countdownSeconds,
    ));
    _startTimer();
    // _loadNetCost();
  }

  /// The request ids to confirm: the multi-id list when present, otherwise the
  /// single id from the booking-creation journey.
  List<int> _idsToConfirm() {
    if (state.reservationRequestIds.isNotEmpty) {
      return state.reservationRequestIds.where((e) => e > 0).toList();
    }
    return state.reservationRequestId > 0 ? [state.reservationRequestId] : [];
  }

  /// Loads the price shown on the screen from CalculateNetCost — summed across
  /// all the requests being confirmed.
  Future<void> _loadNetCost() async {
    final ids = _idsToConfirm();
    if (ids.isEmpty) return;
    emit(state.copyWith(isLoadingNetCost: true));
    num total = 0;
    for (final id in ids) {
      final netCost = await _repo.calculateNetCost(id: id);
      if (netCost != null) total += netCost.netCost;
    }
    emit(state.copyWith(isLoadingNetCost: false, netCostTotal: total));
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

  // Hidden per request — wallet top-up (kept for later).
  void rechargeWallet() {
    // TODO: navigate to the wallet top-up screen once it exists.
    ToastManager.showSuccess('قريباً: شحن المحفظة');
  }

  /// Card payment: confirms via ConfirmClientReservation and returns the
  /// payment-gateway URL for the caller to open in a WebView. Returns null when
  /// the terms aren't accepted, the ids are invalid, or the request fails.
  Future<PaymentGatewayResult?> confirmCardPayment() async {
    if (!state.termsAccepted) {
      ToastManager.showError('برجاء الموافقة على الشروط والسياسات أولاً');
      return null;
    }
    final ids = _idsToConfirm();
    if (ids.isEmpty) {
      ToastManager.showError('رقم طلب الحجز غير صالح');
      return null;
    }
    emit(state.copyWith(isLoading: true));
    final result = await _repo.confirmClientReservationGateway(
      depositAmount: state.depositAmount,
      reservationRequestIds: ids,
    );
    emit(state.copyWith(isLoading: false));
    if (result == null || result.paymentUrl.isEmpty) {
      ToastManager.showError('تعذّر بدء عملية الدفع، حاول مرة أخرى');
      return null;
    }
    return result;
  }

  Future<void> confirmPayment() async {
    if (!state.termsAccepted) {
      ToastManager.showError('برجاء الموافقة على الشروط والسياسات أولاً');
      return;
    }
    final ids = _idsToConfirm();
    if (ids.isEmpty) {
      ToastManager.showError('رقم طلب الحجز غير صالح');
      return;
    }
    emit(state.copyWith(isLoading: true));
    final ok = await _repo.confirmClientReservation(
      depositAmount: state.depositAmount,
      reservationRequestIds: ids,
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

  // VerifyPayment is called by the PaymentWebViewScreen after the user pays
  // (it has the paymobOrderId), via ConfirmBookingRepo.verifyPayment directly.

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
