// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateur.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UtilisateurImpl _$$UtilisateurImplFromJson(Map<String, dynamic> json) =>
    _$UtilisateurImpl(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      role: $enumDecode(_$RoleUtilisateurEnumMap, json['role']),
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      collectiviteId: (json['collectiviteId'] as num?)?.toInt(),
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      actif: json['actif'] as bool? ?? true,
    );

Map<String, dynamic> _$$UtilisateurImplToJson(_$UtilisateurImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'role': _$RoleUtilisateurEnumMap[instance.role]!,
      'email': instance.email,
      'telephone': instance.telephone,
      'collectiviteId': instance.collectiviteId,
      'twoFactorEnabled': instance.twoFactorEnabled,
      'actif': instance.actif,
    };

const _$RoleUtilisateurEnumMap = {
  RoleUtilisateur.superAdmin: 'super_admin',
  RoleUtilisateur.admin: 'admin',
  RoleUtilisateur.agent: 'agent',
  RoleUtilisateur.citoyen: 'citoyen',
};
