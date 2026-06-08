import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';

class RequestToJoinRepo {
  /// إرسال طلب الانضمام لشبكة تجار evex.
  /// بيرجّع `true` لو نجح و`false` غير كده.
  ///
  /// ملحوظة: [AppEndpoints.joinRequest] لسه placeholder — أكّد المسار مع الـ backend.
  Future<bool> submitJoinRequest({
    required String name,
    required String serviceType,
    required String governorate,
    required String city,
    required String address,
    required String countryCode,
    required String phone,
    required String email,
    String pageLink = '',
    String otherInfo = '',
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.joinRequest,
        data: FormData.fromMap({
          'name': name,
          'serviceType': serviceType,
          'governorate': governorate,
          'city': city,
          'address': address,
          'phone': '$countryCode$phone',
          'email': email,
          'pageLink': pageLink,
          'otherInfo': otherInfo,
        }),
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
