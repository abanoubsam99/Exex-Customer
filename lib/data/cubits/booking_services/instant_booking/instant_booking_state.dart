import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/special_offer.dart';

class InstantBookingState {
  final bool isLoading;

  /// Loading the next page of ports at the bottom of the list.
  final bool isLoadingMore;
  final PortsRespondModel? portsModel;
  final List<SpecialOffer> specialOffers;
  final String? errorMessage;

  const InstantBookingState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.portsModel,
    this.specialOffers = const [],
    this.errorMessage,
  });

  /// Whether the server has more port pages (drives infinite scroll).
  bool get hasMorePorts => portsModel?.hasNext ?? false;

  InstantBookingState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    PortsRespondModel? portsModel,
    bool clearPorts = false,
    List<SpecialOffer>? specialOffers,
    String? errorMessage,
  }) {
    return InstantBookingState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      portsModel: clearPorts ? null : (portsModel ?? this.portsModel),
      specialOffers: specialOffers ?? this.specialOffers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
