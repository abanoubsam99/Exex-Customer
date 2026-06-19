/// Response of POST /api/Reservations/ConfirmClientReservation (card flow):
/// `{ paymentUrl, paymobOrderId, totalDeposit, reservationCount }`.
/// The `paymobOrderId` is needed later to VerifyPayment after the user pays.
class PaymentGatewayResult {
  final String paymentUrl;
  final int? paymobOrderId;
  final num? totalDeposit;
  final int? reservationCount;

  PaymentGatewayResult({
    required this.paymentUrl,
    this.paymobOrderId,
    this.totalDeposit,
    this.reservationCount,
  });

  /// Defensive parse — the URL may come under a few key spellings.
  static PaymentGatewayResult? fromJson(dynamic data) {
    if (data is! Map) return null;
    String? url;
    for (final k in ['paymentUrl', 'payment_url', 'url', 'iframeUrl', 'link']) {
      final v = data[k];
      if (v is String && v.trim().toLowerCase().startsWith('http')) {
        url = v.trim();
        break;
      }
    }
    if (url == null) return null;
    return PaymentGatewayResult(
      paymentUrl: url,
      paymobOrderId: (data['paymobOrderId'] as num?)?.toInt(),
      totalDeposit: data['totalDeposit'] as num?,
      reservationCount: (data['reservationCount'] as num?)?.toInt(),
    );
  }
}
