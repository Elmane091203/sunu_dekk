import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/constants.dart';

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(const FlutterSecureStorage());
});

class SecureTokenStorage {
  final FlutterSecureStorage _storage;
  SecureTokenStorage(this._storage);

  Future<String?> readAccess() =>
      _storage.read(key: AppConstants.accessTokenKey);

  Future<String?> readRefresh() =>
      _storage.read(key: AppConstants.refreshTokenKey);

  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: access);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refresh);
  }

  Future<void> clear() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }
}
