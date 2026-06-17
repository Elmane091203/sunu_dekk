import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../models/utilisateur.dart';
import 'privilege.dart';

/// Service de verification des privileges metier.
///
/// Regle d'or : *fail-closed*. Sans utilisateur authentifie ou sans privilege
/// reconnu, [has] retourne `false`. Les widgets doivent appeler [has] avant
/// de rendre une action ; si le retour est `false`, l'action est *absente*
/// de l'interface (pas grisee, pas masquee derriere un message d'erreur).
class PermissionService {
  PermissionService(this._privileges);

  /// Construit le service a partir de l'utilisateur courant.
  /// L'admin (role systeme) recoit l'ensemble des privileges.
  factory PermissionService.forUser(Utilisateur? user) {
    if (user == null) return PermissionService(const <Privilege>{});
    if (user.role == RoleUtilisateur.admin ||
        user.role == RoleUtilisateur.superAdmin) {
      return PermissionService(Privilege.values.toSet());
    }
    return PermissionService(Privilege.parseAll(user.privileges));
  }

  final Set<Privilege> _privileges;

  bool has(Privilege privilege) => _privileges.contains(privilege);

  bool hasAny(Iterable<Privilege> privileges) =>
      privileges.any(_privileges.contains);

  bool hasAll(Iterable<Privilege> privileges) =>
      privileges.every(_privileges.contains);

  Set<Privilege> get all => Set.unmodifiable(_privileges);
}

/// Provider du service de permissions, derive de l'auth controller.
/// Recalcule a chaque changement d'utilisateur (login, logout, refresh).
final permissionServiceProvider = Provider<PermissionService>((ref) {
  final user = ref.watch(authControllerProvider).valueOrNull;
  return PermissionService.forUser(user);
});
