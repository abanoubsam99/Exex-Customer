import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/order_details_model.dart';

class OrderDetailsRepo {
  /// GET /api/Reservations/GetBillDetailsByClient/{id} — تفاصيل فاتورة الحجز.
  Future<OrderDetailsModel?> getOrderDetails({int? id}) async {
    if (id == null) return null;
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.billDetailsByClient}/$id',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return OrderDetailsModel.fromBillJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Reservations/GetReservationUserNote/{id} — the client's note.
  Future<String?> getReservationUserNote(int id) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.reservationUserNote}/$id',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data['userNotes']?.toString() ?? '';
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST /api/Reservations/EditReservationUserNote — { reservationId, userNotes }
  Future<bool> editReservationUserNote(int reservationId, String userNotes) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.editReservationUserNote,
        data: {'reservationId': reservationId, 'userNotes': userNotes},
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// GET /api/Reservations/DownloadInfo?id={id} — returns the reservation PDF
  /// as raw bytes.
  Future<List<int>?> downloadInfo(int id) async {
    try {
      final response = await DioHelper.dio.get(
        AppEndpoints.downloadInfo,
        queryParameters: {'id': id},
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data as List<int>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// PUT /api/Reservations/CancelReservation/{id} — cancels the reservation.
  Future<bool> cancelReservation(int id) async {
    try {
      final response = await DioHelper.putData(
        url: '${AppEndpoints.cancelReservation}/$id',
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// POST /api/Reviews — submit a review (stars + comment) for a reservation.
  Future<bool> addReview({
    required int reservationId,
    required int portId,
    required int stars,
    required String comment,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.reviews,
        data: {
          'reservationId': reservationId,
          'portId': portId,
          'stars': stars,
          'comment': comment,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        },
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
