// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialOffer _$SpecialOfferFromJson(Map<String, dynamic> json) => SpecialOffer(
      priceAfterDiscount: (json['priceAfterDiscount'] as num).toInt(),
      priceBeforDiscount: (json['priceBeforDiscount'] as num).toInt(),
      discountPercentage: (json['discountPercentage'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      serviceKey: json['serviceKey'] as String,
      details: json['details'] as String,
      price: (json['price'] as num).toInt(),
      isDrafted: json['isDrafted'] as bool,
      picturesAlbumName: json['picturesAlbumName'] as String,
      serviceImages: (json['serviceImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      portId: (json['portId'] as num).toInt(),
    );

Map<String, dynamic> _$SpecialOfferToJson(SpecialOffer instance) =>
    <String, dynamic>{
      'priceAfterDiscount': instance.priceAfterDiscount,
      'priceBeforDiscount': instance.priceBeforDiscount,
      'discountPercentage': instance.discountPercentage,
      'id': instance.id,
      'name': instance.name,
      'serviceKey': instance.serviceKey,
      'details': instance.details,
      'price': instance.price,
      'isDrafted': instance.isDrafted,
      'picturesAlbumName': instance.picturesAlbumName,
      'serviceImages': instance.serviceImages,
      'portId': instance.portId,
    };
