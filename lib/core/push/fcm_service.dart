import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';

/// Service push (Firebase Cloud Messaging).
///
/// Responsabilites :
///  1. Initialiser Firebase (idempotent).
///  2. Demander la permission de notification.
///  3. Recuperer le token FCM et le pousser au backend
///     via `PATCH /api/utilisateurs/<id>` { fcm_token }.
///  4. Ecouter les messages en foreground et exposer un Stream pour
///     que les ecrans interesses (notifications) puissent se rafraichir.
///
/// Robustesse : si Firebase n'est pas configure (pas de google-services.json /
/// GoogleService-Info.plist), [init] echoue silencieusement. L'app continue
/// de fonctionner sans push - c'est le comportement attendu en dev.
class FcmService {
  final Dio _api;
  FcmService(this._api);

  bool _initialized = false;
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<String>? _tokenRefreshSub;

  final _messages = StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get onMessage => _messages.stream;

  Future<void> init() async {
    if (_initialized) return;
    try {
      // 1. Init Firebase (no-op si deja initialise par le natif).
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      // 2. Permission (iOS + Android 13+).
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('[FCM] Permission denied - silencieux');
      }

      // 3. Foreground listener.
      _foregroundSub = FirebaseMessaging.onMessage.listen(_messages.add);

      // 4. Refresh du token : si l'utilisateur recoit un nouveau token (reinstall,
      // logout/login, etc), on le re-pousse en backend.
      _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen((
        newToken,
      ) {
        // Sans connaitre le userId on stocke, le caller l'enverra plus tard.
        debugPrint(
          '[FCM] token refresh - caller doit relancer registerToken()',
        );
      });

      _initialized = true;
    } catch (e) {
      debugPrint('[FCM] init failed: $e - l\'app continue sans push');
      _initialized = false;
    }
  }

  /// Recupere le token actuel (null si Firebase pas dispo).
  Future<String?> currentToken() async {
    if (!_initialized) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('[FCM] getToken failed: $e');
      return null;
    }
  }

  /// Enregistre le token aupres du backend pour [userId].
  /// A appeler apres login. Silencieux en cas d'echec : le push n'est pas
  /// critique pour le fonctionnement de l'app.
  Future<void> registerToken(int userId) async {
    final token = await currentToken();
    if (token == null) return;
    try {
      await _api.patch('/utilisateurs/$userId', data: {'fcm_token': token});
    } catch (e) {
      debugPrint('[FCM] registerToken failed: $e');
    }
  }

  /// Retire le token cote backend (logout) : on envoie une valeur vide.
  Future<void> unregisterToken(int userId) async {
    try {
      await _api.patch('/utilisateurs/$userId', data: {'fcm_token': null});
    } catch (e) {
      debugPrint('[FCM] unregisterToken failed: $e');
    }
  }

  Future<void> dispose() async {
    await _foregroundSub?.cancel();
    await _tokenRefreshSub?.cancel();
    await _messages.close();
  }
}

final fcmServiceProvider = Provider<FcmService>((ref) {
  final svc = FcmService(ref.watch(apiClientProvider));
  // Lance l'init en arriere-plan (non bloquant pour l'app).
  unawaited(svc.init());
  ref.onDispose(svc.dispose);
  return svc;
});
