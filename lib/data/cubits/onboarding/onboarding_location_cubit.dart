import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_location_state.dart';

/// Drives the mandatory location step on onboarding: loads the real
/// governorates/cities and persists the chosen pair via [LocationService].
class OnboardingLocationCubit extends Cubit<OnboardingLocationState> {
  final LocationRepo _repo;
  final LocationService _locationService;

  OnboardingLocationCubit(this._repo, this._locationService)
      : super(const OnboardingLocationState()) {
    loadGovernorates();
  }

  Future<void> loadGovernorates() async {
    emit(state.copyWith(isLoadingGovernorates: true));
    final govs = await _repo.getGovernorates() ?? const [];
    emit(state.copyWith(isLoadingGovernorates: false, governorates: govs));
  }

  Future<void> selectGovernorate(Governate gov) async {
    emit(state.copyWith(
      selectedGovernorate: gov,
      selectedCity: null,
      cities: const [],
      isLoadingCities: true,
    ));
    final cities = await _repo.getCities(gov.id) ?? const [];
    emit(state.copyWith(isLoadingCities: false, cities: cities));
  }

  void selectCity(City city) => emit(state.copyWith(selectedCity: city));

  /// Saves the chosen governorate + city. Returns false when either is missing.
  Future<bool> persist() async {
    final gov = state.selectedGovernorate;
    final city = state.selectedCity;
    if (gov == null || city == null) return false;
    await _locationService.save(
      govId: gov.id,
      govName: gov.governorateNameAr,
      cityId: city.id,
      cityName: city.cityNameAr,
    );
    return true;
  }
}
