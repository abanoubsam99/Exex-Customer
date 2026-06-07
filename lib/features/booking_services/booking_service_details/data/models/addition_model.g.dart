// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdditionModel _$AdditionModelFromJson(Map<String, dynamic> json) =>
    AdditionModel(
      additionKey: json['additionKey'] as String?,
      displayNumber: json['displayNumber'] as bool?,
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
      specificToBuffet: json['specificToBuffet'] as bool?,
      giftId: (json['giftId'] as num?)?.toInt(),
      portId: (json['portId'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AdditionModelToJson(AdditionModel instance) =>
    <String, dynamic>{
      'additionKey': instance.additionKey,
      'displayNumber': instance.displayNumber,
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'specificToBuffet': instance.specificToBuffet,
      'portId': instance.portId,
      'giftId': instance.giftId,
      'count': instance.count,
    };
