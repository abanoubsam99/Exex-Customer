import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/data/models/user_model.dart';

class ProfileRepo {
  final UserService _userService;
  ProfileRepo(this._userService);

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

  /// تعديل بيانات العميل. كل الحقول بتتبعت كـ multipart/form-data (زي الـ API
  /// المعتمد)، والصورة بتتبعت في نفس الـ body على الحقل `Image`.
  /// PUT /api/Clients/UpdateClient
  Future<UserViewModel?> updateClient({
    int? id,
    required String name,
    String? governorate,
    String? city,
    String? address,
    String? gender,
    String? dateOfBirth,
    MultipartFile? image,
  }) async {
    try {
      final form = FormData.fromMap({
        if (id != null) 'Id': id,
        'Name': name,
        if (governorate != null && governorate.isNotEmpty)
          'Governorate': governorate,
        if (city != null && city.isNotEmpty) 'City': city,
        if (address != null && address.isNotEmpty) 'Address': address,
        if (gender != null && gender.isNotEmpty) 'Gender': gender,
        if (dateOfBirth != null && dateOfBirth.isNotEmpty)
          'DateOfBirth': dateOfBirth,
        // The backend expects the uploaded file on the `Image` field.
        if (image != null) 'Image': image,
      });
      final response = await DioHelper.putData(
        url: AppEndpoints.updateClient,
        data: form,
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
  /// POST /EVEX/Account/ChangePassword
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: AppEndpoints.changePassword,
        data: {
          'userId': _userService.currentUser?.userViewModel?.userId ?? '',
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
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
        data: {'email': email},
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
