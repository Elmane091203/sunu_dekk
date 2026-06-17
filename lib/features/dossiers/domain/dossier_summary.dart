/// DTO leger pour la liste : on prend juste ce qu'il faut pour afficher la
/// tuile. Le payload complet de l'API est conserve si besoin d'aller plus loin
/// sans refaire un round-trip.
class DossierSummary {
  final int id;
  final String numero;
  final String titre;
  final String statut;
  final String priorite;
  final String? categorie;
  final String? citoyenNomComplet;
  final String? agentNomComplet;
  final DateTime? dateSoumission;
  final DateTime? dateEcheance;
  final int? collectiviteId;

  const DossierSummary({
    required this.id,
    required this.numero,
    required this.titre,
    required this.statut,
    required this.priorite,
    this.categorie,
    this.citoyenNomComplet,
    this.agentNomComplet,
    this.dateSoumission,
    this.dateEcheance,
    this.collectiviteId,
  });

  factory DossierSummary.fromJson(Map<String, dynamic> json) {
    final type = json['type_demarche'] as Map?;
    final citoyen = json['citoyen'] as Map?;
    final agent = json['agent'] as Map?;
    return DossierSummary(
      id: (json['id'] as num).toInt(),
      numero: (json['numero'] ?? '').toString(),
      titre: (json['titre'] ?? type?['nom'] ?? 'Dossier').toString(),
      statut: (json['statut'] ?? 'nouveau').toString(),
      priorite: (json['priorite'] ?? 'normale').toString(),
      categorie: type?['categorie']?.toString(),
      citoyenNomComplet: citoyen?['nom_complet']?.toString(),
      agentNomComplet: agent?['nom_complet']?.toString(),
      dateSoumission: _parseDate(json['date_soumission']),
      dateEcheance: _parseDate(json['date_echeance']),
      collectiviteId: (json['collectivite_id'] as num?)?.toInt(),
    );
  }

  bool get enRetard {
    final d = dateEcheance;
    if (d == null) return false;
    if (statut == 'cloture' || statut == 'rejete' || statut == 'valide') {
      return false;
    }
    return d.isBefore(DateTime.now());
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

class DossiersPage {
  final List<DossierSummary> items;
  final int total;
  final int pages;
  final int page;
  const DossiersPage({
    required this.items,
    required this.total,
    required this.pages,
    required this.page,
  });

  factory DossiersPage.fromJson(Map<String, dynamic> json, {required int page}) {
    final list = (json['dossiers'] as List? ?? [])
        .whereType<Map>()
        .map((e) => DossierSummary.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return DossiersPage(
      items: list,
      total: (json['total'] as num?)?.toInt() ?? list.length,
      pages: (json['pages'] as num?)?.toInt() ?? 1,
      page: page,
    );
  }
}
