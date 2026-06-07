import 'package:evex_user/data/models/transaction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_history_state.dart';

class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  PaymentHistoryCubit() : super(const PaymentHistoryState());

  void loadTransactions() {
    // Using local mock data until a real API endpoint is provided
    emit(state.copyWith(transactions: myTransactions));
  }
}
