import 'package:flutter_memo_app/data/entity/memo.dart';
import 'package:flutter_memo_app/data/local/memo_dao.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_repository.g.dart';

@riverpod
MemoRepository memoRepository(MemoRepositoryRef ref) {
  return MemoRepository(ref.read(memoDaoProvider));
}

class MemoRepository {
  const MemoRepository(this._dao);

  final MemoDao _dao;

  Future<List<Memo>> loadAll() async {
    return _dao.loadAll();
  }

  Future<List<Memo>> search(String keyword) async {
    return _dao.search(keyword);
  }

  Future<void> insert(Memo memo) async {
    await _dao.insert(memo);
  }

  Future<void> update(Memo memo) async {
    await _dao.update(memo);
  }

  Future<void> delete(String id) async {
    await _dao.delete(id);
  }
}
