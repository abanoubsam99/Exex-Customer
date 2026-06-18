import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';

/// Sentinel so copyWith can set the nullable selections back to null (needed
/// when the governorate changes and the city must be cleared).
const Object _unset = Object();

class OnboardingLocationState {
  final bool isLoadingGovernorates;
  final bool isLoadingCities;
  final List<Governate> governorates;
  final List<City> cities;
  final Governate? selectedGovernorate;
  final City? selectedCity;

  const OnboardingLocationState({
    this.isLoadingGovernorates = false,
    this.isLoadingCities = false,
    this.governorates = const [],
    this.cities = const [],
    this.selectedGovernorate,
    this.selectedCity,
  });

  /// Both a governorate and a city must be chosen before onboarding can finish.
  bool get canFinish => selectedGovernorate != null && selectedCity != null;

  OnboardingLocationState copyWith({
    bool? isLoadingGovernorates,
    bool? isLoadingCities,
    List<Governate>? governorates,
    List<City>? cities,
    Object? selectedGovernorate = _unset,
    Object? selectedCity = _unset,
  }) {
    return OnboardingLocationState(
      isLoadingGovernorates:
          isLoadingGovernorates ?? this.isLoadingGovernorates,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      selectedGovernorate: selectedGovernorate == _unset
          ? this.selectedGovernorate
          : selectedGovernorate as Governate?,
      selectedCity:
          selectedCity == _unset ? this.selectedCity : selectedCity as City?,
    );
  }
}
