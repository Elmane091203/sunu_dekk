import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/dashboard_repository.dart';
import '../domain/dashboard_stats.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.watch(apiClientProvider));
});

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio _dio;
  DashboardRepositoryImpl(this._dio);

  @override
  Future<DashboardStats> fetchStats() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/stats/dashboard');
      return DashboardStats.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}
