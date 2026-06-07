import 'package:evex_user/core/constants/app_images.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final String portName;
  final int paymentType; //0 outcome 1 income
  final num paymentAmount;
  final String paymentMethod;
  final String paymentReasson;

  TransactionModel({
    required this.portName,
    required this.paymentType,
    required this.paymentAmount,
    required this.paymentMethod,
    required this.paymentReasson,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  String get paymentMethodImage {
    switch (paymentMethod.toLowerCase()) {
      case 'mastercard':
        return AppImages.imagesMasterCard2;
      case 'visa':
        return AppImages.imagesVisa;
      case 'evex':
        return AppImages.imagesNewLogo;
      case 'cash':
        return AppImages.imagesDollars;
      default:
        return AppImages.imagesNewLogo;
    }
  }
}

List<TransactionModel> myTransactions = [
  TransactionModel(
    portName: 'قاعة البارون',
    paymentType: 0,
    paymentAmount: 1000,
    paymentMethod: 'mastercard',
    paymentReasson: 'مقدم الحجز',
  ),
  TransactionModel(
    portName: 'قاعة البارون',
    paymentType: 1,
    paymentAmount: 1000,
    paymentMethod: 'cash',
    paymentReasson: 'دفعات الحجز',
  ),
  TransactionModel(
    portName: 'محمود فوتوجرافر',
    paymentType: 0,
    paymentAmount: 1000,
    paymentMethod: 'mastercard',
    paymentReasson: 'دفعات الحجز',
  ),
  TransactionModel(
    portName: 'محمود فوتوجرافر',
    paymentType: 0,
    paymentAmount: 1000,
    paymentMethod: 'evex',
    paymentReasson: 'دفعات الحجز',
  ),
  TransactionModel(
    portName: 'محمود فوتوجرافر',
    paymentType: 1,
    paymentAmount: 1000,
    paymentMethod: 'cash',
    paymentReasson: 'دفعات الحجز',
  ),
  TransactionModel(
    portName: 'امنية ميكاب ارتيست',
    paymentType: 0,
    paymentAmount: 1000,
    paymentMethod: 'mastercard',
    paymentReasson: 'دفعات الحجز',
  ),
  TransactionModel(
    portName: 'امنية ميكاب ارتيست',
    paymentType: 0,
    paymentAmount: 1000,
    paymentMethod: 'evex',
    paymentReasson: 'دفعات الحجز',
  ),
];
