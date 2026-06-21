import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/special_offer.dart';

class InstantBookingState {
  final bool isLoading;
  final PortsRespondModel? portsModel;
  final List<SpecialOffer> specialOffers;
  final String? errorMessage;

  const InstantBookingState({
    this.isLoading = false,
    this.portsModel,
    this.specialOffers = const [],
    this.errorMessage,
  });

  InstantBookingState copyWith({
    bool? isLoading,
    PortsRespondModel? portsModel,
    bool clearPorts = false,
    List<SpecialOffer>? specialOffers,
    String? errorMessage,
  }) {
    return InstantBookingState(
      isLoading: isLoading ?? this.isLoading,
      portsModel: clearPorts ? null : (portsModel ?? this.portsModel),
      specialOffers: specialOffers ?? this.specialOffers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
