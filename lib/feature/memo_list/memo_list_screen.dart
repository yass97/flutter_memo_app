import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_memo_app/feature/extension/datetime_ext.dart';
import 'package:flutter_memo_app/feature/memo_edit/memo_edit_screen.dart';
import 'package:flutter_memo_app/feature/memo_list/memo_list_viewmodel.dart';
import 'package:flutter_memo_app/feature/memo_registration/memo_registration_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoListScreen extends HookConsumerWidget {
  const MemoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memos = ref.watch(memoListViewModelProvider);
    final isLoading = useState<bool>(true);

    useEffect(
      () {
        final notifier = ref.read(memoListViewModelProvider.notifier);
        notifier.loadAll().then((_) => isLoading.value = false);
        return null;
      },
      const [],
    );

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: 'Title',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onChanged: (keyword) async {
            isLoading.value = true;
            await ref.read(memoListViewModelProvider.notifier).search(keyword);
            isLoading.value = false;
          },
        ),
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : memos.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sticky_note_2_outlined, size: 42),
                      SizedBox(height: 10),
                      Text('No memo...')
                    ],
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(height: 1);
                  },
                  itemCount: memos.length,
                  itemBuilder: (context, index) {
                    final memo = memos[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MemoEditScreen.route(memo));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              memo.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              memo.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                memo.updatedAt.format(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final route = MemoRegistrationScreen.route();
          Navigator.of(context).push(route);
        },
      ),
    );
  }
}
