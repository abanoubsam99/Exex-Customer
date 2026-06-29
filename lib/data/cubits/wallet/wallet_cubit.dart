import 'package:evex_user/data/repos/wallet_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepo _repo;

  WalletCubit(this._repo) : super(const WalletState());

  Future<void> getWalletData() async {
    emit(state.copyWith(isLoading: true));
    final data = await _repo.getWalletData();
    if (data != null) {
      emit(state.copyWith(isLoading: false, data: data));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  /// Sets/changes the wallet PIN, then refreshes the wallet data so
  /// `passwordChanged` flips to true. Returns true on success.
  Future<bool> changeWalletPassword(String password) async {
    final success = await _repo.changeWalletPassword(password);
    if (success) {
      await getWalletData();
    }
    return success;
  }
}
