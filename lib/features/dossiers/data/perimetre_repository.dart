import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/failure.dart';

/// Charge le périmètre offline complet de l'utilisateur connecté en une
/// requête : workflows + dossiers visibles + collectivité + utilisateur.
///
/// Endpoint backend : `GET /api/dossiers/mon-perimetre` (cf. app/routes/sync.py).
/// À appeler après login et au retour réseau pour préchauffer le cache.
class PerimetreRepository {
  final Dio _dio;
  PerimetreRepository(this._dio);

  Future<Perimetre> charger() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/dossiers/mon-perimetre');
      return Perimetre.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioToFailure(e);
    }
  }
}

class Perimetre {
  final Map<String, dynamic>? utilisateur;
  final Map<String, dynamic>? collectivite;
  final List<Map<String, dynamic>> workflows;
  final List<Map<String, dynamic>> dossiers;
  final int cacheTtlSec;
  final DateTime generatedAt;

  const Perimetre({
    this.utilisateur,
    this.collectivite,
    this.workflows = const [],
    this.dossiers = const [],
    this.cacheTtlSec = 86400,
    required this.generatedAt,
  });

  factory Perimetre.fromJson(Map<String, dynamic> json) => Perimetre(
        utilisateur: (json['utilisateur'] as Map?)?.cast<String, dynamic>(),
        collectivite: (json['collectivite'] as Map?)?.cast<String, dynamic>(),
        workflows: (json['workflows'] as List? ?? [])
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList(),
        dossiers: (json['dossiers'] as List? ?? [])
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList(),
        cacheTtlSec: (json['cache_ttl_s'] as num?)?.toInt() ?? 86400,
        generatedAt: DateTime.tryParse(json['generated_at']?.toString() ?? '') ??
            DateTime.now(),
      );
}

final perimetreRepositoryProvider = Provider<PerimetreRepository>((ref) {
  return PerimetreRepository(ref.watch(apiClientProvider));
});

/// Cache mémoire du dernier périmètre chargé. Invalidé sur logout / login.
final perimetreProvider = FutureProvider<Perimetre?>((ref) async {
  try {
    return await ref.watch(perimetreRepositoryProvider).charger();
  } catch (_) {
    // Pas bloquant : si la requête échoue (offline, 401, etc.), le reste de
    // l'app continue avec ses providers spécifiques (/dossiers, /stats…).
    return null;
  }
});
