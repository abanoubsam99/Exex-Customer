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

  PortsFilterCubit(this._locationRepo, this._bookingRepo)
      : super(const PortsFilterState()) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final govsF = _locationRepo.getGovernorates();
    final occasionsF = _bookingRepo.getOccasions();
    final govs = await govsF ?? const [];
    final occasions = await occasionsF ?? const [];
    emit(state.copyWith(
      isLoading: false,
      governorates: govs,
      occasions: occasions,
    ));
  }

  Future<void> selectGovernorate(Governate gov) async {
    emit(state.copyWith(
      selectedGovernorate: gov,
      selectedCity: null,
      cities: const [],
      isLoadingCities: true,
    ));
    final cities = await _locationRepo.getCities(gov.id) ?? const [];
    emit(state.copyWith(isLoadingCities: false, cities: cities));
  }

  void selectCity(City city) => emit(state.copyWith(selectedCity: city));

  void selectOccasion(int id) => emit(state.copyWith(selectedOccasionId: id));

  /// Clears the draft selections (keeps the loaded lists so they don't reload).
  void clearSelections() => emit(PortsFilterState(
        governorates: state.governorates,
        occasions: state.occasions,
      ));
}
