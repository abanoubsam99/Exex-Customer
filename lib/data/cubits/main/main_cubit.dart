import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  late final PageController pageController = PageController();

  void goToTab(int page) {
    emit(state.copyWith(currentPage: page));
    pageController.jumpToPage(page);
  }

  /// Resets back to the first tab (used on logout).
  void reset() {
    emit(const MainState());
    if (pageController.hasClients) pageController.jumpToPage(0);
  }

  void animateToTab(int page) {
    emit(state.copyWith(currentPage: page));
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
