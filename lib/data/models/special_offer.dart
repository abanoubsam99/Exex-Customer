class SpecialOffer {
  SpecialOffer({
    required this.priceAfterDiscount,
    required this.priceBeforDiscount,
    required this.discountPercentage,
    required this.id,
    required this.name,
    required this.serviceKey,
    required this.details,
    required this.portName,
    required this.price,
    required this.isDrafted,
    required this.picturesAlbumName,
    required this.serviceImages,
    required this.portId,
  });

  final int priceAfterDiscount;
  final int priceBeforDiscount;
  final int discountPercentage;
  final int id;
  final String name;
  final String serviceKey;
  final String details;
  final String portName;
  final int price;
  final bool isDrafted;
  final String picturesAlbumName;
  final List<String> serviceImages;
  final int portId;

  SpecialOffer.fromJson(Map<String, dynamic> json)
      : priceAfterDiscount = (json['priceAfterDiscount'] as num).toInt(),
        priceBeforDiscount = (json['priceBeforDiscount'] as num).toInt(),
        discountPercentage = (json['discountPercentage'] as num).toInt(),
        id = (json['id'] as num).toInt(),
        name = json['name'] as String,
        serviceKey = json['serviceKey'] as String,
        portName = json['portName'] as String,
        details = json['details'] as String,
        price = (json['price'] as num).toInt(),
        isDrafted = json['isDrafted'] as bool,
        picturesAlbumName = json['picturesAlbumName'] as String,
        serviceImages =
            (json['serviceImages'] as List?)?.map((e) => e as String).toList() ??
                const [],
        portId = (json['portId'] as num).toInt();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['priceAfterDiscount'] = priceAfterDiscount;
    data['priceBeforDiscount'] = priceBeforDiscount;
    data['discountPercentage'] = discountPercentage;
    data['id'] = id;
    data['name'] = name;
    data['serviceKey'] = serviceKey;
    data['portName'] = portName;
    data['details'] = details;
    data['price'] = price;
    data['isDrafted'] = isDrafted;
    data['picturesAlbumName'] = picturesAlbumName;
    data['serviceImages'] = serviceImages;
    data['portId'] = portId;
    return data;
  }
}
