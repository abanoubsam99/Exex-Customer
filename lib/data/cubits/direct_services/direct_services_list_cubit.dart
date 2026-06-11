import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/data/repos/booking_services_ports_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'direct_services_list_state.dart';

/// قائمة "الخدمات المباشرة" — نفس فكرة [InstantBookingCubit] بس بتفلتر على
/// نوع البوابة المختار من قسم الدفع المباشر (selectedPaymentPortType).
class DirectServicesListCubit extends Cubit<DirectServicesListState> {
  final BookingServicesPortsRepo _repo;
  final HomeCubit _homeCubit;

  DirectServicesListCubit(this._repo, this._homeCubit)
      : super(const DirectServicesListState());

  final GetPortsRequest _request = GetPortsRequest();

  Future<void> loadPorts() async {
    _request.portType = _homeCubit.state.selectedPaymentPortType?.id;
    await _fetch();
  }

  /// تغيير نوع الخدمة من الـ tabs اللي فوق (يعيد الفلترة بدون navigation جديد).
  Future<void> changeType(int? portTypeId) async {
    _request.portType = portTypeId;
    await _fetch();
  }

  Future<void> _fetch() async {
    emit(state.copyWith(isLoading: true));
    final model = await _repo.getAllPortServices(_request);
    if (model != null) {
      emit(state.copyWith(isLoading: false, portsModel: model));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }
}
