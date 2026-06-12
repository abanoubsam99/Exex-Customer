import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/transaction_model.dart';

class PaymentHistoryRepo {
  /// GET /api/Accounts/GetMyFinancialOperations — the client's financial
  /// operations (payments + refunds). Sent as multipart form to match the API.
  Future<List<TransactionModel>?> getMyFinancialOperations({
    int index = 0,
    int size = 20,
  }) async {
    try {
      final response = await DioHelper.dio.get(
        AppEndpoints.myFinancialOperations,
        data: FormData.fromMap({
          'Id': '',
          'operationType': '',
          'index': '$index',
          'size': '$size',
        }),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final items = response.data['items'] as List?;
        return items
                ?.map((e) => TransactionModel.fromFinancialOperation(e))
                .toList() ??
            [];
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
