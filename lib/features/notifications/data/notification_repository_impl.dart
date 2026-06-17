import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/notification_item.dart';
import '../domain/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(apiClientProvider));
});

class NotificationRepositoryImpl implements NotificationRepository {
  final Dio _dio;
  NotificationRepositoryImpl(this._dio);

  @override
  Future<NotificationsPayload> list({bool unreadOnly = false}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/notifications',
        queryParameters: unreadOnly ? {'non_lues': 'true'} : null,
      );
      return NotificationsPayload.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  @override
  Future<void> markRead(int id) async {
    try {
      await _dio.patch('/notifications/$id/lire');
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      await _dio.patch('/notifications/tout-lire');
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}
