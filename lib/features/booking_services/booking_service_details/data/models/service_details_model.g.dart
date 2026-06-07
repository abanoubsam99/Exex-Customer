// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceDetailsModel _$ServiceDetailsModelFromJson(Map<String, dynamic> json) =>
    ServiceDetailsModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      serviceKey: json['serviceKey'] as String?,
      details: json['details'] as String?,
      picturesAlbumName: json['picturesAlbumName'] as String?,
      oldGifts: (json['oldGifts'] as List<dynamic>?)
          ?.map((e) => GiftDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      portId: (json['portId'] as num?)?.toInt(),
      serviceImages: (json['serviceImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      serviceOccasionsDTOs: (json['serviceOccasionsDTOs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      price: (json['price'] as num?)?.toDouble(),
      specialOffer: json['specialOffer'] as bool?,
      time: json['time'] as String?,
      hasGift: json['hasGift'] as bool?,
      giftDtos: (json['giftDtos'] as List<dynamic>?)
          ?.map((e) => GiftDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      deletedGifts: (json['deletedGifts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ServiceDetailsModelToJson(
        ServiceDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'serviceKey': instance.serviceKey,
      'details': instance.details,
      'picturesAlbumName': instance.picturesAlbumName,
      'portId': instance.portId,
      'serviceImages': instance.serviceImages,
      'serviceOccasionsDTOs': instance.serviceOccasionsDTOs,
      'price': instance.price,
      'specialOffer': instance.specialOffer,
      'time': instance.time,
      'hasGift': instance.hasGift,
      'giftDtos': instance.giftDtos,
      'oldGifts': instance.oldGifts,
      'deletedGifts': instance.deletedGifts,
    };

GiftDTO _$GiftDTOFromJson(Map<String, dynamic> json) => GiftDTO(
      id: (json['id'] as num?)?.toInt(),
      serviceId: (json['serviceId'] as num?)?.toInt(),
      additionId: (json['additionId'] as num?)?.toInt(),
      additionName: json['additionName'] as String?,
      number: (json['number'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GiftDTOToJson(GiftDTO instance) => <String, dynamic>{
      'id': instance.id,
      'serviceId': instance.serviceId,
      'additionId': instance.additionId,
      'additionName': instance.additionName,
      'number': instance.number,
    };
