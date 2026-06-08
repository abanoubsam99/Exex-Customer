import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';

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

  final String? selectedServiceType;
  final String? selectedOccasionType;

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
    this.selectedServiceType,
    this.selectedOccasionType,
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
    String? selectedServiceType,
    String? selectedOccasionType,
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
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      selectedOccasionType: selectedOccasionType ?? this.selectedOccasionType,
      success: success,
      errorMessage: errorMessage,
    );
  }
}
