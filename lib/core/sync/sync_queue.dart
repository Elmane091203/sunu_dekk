import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../database/local_database.dart';
import '../network/api_client.dart';
import 'sync_action.dart';

/// File d'attente locale (SQLite) des actions effectuées hors-ligne.
///
/// Pattern : on enqueue à la place d'appeler l'API quand l'utilisateur est
/// offline. Au retour du réseau, [flush] envoie tout à `POST /api/sync/rejouer`
/// (qui rejoue chaque action via le même moteur que pour le online - auth,
/// gardes, audit). Le serveur reste la source de vérité absolue.
///
/// Limitations connues (à itérer) :
///  - pas de réconciliation de conflit côté UI : les CONFLICT renvoyés par
///    le backend sont juste loggés, à enrichir avec une UX dédiée
///  - pas de retry exponentiel : on flush une fois au retour réseau
class SyncQueue {
  final Database _db;
  final Dio _api;

  SyncQueue(this._db, this._api);

  /// Empile une action. Lève [SyncForbiddenOffline] si l'action est
  /// dans [kActionsInterditesOffline] (paiement / signature).
  Future<int> enqueue(SyncAction action) async {
    final type = action.type;
    if (type != null && kActionsInterditesOffline.contains(type)) {
      throw SyncForbiddenOffline(type);
    }
    return _db.insert('pending_actions', action.toMap()..remove('id'));
  }

  Future<List<SyncAction>> pending() async {
    final rows = await _db.query('pending_actions', orderBy: 'created_at ASC');
    return rows.map(SyncAction.fromMap).toList();
  }

  Future<int> count() async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) AS c FROM pending_actions',
    );
    return (rows.first['c'] as int?) ?? 0;
  }

  /// Envoie toutes les actions en attente au backend via `/api/sync/rejouer`.
  /// Renvoie le rapport renvoyé par le serveur (succès / erreurs / conflits).
  Future<SyncReport> flush() async {
    final actions = await pending();
    if (actions.isEmpty) {
      return const SyncReport(envoye: 0, succes: 0, conflits: 0, erreurs: 0);
    }
    try {
      final resp = await _api.post<Map<String, dynamic>>(
        '/sync/rejouer',
        data: {'actions': actions.map((a) => a.toReplayPayload()).toList()},
      );
      final body = resp.data ?? const {};
      final succes = (body['succes'] as List?)?.length ?? 0;
      final conflits = (body['conflits'] as List?)?.length ?? 0;
      final erreurs = (body['erreurs'] as List?)?.length ?? 0;

      // Politique : on supprime les actions traitées avec SUCCESS. Les CONFLICT
      // et ERROR restent en queue, à reprendre via une UI de réconciliation.
      // Indices de succès : on aligne sur l'ordre du payload envoyé.
      final succesIndices =
          (body['succes_indices'] as List?)?.cast<int>() ?? [];
      for (final i in succesIndices) {
        if (i < actions.length) {
          final id = actions[i].id;
          if (id != null) {
            await _db.delete(
              'pending_actions',
              where: 'id = ?',
              whereArgs: [id],
            );
          }
        }
      }

      return SyncReport(
        envoye: actions.length,
        succes: succes,
        conflits: conflits,
        erreurs: erreurs,
      );
    } catch (e) {
      debugPrint('[SyncQueue] flush failed: $e');
      return SyncReport(
        envoye: actions.length,
        succes: 0,
        conflits: 0,
        erreurs: actions.length,
      );
    }
  }
}

class SyncReport {
  final int envoye;
  final int succes;
  final int conflits;
  final int erreurs;
  const SyncReport({
    required this.envoye,
    required this.succes,
    required this.conflits,
    required this.erreurs,
  });

  bool get tout_ok => envoye == succes;
}

final syncQueueProvider = FutureProvider<SyncQueue>((ref) async {
  final db = await ref.watch(localDatabaseProvider.future);
  return SyncQueue(db, ref.watch(apiClientProvider));
});
