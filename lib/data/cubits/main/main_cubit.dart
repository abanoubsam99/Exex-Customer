import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  /// Switches the visible tab (drives the IndexedStack index + the bottom-nav
  /// highlight). Index-based, so the shown page always matches the highlight.
  void goToTab(int page) => emit(state.copyWith(currentPage: page));

  /// Resets back to the first tab (used on logout).
  void reset() => emit(const MainState());
}
