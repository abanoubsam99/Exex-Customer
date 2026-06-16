import 'package:evex_user/data/models/reservation_model.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:evex_user/data/repos/my_bookings_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final MyBookingsRepo _repo;
  final ConfirmBookingRepo _confirmRepo;

  MyBookingsCubit(this._repo, this._confirmRepo)
      : super(const MyBookingsState());

  /// بيحمّل التابين مع بعض (الطلبات الحالية + الحجوزات المؤكدة).
  Future<void> load() async {
    await Future.wait([loadRequests(), loadReservations()]);
  }

  Future<void> loadReservations() async {
    emit(state.copyWith(isLoadingReservations: true));
    final list = await _repo.getMyReservations();
    if (list != null) {
      bool isCancelled(ReservationModel r) =>
          (r.reservationStatus ?? '').toLowerCase() == 'cancelled';
      final cancelled = list.where(isCancelled).toList();
      final active = list.where((r) => !isCancelled(r)).toList();
      emit(state.copyWith(
        isLoadingReservations: false,
        reservations: active,
        cancelled: cancelled,
      ));
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
    // The pending-deposit summary footer reflects the current requests.
    await loadPendingDeposit();
  }

  /// Loads the deposit summary for all pending requests (footer in the
  /// requests tab).
  Future<void> loadPendingDeposit() async {
    final summary = await _confirmRepo.calculatePendingDeposit();
    if (summary != null) emit(state.copyWith(pendingDeposit: summary));
  }
}
