import 'package:freezed_annotation/freezed_annotation.dart';

part 'dossier.freezed.dart';
part 'dossier.g.dart';

/// Statut metier des dossiers — doit rester aligne sur StatutDossier cote Flask
/// (voir app/models/dossier.py).
enum StatutDossier {
  @JsonValue('nouveau') nouveau,
  @JsonValue('en_cours') enCours,
  @JsonValue('en_attente') enAttente,
  @JsonValue('valide') valide,
  @JsonValue('rejete') rejete,
  @JsonValue('cloture') cloture,
}

enum PrioriteDossier {
  @JsonValue('basse') basse,
  @JsonValue('normale') normale,
  @JsonValue('haute') haute,
  @JsonValue('critique') critique,
}

@freezed
class Dossier with _$Dossier {
  const factory Dossier({
    required int id,
    required String numero,
    required StatutDossier statut,
    required PrioriteDossier priorite,
    required int typeDemarcheId,
    int? citoyenId,
    int? agentId,
    int? collectiviteId,
    String? description,
    DateTime? dateSoumission,
    DateTime? dateEcheance,
  }) = _Dossier;

  factory Dossier.fromJson(Map<String, dynamic> json) => _$DossierFromJson(json);
}
