import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/app_toast.dart';
import '../tracking/providers/tracking_providers.dart';

class SuggestFeatureSheet extends ConsumerStatefulWidget {
  const SuggestFeatureSheet({super.key});

  @override
  ConsumerState<SuggestFeatureSheet> createState() =>
      _SuggestFeatureSheetState();
}

class _SuggestFeatureSheetState extends ConsumerState<SuggestFeatureSheet> {
  final title = TextEditingController();
  final description = TextEditingController();
  bool anonymous = false;
  bool saving = false;
  String? error;

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheetTop),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Suggest a Feature',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Home Widget for Android',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: description,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Explain how this helps your caffeine habits...',
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: anonymous,
                  onChanged: (value) =>
                      setState(() => anonymous = value ?? false),
                  title: const Text('Submit anonymously'),
                ),
                if (error != null)
                  Text(error!, style: TextStyle(color: palette.stateDanger)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: saving
                        ? null
                        : () async {
                            if (title.text.trim().isEmpty ||
                                description.text.trim().isEmpty) {
                              setState(
                                () => error = 'Add a title and description.',
                              );
                              return;
                            }
                            setState(() {
                              saving = true;
                              error = null;
                            });
                            try {
                              await ref
                                  .read(trackingControllerProvider.notifier)
                                  .addIdea(
                                    title.text.trim(),
                                    description.text.trim(),
                                    anonymous,
                                  );
                              if (context.mounted) {
                                Navigator.pop(context);
                                AppToast.show(
                                  context,
                                  'Feature proposed',
                                  icon: Icons.lightbulb_outline,
                                );
                              }
                            } catch (_) {
                              if (mounted) {
                                setState(() {
                                  error = 'Could not save idea. Try again.';
                                  saving = false;
                                });
                              }
                            }
                          },
                    child: Text(saving ? 'Saving...' : 'Post Suggestion'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
