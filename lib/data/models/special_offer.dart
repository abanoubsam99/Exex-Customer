class SpecialOffer {
  SpecialOffer({
    this.priceAfterDiscount,
    this.priceBeforDiscount,
    this.discountPercentage,
    required this.id,
    this.name,
    this.serviceKey,
    this.details,
    this.portName,
    this.price,
    this.isDrafted,
    this.picturesAlbumName,
    this.serviceImages = const [],
    this.portId,
    this.displayPrice = false,
    this.subscriptionType,
  });

  final int? priceAfterDiscount;
  final int? priceBeforDiscount;
  final int? discountPercentage;
  final int id;
  final String? name;
  final String? serviceKey;
  final String? details;
  final String? portName;
  final int? price;
  final bool? isDrafted;
  final String? picturesAlbumName;
  final List<String> serviceImages;
  final int? portId;

  /// When true the price is hidden across the UI (the vendor doesn't want to
  /// publish a fixed price for this service).
  final bool displayPrice;

  /// Service subscription type as sent by the API — `"payment"` = direct
  /// service (مباشر), `"reservation"` = instant booking (فوري). Decides which
  /// module a tapped offer opens.
  final String? subscriptionType;

  /// Whether this offer is a direct-payment service.
  bool get isDirectPayment =>
      subscriptionType?.trim().toLowerCase() == 'payment';

  SpecialOffer.fromJson(Map<String, dynamic> json)
      : priceAfterDiscount = (json['priceAfterDiscount'] as num?)?.toInt(),
        priceBeforDiscount = (json['priceBeforDiscount'] as num?)?.toInt(),
        discountPercentage = (json['discountPercentage'] as num?)?.toInt(),
        id = (json['id'] as num).toInt(),
        name = json['name'] as String?,
        serviceKey = json['serviceKey'] as String?,
        portName = json['portName'] as String?,
        details = json['details'] as String?,
        price = (json['price'] as num?)?.toInt(),
        isDrafted = json['isDrafted'] as bool?,
        picturesAlbumName = json['picturesAlbumName'] as String?,
        serviceImages =
            (json['serviceImages'] as List?)?.map((e) => e as String).toList() ??
                const [],
        portId = (json['portId'] as num?)?.toInt(),
        displayPrice = json['displayPrice'] as bool? ?? false,
        // Older payloads sent this as an int (1 = direct payment); the services
        // endpoint sends "payment" / "reservation".
        subscriptionType = json['subscriptionType'] is num
            ? ((json['subscriptionType'] as num).toInt() == 1
                ? 'payment'
                : 'reservation')
            : json['subscriptionType'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'priceAfterDiscount': priceAfterDiscount,
      'priceBeforDiscount': priceBeforDiscount,
      'discountPercentage': discountPercentage,
      'id': id,
      'name': name,
      'serviceKey': serviceKey,
      'portName': portName,
      'details': details,
      'price': price,
      'isDrafted': isDrafted,
      'picturesAlbumName': picturesAlbumName,
      'serviceImages': serviceImages,
      'portId': portId,
      'displayPrice': displayPrice,
      'subscriptionType': subscriptionType,
    };
  }
}
