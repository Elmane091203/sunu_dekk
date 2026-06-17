/// Type de demarche (catalogue).
class Demarche {
  final int id;
  final String code;
  final String nom;
  final String? nomWolof;
  final String? description;
  final String? categorie;
  final int delaiTraitementJours;
  final double frais;
  final List<String> criteres;
  final List<DocumentRequis> documentsRequis;
  final bool actif;
  final int? collectiviteId;

  const Demarche({
    required this.id,
    required this.code,
    required this.nom,
    this.nomWolof,
    this.description,
    this.categorie,
    required this.delaiTraitementJours,
    required this.frais,
    this.criteres = const [],
    this.documentsRequis = const [],
    required this.actif,
    this.collectiviteId,
  });

  factory Demarche.fromJson(Map<String, dynamic> json) {
    final criteresRaw = json['criteres'];
    final docsRaw = json['documents_requis'];
    return Demarche(
      id: (json['id'] as num).toInt(),
      code: (json['code'] ?? '').toString(),
      nom: (json['nom'] ?? '').toString(),
      nomWolof: json['nom_wolof']?.toString(),
      description: json['description']?.toString(),
      categorie: json['categorie']?.toString(),
      delaiTraitementJours:
          (json['delai_traitement_jours'] as num?)?.toInt() ?? 0,
      frais: (json['frais'] as num?)?.toDouble() ?? 0,
      criteres: criteresRaw is List
          ? criteresRaw.map((e) => e.toString()).toList()
          : const [],
      documentsRequis: docsRaw is List
          ? docsRaw
              .whereType<Map>()
              .map((e) =>
                  DocumentRequis.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      actif: json['actif'] as bool? ?? true,
      collectiviteId: (json['collectivite_id'] as num?)?.toInt(),
    );
  }
}

class DocumentRequis {
  final String nom;
  final List<String> rolesValidateurs;
  const DocumentRequis({required this.nom, this.rolesValidateurs = const []});

  factory DocumentRequis.fromJson(Map<String, dynamic> json) => DocumentRequis(
        nom: (json['nom'] ?? '').toString(),
        rolesValidateurs: (json['roles_validateurs'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
      );
}
