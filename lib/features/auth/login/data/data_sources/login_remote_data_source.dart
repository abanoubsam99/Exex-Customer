import 'package:dio/dio.dart';
import 'package:evex_user/features/auth/login/data/models/login_request.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/app_endpoints.dart';
import '../../../../../core/models/user_model.dart';

part 'login_remote_data_source.g.dart';

@RestApi(baseUrl: AppEndpoints.baseUrl)
abstract class LoginRemoteDataSource {
  factory LoginRemoteDataSource(Dio dio) = _LoginRemoteDataSource;

  @POST(AppEndpoints.login)
  Future<UserModel> login(@Body() LoginRequest loginRequest);
}
