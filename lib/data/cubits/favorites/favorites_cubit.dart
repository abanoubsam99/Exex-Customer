import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/data/repos/favorites_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo _repo;

  FavoritesCubit(this._repo) : super(const FavoritesState());

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true));
    final list = await _repo.getFavorites();
    if (list != null) {
      emit(state.copyWith(isLoading: false, favorites: list));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }

  /// Removes a port from favorites (optimistic; reloads on failure).
  Future<void> removeFavorite(int portId) async {
    final updated = state.favorites.where((p) => p.id != portId).toList();
    emit(state.copyWith(favorites: updated));
    final response = await _repo.removeFavorite(portId);
    // On failure the server error is already toasted by the dio interceptor.
    if (response == null) {
      loadFavorites();
    } else if (response.message != null && response.message!.isNotEmpty) {
      ToastManager.showSuccess(response.message!);
    }
  }
}
