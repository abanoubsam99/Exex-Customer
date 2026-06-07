import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/models/addition.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/repos/port_services_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_service_details_state.dart';

class BookingServiceDetailsCubit extends Cubit<BookingServiceDetailsState> {
  final PortServicesRepo _repo;
  final HomeCubit _homeCubit;

  BookingServiceDetailsCubit(this._repo, this._homeCubit)
      : super(const BookingServiceDetailsState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAllPortServices();
      await getAdditions();
    });
  }

  static const int _defaultPortId = 3;

  int get _portId =>
      _homeCubit.state.selectedBookingPortType?.id ?? _defaultPortId;

  Future<void> getAllPortServices() async {
    emit(state.copyWith(isLoading: true, services: []));
    final result = await _repo.getAllPortServices(_portId);
    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        ToastManager.showError(error.message);
      },
      (services) => emit(state.copyWith(isLoading: false, services: services)),
    );
  }

  Future<void> getAdditions() async {
    emit(
      state.copyWith(
        isLoading: true,
        additions: [],
        buffets: [],
        selectedAdditions: [],
        selectedBuffets: [],
      ),
    );
    final result = await _repo.getAdditions(_portId);
    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
      },
      (all) {
        final additions = all.where((a) => a.specificToBuffet != true).toList();
        final buffets = all.where((a) => a.specificToBuffet == true).toList();
        emit(
          state.copyWith(isLoading: false, additions: additions, buffets: buffets),
        );
      },
    );
  }

  void selectService(PortService service) {
    emit(state.copyWith(selectedService: service));
    getServiceData();
  }

  Future<void> getServiceData() async {
    if (state.selectedService == null) return;
    emit(state.copyWith(isLoading: true));
    final result = await _repo.getServiceData(state.selectedService!.id);
    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        ToastManager.showError(error.message);
      },
      (details) {
        emit(state.copyWith(isLoading: false, serviceDetails: details));
        _recalcTotal();
      },
    );
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
    double cost = state.serviceDetails?.price?.toDouble() ?? 0;
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
