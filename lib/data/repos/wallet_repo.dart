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

  /// GET /api/Clients/ChangeClientWalletPassword
  /// Sets or changes the wallet PIN. The backend expects the password in the
  /// request body of a GET, so we hit dio directly (DioHelper.getData has no
  /// body param). Returns true on success.
  Future<bool> changeWalletPassword(String password) async {
    try {
      final response = await DioHelper.dio.put(
        AppEndpoints.changeWalletPassword,
        data: {'password': password},
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
