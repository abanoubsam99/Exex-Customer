import 'package:evex_user/core/helpers/date_format_helper.dart';

/// Notification kind — drives the tile's icon and color.
enum NotificationType { confirmed, canceled, trash, team, offer }

NotificationType _typeFromString(String? value) {
  final v = value?.toLowerCase().trim() ?? '';
  if (v.contains('cancel') || v.contains('الغاء') || v.contains('رفض')) {
    return NotificationType.canceled;
  }
  if (v.contains('trash') || v.contains('مهملات') || v.contains('حذف')) {
    return NotificationType.trash;
  }
  if (v.contains('team') || v.contains('فريق')) {
    return NotificationType.team;
  }
  if (v.contains('offer') || v.contains('عرض') || v.contains('تخفيض')) {
    return NotificationType.offer;
  }
  return NotificationType.confirmed;
}

class AppNotification {
  final int? id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime? createdAt;
  final NotificationType type;

  const AppNotification({
    this.id,
    this.title = '',
    this.body = '',
    this.isRead = false,
    this.createdAt,
    this.type = NotificationType.confirmed,
  });

  /// Relative time label shown on the tile ("الان" / "منذ 3 ساعات" / date).
  String get time => DateFormatHelper.relativeArabic(createdAt);

  /// Unread notifications appear under "مؤخراً"; already-read ones under "اخري".
  bool get isRecent => !isRead;

  /// Defensive parsing: the backend response shape isn't pinned down, so we try
  /// the common key spellings for each field and fall back to safe defaults.
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['notificationId'] ?? json['Id'];
    return AppNotification(
      id: rawId is num ? rawId.toInt() : int.tryParse('$rawId'),
      title: (json['title'] ?? json['Title'] ?? json['subject'] ?? '').toString(),
      body: (json['body'] ??
              json['message'] ??
              json['Message'] ??
              json['content'] ??
              json['description'] ??
              json['text'] ??
              '')
          .toString(),
      isRead: (json['isRead'] ?? json['read'] ?? json['seen'] ?? false) == true,
      createdAt: DateFormatHelper.parse((json['createdAt'] ??
              json['createdOn'] ??
              json['createdDate'] ??
              json['createDate'] ??
              json['dateTime'] ??
              json['date'])
          ?.toString()),
      type: _typeFromString((json['type'] ?? json['notificationType'])?.toString()),
    );
  }
}
