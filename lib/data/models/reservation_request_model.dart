/// عنصر من GET /api/Reservations/GetMyRequestReservations — الطلبات الحالية.
class ReservationRequestModel {
  final int? id;
  final int? portId;
  final int? serviceId;
  final int? occasionId;
  final String? portName;
  final String? portAddress;
  final String? governorate;
  final String? city;
  final String? occasionDate;
  final String? reservationStatus;
  final String? serviceName;
  final String? serviceDetails;

  /// السعر الظاهر (قبل خصم عدد الحجوزات).
  final num? apparentPrice;

  /// التكلفة النهائية حسب عدد الحجوزات (بعد الخصم).
  final num? finalCost;

  /// مقدم الحجز.
  final num? deposit;

  final bool? acceptedByVendor;

  /// True while the request is still awaiting the vendor's confirmation. Paired
  /// with [acceptedByVendor] == false it means "بأنتظار التأكيد من ناحية التاجر"
  /// — the request isn't bookable/payable yet.
  final bool? waiting;
  final bool? paid;
  final String? userNotes;

  /// Pending message text from the vendor awaiting the client's accept/refuse.
  final String? reservationPendingMessage;

  /// The backend's read/unread flag. Kept for reference only — the badge is
  /// driven by [reservationPendingMessage], not by this.
  final bool? messageStatus;

  ReservationRequestModel({
    this.id,
    this.portId,
    this.serviceId,
    this.occasionId,
    this.portName,
    this.portAddress,
    this.governorate,
    this.city,
    this.occasionDate,
    this.reservationStatus,
    this.serviceName,
    this.serviceDetails,
    this.apparentPrice,
    this.finalCost,
    this.deposit,
    this.acceptedByVendor,
    this.waiting,
    this.paid,
    this.userNotes,
    this.reservationPendingMessage,
    this.messageStatus,
  });

  ReservationRequestModel.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        portId = (json['portId'] as num?)?.toInt(),
        serviceId = (json['serviceId'] as num?)?.toInt(),
        occasionId = (json['occasionId'] as num?)?.toInt(),
        portName = json['portName'] as String?,
        portAddress = json['portAddress'] as String?,
        governorate = json['governorate'] as String?,
        city = json['city'] as String?,
        occasionDate = json['occasionDate'] as String?,
        reservationStatus = json['reservationStatus'] as String?,
        serviceName = json['serviceName'] as String?,
        serviceDetails = json['serviceDetails'] as String?,
        apparentPrice = json['apparentPrice'] as num?,
        finalCost = json['theFinalCostBasedOnNumberOfReservations'] as num?,
        deposit = json['deposit'] as num?,
        acceptedByVendor = json['acceptedByVendor'] as bool?,
        waiting = json['waiting'] as bool?,
        paid = json['paid'] as bool?,
        userNotes = json['userNotes'] as String?,
        reservationPendingMessage = (json['reservationPendingMessage'] ??
            json['pendingMessage'] ??
            json['vendorPendingMessage']) as String?,
        messageStatus = _bool(json, const [
          'messageStatus',
          'reservationMessageStatus',
          'hasPendingMessage',
          'pendingMessageStatus',
        ]);

  /// Whether the envelope badge should show. Driven by the message text alone —
  /// the backend sends a real [reservationPendingMessage] when the vendor writes
  /// one and null otherwise, so [messageStatus] is deliberately not consulted.
  bool get hasPendingMessage =>
      reservationPendingMessage?.trim().isNotEmpty ?? false;

  /// Reads the first key holding a boolean, tolerating the numeric (1/0) and
  /// string ("true"/"false") shapes some endpoints return.
  static bool? _bool(Map<String, dynamic> json, List<String> keys) {
    for (final k in keys) {
      final v = json[k];
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final s = v.trim().toLowerCase();
        if (s == 'true' || s == '1') return true;
        if (s == 'false' || s == '0') return false;
      }
    }
    return null;
  }
}
