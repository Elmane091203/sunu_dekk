class AppConstants {
  AppConstants._();

  /// Base URL de l'API Flask.
  /// - 10.0.2.2 = localhost vu depuis l'emulateur Android
  /// - localhost = iOS simulator / web
  /// A externaliser en --dart-define pour la prod.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5001/api',
  );

  /// Cle de stockage securise du JWT.
  static const String accessTokenKey = 'sunu_dekk_access_token';
  static const String refreshTokenKey = 'sunu_dekk_refresh_token';
}
