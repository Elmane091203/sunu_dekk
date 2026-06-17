import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/failure.dart';
import '../data/chatbot_repository_impl.dart';
import '../domain/chat_message.dart';

class ChatbotState {
  const ChatbotState({
    this.messages = const <ChatMessage>[],
    this.isLoading = false,
  });

  final List<ChatMessage> messages;
  final bool isLoading;

  ChatbotState copyWith({List<ChatMessage>? messages, bool? isLoading}) =>
      ChatbotState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
      );
}

class ChatbotController extends Notifier<ChatbotState> {
  @override
  ChatbotState build() => const ChatbotState();

  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || state.isLoading) return;

    final withUser = [
      ...state.messages,
      ChatMessage(role: 'user', content: text),
    ];
    state = state.copyWith(messages: withUser, isLoading: true);

    try {
      final reponse = await ref.read(chatbotRepositoryProvider).ask(text);
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(role: 'assistant', content: reponse),
        ],
        isLoading: false,
      );
    } on Failure catch (f) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
            role: 'assistant',
            content: 'Erreur : ${f.message}',
          ),
        ],
        isLoading: false,
      );
    }
  }

  void clear() {
    state = const ChatbotState();
  }
}

final chatbotControllerProvider =
    NotifierProvider<ChatbotController, ChatbotState>(ChatbotController.new);
