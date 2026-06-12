import 'package:evex_user/data/repos/my_bookings_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final MyBookingsRepo _repo;

  MyBookingsCubit(this._repo) : super(const MyBookingsState());

  /// بيحمّل التابين مع بعض (الطلبات الحالية + الحجوزات المؤكدة).
  Future<void> load() async {
    await Future.wait([loadRequests(), loadReservations()]);
  }

  Future<void> loadReservations() async {
    emit(state.copyWith(isLoadingReservations: true));
    final list = await _repo.getMyReservations();
    if (list != null) {
      emit(state.copyWith(isLoadingReservations: false, reservations: list));
    } else {
      emit(state.copyWith(
        isLoadingReservations: false,
        reservationsError: 'حدث خطأ',
      ));
    }
  }

  Future<void> loadRequests() async {
    emit(state.copyWith(isLoadingRequests: true));
    final list = await _repo.getMyRequestReservations();
    if (list != null) {
      emit(state.copyWith(isLoadingRequests: false, requests: list));
    } else {
      emit(state.copyWith(isLoadingRequests: false, requestsError: 'حدث خطأ'));
    }
  }
}
