import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/constants.dart';
import '../storage/secure_token_storage.dart';
import 'failure.dart';
import 'interceptors/auth_interceptor.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureTokenStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.add(AuthInterceptor(storage));
  return dio;
});

/// Helper : convertit un DioException en Failure metier.
/// A appeler dans la couche data, pas dans la couche presentation.
Failure mapDioToFailure(DioException e) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout) {
    return const NetworkFailure();
  }
  final response = e.response;
  if (response == null) {
    return const UnknownFailure();
  }
  final status = response.statusCode ?? 0;
  final message = (response.data is Map && response.data['message'] is String)
      ? response.data['message'] as String
      : 'Erreur serveur ($status)';
  if (status == 401 || status == 403) return AuthFailure(message);
  if (status == 400 || status == 422) {
    final errors = response.data is Map ? response.data['errors'] : null;
    return ValidationFailure(
      message,
      errors: errors is Map
          ? errors.map((k, v) => MapEntry(
              k.toString(),
              (v is List) ? v.map((e) => e.toString()).toList() : [v.toString()]))
          : null,
    );
  }
  return ServerFailure(message, statusCode: status);
}
