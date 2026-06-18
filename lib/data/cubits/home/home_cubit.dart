import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/data/models/port_category_with_port_types.dart';
import 'package:evex_user/data/models/ports_respond_model.dart'
    show CheckReservationResponse;
import 'package:evex_user/data/repos/home_repo.dart';
import 'package:evex_user/data/repos/notifications_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;
  final NotificationsRepo _notificationsRepo;
  final UserService _userService;

  HomeCubit(this._homeRepo, this._notificationsRepo, this._userService)
      : super(const HomeState());

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
    emit(state.copyWith(isLoadingPorts: true));
    final ports = await _homeRepo.getHomeUserAppInfo();
    if (ports != null) {
      final booking = ports.where((p) => p.subscriptionType == 0).toList();
      final payment = ports.where((p) => p.subscriptionType == 1).toList();
      emit(state.copyWith(
        isLoadingPorts: false,
        bookingPorts: booking,
        paymentPorts: payment,
      ));
    } else {
      emit(state.copyWith(isLoadingPorts: false, errorMessage: 'حدث خطأ'));
    }
  }

  Future<void> getSpecialOffers() async {
    emit(state.copyWith(isLoadingOffers: true));
    final offers = await _homeRepo.getSpecialOffers();
    if (offers != null) {
      emit(state.copyWith(isLoadingOffers: false, specialOffers: offers));
    } else {
      emit(state.copyWith(isLoadingOffers: false, errorMessage: 'حدث خطأ'));
    }
  }

  void selectBookingPort(PortCategoryWithPortTypes port) {
    final firstType =
        port.portTypeDtos.isNotEmpty ? port.portTypeDtos.first : null;
    emit(state.copyWith(
      selectedBookingPort: port,
      selectedBookingPortType: firstType,
    ));
  }

  void selectBookingPortType(PortTypeDto type) {
    emit(state.copyWith(selectedBookingPortType: type));
  }

  void selectPaymentPort(PortCategoryWithPortTypes port) {
    final firstType =
        port.portTypeDtos.isNotEmpty ? port.portTypeDtos.first : null;
    emit(state.copyWith(
      selectedPaymentPort: port,
      selectedPaymentPortType: firstType,
    ));
  }

  void selectPaymentPortType(PortTypeDto type) {
    emit(state.copyWith(selectedPaymentPortType: type));
  }

  /// Stores the occasion date picked in the instant-booking filter so the
  /// booking flow can send it as the reservation's occasionDate. Clears the
  /// previous availability result until it's re-checked for the new date.
  void setBookingDate(DateTime date) =>
      emit(state.copyWith(bookingDate: date, clearAvailability: true));

  /// Stores the availability result for the selected port + date.
  void setAvailability(CheckReservationResponse? availability) =>
      emit(state.copyWith(availability: availability));
}
