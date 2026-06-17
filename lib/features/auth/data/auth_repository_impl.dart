import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/failure.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../../../models/utilisateur.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  final storage = ref.watch(secureTokenStorageProvider);
  return AuthRepositoryImpl(AuthRemoteDataSource(dio), storage);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureTokenStorage _storage;

  AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<Utilisateur> login({
    required String email,
    required String password,
    String? twoFactorCode,
  }) async {
    // Premier appel : tente le login direct.
    final res = twoFactorCode == null
        ? await _remote.login(email: email, password: password)
        : await _firstStepThenVerify(email, password, twoFactorCode);

    // Si le backend reclame un 2FA et qu'on n'a pas de code, on signale au caller.
    if (res['two_factor_required'] == true) {
      final userId = res['user_id'];
      throw TwoFactorRequiredFailure(userId is int ? userId : int.parse('$userId'));
    }

    await _storage.save(
      access: res['access_token'] as String,
      refresh: res['refresh_token'] as String,
    );
    return Utilisateur.fromJson(_normalizeUser(res['utilisateur'] as Map));
  }

  Future<Map<String, dynamic>> _firstStepThenVerify(
    String email,
    String password,
    String code,
  ) async {
    final first = await _remote.login(email: email, password: password);
    if (first['two_factor_required'] != true) return first;
    final userId = first['user_id'];
    return _remote.verifyTwoFactor(
      userId: userId is int ? userId : int.parse('$userId'),
      code: code,
    );
  }

  @override
  Future<void> logout() async {
    // JWT stateless cote backend : il suffit de vider le storage local.
    await _storage.clear();
  }

  @override
  Future<Utilisateur?> currentUser() async {
    final token = await _storage.readAccess();
    if (token == null) return null;
    try {
      final data = await _remote.me();
      if (data == null) return null;
      return Utilisateur.fromJson(_normalizeUser(data));
    } on AuthFailure {
      // Token invalide / expire : on nettoie pour repartir sur un login propre.
      await _storage.clear();
      return null;
    }
  }

  /// Le backend renvoie du snake_case (`collectivite_id`, `two_factor_enabled`),
  /// mais le modele freezed attend du camelCase. On adapte ici plutot que
  /// d'ajouter des `@JsonKey` partout (qui forceraient un build_runner).
  Map<String, dynamic> _normalizeUser(Map raw) {
    final m = Map<String, dynamic>.from(raw);
    if (m.containsKey('collectivite_id')) {
      m['collectiviteId'] = m.remove('collectivite_id');
    }
    if (m.containsKey('two_factor_enabled')) {
      m['twoFactorEnabled'] = m.remove('two_factor_enabled');
    }
    return m;
  }
}

