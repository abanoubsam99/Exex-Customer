import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/models/addition_model.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/models/port_service.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/models/service_details_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../../../core/constants/app_endpoints.dart';

part 'port_services_remote_data_source.g.dart';

@RestApi()
abstract class PortServicesRemoteDataSource {
  factory PortServicesRemoteDataSource(Dio dio) = _PortServicesRemoteDataSource;

  @GET(AppEndpoints.services)
  Future<List<PortService>> getAllPortServices(@Query("portId") int portId);

  @GET(AppEndpoints.addition)
  Future<List<AdditionModel>> getAllAdditions(@Query("portId") int portId);

  @GET("${AppEndpoints.serviceData}/{id}")
  Future<ServiceDetailsModel> getServiceData(@Path("id") int id);
}
