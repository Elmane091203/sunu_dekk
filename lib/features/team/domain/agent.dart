/// Agent / collaborateur municipal.
class Agent {
  final int id;
  final String nom;
  final String prenom;
  final String role; // agent | admin
  final String? email;
  final String? telephone;
  final bool actif;
  final DateTime? derniereConnexion;
  final int? collectiviteId;

  const Agent({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
    this.email,
    this.telephone,
    required this.actif,
    this.derniereConnexion,
    this.collectiviteId,
  });

  String get nomComplet => '$prenom $nom'.trim();
  String get initials =>
      ('${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}')
          .toUpperCase();

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: (json['id'] as num).toInt(),
        nom: (json['nom'] ?? '').toString(),
        prenom: (json['prenom'] ?? '').toString(),
        role: (json['role'] ?? 'agent').toString(),
        email: json['email']?.toString(),
        telephone: json['telephone']?.toString(),
        actif: json['actif'] as bool? ?? true,
        derniereConnexion: _parseDate(json['derniere_connexion']),
        collectiviteId: (json['collectivite_id'] as num?)?.toInt(),
      );

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    try {
      return DateTime.parse(raw.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }
}

/// Snapshot des performances d'un agent (issue de /api/stats/agents).
class AgentPerformance {
  final Agent agent;
  final int totalAssignes;
  final int totalClos;
  final int enRetard;
  final double tauxCompletion; // 0-100

  const AgentPerformance({
    required this.agent,
    required this.totalAssignes,
    required this.totalClos,
    required this.enRetard,
    required this.tauxCompletion,
  });

  factory AgentPerformance.fromJson(Map<String, dynamic> json) {
    return AgentPerformance(
      agent: Agent.fromJson(Map<String, dynamic>.from(json['agent'] as Map)),
      totalAssignes: (json['total_assignes'] as num?)?.toInt() ?? 0,
      totalClos: (json['total_clos'] as num?)?.toInt() ?? 0,
      enRetard: (json['en_retard'] as num?)?.toInt() ?? 0,
      tauxCompletion:
          (json['taux_completion'] as num?)?.toDouble() ?? 0,
    );
  }
}
