import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/app_endpoints.dart';

part 'add_phone_data_source.g.dart';

@RestApi()
abstract class AddPhoneRemoteDataSource {
  factory AddPhoneRemoteDataSource(Dio dio) = _AddPhoneRemoteDataSource;

  @POST(AppEndpoints.addPhone)
  Future<dynamic> addPhone(@Body() FormData data);

  @POST(AppEndpoints.confirmPhoneNumber)
  Future<dynamic> confirmPhone(@Body() FormData data);
}
