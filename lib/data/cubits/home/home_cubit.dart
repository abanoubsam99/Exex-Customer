import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/port_category_with_port_types.dart';
import 'package:evex_user/features/home/data/repos/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(const HomeState());

  Future<void> init() async {
    await Future.wait([getHomeUserAppInfo(), getSpecialOffers()]);
  }

  Future<void> getHomeUserAppInfo() async {
    emit(state.copyWith(isLoadingPorts: true));
    final result = await _homeRepo.getHomeUserAppInfo();
    result.fold(
      (error) {
        emit(state.copyWith(isLoadingPorts: false, errorMessage: error.message));
        ToastManager.showError(error.message);
      },
      (ports) {
        final booking = ports.where((p) => p.subscriptionType == 0).toList();
        final payment = ports.where((p) => p.subscriptionType == 1).toList();
        emit(
          state.copyWith(
            isLoadingPorts: false,
            bookingPorts: booking,
            paymentPorts: payment,
          ),
        );
      },
    );
  }

  Future<void> getSpecialOffers() async {
    emit(state.copyWith(isLoadingOffers: true));
    final result = await _homeRepo.getSpecialOffers();
    result.fold(
      (error) => emit(
        state.copyWith(isLoadingOffers: false, errorMessage: error.message),
      ),
      (offers) => emit(
        state.copyWith(isLoadingOffers: false, specialOffers: offers),
      ),
    );
  }

  void selectBookingPort(PortCategoryWithPortTypes port) {
    final firstType =
        port.portTypeDtos?.isNotEmpty == true ? port.portTypeDtos!.first : null;
    emit(
      state.copyWith(
        selectedBookingPort: port,
        selectedBookingPortType: firstType,
      ),
    );
  }

  void selectBookingPortType(PortTypeDto type) {
    emit(state.copyWith(selectedBookingPortType: type));
  }

  void selectPaymentPort(PortCategoryWithPortTypes port) {
    final firstType =
        port.portTypeDtos?.isNotEmpty == true ? port.portTypeDtos!.first : null;
    emit(
      state.copyWith(
        selectedPaymentPort: port,
        selectedPaymentPortType: firstType,
      ),
    );
  }

  void selectPaymentPortType(PortTypeDto type) {
    emit(state.copyWith(selectedPaymentPortType: type));
  }
}
