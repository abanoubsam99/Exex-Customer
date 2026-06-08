import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';

class RequestToJoinState {
  final bool isLoading;
  final List<Governate> governorates;
  final List<City> cities;
  final Governate? selectedGovernorate;
  final City? selectedCity;
  final String? selectedServiceType;
  final bool? success;
  final String? errorMessage;

  const RequestToJoinState({
    this.isLoading = false,
    this.governorates = const [],
    this.cities = const [],
    this.selectedGovernorate,
    this.selectedCity,
    this.selectedServiceType,
    this.success,
    this.errorMessage,
  });

  RequestToJoinState copyWith({
    bool? isLoading,
    List<Governate>? governorates,
    List<City>? cities,
    Governate? selectedGovernorate,
    City? selectedCity,
    String? selectedServiceType,
    bool? success,
    String? errorMessage,
    bool clearCity = false,
  }) {
    return RequestToJoinState(
      isLoading: isLoading ?? this.isLoading,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedCity: clearCity ? null : selectedCity ?? this.selectedCity,
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      success: success,
      errorMessage: errorMessage,
    );
  }
}
