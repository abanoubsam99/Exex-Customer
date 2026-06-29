import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/services/user_service.dart';

class AddPhoneRepo {
  final UserService userService;
  AddPhoneRepo(this.userService);

  Future<String?> addPhone({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      print("phoneNumberphoneNumber ${phoneNumber}");
      print("countryCode ${countryCode}");

      final response = await DioHelper.postData(
        url: AppEndpoints.addPhone,
        data: FormData.fromMap({
          'PhoneNumber': phoneNumber,
          'CountryCode': countryCode,
        }),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data['message'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> confirmPhone({required String code}) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.confirmPhoneNumber,
        data: FormData.fromMap({
          'email': userService.currentUser?.userViewModel?.email,
          'code': code,
        }),
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
