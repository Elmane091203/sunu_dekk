import '../../../models/utilisateur.dart';

/// Contrat de la couche auth. La couche presentation depend de cette interface,
/// pas de l'implementation. Permet de mocker en test.
abstract class AuthRepository {
  /// Connexion email + password. Retourne l'utilisateur connecte si OK.
  /// Si l'utilisateur a 2FA active, [twoFactorCode] devient obligatoire au 2eme appel.
  Future<Utilisateur> login({
    required String email,
    required String password,
    String? twoFactorCode,
  });

  Future<void> logout();

  /// Recupere l'utilisateur courant depuis /api/auth/me (verifie aussi la validite du token).
  Future<Utilisateur?> currentUser();
}
