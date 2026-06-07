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
  final String? errorMessage;
  final bool updateSuccess;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.governorates = const [],
    this.cities = const [],
    this.selectedGovernorate,
    this.selectedCity,
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
    String? errorMessage,
    bool? updateSuccess,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedCity: selectedCity ?? this.selectedCity,
      errorMessage: errorMessage ?? this.errorMessage,
      updateSuccess: updateSuccess ?? this.updateSuccess,
    );
  }
}
