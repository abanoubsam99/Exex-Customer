import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:evex_user/data/models/error_model.dart';
import 'package:evex_user/core/networking/api_error_handler.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/features/auth/add_phone/data/data_sources/add_phone_data_source.dart';

class AddPhoneRepo {
  final AddPhoneRemoteDataSource addPhoneRemoteDataSource;
  final UserService userService;
  AddPhoneRepo(this.addPhoneRemoteDataSource, this.userService);

  Future<Either<ErrorModel, String>> addPhone({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      var response = await addPhoneRemoteDataSource.addPhone(
        FormData.fromMap({
          'PhoneNumber': phoneNumber,
          'CountryCode': countryCode,
        }),
      );

      return Right(response['message']);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ErrorModel, String>> confirmPhone({
    required String code,
  }) async {
    try {
      var response = await addPhoneRemoteDataSource.confirmPhone(
        FormData.fromMap({
          'email': userService.currentUser?.userViewModel?.email,
          'code': code,
        }),
      );

      return Right(response['message']);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
