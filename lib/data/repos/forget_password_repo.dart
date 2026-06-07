import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/forget_password_response.dart';

class ForgetPasswordRepo {
  Future<ForgetPasswordResponse?> forgetPassword({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.forgetPassword,
        data: {'phoneNumber': phoneNumber, 'countryCode': countryCode},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ForgetPasswordResponse.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> resetPassword({
    required String phoneNumber,
    required String countryCode,
    required String newPassword,
    required String confirmPassword,
    required String code,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.resetPassword,
        data: {
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
          'code': code,
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data['message'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
