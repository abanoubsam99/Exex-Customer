import 'package:evex_user/data/models/addition.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/models/port_policy.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';

/// البيانات الجاية من شاشة تفاصيل الخدمة (اللي قبل استكمال الحجز) حسب اختيار
/// المستخدم.
class CompleteBookingArgs {
  final Item? port;
  final PortService? service;
  final List<Addition> additions;
  final double totalCost;

  /// Occasion date picked in the instant-booking filter (the reservation date).
  final DateTime? occasionDate;

  const CompleteBookingArgs({
    this.port,
    this.service,
    this.additions = const [],
    this.totalCost = 0,
    this.occasionDate,
  });
}

class CompleteBookingState {
  final bool isLoadingPolicy;
  final PortPolicy? policy;
  final bool termsAccepted;
  final bool isSubmitting;
  final String? errorMessage;

  /// Occasion types (نوع المناسبة) + the one the user picked.
  final List<Occasion> occasions;
  final int? selectedOccasionId;

  const CompleteBookingState({
    this.isLoadingPolicy = false,
    this.policy,
    this.termsAccepted = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.occasions = const [],
    this.selectedOccasionId,
  });

  CompleteBookingState copyWith({
    bool? isLoadingPolicy,
    PortPolicy? policy,
    bool? termsAccepted,
    bool? isSubmitting,
    String? errorMessage,
    List<Occasion>? occasions,
    int? selectedOccasionId,
  }) {
    return CompleteBookingState(
      isLoadingPolicy: isLoadingPolicy ?? this.isLoadingPolicy,
      policy: policy ?? this.policy,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      occasions: occasions ?? this.occasions,
      selectedOccasionId: selectedOccasionId ?? this.selectedOccasionId,
    );
  }
}
