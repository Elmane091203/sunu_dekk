import 'dossier_detail.dart';
import 'dossier_summary.dart';

class DossierFilter {
  final String? statut;
  final String? priorite;
  final String? search;
  const DossierFilter({this.statut, this.priorite, this.search});

  Map<String, String> toQueryParams() {
    final m = <String, String>{};
    if (statut != null && statut!.isNotEmpty) m['statut'] = statut!;
    if (priorite != null && priorite!.isNotEmpty) m['priorite'] = priorite!;
    if (search != null && search!.isNotEmpty) m['q'] = search!;
    return m;
  }

  DossierFilter copyWith({String? statut, String? priorite, String? search}) =>
      DossierFilter(
        statut: statut ?? this.statut,
        priorite: priorite ?? this.priorite,
        search: search ?? this.search,
      );

  bool get isEmpty =>
      (statut == null || statut!.isEmpty) &&
      (priorite == null || priorite!.isEmpty) &&
      (search == null || search!.isEmpty);
}

abstract class DossierRepository {
  Future<DossiersPage> list({
    int page = 1,
    int perPage = 20,
    DossierFilter filter = const DossierFilter(),
  });

  Future<DossierDetail> detail(int id);

  Future<DossierDetail> changerStatut(
    int id, {
    required String statut,
    String? commentaire,
  });

  Future<DossierDetail> validerWorkflow(int id, {String? commentaire});
  Future<DossierDetail> rejeterWorkflow(int id, {String? commentaire});
}
