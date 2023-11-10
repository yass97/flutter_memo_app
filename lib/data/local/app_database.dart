import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'app_database.g.dart';

@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) => AppDatabase();

class AppDatabase {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  final queries = [
    [
      'CREATE TABLE Memos(id TEXT PRIMARY KEY, title TEXT, description TEXT, created_at TEXT, updated_at TEXT)'
    ]
  ];

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'memo.db');
    return await openDatabase(
      path,
      version: queries.length,
      onCreate: (db, version) async {
        for (final query in queries.first) {
          await db.execute(query);
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion; i < newVersion; i++) {
          for (final query in queries[i]) {
            await db.execute(query);
          }
        }
      },
    );
  }
}
