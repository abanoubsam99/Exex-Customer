import 'package:evex_user/data/models/app_notification.dart';

class NotificationsState {
  final bool isLoading;
  final List<AppNotification> notifications;
  final String? errorMessage;

  const NotificationsState({
    this.isLoading = false,
    this.notifications = const [],
    this.errorMessage,
  });

  List<AppNotification> get recent =>
      notifications.where((n) => n.isRecent).toList();

  List<AppNotification> get others =>
      notifications.where((n) => !n.isRecent).toList();

  NotificationsState copyWith({
    bool? isLoading,
    List<AppNotification>? notifications,
    String? errorMessage,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }
}
