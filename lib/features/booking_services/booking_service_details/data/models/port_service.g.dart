// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'port_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortService _$PortServiceFromJson(Map<String, dynamic> json) => PortService(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      serviceKey: json['serviceKey'] as String?,
      details: json['details'] as String?,
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toInt(),
      priceBeforDiscount: (json['priceBeforDiscount'] as num?)?.toInt(),
      picturesAlbumName: json['picturesAlbumName'] as String?,
      serviceImages: (json['serviceImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      portId: (json['portId'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PortServiceToJson(PortService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'serviceKey': instance.serviceKey,
      'details': instance.details,
      'priceAfterDiscount': instance.priceAfterDiscount,
      'serviceImages': instance.serviceImages,
      'price': instance.price,
      'priceBeforDiscount': instance.priceBeforDiscount,
      'picturesAlbumName': instance.picturesAlbumName,
      'portId': instance.portId,
    };
