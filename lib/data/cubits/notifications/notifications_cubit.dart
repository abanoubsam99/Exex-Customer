import 'package:evex_user/data/repos/notifications_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _notificationsRepo;

  NotificationsCubit(this._notificationsRepo)
      : super(const NotificationsState());

  Future<void> getNotifications() async {
    emit(state.copyWith(isLoading: true));
    final result = await _notificationsRepo.getNotifications();
    if (result != null) {
      emit(state.copyWith(isLoading: false, notifications: result));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ'));
    }
  }
}
