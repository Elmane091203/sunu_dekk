import 'package:dio/dio.dart';

/// Couche I/O brute : parle a /api/auth/* et renvoie les Map<String, dynamic>.
/// Aucune logique metier, aucune conversion en modele.
class AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSource(this._dio);

  // TODO: implementer
  // POST /api/auth/login    {email, password}                -> {access_token, refresh_token, user}
  // POST /api/auth/login    {email, password, 2fa_code}       -> meme reponse si 2FA active
  // POST /api/auth/logout                                     -> 200
  // GET  /api/auth/me                                         -> {user}
  // POST /api/auth/refresh  {refresh_token}                   -> {access_token}

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? twoFactorCode,
  }) {
    throw UnimplementedError();
  }

  Future<void> logout() {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>?> me() {
    throw UnimplementedError();
  }
}
