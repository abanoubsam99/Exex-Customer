import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/models/user_model.dart';

class ProfileState {
  final bool isLoading;
  final UserViewModel? profile;
  final List<Governate> governorates;
  final List<City> cities;
  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedGender;
  final String? errorMessage;
  final bool updateSuccess;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.governorates = const [],
    this.cities = const [],
    this.selectedGovernorate,
    this.selectedCity,
    this.selectedGender,
    this.errorMessage,
    this.updateSuccess = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserViewModel? profile,
    List<Governate>? governorates,
    List<City>? cities,
    String? selectedGovernorate,
    String? selectedCity,
    String? selectedGender,
    String? errorMessage,
    bool? updateSuccess,
    // copyWith can't normally reset a value to null; these flags allow it.
    bool clearSelectedCity = false,
    bool clearSelectedGovernorate = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      selectedGovernorate: clearSelectedGovernorate
          ? null
          : selectedGovernorate ?? this.selectedGovernorate,
      selectedCity:
          clearSelectedCity ? null : selectedCity ?? this.selectedCity,
      selectedGender: selectedGender ?? this.selectedGender,
      errorMessage: errorMessage ?? this.errorMessage,
      updateSuccess: updateSuccess ?? this.updateSuccess,
    );
  }
}
