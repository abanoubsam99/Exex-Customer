import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/port_policy.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/reservation_models.dart';

/// Repo بتاع مسار "استكمال الحجز → تأكيد الحجز":
/// جلب سياسات التاجر + إنشاء طلب الحجز + تأكيده.
class ConfirmBookingRepo {
  /// GET /api/Ports/GetPortPolicy/{portId} — سياسات التاجر.
  Future<PortPolicy?> getPortPolicy(int portId) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.portPolicy}/$portId',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return PortPolicy.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST /api/Reservations/AddClientReservation — بينشئ طلب الحجز ويرجّع
  /// رقمه + المقدم عشان نأكّده بعد كده.
  /// TODO: أكّد شكل الـ request/response مع الـ backend (curl) وعدّل
  /// [AddReservationRequest.toJson] / [AddReservationResult.fromJson] لو لزم.
  Future<AddReservationResult?> addClientReservation(
    AddReservationRequest request,
  ) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.addClientReservation,
        data: request.toJson(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return AddReservationResult.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST /api/Reservations/ConfirmClientReservation_2
  /// body: { "depositAmount": ..., "reservationRequestIds": ... }
  /// بيرجّع `true` لو نجح.
  Future<bool> confirmClientReservation({
    required num depositAmount,
    required int reservationRequestId,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.confirmClientReservation2,
        data: {
          'depositAmount': depositAmount,
          'reservationRequestIds': reservationRequestId,
        },
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// GET /api/Reservations/CheckReservationAvailabilityByClient/{portId}?date=
  /// Returns whether the port is available for instant booking on [date].
  Future<CheckReservationResponse?> checkAvailability({
    required int portId,
    required DateTime date,
  }) async {
    try {
      final d = '${date.year}/${date.month}/${date.day}';
      final response = await DioHelper.getData(
        url: '${AppEndpoints.checkReservationAvailability}/$portId',
        query: {'date': d},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return CheckReservationResponse.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST /api/Reservations/VerifyPayment — verifies a Paymob card payment.
  /// body: { "paymobOrderId": ... }
  Future<bool> verifyPayment(int paymobOrderId) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.verifyPayment,
        data: {'paymobOrderId': paymobOrderId},
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
