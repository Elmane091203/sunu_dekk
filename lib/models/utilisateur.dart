import 'package:freezed_annotation/freezed_annotation.dart';

part 'utilisateur.freezed.dart';
part 'utilisateur.g.dart';

enum RoleUtilisateur {
  @JsonValue('super_admin') superAdmin,
  @JsonValue('admin') admin,
  @JsonValue('agent') agent,
  @JsonValue('citoyen') citoyen,
}

@freezed
class Utilisateur with _$Utilisateur {
  const factory Utilisateur({
    required int id,
    required String nom,
    required String prenom,
    required RoleUtilisateur role,
    String? email,
    String? telephone,
    int? collectiviteId,
    @Default(false) bool twoFactorEnabled,
    @Default(true) bool actif,
  }) = _Utilisateur;

  factory Utilisateur.fromJson(Map<String, dynamic> json) =>
      _$UtilisateurFromJson(json);
}
