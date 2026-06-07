class ServiceDetailsModel {
  final int? id;
  final String? name;
  final String? serviceKey;
  final String? details;
  final String? picturesAlbumName;
  final int? portId;
  final List<String>? serviceImages;
  final List<String>? serviceOccasionsDTOs;
  final double? price;
  final bool? specialOffer;
  final String? time;
  final bool? hasGift;
  final List<GiftDTO>? giftDtos;
  final List<GiftDTO>? oldGifts;
  final List<String>? deletedGifts;

  ServiceDetailsModel({
    this.id,
    this.name,
    this.serviceKey,
    this.details,
    this.picturesAlbumName,
    this.oldGifts,
    this.portId,
    this.serviceImages,
    this.serviceOccasionsDTOs,
    this.price,
    this.specialOffer,
    this.time,
    this.hasGift,
    this.giftDtos,
    this.deletedGifts,
  });

  ServiceDetailsModel.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        name = json['name'],
        serviceKey = json['serviceKey'],
        details = json['details'],
        picturesAlbumName = json['picturesAlbumName'],
        portId = (json['portId'] as num?)?.toInt(),
        serviceImages = (json['serviceImages'] as List?)
            ?.map((e) => e as String)
            .toList(),
        serviceOccasionsDTOs = (json['serviceOccasionsDTOs'] as List?)
            ?.map((e) => e as String)
            .toList(),
        price = (json['price'] as num?)?.toDouble(),
        specialOffer = json['specialOffer'],
        time = json['time'],
        hasGift = json['hasGift'],
        giftDtos = (json['giftDtos'] as List?)
            ?.map((e) => GiftDTO.fromJson(e))
            .toList(),
        oldGifts = (json['oldGifts'] as List?)
            ?.map((e) => GiftDTO.fromJson(e))
            .toList(),
        deletedGifts = (json['deletedGifts'] as List?)
            ?.map((e) => e as String)
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serviceKey'] = serviceKey;
    data['details'] = details;
    data['picturesAlbumName'] = picturesAlbumName;
    data['portId'] = portId;
    data['serviceImages'] = serviceImages;
    data['serviceOccasionsDTOs'] = serviceOccasionsDTOs;
    data['price'] = price;
    data['specialOffer'] = specialOffer;
    data['time'] = time;
    data['hasGift'] = hasGift;
    data['giftDtos'] = giftDtos?.map((e) => e.toJson()).toList();
    data['oldGifts'] = oldGifts?.map((e) => e.toJson()).toList();
    data['deletedGifts'] = deletedGifts;
    return data;
  }
}

class GiftDTO {
  int? id;
  final int? serviceId;
  final int? additionId;
  final String? additionName;
  final int? number;

  GiftDTO({
    this.id,
    this.serviceId,
    this.additionId,
    this.additionName,
    this.number,
  });

  GiftDTO.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        serviceId = (json['serviceId'] as num?)?.toInt(),
        additionId = (json['additionId'] as num?)?.toInt(),
        additionName = json['additionName'],
        number = (json['number'] as num?)?.toInt();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serviceId'] = serviceId;
    data['additionId'] = additionId;
    data['additionName'] = additionName;
    data['number'] = number;
    return data;
  }
}
