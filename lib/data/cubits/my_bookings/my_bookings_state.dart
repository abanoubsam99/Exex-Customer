import 'package:evex_user/data/models/pending_deposit_model.dart';
import 'package:evex_user/data/models/reservation_model.dart';
import 'package:evex_user/data/models/reservation_request_model.dart';

class MyBookingsState {
  final bool isLoadingReservations;
  final bool isLoadingRequests;
  final List<ReservationModel> reservations;

  /// Cancelled reservations (reservationStatus == "Cancelled").
  final List<ReservationModel> cancelled;
  final List<ReservationRequestModel> requests;
  final String? reservationsError;
  final String? requestsError;

  /// Infinite-scroll flags for the requests tab.
  final bool requestsLoadingMore;
  final bool requestsHasMore;

  /// Infinite-scroll flags for the reservations source (drives both the
  /// confirmed and the cancelled tabs, which split the same paginated list).
  final bool reservationsLoadingMore;
  final bool reservationsHasMore;

  /// Deposit summary for all pending requests (CalculatePendingDeposit).
  final PendingDepositModel? pendingDeposit;

  const MyBookingsState({
    this.isLoadingReservations = false,
    this.isLoadingRequests = false,
    this.reservations = const [],
    this.cancelled = const [],
    this.requests = const [],
    this.reservationsError,
    this.requestsError,
    this.requestsLoadingMore = false,
    this.requestsHasMore = true,
    this.reservationsLoadingMore = false,
    this.reservationsHasMore = true,
    this.pendingDeposit,
  });

  MyBookingsState copyWith({
    bool? isLoadingReservations,
    bool? isLoadingRequests,
    List<ReservationModel>? reservations,
    List<ReservationModel>? cancelled,
    List<ReservationRequestModel>? requests,
    String? reservationsError,
    String? requestsError,
    bool? requestsLoadingMore,
    bool? requestsHasMore,
    bool? reservationsLoadingMore,
    bool? reservationsHasMore,
    PendingDepositModel? pendingDeposit,
  }) {
    return MyBookingsState(
      isLoadingReservations:
          isLoadingReservations ?? this.isLoadingReservations,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      reservations: reservations ?? this.reservations,
      cancelled: cancelled ?? this.cancelled,
      requests: requests ?? this.requests,
      reservationsError: reservationsError,
      requestsError: requestsError,
      requestsLoadingMore: requestsLoadingMore ?? this.requestsLoadingMore,
      requestsHasMore: requestsHasMore ?? this.requestsHasMore,
      reservationsLoadingMore:
          reservationsLoadingMore ?? this.reservationsLoadingMore,
      reservationsHasMore: reservationsHasMore ?? this.reservationsHasMore,
      pendingDeposit: pendingDeposit ?? this.pendingDeposit,
    );
  }
}
