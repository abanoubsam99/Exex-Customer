import 'package:evex_user/data/models/port_category_with_port_types.dart';
import 'package:evex_user/data/models/ports_respond_model.dart'
    show CheckReservationResponse;
import 'package:evex_user/data/models/special_offer.dart';
import 'package:evex_user/data/models/user_model.dart';

/// Lifecycle of an instant-booking availability check, so the UI can tell
/// "still checking" apart from "the check failed" (network/timeout). Without
/// this a failed check leaves [HomeState.availability] null forever and the
/// badge stays stuck on "جاري التحقق...".
enum AvailabilityStatus { idle, checking, done, failed }

class HomeState {
  final bool isLoadingPorts;
  final bool isLoadingOffers;
  final List<PortCategoryWithPortTypes> bookingPorts;
  final List<PortCategoryWithPortTypes> paymentPorts;
  final List<SpecialOffer> specialOffers;
  final PortCategoryWithPortTypes? selectedBookingPort;
  final PortTypeDto? selectedBookingPortType;
  final PortCategoryWithPortTypes? selectedPaymentPort;
  final PortTypeDto? selectedPaymentPortType;

  /// The occasion date the user picked in the instant-booking filter; reused
  /// as the reservation's occasionDate later in the flow.
  final DateTime? bookingDate;

  /// The event location (مكان المناسبة) picked in the edit sheet — defaults to
  /// the user's profile location and is sent with the availability check + the
  /// reservation. Null until the user edits it (UI falls back to the profile).
  final String? eventGovernorate;
  final String? eventCity;

  /// Instant-booking availability for the selected port + [bookingDate].
  final CheckReservationResponse? availability;

  /// Where the availability check currently is in its lifecycle. Lets the badge
  /// show a retry on failure instead of spinning forever (see [AvailabilityStatus]).
  final AvailabilityStatus availabilityStatus;

  /// Unread notifications count, shown as a badge on the home bell icon.
  final int unreadNotifications;

  /// The signed-in user, refreshed from GetUserData so the greeting shows the
  /// real name (the cached login user often only has the email in `userName`).
  final UserViewModel? currentUser;
  final String? errorMessage;

  const HomeState({
    this.isLoadingPorts = false,
    this.isLoadingOffers = false,
    this.bookingPorts = const [],
    this.paymentPorts = const [],
    this.specialOffers = const [],
    this.selectedBookingPort,
    this.selectedBookingPortType,
    this.selectedPaymentPort,
    this.selectedPaymentPortType,
    this.bookingDate,
    this.eventGovernorate,
    this.eventCity,
    this.availability,
    this.availabilityStatus = AvailabilityStatus.idle,
    this.unreadNotifications = 0,
    this.currentUser,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoadingPorts,
    bool? isLoadingOffers,
    List<PortCategoryWithPortTypes>? bookingPorts,
    List<PortCategoryWithPortTypes>? paymentPorts,
    List<SpecialOffer>? specialOffers,
    PortCategoryWithPortTypes? selectedBookingPort,
    PortTypeDto? selectedBookingPortType,
    PortCategoryWithPortTypes? selectedPaymentPort,
    PortTypeDto? selectedPaymentPortType,
    DateTime? bookingDate,
    String? eventGovernorate,
    String? eventCity,
    CheckReservationResponse? availability,
    AvailabilityStatus? availabilityStatus,
    bool clearAvailability = false,
    // Clear a whole section's selection (category + type). Used to keep the
    // instant-booking and direct-services sections mutually exclusive.
    bool clearBookingSelection = false,
    bool clearPaymentSelection = false,
    // Clear only the selected port type (keep the category). Used so picking a
    // category shows its type chips with none highlighted by default.
    bool clearBookingType = false,
    bool clearPaymentType = false,
    int? unreadNotifications,
    UserViewModel? currentUser,
    String? errorMessage,
  }) {
    return HomeState(
      isLoadingPorts: isLoadingPorts ?? this.isLoadingPorts,
      isLoadingOffers: isLoadingOffers ?? this.isLoadingOffers,
      bookingPorts: bookingPorts ?? this.bookingPorts,
      paymentPorts: paymentPorts ?? this.paymentPorts,
      specialOffers: specialOffers ?? this.specialOffers,
      selectedBookingPort: clearBookingSelection
          ? null
          : (selectedBookingPort ?? this.selectedBookingPort),
      selectedBookingPortType: (clearBookingSelection || clearBookingType)
          ? null
          : (selectedBookingPortType ?? this.selectedBookingPortType),
      selectedPaymentPort: clearPaymentSelection
          ? null
          : (selectedPaymentPort ?? this.selectedPaymentPort),
      selectedPaymentPortType: (clearPaymentSelection || clearPaymentType)
          ? null
          : (selectedPaymentPortType ?? this.selectedPaymentPortType),
      bookingDate: bookingDate ?? this.bookingDate,
      eventGovernorate: eventGovernorate ?? this.eventGovernorate,
      eventCity: eventCity ?? this.eventCity,
      availability:
          clearAvailability ? null : (availability ?? this.availability),
      availabilityStatus: clearAvailability
          ? AvailabilityStatus.idle
          : (availabilityStatus ?? this.availabilityStatus),
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
