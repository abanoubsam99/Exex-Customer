import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/transaction_model.dart';

class PaymentHistoryRepo {
  /// GET /api/Accounts/GetMyFinancialOperations — the client's financial
  /// operations (payments + refunds). All params are sent as query string
  /// (matching the Swagger contract).
  /// [operationType] filters server-side ('' = all, 'Paying', 'Refund'),
  /// while [index]/[size] drive the pagination.
  Future<List<TransactionModel>?> getMyFinancialOperations({
    String operationType = '',
    int index = 0,
    int size = 20,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.myFinancialOperations,
        query: {
          if (operationType.isNotEmpty) 'operationType': operationType,
          'index': index,
          'size': size,
        },
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
