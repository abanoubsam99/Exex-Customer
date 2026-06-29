import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_state.dart'
    show EditReservationArgs;
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/models/addition.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/reservation_update_model.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:evex_user/data/repos/favorites_repo.dart';
import 'package:evex_user/data/repos/my_bookings_repo.dart';
import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_service_details_state.dart';

class BookingServiceDetailsCubit extends Cubit<BookingServiceDetailsState> {
  final PortServicesRepo _repo;
  final FavoritesRepo _favoritesRepo;
  final HomeCubit _homeCubit;
  final ConfirmBookingRepo _confirmRepo;
  final BookingServicesPortsRepo _portsRepo;
  final MyBookingsRepo _bookingsRepo;

  /// When non-null the screen is in "edit" mode: it pre-fills an existing
  /// reservation's selections and the bottom button updates it in place.
  final EditReservationArgs? editArgs;

  /// [port] is the port selected on the previous screen. Its id drives the
  /// services/additions/reviews requests; the object feeds the header UI.
  /// [portId] is used when we only have the id (e.g. opening a special offer
  /// where no full [Item] is available).
  BookingServiceDetailsCubit(
    this._repo,
    this._favoritesRepo,
    this._homeCubit,
    this._confirmRepo,
    this._portsRepo,
    this._bookingsRepo, {
    Item? port,
    int? portId,
    this.editArgs,
  })  : _offerPortId = portId ?? editArgs?.portId,
        super(BookingServiceDetailsState(
          port: port,
          isEditMode: editArgs != null,
        )) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getPortImages();
      getOtherPorts();
      getOccasions();
      _checkConfirmedBooking();
      await getAllPortServices();
      await getAdditions();
      await getReviews();
      if (editArgs != null) {
        await _applyEdit(editArgs!);
      } else {
        _ensureAvailability();
      }
    });
  }

  /// Port id passed directly (without a full [Item]) — e.g. from an offer.
  final int? _offerPortId;

  /// The reservation bill echoed back on save (edit mode) + the existing
  /// addition row ids (additionId → row id) so the backend can diff on update.
  ReservationUpdateModel? _editBill;
  final Map<int, int> _existingAdditionRowIds = {};

  static const int _defaultPortId = 3;

  // Only real port ids feed this chain. A port-type id is NOT a port id, so the
  // selected booking type is never used here as a fallback.
  int get _portId =>
      state.port?.id ??
      _offerPortId ??
      _defaultPortId;

  /// The id of the port currently shown — used to build its share link.
  int get currentPortId => _portId;

  /// Toggles the favorite state of this port (optimistic; reverts on failure).
  Future<void> toggleFavorite() async {
    final id = state.port?.id;
    if (id == null) return;
    final wasFavorite = state.isFavorite;
    emit(state.copyWith(isFavorite: !wasFavorite));
    final response = wasFavorite
        ? await _favoritesRepo.removeFavorite(id)
        : await _favoritesRepo.addFavorite(id);
    // On failure the server error is already toasted by the dio interceptor.
    if (response == null) {
      emit(state.copyWith(isFavorite: wasFavorite));
    } else if (response.message != null && response.message!.isNotEmpty) {
      ToastManager.showSuccess(response.message!);
    }
  }

  /// Checks whether the user has a confirmed reservation for this port and
  /// updates [BookingServiceDetailsState.hasConfirmedBooking] accordingly.
  Future<void> _checkConfirmedBooking() async {
    final portId = _portId;
    final reservations = await _bookingsRepo.getMyReservations(size: 100);
    if (reservations == null) return;
    final has = reservations.any((r) => r.portId == portId);
    emit(state.copyWith(hasConfirmedBooking: has));
  }

  /// Loads the port's gallery from /api/Ports/GetPortImages and stores it on the
  /// state (the carousel prefers it over the port's inline images).
  Future<void> getPortImages() async {
    final images = await _repo.getPortImages(_portId);
    if (images != null && images.isNotEmpty) {
      emit(state.copyWith(portImages: images));
    }
  }

  /// Edit mode: loads the reservation bill and pre-fills the same selections the
  /// client made before (service + additions/buffet + occasion date), so the
  /// booking module opens autofilled. Runs after services/additions are loaded.
  Future<void> _applyEdit(EditReservationArgs args) async {
    final bill = await _confirmRepo.getReservationBill(
      args.reservationId,
      serviceId: args.serviceId,
      occasionId: args.occasionId,
    );
    _editBill = bill;

    // Header title + original slot (no full [Item] is passed when editing, so
    // the port name comes from the bill). The original date/place lets the
    // availability badge treat the user's own slot as available (see below).
    emit(state.copyWith(
      editPortName: bill?.portName,
      editOriginalDate: _parseBillDate(bill?.occasionDate) ?? args.occasionDate,
      editOriginalGovernorate: bill?.governorate ?? args.governorate,
      editOriginalCity: bill?.city ?? args.city,
    ));

    // Pre-select the occasion type that was on the reservation.
    if (bill != null && bill.occasionId > 0) {
      emit(state.copyWith(selectedOccasionId: bill.occasionId));
    }

    // Remember existing addition row ids for the diff on save.
    if (bill != null) {
      for (final a in bill.oldAdditions) {
        final additionId = (a['additionId'] as num?)?.toInt() ?? 0;
        final rowId = (a['id'] as num?)?.toInt() ?? 0;
        if (additionId > 0 && rowId > 0) {
          _existingAdditionRowIds[additionId] = rowId;
        }
      }
    }

    // Seed the original date + place onto HomeCubit so the header shows the
    // reservation's own date/governorate/city. We deliberately DON'T call
    // checkAvailability here: this is the user's own slot, so ChangeOccasion
    // shows it as available directly (see _isOwnOriginalSlot). Availability is
    // only re-checked from the edit sheet when the user changes the date/place.
    final date = _parseBillDate(bill?.occasionDate) ?? args.occasionDate;
    final gov = bill?.governorate ?? args.governorate;
    final city = bill?.city ?? args.city;
    if (date != null) {
      _homeCubit.setBookingDate(date);
      // Always reset the event location to the reservation's own one (even if
      // empty), so a stale value from a previous flow can't break the
      // "own original slot" comparison below and leave the badge stuck on
      // "جاري التحقق".
      _homeCubit.setEventLocation(gov ?? '', city ?? '');
    }

    // Pre-select the booked base service so its price seeds the total. The bill
    // doesn't always carry a serviceId (e.g. coming from order details), so we
    // match by id first, then fall back to matching by the service name.
    final targetServiceId = args.serviceId ?? bill?.serviceId ?? 0;
    final targetServiceName = bill?.serviceName?.trim() ?? '';
    PortService? matchedService;
    if (targetServiceId > 0) {
      for (final s in state.services) {
        if (s.id == targetServiceId) {
          matchedService = s;
          break;
        }
      }
    }
    if (matchedService == null && targetServiceName.isNotEmpty) {
      final target = targetServiceName.toLowerCase();
      for (final s in state.services) {
        if ((s.name ?? '').trim().toLowerCase() == target) {
          matchedService = s;
          break;
        }
      }
    }
    // Last resort: if the reservation has exactly one base service to choose
    // from, pre-select it so the total isn't stuck at 0 in edit mode.
    matchedService ??= state.services.length == 1 ? state.services.first : null;
    if (matchedService != null) {
      emit(state.copyWith(selectedService: matchedService));
      await getServiceData();
    }

    // Pre-select the additions/buffet that were on the reservation.
    final billCounts = <int, int>{};
    if (bill != null) {
      for (final a in bill.additions) {
        final id = (a['additionId'] as num?)?.toInt() ?? 0;
        final n = (a['number'] as num?)?.toInt() ?? 0;
        if (id > 0 && n > 0) billCounts[id] = n;
      }
    }
    final selAdds = <AdditionModel>[];
    for (final a in state.additions) {
      final id = a.id;
      final n = id == null ? null : billCounts[id];
      if (n != null && n > 0) {
        a.count = n;
        selAdds.add(a);
      }
    }
    final selBuffets = <AdditionModel>[];
    for (final b in state.buffets) {
      final id = b.id;
      final n = id == null ? null : billCounts[id];
      if (n != null && n > 0) {
        b.count = n;
        selBuffets.add(b);
      }
    }
    emit(state.copyWith(selectedAdditions: selAdds, selectedBuffets: selBuffets));
    _recalcTotal();
  }

  /// Edit mode: applies the chosen base service + additions onto the echoed
  /// bill and returns it, so the complete-booking screen can finalize the
  /// occasion/date/notes and update the reservation in place (same flow as a
  /// new booking, with payment + policies + notes). Returns null when the bill
  /// or a base service isn't ready yet.
  ReservationUpdateModel? prepareEditBill() {
    final bill = _editBill;
    if (bill == null) {
      ToastManager.showError('تعذّر تحميل بيانات الحجز، حاول مرة أخرى');
      return null;
    }
    if (state.selectedService == null) {
      ToastManager.showError('من فضلك اختر خدمة أولاً');
      return null;
    }

    bill.serviceId = state.selectedService!.id;
    bill.additions = [...state.selectedAdditions, ...state.selectedBuffets]
        .where((a) => a.id != null && (a.count ?? 0) > 0)
        .map((a) => {
              'id': _existingAdditionRowIds[a.id] ?? 0,
              'number': a.count ?? 1,
              'additionId': a.id,
            })
        .toList();
    return bill;
  }

  /// Parses the bill's M/d/yyyy occasion date (ignores any trailing time).
  static DateTime? _parseBillDate(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final parts = s.split('/');
    if (parts.length == 3) {
      final m = int.tryParse(parts[0].trim());
      final d = int.tryParse(parts[1].trim());
      final y = int.tryParse(parts[2].trim().split(' ').first);
      if (m != null && d != null && y != null) return DateTime(y, m, d);
    }
    return DateTime.tryParse(s);
  }

  /// Loads occasion types (نوع المناسبة) for the picker on this screen.
  Future<void> getOccasions() async {
    final occasions = await _confirmRepo.getOccasions();
    if (occasions != null) emit(state.copyWith(occasions: occasions));
  }

  /// Sets the chosen occasion type (mandatory before adding to bookings).
  void selectOccasion(int id) => emit(state.copyWith(selectedOccasionId: id));

  /// Checks instant-booking availability when the screen opens with a date
  /// already picked (otherwise the status line would stay on "جاري التحقق").
  Future<void> _ensureAvailability() async {
    final date = _homeCubit.state.bookingDate;
    if (date == null || _homeCubit.state.availability != null) return;
    final portId = _portId;
    if (portId <= 0) return;
    _homeCubit.setAvailability(
      await _confirmRepo.checkAvailability(
        portId: portId,
        date: date,
        governorate: _homeCubit.state.eventGovernorate,
        city: _homeCubit.state.eventCity,
      ),
    );
  }

  /// Loads other ports owned by the same vendor for the "خدمات أخرى" section
  /// via /api/Ports/Filter?companyId=. Needs the current port's companyId, so
  /// it's skipped when we only have a portId (offer/edit/deep-link).
  Future<void> getOtherPorts() async {
    final companyId = state.port?.companyId;
    if (companyId == null) return;
    final model =
        await _portsRepo.getAllPortServices(GetPortsRequest(companyId: companyId));
    final items = model?.items;
    if (items == null) return;
    // Drop the port currently being viewed from the list.
    final currentId = state.port?.id;
    emit(state.copyWith(
      otherPorts: items.where((p) => p.id != currentId).toList(),
    ));
  }

  Future<void> getAllPortServices() async {
    emit(state.copyWith(isLoading: true, services: []));
    final services = await _repo.getAllPortServices(_portId);
    if (services != null) {
      emit(state.copyWith(isLoading: false, services: services));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  Future<void> getAdditions() async {
    emit(state.copyWith(
      isLoading: true,
      additions: [],
      buffets: [],
      selectedAdditions: [],
      selectedBuffets: [],
    ));
    final all = await _repo.getAdditions(_portId);
    if (all != null) {
      final additions = all.where((a) => a.specificToBuffet != true).toList();
      final buffets = all.where((a) => a.specificToBuffet == true).toList();
      emit(state.copyWith(isLoading: false, additions: additions, buffets: buffets));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  Future<void> getReviews() async {
    final reviews = await _repo.getReviews(_portId);
    if (reviews != null) {
      emit(state.copyWith(reviews: reviews));
    }
  }

  void selectService(PortService service) {
    emit(state.copyWith(selectedService: service));
    getServiceData();
  }

  Future<void> getServiceData() async {
    if (state.selectedService == null) return;
    emit(state.copyWith(isLoading: true));
    final details = await _repo.getServiceData(state.selectedService!.id);
    if (details != null) {
      emit(state.copyWith(isLoading: false, serviceDetails: details));
      _recalcTotal();
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  void toggleAddition(AdditionModel model) {
    final updated = List<AdditionModel>.from(state.selectedAdditions);
    if (updated.any((e) => e.id == model.id)) {
      updated.removeWhere((e) => e.id == model.id);
    } else {
      updated.add(model);
    }
    emit(state.copyWith(selectedAdditions: updated));
    _recalcTotal();
  }

  void toggleBuffet(AdditionModel model) {
    final updated = List<AdditionModel>.from(state.selectedBuffets);
    if (updated.any((e) => e.id == model.id)) {
      updated.removeWhere((e) => e.id == model.id);
    } else {
      updated.add(model);
    }
    emit(state.copyWith(selectedBuffets: updated));
    _recalcTotal();
  }

  void changeAdditionCount(AdditionModel model, int count) {
    final updated = List<AdditionModel>.from(state.selectedAdditions);
    final i = updated.indexWhere((e) => e.id == model.id);
    if (i == -1) {
      updated.add(model..count = count);
    } else {
      updated[i] = model..count = count;
    }
    emit(state.copyWith(selectedAdditions: updated));
    _recalcTotal();
  }

  void changeBuffetCount(AdditionModel model, int count) {
    final updated = List<AdditionModel>.from(state.selectedBuffets);
    final i = updated.indexWhere((e) => e.id == model.id);
    if (i == -1) {
      updated.add(model..count = count);
    } else {
      updated[i] = model..count = count;
    }
    emit(state.copyWith(selectedBuffets: updated));
    _recalcTotal();
  }

  void _recalcTotal() {
    // Prefer the detailed price; fall back to the selected service's own price
    // so the total still reflects the base service if its details didn't load.
    double cost = (state.serviceDetails?.price ?? state.selectedService?.price)
            ?.toDouble() ??
        0;
    final oldGiftIds =
        state.serviceDetails?.oldGifts?.map((e) => e.id).toSet() ?? {};

    for (final a in [...state.selectedAdditions, ...state.selectedBuffets]) {
      if (a.displayNumber == false && oldGiftIds.contains(a.id)) continue;
      cost += (a.count ?? 1) * (a.price?.toDouble() ?? 1);
    }
    emit(state.copyWith(totalCost: cost));
  }

  List<Addition> prepareFinalAdditions() {
    final giftIds =
        state.serviceDetails?.oldGifts?.map((e) => e.id).toSet() ?? {};
    return [
      ...state.selectedAdditions,
      ...state.selectedBuffets,
    ]
        .where(
          (a) =>
              ((a.count ?? 0) > 0 && a.displayNumber == true) ||
              (a.displayNumber == false && !giftIds.contains(a.id)),
        )
        .map(
          (e) => Addition(
            name: e.name,
            additionId: e.id,
            id: e.id,
            number: e.count,
          ),
        )
        .toList();
  }

  bool checkGift(int additionId) =>
      state.serviceDetails?.oldGifts?.any((e) => e.additionId == additionId) ==
      true;

  bool checkSelection(int additionId) =>
      state.selectedAdditions.any((e) => e.id == additionId) ||
      state.selectedBuffets.any((e) => e.id == additionId);
}
