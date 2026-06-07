import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';

class RegisterRepo {
  Future<String?> register({
    required String email,
    required String password,
    required String confirmpassword,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'confirmPassword': confirmpassword,
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
