
import 'package:json_annotation/json_annotation.dart';

part 'service_details_model.g.dart';

@JsonSerializable()
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

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceDetailsModelFromJson(json);
}

@JsonSerializable()
class GiftDTO {
  int? id;
  final int? serviceId;
  final int? additionId;
  final String? additionName;
  final int? number;

  GiftDTO({
    required this.id,
    required this.serviceId,
    required this.additionId,
    required this.additionName,
    required this.number,
  });

  factory GiftDTO.fromJson(Map<String, dynamic> json) => _$GiftDTOFromJson(json);
}
