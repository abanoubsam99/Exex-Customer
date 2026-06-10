import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/client_wallet_data.dart';

class WalletRepo {
  /// GET /api/Clients/GetMyClientWalletData
  Future<ClientWalletData?> getWalletData() async {
    try {
      final response = await DioHelper.getData(url: AppEndpoints.walletData);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ClientWalletData.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
