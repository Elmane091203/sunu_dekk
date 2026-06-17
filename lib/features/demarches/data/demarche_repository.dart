import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/demarche.dart';

class DemarcheRepository {
  final Dio _dio;
  DemarcheRepository(this._dio);

  /// Liste des types de demarche. Si [collectiviteId] est fourni, scope sur
  /// la commune ; sinon le backend renvoie tous les actifs.
  Future<List<Demarche>> list({int? collectiviteId, String? search}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        '/dossiers/demarches',
        queryParameters: {
          if (collectiviteId != null) 'collectivite_id': collectiviteId,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      return (res.data ?? [])
          .whereType<Map>()
          .map((e) => Demarche.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  Future<Demarche> detail(int id) async {
    try {
      final res =
          await _dio.get<Map<String, dynamic>>('/dossiers/demarches/$id');
      return Demarche.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  Future<Demarche> toggleActif(int id, bool actif) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        '/dossiers/demarches/$id',
        data: {'actif': actif},
      );
      return Demarche.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}

final demarcheRepositoryProvider = Provider<DemarcheRepository>((ref) {
  return DemarcheRepository(ref.watch(apiClientProvider));
});

final demarcheListProvider =
    FutureProvider.autoDispose.family<List<Demarche>, String>((ref, search) {
  return ref.watch(demarcheRepositoryProvider).list(search: search);
});

final demarcheDetailProvider =
    FutureProvider.autoDispose.family<Demarche, int>((ref, id) {
  return ref.watch(demarcheRepositoryProvider).detail(id);
});
