import 'package:evex_user/data/models/transaction_model.dart';

class PaymentHistoryState {
  final bool isLoading;
  final List<TransactionModel> transactions;

  const PaymentHistoryState({
    this.isLoading = false,
    this.transactions = const [],
  });

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
