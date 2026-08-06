/// Body for PUT /api/Reservations/UpdateReservationByClient/{id}
/// (and UpdateReservationRequest/{id}).
///
/// The endpoint expects the full reservation object, so we echo back the
/// current reservation (loaded from GetReservationsDetailsByClient) and apply
/// the client's edits (occasionDate + userNotes).
class ReservationUpdateModel {
  final int id;
  final String? reservationKey;

  /// Editable — occasion date (kept in the bill's M/d/yyyy format).
  String occasionDate;
  final String? reservationWay;
  final String? employeName;

  /// Editable — occasion governorate.
  String? governorate;

  /// Editable — occasion city.
  String? city;
  final String? clientName;
  final String? startTime;
  final String? finishTime;
  final String? reservationStatus;
  final String? portName;
  final String? reservationDate;
  final String? reservationRequestDto;
  final int portId;

  /// Editable — the chosen base service (can change when editing a reservation).
  int serviceId;

  /// Service display name from the bill — used to re-select the base service on
  /// the edit screen when the bill doesn't carry a serviceId.
  final String? serviceName;
  final int clientId;

  /// Editable — occasion type.
  int occasionId;
  final num totalCost;
  final num additionalCost;
  final String? additionalCostDetails;
  final num discount;
  final num vat;
  final num netCost;
  final num deposit;
  final int billId;
  final int nationalId;

  /// Editable — client notes.
  String userNotes;

  /// Editable — the desired additions (id/number/additionId). oldAdditions
  /// stays as originally loaded so the backend can diff against it.
  List<Map<String, dynamic>> additions;
  final List<Map<String, dynamic>> oldAdditions;

  ReservationUpdateModel({
    required this.id,
    this.reservationKey,
    this.occasionDate = '',
    this.reservationWay,
    this.employeName,
    this.governorate,
    this.reservationRequestDto,
    this.city,
    this.clientName,
    this.startTime,
    this.finishTime,
    this.reservationStatus,
    this.portName,
    this.reservationDate,
    this.portId = 0,
    this.serviceId = 0,
    this.serviceName,
    this.clientId = 0,
    this.occasionId = 0,
    this.totalCost = 0,
    this.additionalCost = 0,
    this.additionalCostDetails,
    this.discount = 0,
    this.vat = 0,
    this.netCost = 0,
    this.deposit = 0,
    this.billId = 0,
    this.nationalId = 0,
    this.userNotes = '',
    this.additions = const [],
    this.oldAdditions = const [],
  });

