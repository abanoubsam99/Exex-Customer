import 'dart:async';

import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_state.dart'
    show EditReservationArgs;
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/data/models/addition.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/models/reservation_update_model.dart';
import 'package:evex_user/core/services/user_service.dart';
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
  final UserService _userService;

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
    this._bookingsRepo,
    this._userService, {
    Item? port,
    int? portId,
    int? autoSelectServiceId,
    this.editArgs,
  })  : _offerPortId = portId ?? editArgs?.portId,
        _autoSelectServiceId = autoSelectServiceId,
        super(BookingServiceDetailsState(
          port: port,
          isEditMode: editArgs != null,
          // Seed the header title/date/place from the list item right away, so
          // the screen isn't blank while the port + bill load (and stays filled
          // for a pending request whose bill 404s).
          editPortName: editArgs?.portName,
          editOriginalDate: editArgs?.occasionDate,
          editOriginalGovernorate: editArgs?.governorate,
          editOriginalCity: editArgs?.city,
        )) {
    // Availability lives on HomeCubit (it's shared with the header badge), so
    // watch it to drop a selected service the picked date no longer allows.
    _lastAvailability = _homeCubit.state.availability;
    _homeSub = _homeCubit.stream.listen((s) {
      if (identical(s.availability, _lastAvailability)) return;
      _lastAvailability = s.availability;
      _dropUnavailableSelection();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  /// Loads (or reloads) everything the screen shows: the port header, images,
  /// other ports, occasions, services, additions and reviews — then restores
  /// the right selection (edit-mode reservation, or the first service).
  Future<void> _loadAll() async {
    await _ensurePortLoaded();
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
      _autoSelectInitialService();
      _ensureAvailability();
    }
  }

  /// Pull-to-refresh entry point — re-fetches all of the screen's data.
  Future<void> refresh() => _loadAll();

  /// Watches [HomeCubit] for a new availability response.
  late final StreamSubscription<HomeState> _homeSub;
  CheckReservationResponse? _lastAvailability;

  @override
  Future<void> close() {
    _homeSub.cancel();
    return super.close();
  }

  /// Whether the service [serviceId] can be booked on the picked date.
  /// The backend answers per-service through `unreservedServices`; while there's
  /// no availability yet (no date picked, or the check is still running) every
  /// service reads as available.
  bool isServiceAvailable(int? serviceId) {
    final av = _homeCubit.state.availability;
    if (av == null) return true;
    return av.allowsService(serviceId);
  }

  /// Clears the selected service (and its details/total) once a new availability
  /// response says it's no longer bookable, so an unavailable service can never
  /// be carried into the booking.
  void _dropUnavailableSelection() {
    final selected = state.selectedService;
    if (selected == null || isServiceAvailable(selected.id)) return;
    emit(state.copyWith(clearSelectedService: true, clearServiceDetails: true));
    _recalcTotal();
    // Never leave the screen with nothing selected — move to the first service
    // the new date does allow. Edit mode keeps the reservation's own service,
    // so it's left cleared for the user to re-pick.
    if (!state.isEditMode) _autoSelectInitialService();
  }

  /// Port id passed directly (without a full [Item]) — e.g. from an offer.
  final int? _offerPortId;

  /// Service id to auto-select when the screen opens from a special offer, so
  /// the offered service (and its gift additions) is pre-selected without the
  /// user tapping it.
  final int? _autoSelectServiceId;

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
  ///
  /// Defaults the event location to the signed-in user's profile area when the
  /// user hasn't picked one yet, so the check (and the header) reflect the real
  /// location — an out-of-area default then reads as "غير متاح في هذه المنطقة"
  /// instead of a false "متاح", and can't be added to bookings.
  Future<void> _ensureAvailability() async {
    final date = _homeCubit.state.bookingDate;
    if (date == null) return;
    final portId = _portId;
    if (portId <= 0) return;

    final user = _userService.currentUser?.userViewModel;
    final gov =
        _firstNonEmpty([_homeCubit.state.eventGovernorate, user?.governorate]);
    final city = _firstNonEmpty([_homeCubit.state.eventCity, user?.city]);
    if ((gov ?? '').isNotEmpty) {
      _homeCubit.setEventLocation(gov!, city ?? '');
    }

    _homeCubit.setAvailabilityChecking();
    _homeCubit.setAvailability(
      await _confirmRepo.checkAvailability(
        portId: portId,
        date: date,
        governorate: gov,
        city: city,
      ),
    );
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      final t = v?.trim();
      if (t != null && t.isNotEmpty) return t;
    }
    return null;
  }

  /// Always loads the full, fresh port from /api/Ports/Filter?Id= and seeds it
  /// (name, rating, description, working area, favorite flag, …) onto the state.
  ///
  /// The header data must come from the backend — not from whatever partial
  /// [Item] the previous screen happened to pass — so it's correct and current
  /// (e.g. the favorite state) regardless of the entry point (ports list,
  /// special offer, shared deep link, or the edit flow from حجوزاتي).
  Future<void> _ensurePortLoaded() async {
    final id = state.port?.id ?? _offerPortId;
    if (id == null || id <= 0) {
      // No id at all — keep whatever the caller passed and read its fav flag.
      _seedFavoriteFromPort();
      return;
    }
    final model = await _portsRepo.getAllPortServices(GetPortsRequest(id: id));
    final items = model?.items;
    if (items == null || items.isEmpty) {
      // Fetch failed — fall back to the passed-in [Item] so the header isn't
      // blank, and still surface its favorite flag if it has one.
      _seedFavoriteFromPort();
      return;
    }
    final match = items.firstWhere((p) => p.id == id, orElse: () => items.first);
    emit(state.copyWith(port: match, isFavorite: match.isFavorite ?? false));
  }

  /// Seeds [BookingServiceDetailsState.isFavorite] from the current port.
  void _seedFavoriteFromPort() {
    final fav = state.port?.isFavorite;
    if (fav != null) emit(state.copyWith(isFavorite: fav));
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

  /// Selects a base service. Returns false (and toasts) when the picked date
  /// doesn't allow it, so the caller doesn't open its details sheet.
  bool selectService(PortService service) {
    if (!isServiceAvailable(service.id)) {
      ToastManager.showError('هذه الخدمة غير متاحة فى هذا اليوم');
      return false;
    }
    emit(state.copyWith(selectedService: service));
    getServiceData();
    return true;
  }

  /// The screen never opens without a selected service:
  ///   • from a special offer → the offered service ([_autoSelectServiceId]).
  ///     Selecting it loads its details, which surfaces the free gift additions
  ///     as already selected via [checkGift].
  ///   • from the ports list  → the first service (the right-most card in RTL).
  /// Skips services the picked date doesn't allow, and never toasts — this runs
  /// without the user tapping anything.
  void _autoSelectInitialService() {
    if (state.selectedService != null || state.services.isEmpty) return;
    final id = _autoSelectServiceId;
    PortService? match;
    if (id != null && id > 0) {
      for (final s in state.services) {
        if (s.id == id) {
          match = s;
          break;
        }
      }
    }
    // The offered service can be booked out on the picked date — fall back to
    // the first one that isn't.
    if (match != null && !isServiceAvailable(match.id)) match = null;
    match ??= _firstAvailableService();
    if (match == null) return;
    emit(state.copyWith(selectedService: match));
    getServiceData();
  }

  /// The first service bookable on the picked date, or null when none is.
  PortService? _firstAvailableService() {
    for (final s in state.services) {
      if (isServiceAvailable(s.id)) return s;
    }
    return null;
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
    // Base cost = the selected service's price after discount — the same value
    // the service card shows as its live price. The detailed model has no
    // discount field, so prefer the service's discounted price; fall back to
    // the detailed/full price only when there is no discounted value.
    double cost = (state.selectedService?.priceAfterDiscount ??
                state.serviceDetails?.price ??
                state.selectedService?.price)
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
