import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/utilisateur.dart';
import '../data/auth_repository_impl.dart';

/// AsyncNotifier qui gere l'etat d'authentification.
/// - AsyncData(Utilisateur)  : connecte
/// - AsyncData(null)         : deconnecte
/// - AsyncError              : erreur lors de la derniere operation
/// - AsyncLoading            : en cours
class AuthController extends AsyncNotifier<Utilisateur?> {
  @override
  Future<Utilisateur?> build() async {
    final repo = ref.read(authRepositoryProvider);
    return repo.currentUser();
  }

  Future<void> signIn({
    required String email,
    required String password,
    String? twoFactorCode,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => repo.login(
          email: email,
          password: password,
          twoFactorCode: twoFactorCode,
        ));
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncData(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, Utilisateur?>(AuthController.new);
