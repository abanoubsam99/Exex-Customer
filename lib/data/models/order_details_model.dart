import 'package:evex_user/core/helpers/date_format_helper.dart';

class OrderDetailsModel {
  final String bookingNumber;
  final int? reservationId;
  final int? portId;
  final OrderCustomer customer;
  final String status;
  final String createdDate;
  final String createdTime;
  final String hallName;
  final String eventType;
  final String venueLocation;
  final String eventDay;
  final String eventDate;
  final OrderLineItem basicService;
  final List<OrderLineItem> additions;
  final List<OrderLineItem> buffet;
  final List<CostRow> costBreakdown;
  final num totalCost;
  final num netCost;
  final num paid;
  final num remaining;
  final num refunded;

  const OrderDetailsModel({
    required this.bookingNumber,
    this.reservationId,
    this.portId,
    required this.customer,
    required this.status,
    required this.createdDate,
    required this.createdTime,
    required this.hallName,
    required this.eventType,
    required this.venueLocation,
    required this.eventDay,
    required this.eventDate,
    required this.basicService,
    required this.additions,
    required this.buffet,
    required this.costBreakdown,
    required this.totalCost,
    required this.netCost,
    required this.paid,
    required this.remaining,
    required this.refunded,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      bookingNumber: json['bookingNumber']?.toString() ?? '',
      reservationId: (json['reservationId'] as num?)?.toInt(),
      portId: (json['portId'] as num?)?.toInt(),
      customer: OrderCustomer.fromJson(json['customer'] ?? const {}),
      status: json['status'] ?? '',
      createdDate: json['createdDate'] ?? '',
      createdTime: json['createdTime'] ?? '',
      hallName: json['hallName'] ?? '',
      eventType: json['eventType'] ?? '',
      venueLocation: json['venueLocation'] ?? '',
      eventDay: json['eventDay'] ?? '',
      eventDate: json['eventDate'] ?? '',
      basicService: OrderLineItem.fromJson(json['basicService'] ?? const {}),
      additions: ((json['additions'] ?? []) as List)
          .map((e) => OrderLineItem.fromJson(e))
          .toList(),
      buffet: ((json['buffet'] ?? []) as List)
          .map((e) => OrderLineItem.fromJson(e))
          .toList(),
      costBreakdown: ((json['costBreakdown'] ?? []) as List)
          .map((e) => CostRow.fromJson(e))
          .toList(),
      totalCost: json['totalCost'] ?? 0,
      netCost: json['netCost'] ?? 0,
      paid: json['paid'] ?? 0,
      remaining: json['remaining'] ?? 0,
      refunded: json['refunded'] ?? 0,
    );
  }

  /// The booking code the user sees: the last 6 characters of the reservation
  /// key (`2e0fc698-...-ebbb77ed7370` → `ed7370`). Null when there's no key.
  static String? _bookingCode(String key) {
    if (key.isEmpty) return null;
    return key.length <= 6 ? key : key.substring(key.length - 6);
  }

