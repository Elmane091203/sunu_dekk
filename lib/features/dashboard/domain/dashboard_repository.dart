import 'dashboard_stats.dart';

abstract class DashboardRepository {
  /// Recupere les stats du tableau de bord pour l'utilisateur courant.
  /// Le scope (collectivite / agent) est decide cote backend via le JWT.
  Future<DashboardStats> fetchStats();
}
