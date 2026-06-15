// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collectivite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollectiviteImpl _$$CollectiviteImplFromJson(Map<String, dynamic> json) =>
    _$CollectiviteImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      nom: json['nom'] as String,
      type: json['type'] as String?,
      region: json['region'] as String?,
      actif: json['actif'] as bool? ?? true,
    );

Map<String, dynamic> _$$CollectiviteImplToJson(_$CollectiviteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'nom': instance.nom,
      'type': instance.type,
      'region': instance.region,
      'actif': instance.actif,
    };
