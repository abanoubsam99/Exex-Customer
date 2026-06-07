import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';

class AddClientState {
  final bool isLoading;
  final List<Governate> governorates;
  final List<City> cities;
  final Governate? selectedGovernorate;
  final City? selectedCity;
  final bool? success;
  final String? errorMessage;

  const AddClientState({
    this.isLoading = false,
    this.governorates = const [],
    this.cities = const [],
    this.selectedGovernorate,
    this.selectedCity,
    this.success,
    this.errorMessage,
  });

  AddClientState copyWith({
    bool? isLoading,
    List<Governate>? governorates,
    List<City>? cities,
    Governate? selectedGovernorate,
    City? selectedCity,
    bool? success,
    String? errorMessage,
    bool clearGovernorate = false,
    bool clearCity = false,
  }) {
    return AddClientState(
      isLoading: isLoading ?? this.isLoading,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      selectedGovernorate:
          clearGovernorate ? null : selectedGovernorate ?? this.selectedGovernorate,
      selectedCity: clearCity ? null : selectedCity ?? this.selectedCity,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
