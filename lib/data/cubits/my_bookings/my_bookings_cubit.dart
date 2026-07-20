import 'package:evex_user/core/helpers/file_download_helper.dart';
import 'package:evex_user/core/helpers/reservation_status_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/reservation_request_model.dart';
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

  static const int _pageSize = 20;

  /// Backend reservation-status filters (sent as the `status` query param).
  static const String _confirmedStatus = 'Confirmed';
  static const String _cancelledStatus = 'Cancelled';

  /// Accumulated raw request pages (re-filtered to active on every emit).
  final List<ReservationRequestModel> _rawRequests = [];
  int _reservationsNextIndex = 0;
  int _cancelledNextIndex = 0;
  int _requestsNextIndex = 0;

  /// بيحمّل التابات مع بعض (الطلبات الحالية + المؤكدة + الملغية).
  Future<void> load() async {
    await Future.wait([loadRequests(), loadReservations(), loadCancelled()]);
  }

  // ── Confirmed reservations (status=Confirmed) ──

  Future<void> loadReservations() async {
    emit(state.copyWith(isLoadingReservations: true));
    final list = await _repo.getMyReservations(
      index: 0,
      size: _pageSize,
      status: _confirmedStatus,
    );
    if (list != null) {
      _reservationsNextIndex = 1;
      emit(state.copyWith(
        isLoadingReservations: false,
        reservations: list,
        reservationsHasMore: list.length >= _pageSize,
      ));
    } else {
      emit(state.copyWith(
        isLoadingReservations: false,
        reservationsError: 'حدث خطأ',
      ));
    }
  }

  /// Appends the next page of confirmed reservations (infinite scroll).
  Future<void> loadMoreReservations() async {
    if (state.isLoadingReservations ||
        state.reservationsLoadingMore ||
        !state.reservationsHasMore) {
      return;
    }
    emit(state.copyWith(reservationsLoadingMore: true));
    final list = await _repo.getMyReservations(
      index: _reservationsNextIndex,
      size: _pageSize,
      status: _confirmedStatus,
    );
    if (list != null) {
      _reservationsNextIndex += 1;
      emit(state.copyWith(
        reservationsLoadingMore: false,
        reservations: [...state.reservations, ...list],
        reservationsHasMore: list.length >= _pageSize,
      ));
    } else {
      emit(state.copyWith(reservationsLoadingMore: false));
    }
  }

  // ── Cancelled reservations (status=Cancelled) ──

  Future<void> loadCancelled() async {
    emit(state.copyWith(isLoadingCancelled: true));
    final list = await _repo.getMyReservations(
      index: 0,
      size: _pageSize,
      status: _cancelledStatus,
    );
    if (list != null) {
      _cancelledNextIndex = 1;
      emit(state.copyWith(
        isLoadingCancelled: false,
        cancelled: list,
        cancelledHasMore: list.length >= _pageSize,
      ));
    } else {
      emit(state.copyWith(
        isLoadingCancelled: false,
        cancelledError: 'حدث خطأ',
      ));
    }
  }

  /// Appends the next page of cancelled reservations (infinite scroll).
  Future<void> loadMoreCancelled() async {
    if (state.isLoadingCancelled ||
        state.cancelledLoadingMore ||
        !state.cancelledHasMore) {
      return;
    }
    emit(state.copyWith(cancelledLoadingMore: true));
    final list = await _repo.getMyReservations(
      index: _cancelledNextIndex,
      size: _pageSize,
      status: _cancelledStatus,
    );
    if (list != null) {
      _cancelledNextIndex += 1;
      emit(state.copyWith(
        cancelledLoadingMore: false,
        cancelled: [...state.cancelled, ...list],
        cancelledHasMore: list.length >= _pageSize,
      ));
    } else {
      emit(state.copyWith(cancelledLoadingMore: false));
    }
  }

  /// Filters out cancelled requests and emits the active "current requests".
  void _emitRequests({required bool hasMore, bool loadingMore = false}) {
    final active = _rawRequests
        .where((r) => !ReservationStatusHelper.isCancelled(r.reservationStatus))
        .toList();
    emit(state.copyWith(
      isLoadingRequests: false,
      requestsLoadingMore: loadingMore,
      requests: active,
      requestsHasMore: hasMore,
    ));
  }

  Future<void> loadRequests() async {
    emit(state.copyWith(isLoadingRequests: true));
    final list =
        await _repo.getMyRequestReservations(index: 0, size: _pageSize);
    if (list != null) {
      _rawRequests
        ..clear()
        ..addAll(list);
      _requestsNextIndex = 1;
      _emitRequests(hasMore: list.length >= _pageSize);
    } else {
      emit(state.copyWith(isLoadingRequests: false, requestsError: 'حدث خطأ'));
    }
    // The pending-deposit summary footer reflects the current requests.
    await loadPendingDeposit();
  }

  /// Appends the next page of current requests (infinite scroll).
  Future<void> loadMoreRequests() async {
    if (state.isLoadingRequests ||
        state.requestsLoadingMore ||
        !state.requestsHasMore) {
      return;
    }
    emit(state.copyWith(requestsLoadingMore: true));
    final list = await _repo.getMyRequestReservations(
      index: _requestsNextIndex,
      size: _pageSize,
    );
    if (list != null) {
      _rawRequests.addAll(list);
      _requestsNextIndex += 1;
      _emitRequests(hasMore: list.length >= _pageSize, loadingMore: false);
    } else {
      emit(state.copyWith(requestsLoadingMore: false));
    }
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

  /// Marks the vendor's pending message for [id] as read (the client opened it),
  /// then refreshes the requests list so the envelope badge clears.
  Future<void> markMessageAsRead(int id) async {
    final ok = await _repo.markMessageStatusAsRead(id);
    if (ok) await loadRequests();
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
