// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:evex_user/data/models/error_model.dart';
import 'package:evex_user/data/models/user_model.dart';
import 'package:evex_user/core/networking/api_error_handler.dart';
import 'package:evex_user/data/models/profile.dart';
import 'package:evex_user/features/profile/data_sources/profile_remote_data_source.dart';

class ProfileRepo {
  ProfileRemoteDataSource profileRemoteDataSource;
  ProfileRepo(this.profileRemoteDataSource);

  Future<Either<ErrorModel, UserViewModel>> getProfile({
    String? gov,
    String? city,
  }) async {
    try {
      var result = await profileRemoteDataSource.getProfile();
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ErrorModel, UserViewModel>> updateClient({
    required FormData formData,
  }) async {
    try {
      var result = await profileRemoteDataSource.updateClient(formData);
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ErrorModel, String>> deleteAccount(String email) async {
    var response = await profileRemoteDataSource.deleteAccount("\"$email\"");
    return Right(response['message']);
  }

  // Future<Either<String, String>> updateProfile(Profile profile) async {
  //   try {
  //     var response = await DioImpl().put(
  //       endPoint:
  //           "${EndPoints.vendor}/${UserService.to.currentUser?.value?.modelId}",
  //       data: profile.toJson(),
  //     );
  //     if (response.statusCode == 200) {
  //       return Right(response.data['message']);
  //     } else {
  //       return Left(response.data['message']);
  //     }
  //   } on PrimaryServerException catch (ee) {
  //     return Left(ee.message);
  //   } catch (e) {
  //     return const Left('فشل الاتصال');
  //   }
  // }

  // Future<Either<String, String>> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  //   required String confirmPassword,
  // }) async {
  //   try {
  //     var response = await DioImpl().post(
  //       endPoint: EndPoints.changePassword,
  //       data: {
  //         'currentPassword': currentPassword,
  //         'newPassword': newPassword,
  //         'ConfirmPassword': confirmPassword,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       return Right(response.data['message']);
  //     } else {
  //       return Left(response.data['message']);
  //     }
  //   } on PrimaryServerException catch (e) {
  //     return Left(e.message);
  //   } catch (e) {
  //     return const Left('فشل الاتصال');
  //   }
  // }
}
