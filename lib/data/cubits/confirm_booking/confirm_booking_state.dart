enum BookingPaymentMethod { card, evex, cash }

/// البيانات الجاية من شاشة استكمال الحجز لتأكيد الحجز (ConfirmClientReservation_2).
class ConfirmBookingArgs {
  final int reservationRequestId;
  final num depositAmount;
  final num totalAmount;

  const ConfirmBookingArgs({
    required this.reservationRequestId,
    this.depositAmount = 0,
    this.totalAmount = 0,
  });
}

class ConfirmBookingState {
  final BookingPaymentMethod selectedMethod;
  final bool termsAccepted;
  final num totalAmount;

  /// المبلغ اللي هيتبعت لـ ConfirmClientReservation_2 (مقدم الحجز).
  final num depositAmount;

  /// رقم طلب الحجز اللي رجع من AddClientReservation.
  final int reservationRequestId;
  final num walletBalance;
  final int remainingSeconds;
  final bool isLoading;
  final bool? success;
  final String? errorMessage;

  const ConfirmBookingState({
    this.selectedMethod = BookingPaymentMethod.evex,
    this.termsAccepted = false,
    this.totalAmount = 0,
    this.depositAmount = 0,
    this.reservationRequestId = 0,
    this.walletBalance = 0,
    this.remainingSeconds = 0,
    this.isLoading = false,
    this.success,
    this.errorMessage,
  });

  String get formattedTime {
    final m = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  ConfirmBookingState copyWith({
    BookingPaymentMethod? selectedMethod,
    bool? termsAccepted,
    num? totalAmount,
    num? depositAmount,
    int? reservationRequestId,
    num? walletBalance,
    int? remainingSeconds,
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return ConfirmBookingState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      totalAmount: totalAmount ?? this.totalAmount,
      depositAmount: depositAmount ?? this.depositAmount,
      reservationRequestId: reservationRequestId ?? this.reservationRequestId,
      walletBalance: walletBalance ?? this.walletBalance,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isLoading: isLoading ?? this.isLoading,
      success: success,
      errorMessage: errorMessage,
    );
  }
}
