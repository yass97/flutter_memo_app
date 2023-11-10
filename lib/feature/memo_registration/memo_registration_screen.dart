import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_memo_app/feature/memo_registration/memo_registration_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoRegistrationScreen extends HookConsumerWidget {
  const MemoRegistrationScreen({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(builder: (_) => const MemoRegistrationScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final isLoading = useState<bool>(false);
    final isValid = useState<bool>(false);

    useEffect(() {
      titleController.addListener(() {
        isValid.value = titleController.text.isNotEmpty && !isLoading.value;
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
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
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: isValid.value
                        ? () async {
                            isLoading.value = true;
                            final notifier = ref.read(
                              memoRegistrationViewModelProvider.notifier,
                            );
                            await notifier.create(
                              titleController.text,
                              descriptionController.text,
                            );
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
                    label: const Text('save'),
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
