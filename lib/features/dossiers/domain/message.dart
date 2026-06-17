class DossierMessage {
  final int id;
  final String contenu;
  final int auteurId;
  final String? auteurNom;
  final String? auteurRole;
  final DateTime? createdAt;
  final bool lu;

  const DossierMessage({
    required this.id,
    required this.contenu,
    required this.auteurId,
    this.auteurNom,
    this.auteurRole,
    this.createdAt,
    required this.lu,
  });

  factory DossierMessage.fromJson(Map<String, dynamic> json) {
    DateTime? d;
    try {
      d = DateTime.parse(json['created_at'].toString()).toLocal();
    } catch (_) {}
    final auteur = json['auteur'] is Map ? json['auteur'] as Map : null;
    return DossierMessage(
      id: (json['id'] as num).toInt(),
      contenu: (json['contenu'] ?? '').toString(),
      auteurId: (json['auteur_id'] as num?)?.toInt() ??
          (auteur?['id'] as num?)?.toInt() ??
          0,
      auteurNom: auteur?['nom_complet']?.toString() ??
          (json['auteur_nom']?.toString()),
      auteurRole: auteur?['role']?.toString() ??
          (json['auteur_role']?.toString()),
      createdAt: d,
      lu: json['lu'] as bool? ?? false,
    );
  }
}
