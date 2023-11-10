import 'package:flutter_memo_app/data/entity/memo.dart';
import 'package:flutter_memo_app/data/repository/memo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_list_viewmodel.g.dart';

@riverpod
class MemoListViewModel extends _$MemoListViewModel {
  @override
  List<Memo> build() => [];

  Future<void> loadAll() async {
    state = await ref.read(memoRepositoryProvider).loadAll();
  }

  Future<void> search(String keyword) async {
    state = await ref.read(memoRepositoryProvider).search(keyword);
  }

  void add(Memo memo) => state = <Memo>[memo, ...state];

  void update(Memo memo) {
    state = state.map((m) => (m.id == memo.id) ? memo : m).toList();
  }

  void delete(String id) {
    state = state.where((m) => m.id != id).toList();
  }
}
