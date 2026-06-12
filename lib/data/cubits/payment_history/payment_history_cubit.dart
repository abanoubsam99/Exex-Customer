import 'package:evex_user/data/repos/payment_history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_history_state.dart';

class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  final PaymentHistoryRepo _repo;

  PaymentHistoryCubit(this._repo) : super(const PaymentHistoryState());

  Future<void> loadTransactions() async {
    emit(state.copyWith(isLoading: true));
    final list = await _repo.getMyFinancialOperations();
    if (list != null) {
      emit(state.copyWith(isLoading: false, transactions: list));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }
}
