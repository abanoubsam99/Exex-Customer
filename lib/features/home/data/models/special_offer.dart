import 'package:json_annotation/json_annotation.dart';

part 'special_offer.g.dart';

@JsonSerializable()
class SpecialOffer {
    SpecialOffer({
        required this.priceAfterDiscount,
        required this.priceBeforDiscount,
        required this.discountPercentage,
        required this.id,
        required this.name,
        required this.serviceKey,
        required this.details,
        required this.price,
        required this.isDrafted,
        required this.picturesAlbumName,
        required this.serviceImages,
        required this.portId,
    });

    final int priceAfterDiscount;
    final int priceBeforDiscount;
    final int discountPercentage;
    final int id;
    final String name;
    final String serviceKey;
    final String details;
    final int price;
    final bool isDrafted;
    final String picturesAlbumName;
    final List<String> serviceImages;
    final int portId;

    factory SpecialOffer.fromJson(Map<String, dynamic> json) => _$SpecialOfferFromJson(json);

}
