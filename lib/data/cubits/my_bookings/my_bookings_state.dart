import 'package:evex_user/data/models/pending_deposit_model.dart';
import 'package:evex_user/data/models/reservation_model.dart';
import 'package:evex_user/data/models/reservation_request_model.dart';

class MyBookingsState {
  final bool isLoadingReservations;
  final bool isLoadingCancelled;
  final bool isLoadingRequests;

  /// Confirmed reservations (fetched with status=Confirmed).
  final List<ReservationModel> reservations;

  /// Cancelled reservations (fetched with status=Cancelled).
  final List<ReservationModel> cancelled;
  final List<ReservationRequestModel> requests;
  final String? reservationsError;
  final String? cancelledError;
  final String? requestsError;

  /// Infinite-scroll flags for the requests tab.
  final bool requestsLoadingMore;
  final bool requestsHasMore;

  /// Infinite-scroll flags for the confirmed-reservations tab.
  final bool reservationsLoadingMore;
  final bool reservationsHasMore;

  /// Infinite-scroll flags for the cancelled-reservations tab.
  final bool cancelledLoadingMore;
  final bool cancelledHasMore;

  /// Deposit summary for all pending requests (CalculatePendingDeposit).
  final PendingDepositModel? pendingDeposit;

  const MyBookingsState({
    this.isLoadingReservations = false,
    this.isLoadingCancelled = false,
    this.isLoadingRequests = false,
    this.reservations = const [],
    this.cancelled = const [],
    this.requests = const [],
    this.reservationsError,
    this.cancelledError,
    this.requestsError,
    this.requestsLoadingMore = false,
    this.requestsHasMore = true,
    this.reservationsLoadingMore = false,
    this.reservationsHasMore = true,
    this.cancelledLoadingMore = false,
    this.cancelledHasMore = true,
    this.pendingDeposit,
  });

  MyBookingsState copyWith({
    bool? isLoadingReservations,
    bool? isLoadingCancelled,
    bool? isLoadingRequests,
    List<ReservationModel>? reservations,
    List<ReservationModel>? cancelled,
    List<ReservationRequestModel>? requests,
    String? reservationsError,
    String? cancelledError,
    String? requestsError,
    bool? requestsLoadingMore,
    bool? requestsHasMore,
    bool? reservationsLoadingMore,
    bool? reservationsHasMore,
    bool? cancelledLoadingMore,
    bool? cancelledHasMore,
    PendingDepositModel? pendingDeposit,
  }) {
    return MyBookingsState(
      isLoadingReservations:
          isLoadingReservations ?? this.isLoadingReservations,
      isLoadingCancelled: isLoadingCancelled ?? this.isLoadingCancelled,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      reservations: reservations ?? this.reservations,
      cancelled: cancelled ?? this.cancelled,
      requests: requests ?? this.requests,
      reservationsError: reservationsError,
      cancelledError: cancelledError,
      requestsError: requestsError,
      requestsLoadingMore: requestsLoadingMore ?? this.requestsLoadingMore,
      requestsHasMore: requestsHasMore ?? this.requestsHasMore,
      reservationsLoadingMore:
          reservationsLoadingMore ?? this.reservationsLoadingMore,
      reservationsHasMore: reservationsHasMore ?? this.reservationsHasMore,
      cancelledLoadingMore: cancelledLoadingMore ?? this.cancelledLoadingMore,
      cancelledHasMore: cancelledHasMore ?? this.cancelledHasMore,
      pendingDeposit: pendingDeposit ?? this.pendingDeposit,
    );
  }
}
