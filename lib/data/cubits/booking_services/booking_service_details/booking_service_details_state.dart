import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/service_details_model.dart';

class BookingServiceDetailsState {
  final bool isLoading;
  final List<PortService> services;
  final PortService? selectedService;
  final List<AdditionModel> additions;
  final List<AdditionModel> selectedAdditions;
  final List<AdditionModel> buffets;
  final List<AdditionModel> selectedBuffets;
  final ServiceDetailsModel? serviceDetails;
  final double totalCost;
  final String? errorMessage;

  const BookingServiceDetailsState({
    this.isLoading = false,
    this.services = const [],
    this.selectedService,
    this.additions = const [],
    this.selectedAdditions = const [],
    this.buffets = const [],
    this.selectedBuffets = const [],
    this.serviceDetails,
    this.totalCost = 0.0,
    this.errorMessage,
  });

  BookingServiceDetailsState copyWith({
    bool? isLoading,
    List<PortService>? services,
    PortService? selectedService,
    List<AdditionModel>? additions,
    List<AdditionModel>? selectedAdditions,
    List<AdditionModel>? buffets,
    List<AdditionModel>? selectedBuffets,
    ServiceDetailsModel? serviceDetails,
    double? totalCost,
    String? errorMessage,
  }) {
    return BookingServiceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      services: services ?? this.services,
      selectedService: selectedService ?? this.selectedService,
      additions: additions ?? this.additions,
      selectedAdditions: selectedAdditions ?? this.selectedAdditions,
      buffets: buffets ?? this.buffets,
      selectedBuffets: selectedBuffets ?? this.selectedBuffets,
      serviceDetails: serviceDetails ?? this.serviceDetails,
      totalCost: totalCost ?? this.totalCost,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
