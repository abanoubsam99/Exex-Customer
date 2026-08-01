import 'package:dio/dio.dart';
import 'package:evex_user/app/helpers/dio_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/data/models/app_notification.dart';
import 'package:evex_user/data/models/general_response.dart';

class NotificationsRepo {
  /// GET /api/Notifications/GetMyNotifications?index=&size= — the client's
  /// notifications. Parsing is defensive (raw list or a paged `{ items: [...] }`).
  Future<List<AppNotification>?> getNotifications({
    int index = 0,
    int size = 20,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.myNotifications,
        query: {'index': index, 'size': size},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;
        final list = data is List
            ? data
            : (data is Map
                ? (data['items'] ?? data['data'] ?? data['notifications'])
                : null);
        if (list is List) {
          return list.map((e) => AppNotification.fromJson(e)).toList();
        }
        return [];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/Notifications/GetUnreadCount — number of unread notifications.
  /// Returns null on failure so callers can keep the previous badge value.
  Future<int?> getUnreadCount() async {
    try {
      final response = await DioHelper.getData(
        url: AppEndpoints.notificationsUnreadCount,
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;
        if (data is Map) {
          final count = data['unreadCount'] ?? data['count'] ?? 0;
          return count is num ? count.toInt() : int.tryParse('$count') ?? 0;
        }
        if (data is num) return data.toInt();
        return 0;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// PUT /api/Notifications/MarkAllAsRead — marks every notification as read.
  Future<GeneralResponse?> markAllAsRead() async {
    try {
      final response = await DioHelper.putData(
        url: AppEndpoints.markAllNotificationsRead,
        // Silent background write (opening the notifications screen) — no toast.
        options: Options(extra: {'suppressSuccessToast': true}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GeneralResponse.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
