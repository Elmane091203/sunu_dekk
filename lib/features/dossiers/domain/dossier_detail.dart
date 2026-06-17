/// Vue detaillee d'un dossier : reflete fidelement le payload `DossierSchema`
/// du backend (relations imbriquees comprises).
class DossierDetail {
  final int id;
  final String numero;
  final String titre;
  final String statut;
  final String priorite;
  final String? description;
  final DateTime? dateSoumission;
  final DateTime? dateEcheance;
  final DateTime? dateCloture;
  final int? delaiEstimeJours;
  final int? noteSatisfaction;
  final String? commentaireSatisfaction;
  final Partie? citoyen;
  final Partie? agent;
  final Collectivite? collectivite;
  final TypeDemarche? typeDemarche;
  final List<DocumentItem> documents;
  final List<HistoriqueItem> historique;

  const DossierDetail({
    required this.id,
    required this.numero,
    required this.titre,
    required this.statut,
    required this.priorite,
    this.description,
    this.dateSoumission,
    this.dateEcheance,
    this.dateCloture,
    this.delaiEstimeJours,
    this.noteSatisfaction,
    this.commentaireSatisfaction,
    this.citoyen,
    this.agent,
    this.collectivite,
    this.typeDemarche,
    this.documents = const [],
    this.historique = const [],
  });

  factory DossierDetail.fromJson(Map<String, dynamic> json) {
    return DossierDetail(
      id: (json['id'] as num).toInt(),
      numero: (json['numero'] ?? '').toString(),
      titre: (json['titre'] ?? 'Dossier').toString(),
      statut: (json['statut'] ?? 'nouveau').toString(),
      priorite: (json['priorite'] ?? 'normale').toString(),
      description: json['description']?.toString(),
      dateSoumission: _parseDate(json['date_soumission']),
      dateEcheance: _parseDate(json['date_echeance']),
      dateCloture: _parseDate(json['date_cloture']),
      delaiEstimeJours: (json['delai_estime_jours'] as num?)?.toInt(),
      noteSatisfaction: (json['note_satisfaction'] as num?)?.toInt(),
      commentaireSatisfaction: json['commentaire_satisfaction']?.toString(),
      citoyen: Partie.maybe(json['citoyen']),
      agent: Partie.maybe(json['agent']),
      collectivite: Collectivite.maybe(json['collectivite']),
      typeDemarche: TypeDemarche.maybe(json['type_demarche']),
      documents: (json['documents'] as List? ?? [])
          .whereType<Map>()
          .map((e) => DocumentItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      historique: (json['historique'] as List? ?? [])
          .whereType<Map>()
          .map((e) => HistoriqueItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    try {
      return DateTime.parse(raw.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }
}

class Partie {
  final int id;
  final String nomComplet;
  final String? telephone;
  final String? email;
  const Partie({
    required this.id,
    required this.nomComplet,
    this.telephone,
    this.email,
  });

  static Partie? maybe(dynamic raw) {
    if (raw is! Map) return null;
    return Partie(
      id: (raw['id'] as num?)?.toInt() ?? 0,
      nomComplet:
          (raw['nom_complet'] ?? '${raw['prenom'] ?? ''} ${raw['nom'] ?? ''}')
              .toString()
              .trim(),
      telephone: raw['telephone']?.toString(),
      email: raw['email']?.toString(),
    );
  }
}

class Collectivite {
  final int id;
  final String nom;
  final String? type;
  const Collectivite({required this.id, required this.nom, this.type});

  static Collectivite? maybe(dynamic raw) {
    if (raw is! Map) return null;
    return Collectivite(
      id: (raw['id'] as num?)?.toInt() ?? 0,
      nom: (raw['nom'] ?? '').toString(),
      type: raw['type']?.toString(),
    );
  }
}

class TypeDemarche {
  final int id;
  final String nom;
  final String? categorie;
  final int? delaiTraitementJours;
  const TypeDemarche({
    required this.id,
    required this.nom,
    this.categorie,
    this.delaiTraitementJours,
  });

  static TypeDemarche? maybe(dynamic raw) {
    if (raw is! Map) return null;
    return TypeDemarche(
      id: (raw['id'] as num?)?.toInt() ?? 0,
      nom: (raw['nom'] ?? '').toString(),
      categorie: raw['categorie']?.toString(),
      delaiTraitementJours: (raw['delai_traitement_jours'] as num?)?.toInt(),
    );
  }
}

class DocumentItem {
  final int id;
  final String nom;
  final String? mimeType;
  final int? taille;
  final String? url;
  final bool? valide;
  final bool requis;
  const DocumentItem({
    required this.id,
    required this.nom,
    this.mimeType,
    this.taille,
    this.url,
    this.valide,
    required this.requis,
  });

  factory DocumentItem.fromJson(Map<String, dynamic> json) => DocumentItem(
        id: (json['id'] as num).toInt(),
        nom: (json['nom'] ?? '').toString(),
        mimeType: json['mime_type']?.toString(),
        taille: (json['taille'] as num?)?.toInt(),
        url: json['url']?.toString(),
        valide: json['valide'] as bool?,
        requis: json['est_requis'] as bool? ?? false,
      );
}

class HistoriqueItem {
  final int id;
  final String? statutAncien;
  final String statutNouveau;
  final String? commentaire;
  final DateTime? createdAt;
  const HistoriqueItem({
    required this.id,
    this.statutAncien,
    required this.statutNouveau,
    this.commentaire,
    this.createdAt,
  });

  factory HistoriqueItem.fromJson(Map<String, dynamic> json) => HistoriqueItem(
        id: (json['id'] as num).toInt(),
        statutAncien: json['statut_ancien']?.toString(),
        statutNouveau: (json['statut_nouveau'] ?? '').toString(),
        commentaire: json['commentaire']?.toString(),
        createdAt: DossierDetail._parseDate(json['created_at']),
      );
}
