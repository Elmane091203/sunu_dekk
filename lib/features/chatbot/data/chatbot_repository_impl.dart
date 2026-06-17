import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/chatbot_repository.dart';
import 'chatbot_remote_data_source.dart';

final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ChatbotRepositoryImpl(ChatbotRemoteDataSource(dio));
});

class ChatbotRepositoryImpl implements ChatbotRepository {
  ChatbotRepositoryImpl(this._remote);

  final ChatbotRemoteDataSource _remote;

  @override
  Future<String> ask(String message) async {
    final data = await _remote.chatbot(message);
    final reponse = data['reponse'] ?? data['message'];
    if (reponse is String && reponse.isNotEmpty) return reponse;
    return 'Je n\'ai pas pu interpreter votre demande.';
  }
}
