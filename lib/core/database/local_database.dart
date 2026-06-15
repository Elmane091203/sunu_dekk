import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Cache local SQLite pour le mode hors-ligne.
/// Schema: a etoffer avec les tables `pending_actions` (file d'attente
/// de validations a sync), `dossiers_cache`, etc.
final localDatabaseProvider = FutureProvider<Database>((ref) async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    p.join(dbPath, 'sunu_dekk.db'),
    version: 1,
    onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE pending_actions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          endpoint TEXT NOT NULL,
          method TEXT NOT NULL,
          payload TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    },
  );
});
