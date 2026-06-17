import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_repository_impl.dart';
import '../domain/dashboard_stats.dart';

/// FutureProvider auto-dispose : recharge a chaque entree sur le dashboard,
/// invalidable manuellement via `ref.invalidate(dashboardStatsProvider)`.
final dashboardStatsProvider =
    FutureProvider.autoDispose<DashboardStats>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  return repo.fetchStats();
});
