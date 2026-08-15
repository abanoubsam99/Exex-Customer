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
      final response = await DioHelper.postData(
        url: AppEndpoints.addPhone,
        data: FormData.fromMap({
          'PhoneNumber': phoneNumber,
          'CountryCode': countryCode,
        }),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return _messageOrNull(response.data);
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
        return _messageOrNull(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// A 2xx response can still carry a business failure (`isSuccess: false`) —
  /// a wrong or expired code comes back that way. Returns `null` for those so
  /// the caller treats it as a failure; the backend `message` itself is already
  /// surfaced to the user by the Dio interceptor.
  String? _messageOrNull(dynamic data) {
    if (data is! Map) return '';
    if (data['isSuccess'] == false || data['IsSuccess'] == false) return null;
    final message = data['message'] ?? data['Message'];
    return message is String ? message : '';
  }
}
