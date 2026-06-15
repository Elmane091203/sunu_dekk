// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dossier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DossierImpl _$$DossierImplFromJson(Map<String, dynamic> json) =>
    _$DossierImpl(
      id: (json['id'] as num).toInt(),
      numero: json['numero'] as String,
      statut: $enumDecode(_$StatutDossierEnumMap, json['statut']),
      priorite: $enumDecode(_$PrioriteDossierEnumMap, json['priorite']),
      typeDemarcheId: (json['typeDemarcheId'] as num).toInt(),
      citoyenId: (json['citoyenId'] as num?)?.toInt(),
      agentId: (json['agentId'] as num?)?.toInt(),
      collectiviteId: (json['collectiviteId'] as num?)?.toInt(),
      description: json['description'] as String?,
      dateSoumission: json['dateSoumission'] == null
          ? null
          : DateTime.parse(json['dateSoumission'] as String),
      dateEcheance: json['dateEcheance'] == null
          ? null
          : DateTime.parse(json['dateEcheance'] as String),
    );

Map<String, dynamic> _$$DossierImplToJson(_$DossierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numero': instance.numero,
      'statut': _$StatutDossierEnumMap[instance.statut]!,
      'priorite': _$PrioriteDossierEnumMap[instance.priorite]!,
      'typeDemarcheId': instance.typeDemarcheId,
      'citoyenId': instance.citoyenId,
      'agentId': instance.agentId,
      'collectiviteId': instance.collectiviteId,
      'description': instance.description,
      'dateSoumission': instance.dateSoumission?.toIso8601String(),
      'dateEcheance': instance.dateEcheance?.toIso8601String(),
    };

const _$StatutDossierEnumMap = {
  StatutDossier.nouveau: 'nouveau',
  StatutDossier.enCours: 'en_cours',
  StatutDossier.enAttente: 'en_attente',
  StatutDossier.valide: 'valide',
  StatutDossier.rejete: 'rejete',
  StatutDossier.cloture: 'cloture',
};

const _$PrioriteDossierEnumMap = {
  PrioriteDossier.basse: 'basse',
  PrioriteDossier.normale: 'normale',
  PrioriteDossier.haute: 'haute',
  PrioriteDossier.critique: 'critique',
};
