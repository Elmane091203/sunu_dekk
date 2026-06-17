import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/agent.dart';

class TeamRepository {
  final Dio _dio;
  TeamRepository(this._dio);

  /// Liste des agents (et admins) de la collectivite courante.
  /// `role` optionnel pour filtrer cote backend (`agent` ou `admin`).
  Future<List<Agent>> list({String role = 'agent'}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        '/utilisateurs',
        queryParameters: {'role': role},
      );
      return (res.data ?? [])
          .whereType<Map>()
          .map((e) => Agent.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  Future<Agent> detail(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/utilisateurs/$id');
      return Agent.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  /// Stats perf des agents de la collectivite (require_privilege voir_stats).
  Future<List<AgentPerformance>> performances() async {
    try {
      final res = await _dio.get<List<dynamic>>('/stats/agents');
      return (res.data ?? [])
          .whereType<Map>()
          .map((e) =>
              AgentPerformance.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  Future<Agent> create({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required String password,
    String role = 'agent',
    int? collectiviteId,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/utilisateurs',
        data: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'telephone': telephone,
          'password': password,
          'role': role,
          if (collectiviteId != null) 'collectivite_id': collectiviteId,
        },
      );
      return Agent.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  Future<void> block(int id) async {
    try {
      await _dio.post('/utilisateurs/$id/bloquer');
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  Future<void> unblock(int id) async {
    try {
      await _dio.post('/utilisateurs/$id/debloquer');
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(ref.watch(apiClientProvider));
});

final agentListProvider =
    FutureProvider.autoDispose<List<Agent>>((ref) async {
  return ref.watch(teamRepositoryProvider).list();
});

final agentPerformanceProvider =
    FutureProvider.autoDispose<List<AgentPerformance>>((ref) async {
  return ref.watch(teamRepositoryProvider).performances();
});

final agentDetailProvider =
    FutureProvider.autoDispose.family<Agent, int>((ref, id) async {
  return ref.watch(teamRepositoryProvider).detail(id);
});
