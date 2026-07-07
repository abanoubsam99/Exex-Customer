import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ports_filter_state.dart';

/// Backs the instant-booking "تصفيه" sheet: loads the real governorates,
/// cities and occasions and holds the draft selections until the user taps
/// "تأكيد" (which applies them onto the ports list via /api/Ports/Filter).
class PortsFilterCubit extends Cubit<PortsFilterState> {
  final LocationRepo _locationRepo;
  final ConfirmBookingRepo _bookingRepo;
  final LocationService _locationService;
  final UserService _userService;

  PortsFilterCubit(
    this._locationRepo,
    this._bookingRepo,
    this._locationService,
    this._userService,
  ) : super(const PortsFilterState()) {
    load();
  }

  Future<void> load() async {
    // Guests can't restrict to "الخدمات المتاحه فقط" — default them to the
    // unrestricted "جميع الخدمات" so they browse everything.
    final isLoggedIn = _userService.currentUser != null;
    emit(state.copyWith(isLoading: true, availableOnly: isLoggedIn));
    final govsF = _locationRepo.getGovernorates();
    final occasionsF = _bookingRepo.getOccasions();
    final govs = await govsF ?? const [];
    final occasions = await occasionsF ?? const [];
    emit(state.copyWith(
      isLoading: false,
      governorates: govs,
      occasions: occasions,
    ));
    await _autofillUserLocation(govs);
  }

  /// Pre-fills the governorate/city the user entered before — from
  /// [LocationService] (onboarding, for guests and registered users) and, as a
  /// fallback, their profile — so the filter opens already set to their area.
  Future<void> _autofillUserLocation(List<Governate> govs) async {
    // Don't override a selection the user already made in this session.
    if (state.selectedGovernorate != null) return;
    final user = _userService.currentUser?.userViewModel;
    final govName =
        _firstNonEmpty([_locationService.govName, user?.governorate]);
    final cityName = _firstNonEmpty([_locationService.cityName, user?.city]);
    if (govName == null) return;

    Governate? gov;
    for (final g in govs) {
      if (g.governorateNameAr == govName || g.governorateNameEn == govName) {
        gov = g;
        break;
      }
    }
    if (gov == null) return;

    emit(state.copyWith(
      selectedGovernorate: gov,
      selectedCity: null,
      cities: const [],
      isLoadingCities: true,
    ));
    final cities = await _locationRepo.getCities(gov.id!) ?? const [];
    City? city;
    if (cityName != null) {
      for (final c in cities) {
        if (c.cityNameAr == cityName || c.cityNameEn == cityName) {
          city = c;
          break;
        }
      }
    }
    emit(state.copyWith(
      isLoadingCities: false,
      cities: cities,
      selectedCity: city,
    ));
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      final t = v?.trim();
      if (t != null && t.isNotEmpty) return t;
    }
    return null;
  }

  Future<void> selectGovernorate(Governate gov) async {
    emit(state.copyWith(
      selectedGovernorate: gov,
      selectedCity: null,
      cities: const [],
      isLoadingCities: true,
    ));
    final cities = await _locationRepo.getCities(gov.id!) ?? const [];
    emit(state.copyWith(isLoadingCities: false, cities: cities));
  }

  void selectCity(City city) => emit(state.copyWith(selectedCity: city));

  void selectOccasion(int id) => emit(state.copyWith(selectedOccasionId: id));

  void setCount(int value) => emit(state.copyWith(count: value));

  void setPrice(double value) => emit(state.copyWith(price: value));

  void setAvailableOnly(bool value) =>
      emit(state.copyWith(availableOnly: value));

  /// Clears the draft selections (keeps the loaded lists so they don't reload).
  /// Guests keep the unrestricted "جميع الخدمات" default.
  void clearSelections() => emit(PortsFilterState(
        governorates: state.governorates,
        occasions: state.occasions,
        availableOnly: _userService.currentUser != null,
      ));
}
