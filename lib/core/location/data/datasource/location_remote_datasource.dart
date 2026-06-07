import 'package:dio/dio.dart';
import 'package:evex_user/core/location/data/models/city.dart';
import 'package:evex_user/core/location/data/models/governate.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/app_endpoints.dart';

part 'location_remote_datasource.g.dart';

@RestApi()
abstract class LocationRemoteDataSource {
  factory LocationRemoteDataSource(Dio dio) = _LocationRemoteDataSource;

  @GET(AppEndpoints.governorates)
  Future<List<Governate>> getGovernorates();

  @GET(AppEndpoints.cities)
  Future<List<City>> getCities(@Path() int govId);
}
