import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/models/occasion.dart';

class NewSuggestionState {
  final bool isLoading;
  final List<Governate> governorates;

  // موقع التاجر
  final List<City> merchantCities;
  final Governate? selectedMerchantGov;
  final City? selectedMerchantCity;

  // موقع المناسبة
  final List<City> eventCities;
  final Governate? selectedEventGov;
  final City? selectedEventCity;

  final List<String> serviceTypes;
  final String? selectedServiceType;
  final List<Occasion> occasions;
  final Occasion? selectedOccasion;

  final bool? success;
  final String? errorMessage;

  const NewSuggestionState({
    this.isLoading = false,
    this.governorates = const [],
    this.merchantCities = const [],
    this.selectedMerchantGov,
    this.selectedMerchantCity,
    this.eventCities = const [],
    this.selectedEventGov,
    this.selectedEventCity,
    this.serviceTypes = const [],
    this.selectedServiceType,
    this.occasions = const [],
    this.selectedOccasion,
    this.success,
    this.errorMessage,
  });

  NewSuggestionState copyWith({
    bool? isLoading,
    List<Governate>? governorates,
    List<City>? merchantCities,
    Governate? selectedMerchantGov,
    City? selectedMerchantCity,
    List<City>? eventCities,
    Governate? selectedEventGov,
    City? selectedEventCity,
    List<String>? serviceTypes,
    String? selectedServiceType,
    List<Occasion>? occasions,
    Occasion? selectedOccasion,
    bool? success,
    String? errorMessage,
    bool clearMerchantCity = false,
    bool clearEventCity = false,
  }) {
    return NewSuggestionState(
      isLoading: isLoading ?? this.isLoading,
      governorates: governorates ?? this.governorates,
      merchantCities: merchantCities ?? this.merchantCities,
      selectedMerchantGov: selectedMerchantGov ?? this.selectedMerchantGov,
      selectedMerchantCity:
          clearMerchantCity ? null : selectedMerchantCity ?? this.selectedMerchantCity,
      eventCities: eventCities ?? this.eventCities,
      selectedEventGov: selectedEventGov ?? this.selectedEventGov,
      selectedEventCity:
          clearEventCity ? null : selectedEventCity ?? this.selectedEventCity,
      serviceTypes: serviceTypes ?? this.serviceTypes,
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      occasions: occasions ?? this.occasions,
      selectedOccasion: selectedOccasion ?? this.selectedOccasion,
      success: success,
      errorMessage: errorMessage,
    );
  }
}
