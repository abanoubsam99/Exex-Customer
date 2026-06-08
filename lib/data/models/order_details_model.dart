class OrderDetailsModel {
  final String bookingNumber;
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
  final String label;
  final num value;
  final String unit; // جنيه / نقطة
  final String? subtitle;

  const CostRow({
    required this.label,
    required this.value,
    this.unit = 'جنيه',
    this.subtitle,
  });

  factory CostRow.fromJson(Map<String, dynamic> json) {
    return CostRow(
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
      unit: json['unit'] ?? 'جنيه',
      subtitle: json['subtitle'],
    );
  }
}
