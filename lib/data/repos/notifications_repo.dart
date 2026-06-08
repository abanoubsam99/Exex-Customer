import 'package:evex_user/data/models/app_notification.dart';

class NotificationsRepo {
  /// TODO: لسه مفيش endpoint للإشعارات في الـ backend.
  /// لما يتوفر، استبدل الـ mock ده بـ:
  ///   final response = await DioHelper.getData(url: AppEndpoints.notifications);
  ///   return (response.data as List).map((e) => AppNotification.fromJson(e)).toList();
  Future<List<AppNotification>?> getNotifications() async {
    return const [
      AppNotification(
        title: 'تم تأكيد حجز قاعه البارون',
        body: 'عرض المزيد من تفاصيل قاعه البارون',
        time: 'الان',
        type: NotificationType.confirmed,
      ),
      AppNotification(
        title: 'تم الغاء بنجاح',
        body: 'لقد قمت بالغاء الحجز لفوتوغرافر وسيتم ...',
        time: '3 ساعات',
        type: NotificationType.canceled,
      ),
      AppNotification(
        title: 'تم اضافه حجز الى سله المهملات',
        body: 'عرض المزيد من تفاصيل قاعه البارون',
        time: '6 اكتوبر 2026',
        type: NotificationType.trash,
      ),
      AppNotification(
        title: 'تم تأكيد حجز قاعه البارون',
        body: 'عرض المزيد من تفاصيل قاعه البارون',
        time: '6 اكتوبر 2026',
        type: NotificationType.confirmed,
      ),
      AppNotification(
        title: 'تم تأكيد حجز فريق العمل',
        body: 'عرض المزيد من تفاصيل قاعه البارون',
        time: '6 اكتوبر 2026',
        type: NotificationType.team,
      ),
      AppNotification(
        title: 'تخفيض حصري الان',
        body: 'الحق التخفيض الذي على القاعات حتى 20 اكت ...',
        time: '6 اكتوبر 2026',
        type: NotificationType.offer,
      ),
      AppNotification(
        title: 'تم تأكيد حجز قاعه البارون',
        body: 'عرض المزيد من تفاصيل قاعه البارون',
        time: '6 اكتوبر 2026',
        type: NotificationType.confirmed,
        isRecent: false,
      ),
      AppNotification(
        title: 'تم تأكيد حجز فريق العمل',
        body: 'عرض المزيد من تفاصيل قاعه البارون',
        time: '6 اكتوبر 2026',
        type: NotificationType.team,
        isRecent: false,
      ),
    ];
  }
}
