import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_memo_app/data/entity/memo.dart';
import 'package:flutter_memo_app/feature/extension/datetime_ext.dart';
import 'package:flutter_memo_app/feature/memo_edit/memo_edit_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoEditScreen extends HookConsumerWidget {
  const MemoEditScreen(this._memo, {super.key});

  final Memo _memo;

  static MaterialPageRoute route(Memo memo) {
    return MaterialPageRoute(builder: (_) => MemoEditScreen(memo));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(
      text: _memo.title,
    );
    final descriptionController = useTextEditingController(
      text: _memo.description,
    );
    final isLoading = useState<bool>(false);
    final isValid = useState<bool>(_memo.title.isNotEmpty);

    useEffect(() {
      titleController.addListener(() {
        isValid.value = titleController.text.isNotEmpty;
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text('Do you want to delete the memo?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ref
                              .read(memoEditViewModelProvider.notifier)
                              .delete(_memo.id);
                          int count = 0;
                          if (context.mounted) {
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          }
                        },
                        child: const Text('delete'),
                      )
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Title（Required）',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  maxLines: 8,
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'created_at : ${_memo.createdAt.format()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'updated_at : ${_memo.updatedAt.format()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: isValid.value
                        ? () async {
                            isLoading.value = true;
                            final updated = _memo.copyWith(
                              title: titleController.text,
                              description: descriptionController.text,
                              updatedAt: DateTime.now(),
                            );
                            await ref
                                .read(memoEditViewModelProvider.notifier)
                                .update(updated);
                            isLoading.value = false;
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    icon: isLoading.value
                        ? const SizedBox.square(
                            dimension: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const SizedBox.shrink(),
                    label: const Text('update'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
