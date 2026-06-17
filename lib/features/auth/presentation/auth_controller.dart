import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/push/fcm_service.dart';
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
    final user = await repo.currentUser();
    // Si on est deja loggue au boot (token persisté), on enregistre quand meme
    // le token FCM pour couvrir le cas du token rafraichi pendant qu'on
    // etait deconnecte.
    if (user != null) {
      _syncPushToken(user.id);
    }
    return user;
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
    final user = state.valueOrNull;
    if (user != null) {
      _syncPushToken(user.id);
    }
  }

  Future<void> signOut() async {
    final user = state.valueOrNull;
    if (user != null) {
      // Tentative best-effort de desenregistrer le token cote backend pour
      // qu'un autre device ne recoive pas les push de cet utilisateur.
      await ref.read(fcmServiceProvider).unregisterToken(user.id);
    }
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncData(null);
  }

  void _syncPushToken(int userId) {
    // Fire-and-forget : le push n'est pas bloquant pour la session.
    ref.read(fcmServiceProvider).registerToken(userId);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, Utilisateur?>(AuthController.new);
