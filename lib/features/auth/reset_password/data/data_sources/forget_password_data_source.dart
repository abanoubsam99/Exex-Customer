import 'package:dio/dio.dart';
import 'package:evex_user/data/models/forget_password_response.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/app_endpoints.dart';

part 'forget_password_data_source.g.dart';

@RestApi()
abstract class ForgetPasswordRemoteDataSource {
  factory ForgetPasswordRemoteDataSource(Dio dio) = _ForgetPasswordRemoteDataSource;

  @POST(AppEndpoints.forgetPassword)
  Future<ForgetPasswordResponse> forgetPassword(
    @Body() Map<String, dynamic> data,
  );

  @POST(AppEndpoints.resetPassword)
  Future<dynamic> resetPassword(@Body() Map<String, dynamic> data);
}
