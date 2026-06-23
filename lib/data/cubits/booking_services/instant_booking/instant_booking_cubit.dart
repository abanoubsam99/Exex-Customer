import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/data/repos/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'instant_booking_state.dart';

class InstantBookingCubit extends Cubit<InstantBookingState> {
  final BookingServicesPortsRepo _repo;
  final HomeRepo _homeRepo;
  final HomeCubit _homeCubit;
  final LocationService _locationService;

  InstantBookingCubit(
    this._repo,
    this._homeRepo,
    this._homeCubit,
    this._locationService,
  ) : super(const InstantBookingState());

  GetPortsRequest _request = GetPortsRequest();

  Future<void> loadPorts() async {
    _request.portType = _homeCubit.state.selectedBookingPortType?.id;
    // Filter by the user's saved (onboarding) location by default.
    _request.gov = _locationService.govName;
    _request.city = _locationService.cityName;
    await Future.wait([_fetchPorts(), _fetchSpecialOffers()]);
  }

  /// Switches the selected booking port type and re-filters the list + offers
  /// in place (no navigation). Clears the old list first so the loading
  /// indicator shows while the new type loads.
  Future<void> changeType(int? portTypeId) async {
    _request.portType = portTypeId;
    emit(state.copyWith(isLoading: true, clearPorts: true));
    await Future.wait([_fetchPorts(), _fetchSpecialOffers()]);
  }

  /// Featured offers filtered by the currently selected booking port type.
  Future<void> _fetchSpecialOffers() async {
    final offers =
        await _homeRepo.getSpecialOffers(portTypeId: _request.portType);
    if (offers != null) emit(state.copyWith(specialOffers: offers));
  }

  Future<void> _fetchPorts() async {
    // Every fresh fetch starts from the first page.
    _request.index = 0;
    emit(state.copyWith(isLoading: true));
    final model = await _repo.getAllPortServices(_request);
    if (model != null) {
      // Fresh fetch → replace the list with page 0 (no append).
      emit(state.copyWith(isLoading: false, portsModel: model));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  /// Fetches the next page of ports and appends it to the current list
  /// (infinite scroll). Uses the response's `hasNext` to know when to stop.
  Future<void> loadMorePorts() async {
    final current = state.portsModel;
    if (state.isLoading || state.isLoadingMore || current?.hasNext != true) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    _request.index = (current?.index ?? 0) + 1;
    final next = await _repo.getAllPortServices(_request);
    if (next != null) {
      emit(state.copyWith(
        isLoadingMore: false,
        portsModel: PortsRespondModel(
          index: next.index,
          size: next.size,
          count: next.count,
          pages: next.pages,
          from: next.from,
          items: [...?current?.items, ...?next.items],
          hasPrevious: next.hasPrevious,
          hasNext: next.hasNext,
        ),
      ));
    } else {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void updateRequest(GetPortsRequest request) {
    _request = request;
    _fetchPorts();
  }

  /// Applies the filter-sheet values onto the current request (keeping the
  /// already-selected port type and date) and re-fetches via /api/Ports/Filter.
  /// [gov]/[city] fall back to the saved location when the sheet leaves them empty.
  Future<void> applyFilters({
    String? gov,
    String? city,
    int? occasionId,
    int? numberAllowed,
    int? minPrice,
    int? maxPrice,
  }) async {
    _request.gov = gov ?? _locationService.govName;
    _request.city = city ?? _locationService.cityName;
    _request.occasionId = occasionId;
    _request.numberAllowed = numberAllowed;
    _request.minPrice = minPrice;
    _request.maxPrice = maxPrice;
    await _fetchPorts();
  }

  /// Clears the filter-sheet values (keeping the port type + date) and
  /// re-fetches. Location falls back to the saved (onboarding) location.
  Future<void> resetFilters() async {
    _request.gov = _locationService.govName;
    _request.city = _locationService.cityName;
    _request.occasionId = null;
    _request.numberAllowed = null;
    _request.minPrice = null;
    _request.maxPrice = null;
    await _fetchPorts();
  }

  /// Sets the occasion date filter and re-fetches. The returned ports then
  /// carry this date in their checkReservationResponse, which the booking flow
  /// uses as the reservation's occasionDate.
  Future<void> setDate(DateTime date) async {
    _request.date = date;
    await _fetchPorts();
  }
}
