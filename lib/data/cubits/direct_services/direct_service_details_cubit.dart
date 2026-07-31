import 'package:evex_user/core/services/location_service.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/repos/booking_services_ports_repo.dart';
import 'package:evex_user/data/repos/favorites_repo.dart';
import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:evex_user/data/repos/wallet_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'direct_service_details_state.dart';

/// تفاصيل خدمة الدفع المباشر: منتجات/خدمات التاجر + نقاط العميل (من المحفظة).
class DirectServiceDetailsCubit extends Cubit<DirectServiceDetailsState> {
  final PortServicesRepo _servicesRepo;
  final WalletRepo _walletRepo;
  final FavoritesRepo _favoritesRepo;
  final BookingServicesPortsRepo _portsRepo;
  final LocationService _locationService;

  /// The port id when opened from a special offer (no full [Item] available).
  final int? _offerPortId;

  DirectServiceDetailsCubit(
    this._servicesRepo,
    this._walletRepo,
    this._favoritesRepo,
    this._portsRepo,
    this._locationService, {
    Item? port,
    int? portId,
  })  : _offerPortId = portId,
        super(DirectServiceDetailsState(
          port: port,
          isFavorite: port?.isFavorite ?? false,
        )) {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  /// The port currently shown (loaded into state, or passed in).
  Item? get port => state.port;

  /// The id used for all per-port requests — the loaded port's id, else the
  /// offer's portId.
  int get _portId => state.port?.id ?? _offerPortId ?? 0;

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

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));
    // Opened from an offer/deep-link with only a portId → fetch the full port
    // first so the header (name/images/contact/favorite) is populated.
    if (state.port == null && _offerPortId != null) {
      final model = await _portsRepo
          .getAllPortServices(GetPortsRequest(id: _offerPortId));
      final items = model?.items;
      if (items != null && items.isNotEmpty) {
        final match = items.firstWhere(
          (p) => p.id == _offerPortId,
          orElse: () => items.first,
        );
        emit(state.copyWith(port: match, isFavorite: match.isFavorite ?? false));
      }
    }
    final id = _portId;
    final services = await _servicesRepo.getAllPortServices(id);
    final wallet = await _walletRepo.getWalletData();
    final images = await _servicesRepo.getPortImages(id);
    final reviews = await _servicesRepo.getReviews(id);
    emit(state.copyWith(
      isLoading: false,
      services: services ?? const [],
      wallet: wallet,
      portImages: images ?? const [],
      reviews: reviews ?? const [],
    ));
    getOtherPorts();
  }

  /// Loads other ports owned by the same vendor for the "خدمات أخرى" section
  /// via /api/Ports/Filter?companyId=. Needs the current port's companyId.
  Future<void> getOtherPorts() async {
    final companyId = state.port?.companyId;
    if (companyId == null) return;
    // Filter by the client's selected location so vendor ports whose working
    // area doesn't cover it are hidden — the client can't open an out-of-area
    // service they'd never be able to book. Same gov/city filter the main lists
    // use.
    final model = await _portsRepo.getAllPortServices(GetPortsRequest(
      companyId: companyId,
      gov: _locationService.govName,
      city: _locationService.cityName,
    ));
    final items = model?.items;
    if (items == null) return;
    // Drop the port currently being viewed from the list.
    final currentId = state.port?.id;
    emit(state.copyWith(
      otherPorts: items.where((p) => p.id != currentId).toList(),
    ));
  }
}
