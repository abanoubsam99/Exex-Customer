import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/net_cost_model.dart';
import 'package:evex_user/data/models/occasion.dart';
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
  /// Returns the payment-gateway URL to open in a WebView, or null on failure.
  Future<String?> confirmClientReservationGateway({
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
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return _extractUrl(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// The gateway response shape isn't pinned down, so we pull the first http(s)
  /// link out of whatever the backend returns (raw string, common url keys, or
  /// a nested object / message).
  String? _extractUrl(dynamic data) {
    bool isLink(Object? v) =>
        v is String && v.trim().toLowerCase().startsWith('http');

    if (isLink(data)) return (data as String).trim();
    if (data is Map) {
      const keys = [
        'url',
        'iframeUrl',
        'iframe_url',
        'paymentUrl',
        'payment_url',
        'redirectUrl',
        'redirect_url',
        'gatewayUrl',
        'link',
        'message',
      ];
      for (final k in keys) {
        if (isLink(data[k])) return (data[k] as String).trim();
      }
      final nested = data['data'] ?? data['result'];
      if (nested != null) return _extractUrl(nested);
    }
    return null;
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

  /// GET /api/Reservations/GetBillDetailsByClient/{id} — loads the current
  /// reservation so the edit screen can echo the full body back on save.
  Future<ReservationUpdateModel?> getReservationBill(
    int id, {
    int? serviceId,
    int? occasionId,
    int? clientId,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.billDetailsByClient}/$id',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ReservationUpdateModel.fromBillJson(
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

  /// GET /api/Reservations/CalculateNetCost/{id} — returns the cost breakdown
  /// (price after discount, net cost, deposit, tax) for a reservation.
  Future<NetCostModel?> calculateNetCost({
    required int id,
    num? totalCost,
    num? additionalCost,
    num? discount,
    num? vat,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.calculateNetCost}/$id',
        query: {
          if (totalCost != null) 'totalCost': totalCost,
          if (additionalCost != null) 'additionalCost': additionalCost,
          if (discount != null) 'discount': discount,
          if (vat != null) 'vat': vat,
        },
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
