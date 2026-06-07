import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:evex_user/core/models/error_model.dart';
import 'package:evex_user/core/networking/api_error_handler.dart';
import 'package:evex_user/features/auth/reset_password/data/data_sources/forget_password_data_source.dart';
import 'package:evex_user/features/auth/reset_password/data/model/forget_password_response.dart';

class ForgetPasswordRepo {
  final ForgetPasswordRemoteDataSource forgetPasswordRemoteDataSource;
  ForgetPasswordRepo(this.forgetPasswordRemoteDataSource);

  Future<Either<ErrorModel, ForgetPasswordResponse>> forgetPassword({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      ForgetPasswordResponse forgetPasswordResponse =
          await forgetPasswordRemoteDataSource.forgetPassword({
            'phoneNumber': phoneNumber,
            'countryCode': countryCode,
          });

      return Right(forgetPasswordResponse);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ErrorModel, String>> resetPassword({
    required String phoneNumber,
    required String countryCode,
    required String newPassword,
    required String confirmPassword,
    required String code,
  }) async {
    try {
      var resetPasswordResponse = await forgetPasswordRemoteDataSource
          .resetPassword({
            'phoneNumber': phoneNumber,
            'countryCode': countryCode,
            'newPassword': newPassword,
            'confirmPassword': confirmPassword,
            'code': code,
          });

      return Right(resetPasswordResponse['message']);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  // Future<Either<ResponseMessage, String>> resetPassword({
  // required String phoneNumber,
  // required String countryCode,
  // required String newPassword,
  // required String confirmPassword,
  // required String code,
  // }) async {
  //   try {
  //     var response = await dio.post(
  //       endPoint: EndPoints.resetPassword,
  // data: {
  //   'phoneNumber': phoneNumber,
  //   'countryCode': countryCode,
  //   'newPassword': newPassword,
  //   'confirmPassword': confirmPassword,
  //   'code': code,
  // },
  //     );

  //     if (response.statusCode == 200) {
  //       return Right(response.data['message']);
  //     } else {
  //       return Left(
  //         ResponseMessage(
  //           message: response.data['message'].toString(),
  //           status: response.data['status'],
  //         ),
  //       );
  //     }
  //   } on PrimaryServerException catch (_) {
  //     return Left(ResponseMessage(message: _.message, status: false));
  //   } catch (e) {
  //     return Left(
  //       ResponseMessage(message: AppStrings.processFailed.tr, status: false),
  //     );
  //   }
  // }
}
