import 'package:evex_user/data/models/client_wallet_data.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/review.dart';

class DirectServiceDetailsState {
  final bool isLoading;
  final List<PortService> services;
  final ClientWalletData? wallet;

  /// Customer reviews for this port ("آراء العملاء").
  final List<Review> reviews;

  /// The vendor port shown in the header. Seeded from the port passed in, or
  /// loaded by id when opened from a special offer (which carries only portId).
  final Item? port;

  /// Other ports owned by the same vendor (same companyId) — shown in the
  /// "خدمات أخرى" section. Each opens its own direct-service details screen.
  final List<Item> otherPorts;

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
    this.port,
    this.otherPorts = const [],
    this.reviews = const [],
    this.portImages = const [],
    this.isFavorite = false,
    this.errorMessage,
  });

  DirectServiceDetailsState copyWith({
    bool? isLoading,
    List<PortService>? services,
    ClientWalletData? wallet,
    Item? port,
    List<Item>? otherPorts,
    List<Review>? reviews,
    List<String>? portImages,
    bool? isFavorite,
    String? errorMessage,
  }) {
    return DirectServiceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      services: services ?? this.services,
      wallet: wallet ?? this.wallet,
      port: port ?? this.port,
      otherPorts: otherPorts ?? this.otherPorts,
      reviews: reviews ?? this.reviews,
      portImages: portImages ?? this.portImages,
      isFavorite: isFavorite ?? this.isFavorite,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
