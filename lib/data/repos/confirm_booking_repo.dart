import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/general_response.dart';
import 'package:evex_user/data/models/net_cost_model.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/models/payment_gateway_result.dart';
import 'package:evex_user/data/models/pending_deposit_model.dart';
import 'package:evex_user/data/models/port_policy.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/reservation_models.dart';
import 'package:evex_user/data/models/reservation_update_model.dart';

/// Repo بتاع مسار "استكمال الحجز → تأكيد الحجز":
/// جلب سياسات التاجر + إنشاء طلب الحجز + تأكيده.
class ConfirmBookingRepo {
  /// GET /api/Occasions — the occasion types (نوع المناسبة).
  Future<List<Occasion>?> getOccasions() async {
    try {
      final response = await DioHelper.getData(url: AppEndpoints.occasions);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List)
            .map((e) => Occasion.fromJson(e))
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

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
  /// body: { "depositAmount": ..., "reservationRequestIds": [...] }
  /// Confirms one or more pending requests. Returns `true` on success.
  Future<bool> confirmClientReservation({
    required num depositAmount,
    required List<int> reservationRequestIds,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.confirmClientReservation2,
        data: {
          'depositAmount': depositAmount,
          'reservationRequestIds': reservationRequestIds,
        },
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// POST /api/Reservations/ConfirmClientReservation — the card-payment variant.
  /// body: { "depositAmount": ..., "reservationRequestIds": [...] }
  /// Returns the payment-gateway URL + paymobOrderId (needed for VerifyPayment),
  /// or null on failure.
  Future<PaymentGatewayResult?> confirmClientReservationGateway({
    required num depositAmount,
    required List<int> reservationRequestIds,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.confirmClientReservation,
        data: {
          'depositAmount': depositAmount,
          'reservationRequestIds': reservationRequestIds,
        },
        // Mid-flow payment start (navigates straight to the gateway WebView on
        // success) — don't pop a success toast; a business failure still shows.
        options: Options(extra: {'suppressSuccessToast': true}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final result = PaymentGatewayResult.fromJson(response.data);
        if (result != null) return result;
        // 2xx but no gateway URL → the backend couldn't start the payment and
        // usually says why in `message`. Surface it (the onError/isSuccess==false
        // interceptor paths don't fire for this success-shaped failure), so the
        // caller's generic fallback toast can't mask the real reason.
        _surfaceBackendMessage(response.data);
        return null;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Shows the backend `message` from a business-failure body via the shared
  /// server-message channel, so any generic app-side fallback toast fired right
  /// after is suppressed. No-op when the body carries no message.
  void _surfaceBackendMessage(dynamic data) {
    if (data is Map) {
      final msg = data['message'] ?? data['Message'];
      if (msg is String && msg.trim().isNotEmpty) {
        ToastManager.showServerMessage(msg.trim());
      }
    }
  }

  /// GET /api/Reservations/CheckReservationAvailabilityByClient/{portId}?date=
  /// Returns whether the port is available for instant booking on [date].
  /// [governorate]/[city] (the event location) are sent when known so the
  /// backend can flag "غير متاح في هذه المنطقة" for out-of-working-area events.
  Future<CheckReservationResponse?> checkAvailability({
    required int portId,
    required DateTime date,
    String? governorate,
    String? city,
  }) async {
    try {
      final d = DateFormatHelper.apiDate(date, separator: '/');
      final response = await DioHelper.getData(
        url: '${AppEndpoints.checkReservationAvailability}/$portId',
        query: {
          'date': d,
          if ((governorate ?? '').isNotEmpty) 'governorate': governorate,
          if ((city ?? '').isNotEmpty) 'city': city,
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return CheckReservationResponse.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST /api/Reservations/VerifyPayment — verifies a Paymob card payment after
  /// the user finishes paying. Returns the server envelope (its `isSuccess` says
  /// whether the booking was confirmed; HTTP can be 200 even when it failed).
  Future<GeneralResponse?> verifyPayment(int paymobOrderId) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.verifyPayment,
        data: {'paymobOrderId': paymobOrderId},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GeneralResponse.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Reservations/GetReservationsDetailsByClient/{id} — loads the
  /// current reservation so the edit screen can echo the full body back on save
  /// and auto-select the reserved service/additions/occasion. This carries the
  /// serviceId/occasionId/clientId directly (unlike the old bill endpoint), so
  /// the auto-select no longer depends on ids passed from the list item.
  Future<ReservationUpdateModel?> getReservationBill(
    int id, {
    int? serviceId,
    int? occasionId,
    int? clientId,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.reservationsDetailsByClient}/$id',
        // A pending request may not resolve yet → the endpoint can 404. That's
        // expected here (the caller falls back to the list item's data), so
        // don't surface the framework's "Not Found" toast to the user.
        options: Options(extra: {'suppressErrorToast': true}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ReservationUpdateModel.fromDetailsJson(
          response.data,
          serviceId: serviceId,
          occasionId: occasionId,
          clientId: clientId,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Reservations/GetRequestReservation/{id} — loads a **pending
  /// request** (not yet a confirmed reservation) so the edit screen can
  /// auto-select the requested service/additions/occasion and echo the full
  /// body back on save. Confirmed reservations use [getReservationBill] instead.
  Future<ReservationUpdateModel?> getRequestReservation(
    int id, {
    int? serviceId,
    int? occasionId,
    int? clientId,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.requestReservation}/$id',
        options: Options(extra: {'suppressErrorToast': true}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ReservationUpdateModel.fromDetailsJson(
          response.data,
          serviceId: serviceId,
          occasionId: occasionId,
          clientId: clientId,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// PUT /api/Reservations/UpdateReservationRequest/{id} — edit a pending request.
  Future<bool> updateReservationRequest(
    int id,
    ReservationUpdateModel body,
  ) async {
    try {
      final response = await DioHelper.putData(
        url: '${AppEndpoints.updateReservationRequest}/$id',
        data: body.toJson(),
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// PUT /api/Reservations/UpdateReservationByClient/{id} — edit a confirmed
  /// reservation.
  Future<bool> updateReservationByClient(
    int id,
    ReservationUpdateModel body,
  ) async {
    try {
      final response = await DioHelper.putData(
        url: '${AppEndpoints.updateReservationByClient}/$id',
        data: body.toJson(),
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// GET /api/Reservations/Client/CalculateNetCost/{id}
  ///   ?servicePrice=&totalCost=&additionalCost=&buffetCost=
  /// Returns the cost breakdown (price after discount, net cost, deposit, tax)
  /// for a reservation.
  Future<NetCostModel?> calculateNetCost({
    required int id,
    num? servicePrice,
    num? totalCost,
    num? additionalCost,
    num? buffetCost,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.calculateNetCost}/$id',
        query: {
          if (servicePrice != null) 'servicePrice': servicePrice,
          if (totalCost != null) 'totalCost': totalCost,
          if (additionalCost != null) 'additionalCost': additionalCost,
          if (buffetCost != null) 'buffetCost': buffetCost,
        },
        // Best-effort cost breakdown — a failure (e.g. 404 "خطأ فى بيانات الحجز")
        // is handled by the caller, so don't pop its message to the user.
        options: Options(extra: {'suppressErrorToast': true}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return NetCostModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Reservations/CalculatePendingDeposit — the deposit summary for
  /// all of the client's pending reservation requests.
  Future<PendingDepositModel?> calculatePendingDeposit() async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.calculatePendingDeposit,
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return PendingDepositModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
