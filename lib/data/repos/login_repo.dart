import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/data/models/login_request.dart';
import 'package:evex_user/data/models/user_model.dart';

class LoginRepo {
  LoginRepo(this.cacheHelper);
  final CacheHelper cacheHelper;

  Future<UserModel?> login(LoginRequest loginRequest) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.login,
        data: loginRequest.toJson(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final user = UserModel.fromJson(response.data);
        await cacheHelper.saveData(key: CacheKeys.token, value: user.token);
        return user;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // Google login disabled — removed for App Store guideline 4.8.
  // /// External (Google) login. POST /EVEX/Account/ExternalLogin
  // Future<UserModel?> externalLogin({
  //   required String idToken,
  //   required String provider,
  //   required String email,
  //   required String name,
  // }) async {
  //   try {
  //     final response = await DioHelper.postData(
  //       url: AppEndpoints.externalLogin,
  //       data: {
  //         'idToken': idToken,
  //         'provider': provider,
  //         'email': email,
  //         'name': name,
  //       },
  //     );
  //     if (response.statusCode! >= 200 && response.statusCode! < 300) {
  //       final user = UserModel.fromJson(response.data);
  //       await cacheHelper.saveData(key: CacheKeys.token, value: user.token);
  //       return user;
  //     }
  //     return null;
  //   } catch (_) {
  //     return null;
  //   }
  // }
}
