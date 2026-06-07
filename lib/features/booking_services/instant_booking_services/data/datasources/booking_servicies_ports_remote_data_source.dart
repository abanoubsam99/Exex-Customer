import 'package:dio/dio.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../../../core/constants/app_endpoints.dart';

part 'booking_servicies_ports_remote_data_source.g.dart';

@RestApi()
abstract class BookingServiciesPortsRemoteDataSource {
  factory BookingServiciesPortsRemoteDataSource(Dio dio) = _BookingServiciesPortsRemoteDataSource;

  @GET(AppEndpoints.ports)
  Future<PortsRespondModel> getPorts(@Queries() Map<String, dynamic> queries);


}
