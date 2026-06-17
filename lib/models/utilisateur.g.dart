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
      collectiviteId: (json['collectiviteId'] as num?)?.toInt() ??
          (json['collectivite_id'] as num?)?.toInt(),
      roleOrganisationId: (json['roleOrganisationId'] as num?)?.toInt() ??
          (json['role_organisation_id'] as num?)?.toInt(),
      privileges: (json['privileges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ??
          json['two_factor_enabled'] as bool? ??
          false,
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
      'roleOrganisationId': instance.roleOrganisationId,
      'privileges': instance.privileges,
      'twoFactorEnabled': instance.twoFactorEnabled,
      'actif': instance.actif,
    };

const _$RoleUtilisateurEnumMap = {
  RoleUtilisateur.superAdmin: 'super_admin',
  RoleUtilisateur.admin: 'admin',
  RoleUtilisateur.agent: 'agent',
  RoleUtilisateur.citoyen: 'citoyen',
};