  /// بيحوّل رد GET /api/Reservations/GetBillDetailsByClient/{id} لشكل الشاشة.
  factory OrderDetailsModel.fromBillJson(Map<String, dynamic> json) {
    // Reads the first key that carries a numeric value: the documented bill
    // field first, then the older names the backend used before.
    num n(String key, [List<String> fallbacks = const []]) {
      for (final k in [key, ...fallbacks]) {
        final v = json[k];
        if (v is num) return v;
      }
      return 0;
    }

    String s(String key) => (json[key]?.toString() ?? '').trim();

    final additions = <OrderLineItem>[];
    final buffet = <OrderLineItem>[];
    for (final a in (json['additions'] as List?) ?? const []) {
      final item = OrderLineItem(
        name: a['name']?.toString() ?? '',
        price: ((a['additionTotalPrice'] as num?) ?? 0).round(),
        count: (a['number'] as num?)?.toInt(),
      );
      (a['isBuft'] == true ? buffet : additions).add(item);
    }

    final address = [s('governorate'), s('city'), s('address')]
        .where((e) => e.isNotEmpty)
        .join(' , ');
    final venue =
        [s('governorate'), s('city')].where((e) => e.isNotEmpty).join(' , ');
    final serviceDetails = s('serviceDetails');

    // Fully dynamic path: if the backend returns the cost components as a list,
    // render them straight from the API (any new component shows automatically).
    // Falls back to building the breakdown from the known flat fields below.
    final rawCosts =
        json['costBreakdown'] ?? json['costDetails'] ?? json['costs'];
    final apiBreakdown = rawCosts is List
        ? rawCosts
            .whereType<Map>()
            .map((e) => CostRow.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : null;

    // Totals come from the API: netBill is the grand total, and the remaining
    // amount is netAmountDueToOrFromCustomer — derived (net − paid) only when
    // the backend doesn't send it explicitly.
    final totalValue = n('totalCost');
    final netCost = n('netBill', const ['netCost']);
    final paidValue = n('totalAmountReceivedFromCustomer');
    final remainingValue = (json['netAmountDueToOrFromCustomer'] as num?) ??
        (json['remainingAmount'] as num?) ??
        (netCost - paidValue);

    return OrderDetailsModel(
      // The booking code shown on the badge: the last 6 characters of the
      // reservation's GUID key — never the raw reservationId.
      bookingNumber: _bookingCode(s('reservationKey')) ?? '',
      reservationId: (json['reservationId'] as num?)?.toInt(),
      portId: (json['portId'] as num?)?.toInt(),
      customer: OrderCustomer(
        name: s('clientName'),
        email: s('email'),
        phone: s('clientPhoneNumber'),
        address: address,
      ),
      // Raw status — screens localize it via ReservationStatusHelper.label().
      status: s('reservationStatus'),
      createdDate:
          DateFormatHelper.arabicDate(s('reservationDate'), fallback: ''),
      createdTime: DateFormatHelper.arabicTime(s('reservationDate')),
      hallName: s('portName'),
      eventType: s('occasionType'),
      venueLocation: venue,
      eventDay: DateFormatHelper.arabicWeekday(s('occasionDate')),
      eventDate:
          DateFormatHelper.arabicDateWithComa(s('occasionDate'), fallback: ''),
      basicService: OrderLineItem(
        name: s('serviceName'),
        price: n('servicePrice').round(),
        description: serviceDetails.isEmpty ? null : serviceDetails,
      ),
      additions: additions,
      buffet: buffet,
      // Labels/units are translation keys — screens render them with `.tr()`.
      // Prefer the API's cost list; otherwise build from the known flat fields.
      // Every component is listed even when it's 0 or absent from the response,
      // so the invoice always shows the full breakdown.
      costBreakdown: apiBreakdown ??
          [
            CostRow(
              label: 'evex commission',
              value: n('evexAdditionalCommissionAmount', const [
                'evexCommission',
              ]).round(),
            ),
            CostRow(
                label: 'administrative fees',
                value: n('administrativeFees').round()),
            CostRow(
                label: 'tax', value: n('vatValue', const ['tax']).round()),
            CostRow(
                label: 'insurance amount', value: n('insuranceAmount').round()),
            CostRow(label: 'booking deposit', value: n('deposit').round()),
            // Cashback comes from the API already converted to money, so it is
            // shown in pounds — not as a points count.
            CostRow(
              label: 'cashback',
              value: n('cashbackPointsValue').round(),
            ),
            CostRow(
              label: 'additional discount from vendor',
              value: n('additionalDiscountFromVendor').round(),
            ),
            CostRow(
              label: 'additional discount from evex',
              value: n('additionalDiscountFromEVEX').round(),
            ),
            CostRow(
              label: 'additional cost from vendor',
              value: n('additionalCostFromVendor').round(),
              subtitle: json['detailsAdditionalCostFromVendor']?.toString(),
            ),
            CostRow(
              label: 'additional cost from evex',
              value: n('additionalCostFromEVEX').round(),
              subtitle: json['detailsAdditionalCostFromEVEX']?.toString(),
            ),
          ],
      totalCost: totalValue.round(),
      netCost: netCost.round(),
      paid: paidValue.round(),
      remaining: remainingValue.round(),
      refunded: n('totalAmountRefundedToCustomer').round(),
    );
  }
}

class OrderCustomer {
  final String name;
  final String email;
  final String phone;
  final String address;

  const OrderCustomer({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory OrderCustomer.fromJson(Map<String, dynamic> json) {
    return OrderCustomer(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class OrderLineItem {
  final String name;
  final num price;
  final String? description;
  final int? count;
  final String? subName;
  final num? subPrice;

  const OrderLineItem({
    required this.name,
    required this.price,
    this.description,
    this.count,
    this.subName,
    this.subPrice,
  });

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    return OrderLineItem(
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'],
      count: json['count'],
      subName: json['subName'],
      subPrice: json['subPrice'],
    );
  }
}

class CostRow {
  /// Translation key for the label + unit ('pound' / 'point'); screens call `.tr()`.
  final String label;
  final num value;
  final String unit;
  final String? subtitle;

  const CostRow({
    required this.label,
    required this.value,
    this.unit = 'pound',
    this.subtitle,
  });

  /// Tolerant of the common field-name variants a backend might use for a
  /// dynamic cost-components list (label/name/title, value/amount, ...).
  factory CostRow.fromJson(Map<String, dynamic> json) {
    return CostRow(
      label: (json['label'] ?? json['name'] ?? json['title'] ?? '').toString(),
      value: ((json['value'] ?? json['amount'] ?? 0) as num).round(),
      unit: (json['unit'] ?? 'pound').toString(),
      subtitle: (json['subtitle'] ?? json['details'])?.toString(),
    );
  }
}
