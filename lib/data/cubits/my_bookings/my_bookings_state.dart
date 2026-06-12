import 'package:evex_user/data/models/reservation_model.dart';
import 'package:evex_user/data/models/reservation_request_model.dart';

class MyBookingsState {
  final bool isLoadingReservations;
  final bool isLoadingRequests;
  final List<ReservationModel> reservations;
  final List<ReservationRequestModel> requests;
  final String? reservationsError;
  final String? requestsError;

  const MyBookingsState({
    this.isLoadingReservations = false,
    this.isLoadingRequests = false,
    this.reservations = const [],
    this.requests = const [],
    this.reservationsError,
    this.requestsError,
  });

  MyBookingsState copyWith({
    bool? isLoadingReservations,
    bool? isLoadingRequests,
    List<ReservationModel>? reservations,
    List<ReservationRequestModel>? requests,
    String? reservationsError,
    String? requestsError,
  }) {
    return MyBookingsState(
      isLoadingReservations:
          isLoadingReservations ?? this.isLoadingReservations,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      reservations: reservations ?? this.reservations,
      requests: requests ?? this.requests,
      reservationsError: reservationsError,
      requestsError: requestsError,
    );
  }
}
