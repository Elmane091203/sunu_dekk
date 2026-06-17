import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/dossier_detail.dart';
import '../domain/dossier_repository.dart';
import '../domain/dossier_summary.dart';

final dossierRepositoryProvider = Provider<DossierRepository>((ref) {
  return DossierRepositoryImpl(ref.watch(apiClientProvider));
});

class DossierRepositoryImpl implements DossierRepository {
  final Dio _dio;
  DossierRepositoryImpl(this._dio);

  @override
  Future<DossiersPage> list({
    int page = 1,
    int perPage = 20,
    DossierFilter filter = const DossierFilter(),
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/dossiers',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          ...filter.toQueryParams(),
        },
      );
      return DossiersPage.fromJson(res.data ?? const {}, page: page);
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  @override
  Future<DossierDetail> detail(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/dossiers/$id');
      return DossierDetail.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  @override
  Future<DossierDetail> changerStatut(
    int id, {
    required String statut,
    String? commentaire,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/dossiers/$id/statut',
        data: {
          'statut': statut,
          if (commentaire != null) 'commentaire': commentaire,
        },
      );
      return DossierDetail.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  @override
  Future<DossierDetail> validerWorkflow(int id, {String? commentaire}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/dossiers/$id/workflow/valider',
        data: {if (commentaire != null) 'commentaire': commentaire},
      );
      return DossierDetail.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  @override
  Future<DossierDetail> rejeterWorkflow(int id, {String? commentaire}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/dossiers/$id/workflow/rejeter',
        data: {if (commentaire != null) 'commentaire': commentaire},
      );
      return DossierDetail.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}
