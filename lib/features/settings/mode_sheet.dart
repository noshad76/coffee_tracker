import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../onboarding/models/onboarding_preferences.dart';
import '../onboarding/providers/onboarding_providers.dart';

class ModeSheet extends ConsumerWidget {
  const ModeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppTheme.paletteOf(context);
    final active = ref
        .watch(onboardingControllerProvider)
        .valueOrNull
        ?.preferences
        .goalMode;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheetTop),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Switch Mode',
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
            for (final mode in CaffeineGoalMode.values)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () async {
                    try {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .saveMode(mode);
                      if (context.mounted) Navigator.pop(context);
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not save mode.')),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: palette.stone900,
                      border: Border.all(
                        color: active == mode
                            ? palette.brand500
                            : palette.stone800,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(switch (mode) {
                                CaffeineGoalMode.tracking => 'Just Tracking',
                                CaffeineGoalMode.cuttingBack => 'Cutting Back',
                                CaffeineGoalMode.quitting =>
                                  'Quitting Completely',
                              }, style: Theme.of(context).textTheme.titleSmall),
                              Text(
                                switch (mode) {
                                  CaffeineGoalMode.tracking =>
                                    'Log habits & view stats',
                                  CaffeineGoalMode.cuttingBack =>
                                    'Strict limit, streaks below goal',
                                  CaffeineGoalMode.quitting =>
                                    'Zero caffeine goal',
                                },
                                style: TextStyle(
                                  color: palette.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          switch (mode) {
                            CaffeineGoalMode.tracking => '400mg',
                            CaffeineGoalMode.cuttingBack => '200mg',
                            CaffeineGoalMode.quitting => '0mg',
                          },
                          style: TextStyle(
                            color: palette.brand300,
                            fontSize: 12,
                          ),
                        ),
                        if (active == mode)
                          Icon(Icons.check, color: palette.brand300),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
