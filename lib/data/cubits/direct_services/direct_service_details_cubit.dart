import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
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

  /// البوابة المختارة من القائمة السابقة (بتغذّي الهيدر + بياناتها للتواصل).
  final Item? port;

  DirectServiceDetailsCubit(
    this._servicesRepo,
    this._walletRepo,
    this._favoritesRepo, {
    this.port,
  }) : super(const DirectServiceDetailsState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  /// Toggles the favorite state of this port (optimistic; reverts on failure).
  Future<void> toggleFavorite() async {
    final id = port?.id;
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
    final services = await _servicesRepo.getAllPortServices(port?.id ?? 0);
    final wallet = await _walletRepo.getWalletData();
    final images = await _servicesRepo.getPortImages(port?.id ?? 0);
    emit(state.copyWith(
      isLoading: false,
      services: services ?? const [],
      wallet: wallet,
      portImages: images ?? const [],
    ));
  }
}
