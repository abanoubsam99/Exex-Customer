import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/app_endpoints.dart';
import '../model/add_client_response.dart';

part 'add_client_remote_datasource.g.dart';

@RestApi()
abstract class AddClientRemoteDataSource {
  factory AddClientRemoteDataSource(Dio dio) = _AddClientRemoteDataSource;

  @POST(AppEndpoints.addClient)
  Future<AddClientResponse> addClient(@Body() FormData data);
}
