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

class EditReservationState {
  final bool isLoading;

  /// The current reservation (loaded from the bill) that we echo back on save.
  final ReservationUpdateModel? model;
  final DateTime? occasionDate;
  final bool isSaving;

  const EditReservationState({
    this.isLoading = false,
    this.model,
    this.occasionDate,
    this.isSaving = false,
  });

  EditReservationState copyWith({
    bool? isLoading,
    ReservationUpdateModel? model,
    DateTime? occasionDate,
    bool? isSaving,
  }) {
    return EditReservationState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      occasionDate: occasionDate ?? this.occasionDate,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
