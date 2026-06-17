import 'package:evex_user/data/repos/payment_history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_history_state.dart';

class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  final PaymentHistoryRepo _repo;

  static const int _pageSize = 20;

  PaymentHistoryCubit(this._repo) : super(const PaymentHistoryState());

  /// بيحمّل أول صفحة لكل التابات مع بعض (كل تاب بفلتر الـ operationType بتاعه).
  Future<void> loadAll() async {
    await Future.wait(PaymentFilter.values.map(loadFirstPage));
  }

  /// بيحمّل (أو يعمل refresh لـ) أول صفحة لتاب معيّن.
  Future<void> loadFirstPage(PaymentFilter filter) async {
    emit(state.copyWithTab(
      filter,
      state.tab(filter).copyWith(isLoading: true, error: null),
    ));
    final list = await _repo.getMyFinancialOperations(
      operationType: filter.operationType,
      index: 0,
      size: _pageSize,
    );
    if (list != null) {
      emit(state.copyWithTab(
        filter,
        PaymentTabData(
          items: list,
          nextIndex: 1,
          hasMore: list.length >= _pageSize,
        ),
      ));
    } else {
      emit(state.copyWithTab(
        filter,
        state.tab(filter).copyWith(isLoading: false, error: 'حدث خطأ'),
      ));
    }
  }

  /// بيجيب الصفحة الجاية لتاب معيّن (infinite scroll).
  Future<void> loadMore(PaymentFilter filter) async {
    final current = state.tab(filter);
    if (current.isLoading || current.isLoadingMore || !current.hasMore) return;

    emit(state.copyWithTab(filter, current.copyWith(isLoadingMore: true)));
    final list = await _repo.getMyFinancialOperations(
      operationType: filter.operationType,
      index: current.nextIndex,
      size: _pageSize,
    );
    if (list != null) {
      emit(state.copyWithTab(
        filter,
        current.copyWith(
          isLoadingMore: false,
          items: [...current.items, ...list],
          nextIndex: current.nextIndex + 1,
          hasMore: list.length >= _pageSize,
        ),
      ));
    } else {
      emit(state.copyWithTab(filter, current.copyWith(isLoadingMore: false)));
    }
  }
}
