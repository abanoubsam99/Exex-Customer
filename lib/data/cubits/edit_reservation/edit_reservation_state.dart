/// Data passed to the edit-reservation screen to prefill the form.
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
  final DateTime? occasionDate;
  final bool isSaving;

  const EditReservationState({this.occasionDate, this.isSaving = false});

  EditReservationState copyWith({DateTime? occasionDate, bool? isSaving}) {
    return EditReservationState(
      occasionDate: occasionDate ?? this.occasionDate,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
