import 'package:evex_user/data/models/addition.dart';

/// Request body for POST /api/Reservations/AddClientReservation.
/// Required by the backend: governorate, city and occasionDate.
class AddReservationRequest {
  final int? portId;
  final int? serviceId;
  final int? occasionId;
  final int? nationalId;
  final String? governorate;
  final String? city;

  /// Event date, formatted as yyyy-MM-dd.
  final String? occasionDate;
  final String? userNotes;
  final bool acceptPolicy;
  final List<Addition> additions;

  AddReservationRequest({
    this.portId,
    this.serviceId,
    this.occasionId,
    this.nationalId,
    this.governorate,
    this.city,
    this.occasionDate,
    this.userNotes,
    this.acceptPolicy = true,
    this.additions = const [],
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'occasionDate': occasionDate,
      'governorate': governorate,
      'city': city,
      'serviceId': serviceId,
      'portId': portId,
      'userNotes': userNotes ?? '',
      'AcceptPolicy': acceptPolicy,
      // The API only needs the addition id for each item.
      'additions': additions
          .where((a) => a.additionId != null)
          .map((a) => {'additionId': a.additionId})
          .toList(),
    };
    if (occasionId != null) map['occasionId'] = occasionId;
    if (nationalId != null) map['NationalId'] = nationalId;
    return map;
  }
}

/// Response of AddClientReservation. We read the reservation-request id +
/// deposit from it to pass them to ConfirmClientReservation_2. Parsing is
/// defensive (tries several possible key names).
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
