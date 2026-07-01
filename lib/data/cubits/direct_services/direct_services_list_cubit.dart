import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/data/repos/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'direct_services_list_state.dart';

/// قائمة "الخدمات المباشرة" — نفس فكرة [InstantBookingCubit] بس بتفلتر على
/// نوع البوابة المختار من قسم الدفع المباشر (selectedPaymentPortType).
class DirectServicesListCubit extends Cubit<DirectServicesListState> {
  final BookingServicesPortsRepo _repo;
  final HomeRepo _homeRepo;
  final HomeCubit _homeCubit;
  final LocationService _locationService;

  DirectServicesListCubit(
    this._repo,
    this._homeRepo,
    this._homeCubit,
    this._locationService,
  ) : super(const DirectServicesListState());

  final GetPortsRequest _request = GetPortsRequest();

  Future<void> loadPorts() async {
    _request.portType = _homeCubit.state.selectedPaymentPortType?.id;
    // Filter by the user's saved (onboarding) location by default.
    _request.gov = _locationService.govName;
    _request.city = _locationService.cityName;
    await Future.wait([_fetch(), _fetchSpecialOffers()]);
  }

  /// تغيير نوع الخدمة من الـ tabs اللي فوق (يعيد الفلترة بدون navigation جديد).
  /// بيمسح القايمة القديمة الأول عشان مؤشر التحميل يظهر لحد ما النوع الجديد يحمّل.
  Future<void> changeType(int? portTypeId) async {
    _request.portType = portTypeId;
    emit(state.copyWith(isLoading: true, clearPorts: true));
    await Future.wait([_fetch(), _fetchSpecialOffers()]);
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

  /// Featured offers filtered by the currently selected payment port type and
  /// the user's location (profile when signed in, otherwise onboarding).
  Future<void> _fetchSpecialOffers() async {
    final offers = await _homeRepo.getSpecialOffers(
      portTypeId: _request.portType,
      gov: _request.gov,
      city: _request.city,
    );
    if (offers != null) emit(state.copyWith(specialOffers: offers));
  }
}
