import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/user_model.dart';

class ProfileRepo {
  Future<UserViewModel?> getProfile() async {
    try {
      final response = await DioHelper.getData(url: AppEndpoints.getUserData);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return UserViewModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<UserViewModel?> updateClient({required FormData formData}) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.updateClient,
        data: formData,
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return UserViewModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// تغيير كلمة المرور. بيرجّع `true` لو نجح.
  /// ملحوظة: [AppEndpoints.changePassword] لسه placeholder — أكّد المسار مع الـ backend.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.changePassword,
        data: FormData.fromMap({
          'oldPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<String?> deleteAccount(String email) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.deleteAccount,
        data: '"$email"',
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
