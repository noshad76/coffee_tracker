import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/coffee_card.dart';
import '../tracking/models/tracking_models.dart';
import '../tracking/providers/tracking_providers.dart';
import 'suggest_feature_sheet.dart';

class FeatureBoardPage extends ConsumerStatefulWidget {
  const FeatureBoardPage({super.key, required this.snapshot});
  final TrackingSnapshot snapshot;

  @override
  ConsumerState<FeatureBoardPage> createState() => _FeatureBoardPageState();
}

class _FeatureBoardPageState extends ConsumerState<FeatureBoardPage> {
  int filter = 0;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final ideas = [...widget.snapshot.ideas];
    if (filter == 0) {
      ideas.sort((a, b) => (b.voted ? 1 : 0).compareTo(a.voted ? 1 : 0));
    }
    if (filter == 1) {
      ideas.sort((a, b) => b.createdAtUtc.compareTo(a.createdAtUtc));
    }
    if (filter == 2) {
      ideas.sort((a, b) => a.createdAtUtc.compareTo(b.createdAtUtc));
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feature Board',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ideas and votes stay on this device.',
                    style: TextStyle(color: palette.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => const SuggestFeatureSheet(),
              ),
              child: const Text('+ Propose'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(['Most Popular', 'Newest', 'Oldest'][i]),
                    selected: filter == i,
                    onSelected: (_) => setState(() => filter = i),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (ideas.isEmpty)
          CoffeeCard(
            child: Column(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 38,
                  color: palette.brand300,
                ),
                const SizedBox(height: 8),
                Text(
                  'No ideas yet',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Propose the first feature for your own roadmap.',
                  style: TextStyle(color: palette.textMuted, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          for (final idea in ideas) ...[
            CoffeeCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          idea.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          idea.description,
                          style: TextStyle(
                            color: palette.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          idea.anonymous
                              ? 'Suggested anonymously'
                              : 'Your suggestion',
                          style: TextStyle(
                            color: palette.textSubtle,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      try {
                        await ref
                            .read(trackingControllerProvider.notifier)
                            .toggleVote(idea);
                      } catch (_) {
                        if (context.mounted) {
                          AppToast.show(
                            context,
                            'Could not save vote.',
                            isError: true,
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: palette.stone800,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            idea.voted
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            size: 16,
                            color: idea.voted
                                ? palette.brand300
                                : palette.textSecondary,
                          ),
                          Text(
                            idea.voted ? '1' : '0',
                            style: TextStyle(
                              color: palette.brand300,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 12),
        CoffeeCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✦  WHAT\'S NEW',
                style: TextStyle(
                  color: palette.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your local roadmap',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'Ideas and votes are private to this device.',
                style: TextStyle(color: palette.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