  /// Builds the update body from a GetReservationsDetailsByClient response.
  /// Tolerates the older bill shape too (GetBillDetailsByClient), where the
  /// reservation id comes as `reservationId` and `id` is the bill id, and
  /// serviceId/occasionId/clientId are missing (the passed-in values fill any
  /// id the response doesn't carry). Also handles the GetRequestReservation
  /// shape, where the request id is in `id` and `reservationId` is 0.
  factory ReservationUpdateModel.fromDetailsJson(
    Map<String, dynamic> json, {
    int? serviceId,
    int? occasionId,
    int? clientId,
  }) {
    int i(String k) => (json[k] as num?)?.toInt() ?? 0;
    num nu(String k) => (json[k] as num?) ?? 0;
    String? s(String k) => json[k]?.toString();

    // Bill shape: reservationId(>0) + id(=billId). Details/request shape: id.
    // A request carries `reservationId: 0`, so only a positive value is a bill.
    final isBillShape = ((json['reservationId'] as num?)?.toInt() ?? 0) > 0;

    final rawAdds = (json['additions'] ??
            json['reservation_Additions'] ??
            json['reservationAdditions']) as List? ??
        const [];
    return ReservationUpdateModel(
      id: isBillShape ? i('reservationId') : i('id'),
      reservationKey: s('reservationKey'),
      occasionDate: s('occasionDate') ?? '',
      reservationWay: s('reservationWay'),
      employeName: s('employeName'),
      reservationRequestDto: s('reservationRequestDto'),
      governorate: s('governorate'),
      city: s('city'),
      clientName: s('clientName'),
      startTime: s('startTime'),
      finishTime: s('finishTime'),
      reservationStatus: s('reservationStatus'),
      portName: s('portName') ?? (json['port'] is Map ? json['port']['portName']?.toString() : null),
      reservationDate: s('reservationDate'),
      portId: i('portId'),
      serviceId: i('serviceId') > 0 ? i('serviceId') : (serviceId ?? 0),
      serviceName: s('serviceName') ?? (json['service'] is Map ? json['service']['name']?.toString() : null),
      clientId: i('clientId') > 0 ? i('clientId') : (clientId ?? 0),
      occasionId: i('occasionId') > 0 ? i('occasionId') : (occasionId ?? 0),
      totalCost: nu('totalCost'),
      additionalCost: nu('additionalCost'),
      additionalCostDetails: s('additionalCostDetails'),
      discount: nu('discount'),
      vat: nu('vat'),
      netCost: nu('netCost'),
      deposit: nu('deposit'),
      billId: isBillShape ? i('id') : i('billId'),
      nationalId: i('nationalId'),
      userNotes: s('userNotes') ?? s('clientNotes') ?? '',
      additions: rawAdds
          .map<Map<String, dynamic>>((a) => {
                'id': (a['id'] as num?)?.toInt() ?? 0,
                'number': (a['number'] as num?)?.toInt() ?? 0,
                'additionId': (a['additionId'] as num?)?.toInt() ?? 0,
              })
          .toList(),
      oldAdditions: rawAdds
          .map<Map<String, dynamic>>((a) => Map<String, dynamic>.from(a as Map))
          .toList(),
    );
  }

  /// The bill returns reservationDate as a non-ISO US string
  /// ("5/13/2026 2:17:36 AM") which the update endpoint can't parse to
  /// DateTime. Convert to ISO 8601 (or null) before sending.
  static String? _isoDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso.toIso8601String();
    try {
      final parts = raw.trim().split(RegExp(r'\s+'));
      final d = parts[0].split('/');
      if (d.length != 3) return null;
      final month = int.parse(d[0]);
      final day = int.parse(d[1]);
      final year = int.parse(d[2]);
      int hour = 0, minute = 0, second = 0;
      if (parts.length >= 2) {
        final t = parts[1].split(':');
        hour = int.parse(t[0]);
        minute = t.length > 1 ? int.parse(t[1]) : 0;
        second = t.length > 2 ? int.parse(t[2]) : 0;
        if (parts.length >= 3) {
          final ap = parts[2].toUpperCase();
          if (ap == 'PM' && hour < 12) hour += 12;
          if (ap == 'AM' && hour == 12) hour = 0;
        }
      }
      return DateTime(year, month, day, hour, minute, second).toIso8601String();
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reservationKey': reservationKey,
        'occasionDate': occasionDate,
        'reservationWay': reservationWay,
        'employeName': employeName,
        'governorate': governorate,
        'city': city,
        'clientName': clientName,
        'reservationRequestDto': reservationRequestDto,
        'startTime': startTime,
        'finishTime': finishTime,
        'reservationStatus': reservationStatus,
        'portName': portName,
        'reservationDate': _isoDate(reservationDate),
        'acceptPolicy': true,
        'portId': portId,
        'serviceId': serviceId,
        'clientId': clientId,
        'occasionId': occasionId,
        'totalCost': totalCost,
        'additionalCost': additionalCost,
        'additionalCostDetails': additionalCostDetails,
        'discount': discount,
        'vat': vat,
        'netCost': netCost,
        'deposit': deposit,
        'billId': billId,
        'nationalId': nationalId,
        'userNotes': userNotes,
        'additions': additions,
        'oldAdditions': oldAdditions,
      };
}
