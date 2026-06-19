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

  // External social login (Google / Facebook / Apple) — fully prepared but
  // disabled for now (hidden for the store; App Store guideline 4.8). To enable:
  // uncomment this + AppEndpoints.externalLogin and the LoginCubit methods.
  //
  // /// Exchanges a provider token for the app's user. POST /EVEX/Account/ExternalLogin
  // Future<UserModel?> externalLogin({
  //   required String provider, // 'google' | 'facebook' | 'apple'
  //   required String token,    // idToken / accessToken / identityToken
  //   String? email,
  //   String? name,
  // }) async {
  //   try {
  //     final response = await DioHelper.postData(
  //       url: AppEndpoints.externalLogin,
  //       data: {
  //         'provider': provider,
  //         'token': token,
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
