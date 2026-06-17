import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/message.dart';

class MessageRepository {
  final Dio _dio;
  MessageRepository(this._dio);

  Future<List<DossierMessage>> list(int dossierId) async {
    try {
      final res =
          await _dio.get<List<dynamic>>('/messages/dossier/$dossierId');
      return (res.data ?? [])
          .whereType<Map>()
          .map((e) => DossierMessage.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  Future<DossierMessage> send(int dossierId, String contenu) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/messages/dossier/$dossierId',
        data: {'contenu': contenu},
      );
      return DossierMessage.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(ref.watch(apiClientProvider));
});

final dossierMessagesProvider = FutureProvider.autoDispose
    .family<List<DossierMessage>, int>((ref, dossierId) {
  return ref.watch(messageRepositoryProvider).list(dossierId);
});
