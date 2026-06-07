import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/data/repos/booking_services_ports_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'instant_booking_state.dart';

class InstantBookingCubit extends Cubit<InstantBookingState> {
  final BookingServicesPortsRepo _repo;
  final HomeCubit _homeCubit;

  InstantBookingCubit(this._repo, this._homeCubit)
      : super(const InstantBookingState());

  GetPortsRequest _request = GetPortsRequest();

  Future<void> loadPorts() async {
    _request.portType = _homeCubit.state.selectedBookingPortType?.id;
    await _fetchPorts();
  }

  Future<void> _fetchPorts() async {
    emit(state.copyWith(isLoading: true));
    final result = await _repo.getAllPortServices(_request);
    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        ToastManager.showError(error.message);
      },
      (model) => emit(state.copyWith(isLoading: false, portsModel: model)),
    );
  }

  void updateRequest(GetPortsRequest request) {
    _request = request;
    _fetchPorts();
  }
}
