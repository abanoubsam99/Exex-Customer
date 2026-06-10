import 'package:evex_user/data/models/client_wallet_data.dart';

class WalletState {
  final bool isLoading;
  final ClientWalletData? data;
  final String? errorMessage;

  const WalletState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  WalletState copyWith({
    bool? isLoading,
    ClientWalletData? data,
    String? errorMessage,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
