import 'package:evex_user/data/models/addition.dart';

/// Request body لـ POST /api/Reservations/AddClientReservation.
///
/// ⚠️ أسماء الحقول دي مبدئية لحد ما نأكّد الـ curl الرسمي بتاع AddClientReservation
/// من الـ backend — عدّل [toJson] لما يوصل الشكل النهائي.
class AddReservationRequest {
  final int? portId;
  final int? serviceId;
  final List<Addition> additions;
  final String? note;
  final num? totalCost;

  AddReservationRequest({
    this.portId,
    this.serviceId,
    this.additions = const [],
    this.note,
    this.totalCost,
  });

  Map<String, dynamic> toJson() => {
        'portId': portId,
        'serviceId': serviceId,
        'note': note,
        'totalCost': totalCost,
        'additions': additions.map((e) => e.toJson()).toList(),
      };
}

/// Response بتاع AddClientReservation. بنقرأ منه رقم طلب الحجز + المقدم
/// عشان نمرّرهم لـ ConfirmClientReservation_2. القراءة دفاعية (أكتر من اسم
/// محتمل) لحد ما نأكّد الشكل الرسمي.
class AddReservationResult {
  final int? reservationRequestId;
  final num? depositAmount;

  AddReservationResult({this.reservationRequestId, this.depositAmount});

  AddReservationResult.fromJson(dynamic json)
      : reservationRequestId = _readId(json),
        depositAmount = _readDeposit(json);

  static int? _readId(dynamic json) {
    if (json is num) return json.toInt();
    if (json is Map) {
      final value = json['reservationRequestId'] ??
          json['reservationRequestIds'] ??
          json['id'] ??
          json['modelId'];
      if (value is num) return value.toInt();
    }
    return null;
  }

  static num? _readDeposit(dynamic json) {
    if (json is Map) {
      final value = json['depositAmount'] ??
          json['deposit'] ??
          json['pendingDeposit'] ??
          json['depositValue'];
      if (value is num) return value;
    }
    return null;
  }
}
