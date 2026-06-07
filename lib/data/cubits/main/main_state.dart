class MainState {
  final int currentPage;
  const MainState({this.currentPage = 0});

  MainState copyWith({int? currentPage}) =>
      MainState(currentPage: currentPage ?? this.currentPage);
}
