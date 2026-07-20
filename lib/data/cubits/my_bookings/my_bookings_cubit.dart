import 'package:evex_user/core/helpers/file_download_helper.dart';
import 'package:evex_user/core/helpers/reservation_status_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/reservation_model.dart';
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

  /// Accumulated raw pages (re-split into active/cancelled on every emit).
  final List<ReservationModel> _rawReservations = [];
  final List<ReservationRequestModel> _rawRequests = [];
  int _reservationsNextIndex = 0;
  int _requestsNextIndex = 0;

  /// بيحمّل التابين مع بعض (الطلبات الحالية + الحجوزات المؤكدة).
  Future<void> load() async {
    await Future.wait([loadRequests(), loadReservations()]);
  }

  /// Splits the accumulated reservations into active/cancelled and emits them.
  void _emitReservations({required bool hasMore, bool loadingMore = false}) {
    final cancelled = _rawReservations
        .where((r) => ReservationStatusHelper.isCancelled(r.reservationStatus))
        .toList();
    final active = _rawReservations
        .where((r) => !ReservationStatusHelper.isCancelled(r.reservationStatus))
        .toList();
    emit(state.copyWith(
      isLoadingReservations: false,
      reservationsLoadingMore: loadingMore,
      reservations: active,
      cancelled: cancelled,
      reservationsHasMore: hasMore,
    ));
  }

  Future<void> loadReservations() async {
    emit(state.copyWith(isLoadingReservations: true));
    final list = await _repo.getMyReservations(index: 0, size: _pageSize);
    if (list != null) {
      _rawReservations
        ..clear()
        ..addAll(list);
      _reservationsNextIndex = 1;
      _emitReservations(hasMore: list.length >= _pageSize);
    } else {
      emit(state.copyWith(
        isLoadingReservations: false,
        reservationsError: 'حدث خطأ',
      ));
    }
  }

  /// Appends the next page of reservations (drives both confirmed + cancelled).
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
    );
    if (list != null) {
      _rawReservations.addAll(list);
      _reservationsNextIndex += 1;
      _emitReservations(hasMore: list.length >= _pageSize, loadingMore: false);
    } else {
      emit(state.copyWith(reservationsLoadingMore: false));
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
