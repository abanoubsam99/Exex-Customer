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
      paid: json['paid'] ?? 0,
      remaining: json['remaining'] ?? 0,
      refunded: json['refunded'] ?? 0,
    );
  }

  /// بيحوّل رد GET /api/Reservations/GetBillDetailsByClient/{id} لشكل الشاشة.
  factory OrderDetailsModel.fromBillJson(Map<String, dynamic> json) {
    num n(String key) => (json[key] as num?) ?? 0;
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
    final venue = [s('governorate'), s('city')]
        .where((e) => e.isNotEmpty)
        .join(' , ');
    final serviceDetails = s('serviceDetails');

    return OrderDetailsModel(
      bookingNumber: (json['reservationId'] as num?)?.toInt().toString() ?? '',
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
      eventDate: DateFormatHelper.arabicDateWithComa(s('occasionDate'), fallback: ''),
      basicService: OrderLineItem(
        name: s('serviceName'),
        price: n('servicePrice').round(),
        description: serviceDetails.isEmpty ? null : serviceDetails,
      ),
      additions: additions,
      buffet: buffet,
      // Labels/units are translation keys — screens render them with `.tr()`.
      costBreakdown: [
        CostRow(label: 'evex commission', value: n('evexCommission').round()),
        CostRow(
            label: 'administrative fees',
            value: n('administrativeFees').round()),
        CostRow(label: 'tax', value: n('tax').round()),
        CostRow(label: 'insurance amount', value: n('insuranceAmount').round()),
        CostRow(label: 'booking deposit', value: n('deposit').round()),
        CostRow(
          label: 'cashback',
          value: n('cashbackPointsValue').round(),
          unit: 'point',
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
      totalCost: n('totalCost').round(),
      paid: n('totalAmountReceivedFromCustomer').round(),
      remaining: n('remainingAmount').round(),
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

  factory CostRow.fromJson(Map<String, dynamic> json) {
    return CostRow(
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
      unit: json['unit'] ?? 'pound',
      subtitle: json['subtitle'],
    );
  }
}
