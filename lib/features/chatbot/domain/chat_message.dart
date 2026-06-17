/// Message echange dans le chatbot. Stocke en memoire uniquement (la session
/// ne survit pas a un kill de l'app).
class ChatMessage {
  const ChatMessage({required this.role, required this.content});

  /// 'user' pour l'agent connecte, 'assistant' pour la reponse IA.
  final String role;
  final String content;

  bool get isUser => role == 'user';
}
