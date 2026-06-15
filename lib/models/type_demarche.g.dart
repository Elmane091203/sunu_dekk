// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_demarche.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TypeDemarcheImpl _$$TypeDemarcheImplFromJson(Map<String, dynamic> json) =>
    _$TypeDemarcheImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      nom: json['nom'] as String,
      categorie: json['categorie'] as String,
      description: json['description'] as String?,
      delaiJours: (json['delaiJours'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TypeDemarcheImplToJson(_$TypeDemarcheImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'nom': instance.nom,
      'categorie': instance.categorie,
      'description': instance.description,
      'delaiJours': instance.delaiJours,
    };
