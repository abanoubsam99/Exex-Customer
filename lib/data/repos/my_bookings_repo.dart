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
