import 'package:evex_user/data/repos/notifications_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _notificationsRepo;

  static const int _pageSize = 20;

  NotificationsCubit(this._notificationsRepo)
      : super(const NotificationsState());

  /// Loads (or refreshes) the first page.
  Future<void> getNotifications() async {
    emit(state.copyWith(isLoading: true));
    final result = await _notificationsRepo.getNotifications(
      index: 0,
      size: _pageSize,
    );
    if (result != null) {
      emit(state.copyWith(
        isLoading: false,
        notifications: result,
        nextIndex: 1,
        hasMore: result.length >= _pageSize,
      ));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
    // Opening the screen counts as seeing them — clear the server's unread flag.
    await _notificationsRepo.markAllAsRead();
  }

  /// Appends the next page (infinite scroll).
  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    final result = await _notificationsRepo.getNotifications(
      index: state.nextIndex,
      size: _pageSize,
    );
    if (result != null) {
      emit(state.copyWith(
        isLoadingMore: false,
        notifications: [...state.notifications, ...result],
        nextIndex: state.nextIndex + 1,
        hasMore: result.length >= _pageSize,
      ));
    } else {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}
