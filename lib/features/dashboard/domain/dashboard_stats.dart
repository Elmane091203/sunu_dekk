/// Snapshot des stats remontees par GET /api/stats/dashboard.
/// On reste sur une classe simple (pas de freezed) pour ne pas imposer un
/// build_runner a la feature.
class DashboardStats {
  final int total;
  final Map<String, int> parStatut;
  final int enRetard;
  final double satisfactionMoyenne;
  final List<VolumeJour> volume7Jours;
  final List<CategorieCount> parCategorie;
  final double delaiMoyenJours;

  const DashboardStats({
    required this.total,
    required this.parStatut,
    required this.enRetard,
    required this.satisfactionMoyenne,
    required this.volume7Jours,
    required this.parCategorie,
    required this.delaiMoyenJours,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    final parStatutRaw = (json['par_statut'] as Map?) ?? const {};
    final volumeRaw = (json['volume_7_jours'] as List?) ?? const [];
    final catRaw = (json['par_categorie'] as List?) ?? const [];
    return DashboardStats(
      total: (json['total'] as num?)?.toInt() ?? 0,
      parStatut: parStatutRaw.map(
        (k, v) => MapEntry(k.toString(), (v as num?)?.toInt() ?? 0),
      ),
      enRetard: (json['en_retard'] as num?)?.toInt() ?? 0,
      satisfactionMoyenne:
          (json['satisfaction_moyenne'] as num?)?.toDouble() ?? 0,
      volume7Jours: volumeRaw
          .whereType<Map>()
          .map((e) => VolumeJour.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      parCategorie: catRaw
          .whereType<Map>()
          .map((e) => CategorieCount.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      delaiMoyenJours: (json['delai_moyen_jours'] as num?)?.toDouble() ?? 0,
    );
  }

  int get enCours => parStatut['en_cours'] ?? 0;
  int get clotures => parStatut['cloture'] ?? 0;
  int get rejetes => parStatut['rejete'] ?? 0;
}

class VolumeJour {
  final String date;
  final int count;
  const VolumeJour({required this.date, required this.count});

  factory VolumeJour.fromJson(Map<String, dynamic> json) => VolumeJour(
        date: json['date'] as String,
        count: (json['count'] as num?)?.toInt() ?? 0,
      );
}

class CategorieCount {
  final String categorie;
  final int count;
  const CategorieCount({required this.categorie, required this.count});

  factory CategorieCount.fromJson(Map<String, dynamic> json) => CategorieCount(
        categorie: (json['categorie'] ?? 'Autre').toString(),
        count: (json['count'] as num?)?.toInt() ?? 0,
      );
}
