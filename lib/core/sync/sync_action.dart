import 'dart:convert';

/// Représente une action effectuée hors-ligne, en attente d'être rejouée
/// au retour du réseau via `POST /api/sync/rejouer`.
///
/// Le backend (`app/routes/sync.py::ACTIONS_INTERDITES_OFFLINE`) refuse
/// d'office `PAIEMENT*` et `SIGNATURE*` - ces actions ne doivent jamais
/// être enfilées par le client.
class SyncAction {
  final int? id;
  final String endpoint; // ex: /dossiers/29/workflow/valider
  final String method; // POST | PATCH | PUT | DELETE
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final String?
  type; // étiquette logique optionnelle (ex: VALIDATION, ASSIGNATION)

  const SyncAction({
    this.id,
    required this.endpoint,
    required this.method,
    required this.payload,
    required this.createdAt,
    this.type,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'endpoint': endpoint,
    'method': method,
    'payload': jsonEncode(payload),
    'created_at': createdAt.toIso8601String(),
    if (type != null) 'type': type,
  };

  factory SyncAction.fromMap(Map<String, dynamic> m) => SyncAction(
    id: m['id'] as int?,
    endpoint: m['endpoint'] as String,
    method: m['method'] as String,
    payload: (m['payload'] is String)
        ? (jsonDecode(m['payload'] as String) as Map<String, dynamic>)
        : Map<String, dynamic>.from(m['payload'] as Map),
    createdAt:
        DateTime.tryParse(m['created_at']?.toString() ?? '') ?? DateTime.now(),
    type: m['type']?.toString(),
  );

  /// Payload prêt à être envoyé à `/api/sync/rejouer` (liste d'actions).
  Map<String, dynamic> toReplayPayload() => {
    'endpoint': endpoint,
    'method': method,
    'payload': payload,
    if (type != null) 'type': type,
    'client_created_at': createdAt.toIso8601String(),
  };
}

/// Actions strictement bloquées hors-ligne - miroir de
/// `ACTIONS_INTERDITES_OFFLINE` dans `app/routes/sync.py`.
/// Si on tente d'enfiler une action correspondante, on lève SyncForbiddenOffline.
const Set<String> kActionsInterditesOffline = {
  'PAIEMENT',
  'PAIEMENT_INITIER',
  'SIGNATURE',
  'SIGNATURE_APPOSER',
};

class SyncForbiddenOffline implements Exception {
  final String type;
  SyncForbiddenOffline(this.type);
  @override
  String toString() =>
      'Action "$type" interdite hors-ligne (paiement et signature exigent une connexion).';
}
