import 'dart:convert';

import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/data/models/port_category_with_port_types.dart';
import 'package:evex_user/data/models/ports_respond_model.dart'
    show CheckReservationResponse;
import 'package:evex_user/data/models/special_offer.dart';
import 'package:evex_user/data/repos/home_repo.dart';
import 'package:evex_user/data/repos/notifications_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;
  final NotificationsRepo _notificationsRepo;
  final UserService _userService;
  final LocationService _locationService;
  final CacheHelper _cacheHelper;

  HomeCubit(
    this._homeRepo,
    this._notificationsRepo,
    this._userService,
    this._locationService,
    this._cacheHelper,
  ) : super(const HomeState());

  /// Clears all home state so the next signed-in account starts fresh.
  void reset() => emit(const HomeState());

  Future<void> init() async {
    await Future.wait([
      getHomeUserAppInfo(),
      getSpecialOffers(),
      loadUnreadNotifications(),
    ]);
  }

  /// Loads the unread-notifications count for the bell badge. Skipped for guests
  /// (the endpoint needs auth); keeps the old value on failure (repo returns
  /// null).
  Future<void> loadUnreadNotifications() async {
    if (_userService.currentUser == null) return;
    final count = await _notificationsRepo.getUnreadCount();
    if (count != null) emit(state.copyWith(unreadNotifications: count));
  }

  /// Resets the badge to zero — called when the user opens the notifications
  /// screen, which marks everything as read on the server.
  void clearUnreadNotifications() =>
      emit(state.copyWith(unreadNotifications: 0));

  Future<void> getHomeUserAppInfo() async {
    // Stale-while-revalidate: paint the last cached categories immediately so a
    // returning user sees content at once instead of a multi-second shimmer,
    // then refresh from the network in the background. Only the very first
    // launch (no cache) shows the shimmer.
    final cached = _readCachedPorts();
    if (cached != null) {
      _emitPorts(cached, isLoading: false);
    } else {
      emit(state.copyWith(isLoadingPorts: true));
    }

    final ports = await _homeRepo.getHomeUserAppInfo(
      gov: _locationService.govName,
      city: _locationService.cityName,
    );
    if (ports != null) {
      _cachePorts(ports);
      _emitPorts(ports, isLoading: false);
    } else {
      // Network failed: stop the shimmer but keep any cached content visible.
      emit(state.copyWith(
        isLoadingPorts: false,
        errorMessage: cached == null ? 'حدث خطأ' : null,
      ));
    }
  }

  /// Splits ports into booking/payment lists and defaults the selection to the
  /// first category (keeping the user's pick across refreshes), then emits.
  void _emitPorts(
    List<PortCategoryWithPortTypes> ports, {
    required bool isLoading,
  }) {
    final booking = ports.where((p) => p.subscriptionType == 0).toList();
    final payment = ports.where((p) => p.subscriptionType == 1).toList();

    // The two sections are mutually exclusive. On a fresh launch (nothing
    // selected yet) default to the first booking category so its types open
    // below it; the direct-services section starts with no selection. We never
    // auto-select a payment category, and a background refresh keeps whatever
    // the user currently has selected.
    final hasSelection =
        state.selectedBookingPort != null || state.selectedPaymentPort != null;
    var selBooking = state.selectedBookingPort;
    var selBookingType = state.selectedBookingPortType;
    if (!hasSelection && booking.isNotEmpty) {
      selBooking = booking.first;
      selBookingType = booking.first.portTypeDtos.isNotEmpty
          ? booking.first.portTypeDtos.first
          : null;
    }

    emit(state.copyWith(
      isLoadingPorts: isLoading,
      bookingPorts: booking,
      paymentPorts: payment,
      selectedBookingPort: selBooking,
      selectedBookingPortType: selBookingType,
      // Payment selection is left exactly as-is (null on first launch).
    ));
  }

  Future<void> getSpecialOffers() async {
    // Same stale-while-revalidate strategy as the categories above.
    final cached = _readCachedOffers();
    if (cached != null) {
      emit(state.copyWith(isLoadingOffers: false, specialOffers: cached));
    } else {
      emit(state.copyWith(isLoadingOffers: true));
    }

    final offers = await _homeRepo.getSpecialOffers(
      gov: _locationService.govName,
      city: _locationService.cityName,
    );
    if (offers != null) {
      _cacheOffers(offers);
      emit(state.copyWith(isLoadingOffers: false, specialOffers: offers));
    } else {
      emit(state.copyWith(
        isLoadingOffers: false,
        errorMessage: cached == null ? 'حدث خطأ' : null,
      ));
    }
  }

  // ── Home payload cache (stale-while-revalidate) ──
  List<PortCategoryWithPortTypes>? _readCachedPorts() {
    final raw = _cacheHelper.getData(CacheKeys.homePorts) as String?;
    if (raw == null || raw.isEmpty) return null;
    try {
      return (jsonDecode(raw) as List)
          .map((e) => PortCategoryWithPortTypes.fromJson(e))
          .toList();
    } catch (_) {
      return null;
    }
  }

  void _cachePorts(List<PortCategoryWithPortTypes> ports) {
    _cacheHelper.saveData(
      key: CacheKeys.homePorts,
      value: jsonEncode(ports.map((e) => e.toJson()).toList()),
    );
  }

  List<SpecialOffer>? _readCachedOffers() {
    final raw = _cacheHelper.getData(CacheKeys.homeOffers) as String?;
    if (raw == null || raw.isEmpty) return null;
    try {
      return (jsonDecode(raw) as List)
          .map((e) => SpecialOffer.fromJson(e))
          .toList();
    } catch (_) {
      return null;
    }
  }

  void _cacheOffers(List<SpecialOffer> offers) {
    _cacheHelper.saveData(
      key: CacheKeys.homeOffers,
      value: jsonEncode(offers.map((e) => e.toJson()).toList()),
    );
  }

  void selectBookingPort(PortCategoryWithPortTypes port) {
    final firstType =
        port.portTypeDtos.isNotEmpty ? port.portTypeDtos.first : null;
    emit(state.copyWith(
      selectedBookingPort: port,
      selectedBookingPortType: firstType,
      // Unchecks the direct-services section and hides its chips.
      clearPaymentSelection: true,
    ));
  }

  void selectBookingPortType(PortTypeDto type) {
    emit(state.copyWith(
      selectedBookingPortType: type,
      clearPaymentSelection: true,
    ));
  }

  void selectPaymentPort(PortCategoryWithPortTypes port) {
    final firstType =
        port.portTypeDtos.isNotEmpty ? port.portTypeDtos.first : null;
    emit(state.copyWith(
      selectedPaymentPort: port,
      selectedPaymentPortType: firstType,
      // Unchecks the instant-booking section and hides its chips.
      clearBookingSelection: true,
    ));
  }

  void selectPaymentPortType(PortTypeDto type) {
    emit(state.copyWith(
      selectedPaymentPortType: type,
      clearBookingSelection: true,
    ));
  }

  /// Stores the occasion date picked in the instant-booking filter so the
  /// booking flow can send it as the reservation's occasionDate. Clears the
  /// previous availability result until it's re-checked for the new date.
  void setBookingDate(DateTime date) =>
      emit(state.copyWith(bookingDate: date, clearAvailability: true));

  /// Stores the event location (مكان المناسبة) chosen in the edit sheet. Clears
  /// the cached availability so it's re-checked against the new location.
  void setEventLocation(String governorate, String city) => emit(state.copyWith(
        eventGovernorate: governorate,
        eventCity: city,
        clearAvailability: true,
      ));

  /// Stores the availability result for the selected port + date.
  void setAvailability(CheckReservationResponse? availability) =>
      emit(state.copyWith(availability: availability));
}
