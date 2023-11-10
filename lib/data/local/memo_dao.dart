import 'package:flutter_memo_app/data/local/app_database.dart';
import 'package:flutter_memo_app/data/entity/memo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_dao.g.dart';

@riverpod
MemoDao memoDao(MemoDaoRef ref) => MemoDao(ref.read(appDatabaseProvider));

class MemoDao {
  const MemoDao(this._database);

  final AppDatabase _database;

  Future<List<Memo>> loadAll() async {
    final db = await _database.db;
    final data = await db.query('Memos', orderBy: 'updated_at DESC');
    return data.isEmpty ? [] : data.map((e) => Memo.fromJson(e)).toList();
  }

  Future<List<Memo>> search(String keyword) async {
    final db = await _database.db;
    final data = await db.query(
      'Memos',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'updated_at DESC',
    );
    return data.isEmpty ? [] : data.map((e) => Memo.fromJson(e)).toList();
  }

  Future<void> insert(Memo memo) async {
    final db = await _database.db;
    await db.insert('Memos', memo.toJson());
  }

  Future<void> update(Memo memo) async {
    final db = await _database.db;
    await db.update(
      'Memos',
      memo.toJson(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.db;
    await db.delete('Memos', where: 'id = ?', whereArgs: [id]);
  }
}
