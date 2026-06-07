import 'package:dartz/dartz.dart';
import 'package:evex_user/data/models/error_model.dart';

import '../../../../../../core/networking/api_error_handler.dart';
import '../data_sources/register_remote_data_source.dart';

class RegisterRepo {
  RegisterRepo(this.registerRemoteDataSource);
  final RegisterRemoteDataSource registerRemoteDataSource;

  Future<Either<ErrorModel, String>> register({
    required String email,
    required String password,
    required String confirmpassword,
  }) async {
    try {
      var result = await registerRemoteDataSource.register({
        'email': email,
        'password': password,
        'confirmPassword': confirmpassword,
      });
      return Right(result['message']);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
