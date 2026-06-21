import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/special_offer.dart';

class DirectServicesListState {
  final bool isLoading;
  final PortsRespondModel? portsModel;
  final List<SpecialOffer> specialOffers;
  final String? errorMessage;

  const DirectServicesListState({
    this.isLoading = false,
    this.portsModel,
    this.specialOffers = const [],
    this.errorMessage,
  });

  DirectServicesListState copyWith({
    bool? isLoading,
    PortsRespondModel? portsModel,
    bool clearPorts = false,
    List<SpecialOffer>? specialOffers,
    String? errorMessage,
  }) {
    return DirectServicesListState(
      isLoading: isLoading ?? this.isLoading,
      portsModel: clearPorts ? null : (portsModel ?? this.portsModel),
      specialOffers: specialOffers ?? this.specialOffers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
