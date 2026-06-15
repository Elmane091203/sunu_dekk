import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/dossiers/presentation/dossier_list_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';

/// Routes nommees — utiliser ces constantes au lieu de strings en dur.
class AppRoute {
  AppRoute._();
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String dossiers = '/dossiers';
  static const String notifications = '/notifications';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.login,
    routes: [
      GoRoute(
        path: AppRoute.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.dashboard,
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoute.dossiers,
        builder: (_, __) => const DossierListScreen(),
      ),
      GoRoute(
        path: AppRoute.notifications,
        builder: (_, __) => const NotificationsScreen(),
      ),
    ],
    // TODO: ajouter un redirect base sur authStateProvider quand auth est branche.
  );
});
