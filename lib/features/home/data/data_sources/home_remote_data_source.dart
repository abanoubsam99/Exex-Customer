import 'package:dio/dio.dart';
import 'package:evex_user/data/models/port_category_with_port_types.dart';
import 'package:evex_user/data/models/special_offer.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/app_endpoints.dart';

part 'home_remote_data_source.g.dart';

@RestApi(baseUrl: AppEndpoints.baseUrl)
abstract class HomeRemoteDataSource {
  factory HomeRemoteDataSource(Dio dio) = _HomeRemoteDataSource;

  @GET(AppEndpoints.getHomeUserAppInfo)
  Future<List<PortCategoryWithPortTypes>> getHomeUserAppInfo(
    @Queries() Map<String, dynamic> queries,
  );

  @GET(AppEndpoints.sepcialOffers)
  Future<List<SpecialOffer>> getSpecialOffers({
    @Queries() Map<String, dynamic>? queries,
  });
}
