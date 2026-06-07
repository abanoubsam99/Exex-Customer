class PortService {
  int id;
  String? name;
  String? serviceKey;
  String? details;
  int? priceAfterDiscount;
  List<String>? serviceImages;
  int? price;
  int? priceBeforDiscount;
  String? picturesAlbumName;
  int? portId;

  PortService({
    required this.id,
    this.name,
    this.serviceKey,
    this.details,
    this.priceAfterDiscount,
    this.priceBeforDiscount,
    this.picturesAlbumName,
    this.serviceImages,
    this.portId,
    this.price,
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
        picturesAlbumName = json['picturesAlbumName'],
        portId = (json['portId'] as num?)?.toInt();

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
    data['picturesAlbumName'] = picturesAlbumName;
    data['portId'] = portId;
    return data;
  }
}
