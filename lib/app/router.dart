import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/demarches/presentation/demarche_detail_screen.dart';
import '../features/demarches/presentation/demarches_screen.dart';
import '../features/dossiers/presentation/dossier_detail_screen.dart';
import '../features/dossiers/presentation/dossier_list_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/team/presentation/agent_detail_screen.dart';
import '../features/team/presentation/team_screen.dart';
import '../shared_ui/app_shell.dart';

class AppRoute {
  AppRoute._();
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String dossiers = '/dossiers';
  static const String team = '/team';
  static const String demarches = '/demarches';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.login,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      if (auth.isLoading) return null;
      final isLogged = auth.valueOrNull != null;
      final goingToLogin = state.matchedLocation == AppRoute.login;
      if (!isLogged && !goingToLogin) return AppRoute.login;
      if (isLogged && goingToLogin) return AppRoute.dashboard;
      return null;
    },
    refreshListenable: _AuthListenable(ref),
    routes: [
      GoRoute(
        path: AppRoute.login,
        builder: (_, _) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(location: state.uri.toString(), child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.dashboard,
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoute.dossiers,
            builder: (_, _) => const DossierListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  return DossierDetailScreen(dossierId: id ?? 0);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.team,
            builder: (_, _) => const TeamScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  return AgentDetailScreen(agentId: id ?? 0);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.demarches,
            builder: (_, _) => const DemarchesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  return DemarcheDetailScreen(typeId: id ?? 0);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.notifications,
            builder: (_, _) => const NotificationsScreen(),
          ),
          GoRoute(
            path: AppRoute.profile,
            builder: (_, _) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    _sub = ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
  late final ProviderSubscription _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
