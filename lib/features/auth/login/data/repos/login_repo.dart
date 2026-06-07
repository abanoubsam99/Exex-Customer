import 'package:dartz/dartz.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/core/helpers/cash_helper.dart';
import 'package:evex_user/core/models/error_model.dart';
import 'package:evex_user/features/auth/login/data/models/login_request.dart';

import '../../../../../core/networking/api_error_handler.dart';
import '../data_sources/login_remote_data_source.dart';
import '../../../../../core/models/user_model.dart';

class LoginRepo {
  LoginRepo(this.loginRemoteDataSource);
  final LoginRemoteDataSource loginRemoteDataSource;

  Future<Either<ErrorModel, UserModel>> login(LoginRequest loginRequest) async {
    try {
      UserModel result = await loginRemoteDataSource.login(loginRequest);
      await CashHelper.to.saveData(key: CacheKeys.token, value: result.token);

      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
