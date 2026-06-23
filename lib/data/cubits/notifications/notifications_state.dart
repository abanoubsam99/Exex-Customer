import 'package:evex_user/data/models/app_notification.dart';

class NotificationsState {
  final bool isLoading;

  /// Loading an extra page at the bottom of the list (infinite scroll).
  final bool isLoadingMore;

  /// Still more pages on the server?
  final bool hasMore;

  /// The next page index to request.
  final int nextIndex;
  final List<AppNotification> notifications;
  final String? errorMessage;

  const NotificationsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.nextIndex = 0,
    this.notifications = const [],
    this.errorMessage,
  });

  List<AppNotification> get recent =>
      notifications.where((n) => n.isRecent).toList();

  List<AppNotification> get others =>
      notifications.where((n) => !n.isRecent).toList();

  NotificationsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? nextIndex,
    List<AppNotification>? notifications,
    String? errorMessage,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextIndex: nextIndex ?? this.nextIndex,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }
}
