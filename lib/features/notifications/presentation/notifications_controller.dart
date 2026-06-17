import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/push/fcm_service.dart';
import '../data/notification_repository_impl.dart';
import '../domain/notification_item.dart';

final notificationsProvider =
    FutureProvider.autoDispose<NotificationsPayload>((ref) async {
  // Abonne ce provider aux push FCM : a chaque message foreground on
  // s'invalide soi-meme pour refleter la nouvelle notif immediatement.
  final sub = ref.read(fcmServiceProvider).onMessage.listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(sub.cancel);

  return ref.watch(notificationRepositoryProvider).list();
});

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).valueOrNull?.nonLues ?? 0;
});
