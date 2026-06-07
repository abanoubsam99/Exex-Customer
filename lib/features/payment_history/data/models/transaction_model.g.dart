// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      portName: json['portName'] as String,
      paymentType: (json['paymentType'] as num).toInt(),
      paymentAmount: json['paymentAmount'] as num,
      paymentMethod: json['paymentMethod'] as String,
      paymentReasson: json['paymentReasson'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'portName': instance.portName,
      'paymentType': instance.paymentType,
      'paymentAmount': instance.paymentAmount,
      'paymentMethod': instance.paymentMethod,
      'paymentReasson': instance.paymentReasson,
    };
