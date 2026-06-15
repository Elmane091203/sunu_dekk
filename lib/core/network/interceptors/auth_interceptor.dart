import 'package:dio/dio.dart';

import '../../storage/secure_token_storage.dart';

/// Injecte automatiquement le Bearer JWT dans chaque requete sortante.
/// Sur 401, vide les tokens (le router devrait reagir et renvoyer au login).
class AuthInterceptor extends Interceptor {
  final SecureTokenStorage _storage;
  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readAccess();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // TODO: tenter un refresh via /api/auth/refresh avant d'effacer.
      await _storage.clear();
    }
    handler.next(err);
  }
}
