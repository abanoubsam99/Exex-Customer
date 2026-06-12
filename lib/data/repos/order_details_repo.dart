import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/order_details_model.dart';

class OrderDetailsRepo {
  /// GET /api/Reservations/GetBillDetailsByClient/{id} — تفاصيل فاتورة الحجز.
  Future<OrderDetailsModel?> getOrderDetails({int? id}) async {
    if (id == null) return null;
    try {
      final response = await DioHelper.getData(
        url: '${AppEndpoints.billDetailsByClient}/$id',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return OrderDetailsModel.fromBillJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
