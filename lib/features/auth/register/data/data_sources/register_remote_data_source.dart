import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../../core/constants/app_endpoints.dart';

part 'register_remote_data_source.g.dart';

@RestApi(baseUrl: AppEndpoints.baseUrl)
abstract class RegisterRemoteDataSource {
  factory RegisterRemoteDataSource(Dio dio) = _RegisterRemoteDataSource;

  @POST(AppEndpoints.register)
  Future<dynamic> register(@Body() Map<String, dynamic> data);
}
