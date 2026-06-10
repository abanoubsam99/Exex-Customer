import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/review.dart';
import 'package:evex_user/data/models/service_details_model.dart';

class BookingServiceDetailsState {
  final bool isLoading;
  final Item? port;
  final bool isFavorite;
  final List<PortService> services;
  final PortService? selectedService;
  final List<AdditionModel> additions;
  final List<AdditionModel> selectedAdditions;
  final List<AdditionModel> buffets;
  final List<AdditionModel> selectedBuffets;
  final ServiceDetailsModel? serviceDetails;
  final List<Review> reviews;
  final double totalCost;
  final String? errorMessage;

  const BookingServiceDetailsState({
    this.isLoading = false,
    this.port,
    this.isFavorite = false,
    this.services = const [],
    this.selectedService,
    this.additions = const [],
    this.selectedAdditions = const [],
    this.buffets = const [],
    this.selectedBuffets = const [],
    this.serviceDetails,
    this.reviews = const [],
    this.totalCost = 0.0,
    this.errorMessage,
  });

  BookingServiceDetailsState copyWith({
    bool? isLoading,
    Item? port,
    bool? isFavorite,
    List<PortService>? services,
    PortService? selectedService,
    List<AdditionModel>? additions,
    List<AdditionModel>? selectedAdditions,
    List<AdditionModel>? buffets,
    List<AdditionModel>? selectedBuffets,
    ServiceDetailsModel? serviceDetails,
    List<Review>? reviews,
    double? totalCost,
    String? errorMessage,
  }) {
    return BookingServiceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      port: port ?? this.port,
      isFavorite: isFavorite ?? this.isFavorite,
      services: services ?? this.services,
      selectedService: selectedService ?? this.selectedService,
      additions: additions ?? this.additions,
      selectedAdditions: selectedAdditions ?? this.selectedAdditions,
      buffets: buffets ?? this.buffets,
      selectedBuffets: selectedBuffets ?? this.selectedBuffets,
      serviceDetails: serviceDetails ?? this.serviceDetails,
      reviews: reviews ?? this.reviews,
      totalCost: totalCost ?? this.totalCost,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
