import 'package:flutter_memo_app/data/entity/memo.dart';
import 'package:flutter_memo_app/data/repository/memo_repository.dart';
import 'package:flutter_memo_app/feature/memo_list/memo_list_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_edit_viewmodel.g.dart';

@riverpod
class MemoEditViewModel extends _$MemoEditViewModel {
  @override
  void build() {}

  Future<void> update(Memo memo) async {
    await ref.read(memoRepositoryProvider).update(memo);
    ref.read(memoListViewModelProvider.notifier).update(memo);
  }

  Future<void> delete(String id) async {
    await ref.read(memoRepositoryProvider).delete(id);
    ref.read(memoListViewModelProvider.notifier).delete(id);
  }
}
