import 'package:json_annotation/json_annotation.dart';

part 'addition_model.g.dart';

@JsonSerializable()
class AdditionModel {
  String? additionKey;
  bool? displayNumber;
  int? id;
  String? name;
  int? price;
  bool? specificToBuffet;
  int? portId;
  int? giftId;
  int? count;

  AdditionModel({
    this.additionKey,
    this.displayNumber,
    this.id,
    this.name,
    this.price,
    this.specificToBuffet,
    this.giftId,
    this.portId,
    this.count,
  });

  factory AdditionModel.fromJson(Map<String, dynamic> json) =>
      _$AdditionModelFromJson(json);
}
