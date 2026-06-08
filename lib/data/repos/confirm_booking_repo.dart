import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/cubits/confirm_booking/confirm_booking_state.dart';

class ConfirmBookingRepo {
  /// تأكيد الدفع للحجز. بيرجّع `true` لو نجح.
  /// ملحوظة: [AppEndpoints.confirmBooking] لسه placeholder — أكّد المسار مع الـ backend.
  Future<bool> confirmPayment({
    required BookingPaymentMethod method,
    String? cardName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.confirmBooking,
        data: FormData.fromMap({
          'paymentMethod': method.name,
          if (method == BookingPaymentMethod.card) ...{
            'cardName': cardName,
            'cardNumber': cardNumber,
            'expiryDate': expiryDate,
            'cvv': cvv,
          },
        }),
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
