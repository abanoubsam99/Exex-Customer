import 'package:evex_user/data/repos/order_details_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderDetailsRepo _repo;

  OrderDetailsCubit(this._repo) : super(const OrderDetailsState());

  Future<void> getOrderDetails({String? bookingId}) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repo.getOrderDetails(bookingId: bookingId);
    if (result != null) {
      emit(state.copyWith(isLoading: false, order: result));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }
}
