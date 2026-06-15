import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
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
    // TODO:
    // 1. appeler _remote.login(...)
    // 2. sauver les tokens via _storage.save(...)
    // 3. retourner Utilisateur.fromJson(response['user'])
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: _remote.logout() puis _storage.clear()
    throw UnimplementedError();
  }

  @override
  Future<Utilisateur?> currentUser() async {
    // TODO: lire token via _storage.readAccess(), si present appeler _remote.me()
    throw UnimplementedError();
  }
}
