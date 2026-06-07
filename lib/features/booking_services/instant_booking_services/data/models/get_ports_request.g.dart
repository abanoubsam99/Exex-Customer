// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_ports_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPortsRequest _$GetPortsRequestFromJson(Map<String, dynamic> json) =>
    GetPortsRequest(
      portType: (json['portType'] as num?)?.toInt(),
      occasionId: (json['occasionId'] as num?)?.toInt(),
      numberAllowed: (json['numberAllowed'] as num?)?.toInt(),
      minPrice: (json['minPrice'] as num?)?.toInt(),
      maxPrice: (json['maxPrice'] as num?)?.toInt(),
      index: (json['index'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 20,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$GetPortsRequestToJson(GetPortsRequest instance) =>
    <String, dynamic>{
      if (instance.portType case final value?) 'portType': value,
      if (instance.occasionId case final value?) 'occasionId': value,
      if (instance.numberAllowed case final value?) 'numberAllowed': value,
      if (instance.minPrice case final value?) 'minPrice': value,
      if (instance.maxPrice case final value?) 'maxPrice': value,
      if (instance.index case final value?) 'index': value,
      if (instance.size case final value?) 'size': value,
      if (instance.date?.toIso8601String() case final value?) 'date': value,
    };
