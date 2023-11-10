import 'package:flutter_memo_app/data/entity/memo.dart';
import 'package:flutter_memo_app/data/repository/memo_repository.dart';
import 'package:flutter_memo_app/feature/memo_list/memo_list_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_registration_viewmodel.g.dart';

@riverpod
class MemoRegistrationViewModel extends _$MemoRegistrationViewModel {
  @override
  void build() {}

  Future<void> create(String title, String description) async {
    final memo = Memo.create(title, description);
    await ref.read(memoRepositoryProvider).insert(memo);
    ref.read(memoListViewModelProvider.notifier).add(memo);
  }
}
