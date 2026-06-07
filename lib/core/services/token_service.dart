import 'package:evex_user/core/helpers/cash_helper.dart';

import '../constants/cash_keys.dart';

class TokenService {
  final CashHelper _cashHelper;
  TokenService(this._cashHelper);

  String? getToken() {
    return _cashHelper.getData(CacheKeys.token) as String?;
  }

  Future<bool> saveToken(String token) {
    return _cashHelper.saveData(key: CacheKeys.token, value: token);
  }
}
