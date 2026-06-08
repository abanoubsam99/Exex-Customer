import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';

class NewSuggestionRepo {
  /// إرسال اقتراح بتاجر/مقدم خدمة جديد. بيرجّع `true` لو نجح.
  ///
  /// ملحوظة: [AppEndpoints.newSuggestion] لسه placeholder — أكّد المسار مع الـ backend.
  Future<bool> submitSuggestion({
    required String merchantName,
    required String serviceType,
    required String merchantGovernorate,
    required String merchantCity,
    required String countryCode,
    required String phone,
    required String address,
    String pageLink = '',
    required String occasionType,
    required String occasionDate,
    required String eventGovernorate,
    required String eventCity,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.newSuggestion,
        data: FormData.fromMap({
          'merchantName': merchantName,
          'serviceType': serviceType,
          'merchantGovernorate': merchantGovernorate,
          'merchantCity': merchantCity,
          'phone': '$countryCode$phone',
          'address': address,
          'pageLink': pageLink,
          'occasionType': occasionType,
          'occasionDate': occasionDate,
          'eventGovernorate': eventGovernorate,
          'eventCity': eventCity,
        }),
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
