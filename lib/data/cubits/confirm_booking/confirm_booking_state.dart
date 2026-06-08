enum BookingPaymentMethod { card, evex, cash }

class ConfirmBookingState {
  final BookingPaymentMethod selectedMethod;
  final bool termsAccepted;
  final num totalAmount;
  final num walletBalance;
  final int remainingSeconds;
  final bool isLoading;
  final bool? success;
  final String? errorMessage;

  const ConfirmBookingState({
    this.selectedMethod = BookingPaymentMethod.evex,
    this.termsAccepted = false,
    this.totalAmount = 0,
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
      walletBalance: walletBalance ?? this.walletBalance,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isLoading: isLoading ?? this.isLoading,
      success: success,
      errorMessage: errorMessage,
    );
  }
}
