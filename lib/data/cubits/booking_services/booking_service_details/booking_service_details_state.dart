import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/review.dart';
import 'package:evex_user/data/models/service_details_model.dart';

class BookingServiceDetailsState {
  final bool isLoading;
  final Item? port;
  final bool isFavorite;

  /// Gallery image paths fetched from /api/Ports/GetPortImages — preferred over
  /// the (often empty) [Item.portImages] that comes with the ports list.
  final List<String> portImages;
  final List<PortService> services;
  final PortService? selectedService;
  final List<AdditionModel> additions;
  final List<AdditionModel> selectedAdditions;
  final List<AdditionModel> buffets;
  final List<AdditionModel> selectedBuffets;
  final ServiceDetailsModel? serviceDetails;
  final List<Review> reviews;

  /// Other ports owned by the same vendor (companyId) — shown in the
  /// "خدمات أخرى" section. Loaded from /api/Ports/Filter?companyId=.
  final List<Item> otherPorts;

  /// Occasion types (نوع المناسبة) + the one the user picked. The selection is
  /// mandatory before "إضافة لحجوزاتي" and is passed on to the booking request.
  final List<Occasion> occasions;
  final int? selectedOccasionId;
  final double totalCost;

  /// Edit mode: the screen pre-fills an existing reservation and the bottom
  /// button confirms the edit (update in place) instead of adding a new booking.
  final bool isEditMode;

  /// Edit mode: the reservation's port name from the bill — used for the header
  /// title because no full [Item] (with [Item.portName]) is passed when editing.
  final String? editPortName;

  /// Edit mode: true when editing a confirmed reservation, false for a pending
  /// request. Only a confirmed reservation already occupies its slot, so only
  /// then is the availability check skipped for the original date/place.
  final bool editIsConfirmed;

  /// Edit mode: the reservation's original date/place. While editing a confirmed
  /// reservation, if the user keeps the same date + governorate + city, the
  /// conflicting slot is the user's own, so no availability verdict is shown.
  final DateTime? editOriginalDate;
  final String? editOriginalGovernorate;
  final String? editOriginalCity;

  /// True while the edit is being saved (update API in flight).
  final bool isSaving;
  final String? errorMessage;


  const BookingServiceDetailsState({
    this.isLoading = false,
    this.port,
    this.isFavorite = false,
    this.portImages = const [],
    this.services = const [],
    this.isEditMode = false,
    this.editIsConfirmed = false,
    this.editPortName,
    this.editOriginalDate,
    this.editOriginalGovernorate,
    this.editOriginalCity,
    this.isSaving = false,
    this.selectedService,
    this.additions = const [],
    this.selectedAdditions = const [],
    this.buffets = const [],
    this.selectedBuffets = const [],
    this.serviceDetails,
    this.reviews = const [],
    this.otherPorts = const [],
    this.occasions = const [],
    this.selectedOccasionId,
    this.totalCost = 0.0,
    this.errorMessage,
  });

  BookingServiceDetailsState copyWith({
    bool? isLoading,
    Item? port,
    bool? isFavorite,
    List<String>? portImages,
    List<PortService>? services,
    PortService? selectedService,
    List<AdditionModel>? additions,
    List<AdditionModel>? selectedAdditions,
    List<AdditionModel>? buffets,
    List<AdditionModel>? selectedBuffets,
    ServiceDetailsModel? serviceDetails,
    List<Review>? reviews,
    List<Item>? otherPorts,
    List<Occasion>? occasions,
    int? selectedOccasionId,
    double? totalCost,
    bool? isEditMode,
    bool? editIsConfirmed,
    String? editPortName,
    DateTime? editOriginalDate,
    String? editOriginalGovernorate,
    String? editOriginalCity,
    bool? isSaving,
    String? errorMessage,
    // Nullable fields can't be reset through `??`, so clearing them is explicit.
    bool clearSelectedService = false,
    bool clearServiceDetails = false,
  }) {
    return BookingServiceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      port: port ?? this.port,
      isFavorite: isFavorite ?? this.isFavorite,
      portImages: portImages ?? this.portImages,
      services: services ?? this.services,
      selectedService: clearSelectedService
          ? null
          : (selectedService ?? this.selectedService),
      additions: additions ?? this.additions,
      selectedAdditions: selectedAdditions ?? this.selectedAdditions,
      buffets: buffets ?? this.buffets,
      selectedBuffets: selectedBuffets ?? this.selectedBuffets,
      serviceDetails:
          clearServiceDetails ? null : (serviceDetails ?? this.serviceDetails),
      reviews: reviews ?? this.reviews,
      otherPorts: otherPorts ?? this.otherPorts,
      occasions: occasions ?? this.occasions,
      selectedOccasionId: selectedOccasionId ?? this.selectedOccasionId,
      totalCost: totalCost ?? this.totalCost,
      isEditMode: isEditMode ?? this.isEditMode,
      editIsConfirmed: editIsConfirmed ?? this.editIsConfirmed,
      editPortName: editPortName ?? this.editPortName,
      editOriginalDate: editOriginalDate ?? this.editOriginalDate,
      editOriginalGovernorate:
          editOriginalGovernorate ?? this.editOriginalGovernorate,
      editOriginalCity: editOriginalCity ?? this.editOriginalCity,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
