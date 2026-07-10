class PortService {
  int id;
  String? name;
  String? serviceKey;
  String? details;
  int? priceAfterDiscount;
  List<String>? serviceImages;
  int? price;
  int? priceBeforDiscount;

  /// Discount percentage straight from the backend — the badge uses this rather
  /// than recomputing it from the before/after prices.
  int? discountPercentage;
  String? picturesAlbumName;
  int? portId;

  /// When true the price is hidden across the UI (the vendor doesn't want to
  /// publish a fixed price for this service).
  bool displayPrice;

  PortService({
    required this.id,
    this.name,
    this.serviceKey,
    this.details,
    this.priceAfterDiscount,
    this.priceBeforDiscount,
    this.discountPercentage,
    this.picturesAlbumName,
    this.serviceImages,
    this.portId,
    this.price,
    this.displayPrice = false,
  });

  PortService.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num).toInt(),
        name = json['name'],
        serviceKey = json['serviceKey'],
        details = json['details'],
        priceAfterDiscount = (json['priceAfterDiscount'] as num?)?.toInt(),
        serviceImages =
            (json['serviceImages'] as List?)?.map((e) => e as String).toList(),
        price = (json['price'] as num?)?.toInt(),
        priceBeforDiscount = (json['priceBeforDiscount'] as num?)?.toInt(),
        discountPercentage = (json['discountPercentage'] as num?)?.toInt(),
        picturesAlbumName = json['picturesAlbumName'],
        portId = (json['portId'] as num?)?.toInt(),
        displayPrice = json['displayPrice'] as bool? ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serviceKey'] = serviceKey;
    data['details'] = details;
    data['priceAfterDiscount'] = priceAfterDiscount;
    data['serviceImages'] = serviceImages;
    data['price'] = price;
    data['priceBeforDiscount'] = priceBeforDiscount;
    data['discountPercentage'] = discountPercentage;
    data['picturesAlbumName'] = picturesAlbumName;
    data['portId'] = portId;
    data['displayPrice'] = displayPrice;
    return data;
  }
}
