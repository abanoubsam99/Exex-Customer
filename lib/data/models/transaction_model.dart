import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/date_format_helper.dart';

class TransactionModel {
  final String portName;

  /// 0 = outcome (money paid by the client), 1 = income (refund to the client).
  final int paymentType;
  final num paymentAmount;
  final String paymentMethod;
  final String paymentReasson;

  /// Pre-formatted date/time line (e.g. "26/5/2026  -  مساءا 9:27").
  final String dateText;

  TransactionModel({
    required this.portName,
    required this.paymentType,
    required this.paymentAmount,
    required this.paymentMethod,
    required this.paymentReasson,
    this.dateText = '',
  });

  /// Maps one item of GET /api/Accounts/GetMyFinancialOperations.
  factory TransactionModel.fromFinancialOperation(Map<String, dynamic> json) {
    final operationType = json['operationType']?.toString() ?? '';
    final details = (json['details']?.toString() ?? '').trim();
    final date = json['dateAndTime']?.toString();
    return TransactionModel(
      portName: json['portName']?.toString() ?? '',
      paymentType: _isRefund(operationType) ? 1 : 0,
      paymentAmount: ((json['amount'] as num?) ?? 0).round(),
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentReasson: details.isNotEmpty ? details : _reasonFor(operationType),
      dateText:
          '${DateFormatHelper.numericDate(date)}  -  ${DateFormatHelper.arabicClock(date)}',
    );
  }

  // Refund/return operations are treated as income; everything else as outcome.
  static bool _isRefund(String operationType) {
    final t = operationType.toLowerCase();
    return t.contains('refund') ||
        t.contains('return') ||
        operationType.contains('استرداد');
  }

  /// Returns a translation key (screens localize it with `.tr()`); an unknown
  /// raw operation type is passed through unchanged.
  static String _reasonFor(String operationType) {
    switch (operationType.toLowerCase()) {
      case 'deposit':
        return 'booking deposit';
      case 'paying':
        return 'booking payments';
      default:
        return _isRefund(operationType) ? 'refund' : operationType;
    }
  }

  String get paymentMethodImage {
    switch (paymentMethod.toLowerCase()) {
      case 'paymob':
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
