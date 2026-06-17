import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

/// Upload de documents (scan, signature) sur un dossier.
/// Endpoint backend : POST /api/documents/dossier/<id>
/// - multipart/form-data
/// - champs: file (binaire), nom (str), type_document (str)
class DocumentUploadService {
  final Dio _dio;
  DocumentUploadService(this._dio);

  /// Upload depuis un fichier disque (image_picker, file_picker).
  Future<Map<String, dynamic>> uploadFromPath({
    required int dossierId,
    required String path,
    required String nom,
    String typeDocument = 'justificatif',
  }) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(path, filename: nom),
        'nom': nom,
        'type_document': typeDocument,
      });
      final res = await _dio.post<Map<String, dynamic>>(
        '/documents/dossier/$dossierId',
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }

  /// Upload depuis des bytes en memoire (signature PNG generee dans l'app).
  Future<Map<String, dynamic>> uploadFromBytes({
    required int dossierId,
    required Uint8List bytes,
    required String nom,
    String typeDocument = 'signature',
    String contentType = 'image/png',
  }) async {
    try {
      final form = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: nom,
          contentType: DioMediaType.parse(contentType),
        ),
        'nom': nom,
        'type_document': typeDocument,
      });
      final res = await _dio.post<Map<String, dynamic>>(
        '/documents/dossier/$dossierId',
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}

final documentUploadServiceProvider = Provider<DocumentUploadService>((ref) {
  return DocumentUploadService(ref.watch(apiClientProvider));
});
