import 'package:flutter_test/flutter_test.dart';
import 'package:sunu_dekk/core/auth/permission_service.dart';
import 'package:sunu_dekk/core/auth/privilege.dart';
import 'package:sunu_dekk/models/utilisateur.dart';

Utilisateur _user({
  RoleUtilisateur role = RoleUtilisateur.agent,
  List<String> privileges = const <String>[],
}) =>
    Utilisateur(
      id: 1,
      nom: 'Diop',
      prenom: 'Awa',
      role: role,
      privileges: privileges,
    );

void main() {
  group('PermissionService - fail-closed par defaut', () {
    test('utilisateur null = aucun privilege', () {
      final svc = PermissionService.forUser(null);
      for (final p in Privilege.values) {
        expect(svc.has(p), isFalse, reason: '${p.code} doit etre refuse');
      }
    });

    test('agent sans role organisationnel = aucun privilege', () {
      final svc = PermissionService.forUser(_user());
      expect(svc.has(Privilege.gererDossiers), isFalse);
      expect(svc.has(Privilege.validerDocuments), isFalse);
    });

    test('privilege inconnu du backend est ignore (parseAll filtre)', () {
      final svc = PermissionService.forUser(
        _user(privileges: const ['gerer_dossiers', 'inexistant']),
      );
      expect(svc.has(Privilege.gererDossiers), isTrue);
      expect(svc.all.length, 1);
    });
  });

  group('PermissionService - admin systeme', () {
    test('admin a tous les privileges du catalogue', () {
      final svc = PermissionService.forUser(_user(role: RoleUtilisateur.admin));
      for (final p in Privilege.values) {
        expect(svc.has(p), isTrue);
      }
    });

    test('super_admin a tous les privileges', () {
      final svc =
          PermissionService.forUser(_user(role: RoleUtilisateur.superAdmin));
      expect(svc.all, equals(Privilege.values.toSet()));
    });
  });

  group('PermissionService - agent avec role organisationnel', () {
    test('hasAny / hasAll respectent l\'ensemble accorde', () {
      final svc = PermissionService.forUser(
        _user(privileges: const ['gerer_dossiers', 'envoyer_messages']),
      );
      expect(
        svc.hasAny(const [Privilege.changerStatut, Privilege.envoyerMessages]),
        isTrue,
      );
      expect(
        svc.hasAll(const [Privilege.gererDossiers, Privilege.envoyerMessages]),
        isTrue,
      );
      expect(
        svc.hasAll(const [Privilege.gererDossiers, Privilege.validerDocuments]),
        isFalse,
      );
    });
  });
}
