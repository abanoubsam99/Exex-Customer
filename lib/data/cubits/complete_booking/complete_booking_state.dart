import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_state.dart'
    show EditReservationArgs;
import 'package:evex_user/data/models/addition.dart';
import 'package:evex_user/data/models/net_cost_model.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/models/port_policy.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/reservation_update_model.dart';

/// البيانات الجاية من شاشة تفاصيل الخدمة (اللي قبل استكمال الحجز) حسب اختيار
/// المستخدم.
class CompleteBookingArgs {
  final Item? port;
  final PortService? service;
  final List<Addition> additions;
  final double totalCost;

  /// Occasion date picked in the instant-booking filter (the reservation date).
  final DateTime? occasionDate;

  /// Occasion type (نوع المناسبة) chosen on the service-details screen.
  final int? occasionId;

  /// Set when this screen is reached to confirm an *edit* of an existing
  /// reservation (rather than create a new one). When non-null the bottom
  /// button updates the reservation in place and reads "تعديل الحجز".
  final EditReservationArgs? editArgs;

  /// The echoed reservation bill (with the chosen service + additions already
  /// applied) that we update in place on confirm. Only set in edit mode.
  final ReservationUpdateModel? editBill;

  /// Port id used for policy/net-cost lookups when no full [port] is available
  /// (edit mode opens without an [Item]).
  final int? portId;

  /// The reservation's original date/place — lets the availability badge treat
  /// the user's own unchanged slot as available in edit mode.
  final DateTime? editOriginalDate;
  final String? editOriginalGovernorate;
  final String? editOriginalCity;

  const CompleteBookingArgs({
    this.port,
    this.service,
    this.additions = const [],
    this.totalCost = 0,
    this.occasionDate,
    this.occasionId,
    this.editArgs,
    this.editBill,
    this.portId,
    this.editOriginalDate,
    this.editOriginalGovernorate,
    this.editOriginalCity,
  });

  /// True when this screen confirms an edit instead of creating a booking.
  bool get isEditMode => editArgs != null;
}

class CompleteBookingState {
  final bool isLoadingPolicy;
  final PortPolicy? policy;
  final bool termsAccepted;
  final bool isSubmitting;

  /// نوع المناسبة options + the chosen one — shown in the same edit sheet as the
  /// service-details screen so both stay identical.
  final List<Occasion> occasions;
  final int? selectedOccasionId;

  /// Cost breakdown (عمولة/رسوم/ضريبة/مقدم) from CalculateNetCost — drives the
  /// "تفاصيل تكلفة الخدمة" section so nothing there is hardcoded.
  final NetCostModel? netCost;
  final String? errorMessage;

  const CompleteBookingState({
    this.isLoadingPolicy = false,
    this.policy,
    this.termsAccepted = false,
    this.isSubmitting = false,
    this.occasions = const [],
    this.selectedOccasionId,
    this.netCost,
    this.errorMessage,
  });

  CompleteBookingState copyWith({
    bool? isLoadingPolicy,
    PortPolicy? policy,
    bool? termsAccepted,
    bool? isSubmitting,
    List<Occasion>? occasions,
    int? selectedOccasionId,
    NetCostModel? netCost,
    String? errorMessage,
  }) {
    return CompleteBookingState(
      isLoadingPolicy: isLoadingPolicy ?? this.isLoadingPolicy,
      policy: policy ?? this.policy,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      occasions: occasions ?? this.occasions,
      selectedOccasionId: selectedOccasionId ?? this.selectedOccasionId,
      netCost: netCost ?? this.netCost,
      errorMessage: errorMessage,
    );
  }
}
