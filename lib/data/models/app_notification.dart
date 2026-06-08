/// نوع الإشعار — بيحدد شكل الأيقونة ولونها.
enum NotificationType { confirmed, canceled, trash, team, offer }

NotificationType _typeFromString(String? value) {
  switch (value) {
    case 'canceled':
      return NotificationType.canceled;
    case 'trash':
      return NotificationType.trash;
    case 'team':
      return NotificationType.team;
    case 'offer':
      return NotificationType.offer;
    case 'confirmed':
    default:
      return NotificationType.confirmed;
  }
}

class AppNotification {
  final String title;
  final String body;
  final String time;
  final NotificationType type;

  /// تحت قسم "مؤخراً" (true) أو "اخري" (false).
  final bool isRecent;

  const AppNotification({
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRecent = true,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      time: json['time'] ?? '',
      type: _typeFromString(json['type']),
      isRecent: json['isRecent'] ?? true,
    );
  }
}
