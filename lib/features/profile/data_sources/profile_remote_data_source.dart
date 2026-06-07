import 'package:dio/dio.dart';
import 'package:evex_user/core/models/user_model.dart';
import 'package:evex_user/features/profile/data/models/profile.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/app_endpoints.dart';

part 'profile_remote_data_source.g.dart';

@RestApi(baseUrl: AppEndpoints.baseUrl)
abstract class ProfileRemoteDataSource {
  factory ProfileRemoteDataSource(Dio dio) = _ProfileRemoteDataSource;

  @GET(AppEndpoints.getUserData)
  Future<UserViewModel> getProfile();

  //updateProfile
  @POST('/api/Clients/UpdateClient')
  @MultiPart()
  Future<UserViewModel> updateClient(@Body() FormData formData);
  
  //changePassword

  //deelete account
  @POST(AppEndpoints.deleteAccount)
  Future<dynamic> deleteAccount(@Body() String body);
}
