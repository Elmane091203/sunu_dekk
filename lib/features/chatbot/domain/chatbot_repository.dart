/// Contrat du chatbot IA. L'implementation appelle POST /ia/chatbot
/// (voir demarche_admin.fask/app/routes/ia.py) et renvoie le champ `reponse`.
abstract class ChatbotRepository {
  /// Envoie un message a l'IA et retourne la reponse en clair.
  /// Leve une Failure (voir core/network/failure.dart) en cas d'erreur reseau
  /// ou serveur. Les widgets ne catchent pas, c'est au controller de gerer.
  Future<String> ask(String message);
}
