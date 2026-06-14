import 'package:evex_user/data/models/ports_respond_model.dart';

class FavoritesState {
  final bool isLoading;
  final List<Item> favorites;
  final String? errorMessage;

  const FavoritesState({
    this.isLoading = false,
    this.favorites = const [],
    this.errorMessage,
  });

  FavoritesState copyWith({
    bool? isLoading,
    List<Item>? favorites,
    String? errorMessage,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage,
    );
  }
}
