import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/models/ports_respond_model.dart'
    show CheckReservationResponse;
import 'package:evex_user/data/models/reservation_update_model.dart';

/// Data passed to the edit-reservation screen.
class EditReservationArgs {
  final int reservationId;

  /// true → confirmed reservation (UpdateReservationByClient);
  /// false → pending request (UpdateReservationRequest).
  final bool isConfirmed;

  final int? portId;
  final int? serviceId;
  final int? occasionId;
  final String? governorate;
  final String? city;
  final DateTime? occasionDate;
  final String? userNotes;

  const EditReservationArgs({
    required this.reservationId,
    this.isConfirmed = false,
    this.portId,
    this.serviceId,
    this.occasionId,
    this.governorate,
    this.city,
    this.occasionDate,
    this.userNotes,
  });
}

/// Sentinel so copyWith can explicitly set the nullable selections back to null
/// (needed when the governorate changes and the city must be cleared).
const Object _unset = Object();

class EditReservationState {
  final bool isLoading;

  /// The current reservation (loaded from the bill) that we echo back on save.
  final ReservationUpdateModel? model;
  final DateTime? occasionDate;
  final bool isSaving;

  // ── Location ──
  final List<Governate> governorates;
  final List<City> cities;
  final Governate? selectedGovernorate;
  final City? selectedCity;
  final bool isLoadingCities;

  // ── Occasion ──
  final List<Occasion> occasions;
  final int? selectedOccasionId;

  // ── Additions ── available additions for the port + chosen counts (additionId → number).
  final List<AdditionModel> additions;
  final Map<int, int> additionCounts;

  // ── Availability of the selected date (CheckReservationAvailability) ──
  final CheckReservationResponse? availability;
  final bool isCheckingAvailability;

  const EditReservationState({
    this.isLoading = false,
    this.model,
    this.occasionDate,
    this.isSaving = false,
    this.governorates = const [],
    this.cities = const [],
    this.selectedGovernorate,
    this.selectedCity,
    this.isLoadingCities = false,
    this.occasions = const [],
    this.selectedOccasionId,
    this.additions = const [],
    this.additionCounts = const {},
    this.availability,
    this.isCheckingAvailability = false,
  });

  EditReservationState copyWith({
    bool? isLoading,
    ReservationUpdateModel? model,
    DateTime? occasionDate,
    bool? isSaving,
    List<Governate>? governorates,
    List<City>? cities,
    Object? selectedGovernorate = _unset,
    Object? selectedCity = _unset,
    bool? isLoadingCities,
    List<Occasion>? occasions,
    int? selectedOccasionId,
    List<AdditionModel>? additions,
    Map<int, int>? additionCounts,
    Object? availability = _unset,
    bool? isCheckingAvailability,
  }) {
    return EditReservationState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      occasionDate: occasionDate ?? this.occasionDate,
      isSaving: isSaving ?? this.isSaving,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      selectedGovernorate: selectedGovernorate == _unset
          ? this.selectedGovernorate
          : selectedGovernorate as Governate?,
      selectedCity:
          selectedCity == _unset ? this.selectedCity : selectedCity as City?,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
      occasions: occasions ?? this.occasions,
      selectedOccasionId: selectedOccasionId ?? this.selectedOccasionId,
      additions: additions ?? this.additions,
      additionCounts: additionCounts ?? this.additionCounts,
      availability: availability == _unset
          ? this.availability
          : availability as CheckReservationResponse?,
      isCheckingAvailability:
          isCheckingAvailability ?? this.isCheckingAvailability,
    );
  }
}
