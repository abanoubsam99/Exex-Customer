import 'package:evex_user/data/models/client_wallet_data.dart';
import 'package:evex_user/data/models/port_service.dart';

class DirectServiceDetailsState {
  final bool isLoading;
  final List<PortService> services;
  final ClientWalletData? wallet;

  /// Gallery image paths fetched from /api/Ports/GetPortImages — preferred over
  /// the (often empty) [Item.portImages] passed in with the port.
  final List<String> portImages;

  /// Whether the current port is in the client's favorites (optimistic, local).
  final bool isFavorite;
  final String? errorMessage;

  const DirectServiceDetailsState({
    this.isLoading = false,
    this.services = const [],
    this.wallet,
    this.portImages = const [],
    this.isFavorite = false,
    this.errorMessage,
  });

  DirectServiceDetailsState copyWith({
    bool? isLoading,
    List<PortService>? services,
    ClientWalletData? wallet,
    List<String>? portImages,
    bool? isFavorite,
    String? errorMessage,
  }) {
    return DirectServiceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      services: services ?? this.services,
      wallet: wallet ?? this.wallet,
      portImages: portImages ?? this.portImages,
      isFavorite: isFavorite ?? this.isFavorite,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
