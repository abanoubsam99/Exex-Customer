import 'package:evex_user/data/models/client_wallet_data.dart';
import 'package:evex_user/data/models/port_service.dart';

class DirectServiceDetailsState {
  final bool isLoading;
  final List<PortService> services;
  final ClientWalletData? wallet;
  final String? errorMessage;

  const DirectServiceDetailsState({
    this.isLoading = false,
    this.services = const [],
    this.wallet,
    this.errorMessage,
  });

  DirectServiceDetailsState copyWith({
    bool? isLoading,
    List<PortService>? services,
    ClientWalletData? wallet,
    String? errorMessage,
  }) {
    return DirectServiceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      services: services ?? this.services,
      wallet: wallet ?? this.wallet,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
