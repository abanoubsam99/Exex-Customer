import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/reservation_model.dart';
import 'package:evex_user/data/models/reservation_request_model.dart';

class MyBookingsRepo {
  /// GET /api/Reservations/GetMyReservations — الحجوزات المؤكدة.
  Future<List<ReservationModel>?> getMyReservations({
    int index = 0,
    int size = 20,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.myReservations,
        query: {'index': index, 'size': size},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final items = response.data['items'] as List?;
        return items?.map((e) => ReservationModel.fromJson(e)).toList() ?? [];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// PUT /api/Reservations/CancelReservationByClient/{id} — cancels (deletes)
  /// a pending reservation request from the current-requests tab.
  Future<bool> cancelRequest(int id) async {
    try {
      final response = await DioHelper.putData(
        url: '${AppEndpoints.cancelReservation}/$id',
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// GET /api/Reservations/GetMyRequestReservations — الطلبات الحالية.
  Future<List<ReservationRequestModel>?> getMyRequestReservations({
    int index = 0,
    int size = 20,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.myRequestReservations,
        query: {'index': index, 'size': size},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final items = response.data['items'] as List?;
        return items
                ?.map((e) => ReservationRequestModel.fromJson(e))
                .toList() ??
            [];
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
