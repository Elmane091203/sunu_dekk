import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

/// Couche I/O brute : parle a /api/auth/* et renvoie les `Map<String, dynamic>`.
/// Aucune logique metier, aucune conversion en modele. Toute DioException est
/// convertie en Failure (cf. mapDioToFailure).
class AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSource(this._dio);

  /// POST /api/auth/login
  /// Reponse normale : { access_token, refresh_token, utilisateur }
  /// Si 2FA active  : { two_factor_required: true, user_id }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return res.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  /// POST /api/auth/2fa/verify  { user_id, code }
  /// Reponse : { access_token, refresh_token, utilisateur }
  Future<Map<String, dynamic>> verifyTwoFactor({
    required int userId,
    required String code,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/2fa/verify',
        data: {'user_id': userId, 'code': code},
      );
      return res.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  /// GET /api/auth/me → utilisateur courant (objet a plat).
  Future<Map<String, dynamic>?> me() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/auth/me');
      return res.data;
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}
