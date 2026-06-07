import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';

class BookingServicesPortsRepo {
  Future<PortsRespondModel?> getAllPortServices(GetPortsRequest queries) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.ports,
        query: queries.toJson(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return PortsRespondModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
