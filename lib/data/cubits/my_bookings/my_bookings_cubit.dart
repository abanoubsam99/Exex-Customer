import 'package:evex_user/core/helpers/file_download_helper.dart';
import 'package:evex_user/core/helpers/reservation_status_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:evex_user/data/repos/my_bookings_repo.dart';
import 'package:evex_user/data/repos/order_details_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final MyBookingsRepo _repo;
  final ConfirmBookingRepo _confirmRepo;
  final OrderDetailsRepo _orderDetailsRepo;

  MyBookingsCubit(this._repo, this._confirmRepo, this._orderDetailsRepo)
      : super(const MyBookingsState());

  /// بيحمّل التابين مع بعض (الطلبات الحالية + الحجوزات المؤكدة).
  Future<void> load() async {
    await Future.wait([loadRequests(), loadReservations()]);
  }

  Future<void> loadReservations() async {
    emit(state.copyWith(isLoadingReservations: true));
    final list = await _repo.getMyReservations();
    if (list != null) {
      final cancelled = list
          .where((r) => ReservationStatusHelper.isCancelled(r.reservationStatus))
          .toList();
      final active = list
          .where((r) => !ReservationStatusHelper.isCancelled(r.reservationStatus))
          .toList();
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
      // Cancelled requests don't belong in the active "current requests" tab.
      final active = list
          .where((r) => !ReservationStatusHelper.isCancelled(r.reservationStatus))
          .toList();
      emit(state.copyWith(isLoadingRequests: false, requests: active));
    } else {
      emit(state.copyWith(isLoadingRequests: false, requestsError: 'حدث خطأ'));
    }
    // The pending-deposit summary footer reflects the current requests.
    await loadPendingDeposit();
  }

  /// Deletes a pending request (after the UI confirms) then refreshes the list.
  Future<void> cancelRequest(int id) async {
    final ok = await _repo.cancelRequest(id);
    if (ok) {
      ToastManager.showSuccess('تم حذف الطلب');
      await loadRequests();
    } else {
      ToastManager.showError('تعذّر حذف الطلب');
    }
  }

  /// Loads the deposit summary for all pending requests (footer in the
  /// requests tab).
  Future<void> loadPendingDeposit() async {
    final summary = await _confirmRepo.calculatePendingDeposit();
    if (summary != null) emit(state.copyWith(pendingDeposit: summary));
  }

  /// Downloads a reservation's PDF (DownloadInfo) and opens it — used by the
  /// download icon on confirmed / cancelled cards.
  Future<void> downloadReservation(int id) async {
    ToastManager.showSuccess('جاري تحميل الملف...');
    final bytes = await _orderDetailsRepo.downloadInfo(id);
    await FileDownloadHelper.openReservationPdf(id: id, bytes: bytes);
  }
}
