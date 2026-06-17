import 'notification_item.dart';

abstract class NotificationRepository {
  Future<NotificationsPayload> list({bool unreadOnly = false});
  Future<void> markRead(int id);
  Future<void> markAllRead();
}
