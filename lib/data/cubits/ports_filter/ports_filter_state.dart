import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/models/occasion.dart';

/// Sentinel so copyWith can clear the nullable selections back to null.
const Object _unset = Object();

class PortsFilterState {
  final bool isLoading;
  final bool isLoadingCities;
  final List<Governate> governorates;
  final List<City> cities;
  final List<Occasion> occasions;
  final Governate? selectedGovernorate;
  final City? selectedCity;
  final int? selectedOccasionId;

  /// Attendee count (حدد عدد الحضور); 0 means "not set".
  final int count;

  /// Price-slider position (حدد سعر معين); the max value means "no price cap".
  final double price;

  /// "الخدمات المتاحه فقط" toggle (vs. "جميع الخدمات").
  final bool availableOnly;

  const PortsFilterState({
    this.isLoading = false,
    this.isLoadingCities = false,
    this.governorates = const [],
    this.cities = const [],
    this.occasions = const [],
    this.selectedGovernorate,
    this.selectedCity,
    this.selectedOccasionId,
    this.count = 0,
    this.price = 500000,
    this.availableOnly = true,
  });

  PortsFilterState copyWith({
    bool? isLoading,
    bool? isLoadingCities,
    List<Governate>? governorates,
    List<City>? cities,
    List<Occasion>? occasions,
    Object? selectedGovernorate = _unset,
    Object? selectedCity = _unset,
    Object? selectedOccasionId = _unset,
    int? count,
    double? price,
    bool? availableOnly,
  }) {
    return PortsFilterState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      occasions: occasions ?? this.occasions,
      selectedGovernorate: selectedGovernorate == _unset
          ? this.selectedGovernorate
          : selectedGovernorate as Governate?,
      selectedCity:
          selectedCity == _unset ? this.selectedCity : selectedCity as City?,
      selectedOccasionId: selectedOccasionId == _unset
          ? this.selectedOccasionId
          : selectedOccasionId as int?,
      count: count ?? this.count,
      price: price ?? this.price,
      availableOnly: availableOnly ?? this.availableOnly,
    );
  }
}
