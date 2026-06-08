import 'package:evex_user/data/models/transaction_model.dart';

/// فلتر تابات سجل المدفوعات.
enum PaymentFilter { all, payments, refunds }

class PaymentHistoryState {
  final bool isLoading;
  final List<TransactionModel> transactions;

  const PaymentHistoryState({
    this.isLoading = false,
    this.transactions = const [],
  });

  // paymentType: 0 = مدفوعات (صرف) / 1 = استردادات (استلام)
  List<TransactionModel> get payments =>
      transactions.where((t) => t.paymentType == 0).toList();

  List<TransactionModel> get refunds =>
      transactions.where((t) => t.paymentType == 1).toList();

  List<TransactionModel> filtered(PaymentFilter filter) {
    switch (filter) {
      case PaymentFilter.payments:
        return payments;
      case PaymentFilter.refunds:
        return refunds;
      case PaymentFilter.all:
        return transactions;
    }
  }

  PaymentHistoryState copyWith({
    bool? isLoading,
    List<TransactionModel>? transactions,
  }) {
    return PaymentHistoryState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
    );
  }
}
