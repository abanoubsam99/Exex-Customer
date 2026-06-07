// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hall _$HallFromJson(Map<String, dynamic> json) => Hall(
      json['name'] as String,
      json['discription'] as String,
      json['price'] as num,
      json['stars'] as num,
      (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$HallToJson(Hall instance) => <String, dynamic>{
      'name': instance.name,
      'discription': instance.discription,
      'price': instance.price,
      'stars': instance.stars,
      'images': instance.images,
    };
