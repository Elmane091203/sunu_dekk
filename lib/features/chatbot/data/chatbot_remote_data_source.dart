import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

/// Appel HTTP brut vers l'endpoint chatbot. Conversion des erreurs en
/// Failure faite par le repository_impl.
class ChatbotRemoteDataSource {
  ChatbotRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> chatbot(String message) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/ia/chatbot',
        data: {'message': message},
      );
      return res.data ?? const <String, dynamic>{};
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}
