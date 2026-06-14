import 'package:evex_user/data/models/port_category_with_port_types.dart';
import 'package:evex_user/data/models/ports_respond_model.dart'
    show CheckReservationResponse;
import 'package:evex_user/data/models/special_offer.dart';

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

  /// Instant-booking availability for the selected port + [bookingDate].
  final CheckReservationResponse? availability;
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
    this.availability,
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
    CheckReservationResponse? availability,
    bool clearAvailability = false,
    String? errorMessage,
  }) {
    return HomeState(
      isLoadingPorts: isLoadingPorts ?? this.isLoadingPorts,
      isLoadingOffers: isLoadingOffers ?? this.isLoadingOffers,
      bookingPorts: bookingPorts ?? this.bookingPorts,
      paymentPorts: paymentPorts ?? this.paymentPorts,
      specialOffers: specialOffers ?? this.specialOffers,
      selectedBookingPort: selectedBookingPort ?? this.selectedBookingPort,
      selectedBookingPortType:
          selectedBookingPortType ?? this.selectedBookingPortType,
      selectedPaymentPort: selectedPaymentPort ?? this.selectedPaymentPort,
      selectedPaymentPortType:
          selectedPaymentPortType ?? this.selectedPaymentPortType,
      bookingDate: bookingDate ?? this.bookingDate,
      availability:
          clearAvailability ? null : (availability ?? this.availability),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
