import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/app_toast.dart';
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

    final modes = [
      (
        mode: CaffeineGoalMode.tracking,
        title: 'Just Tracking',
        desc: 'Log habits & view stats (Daily log streak)',
        goalText: '400mg Limit',
        goalColor: palette.stateSuccess,
      ),
      (
        mode: CaffeineGoalMode.cuttingBack,
        title: 'Cutting Back',
        desc: 'Strict limit, streaks count days below goal',
        goalText: '200mg Goal',
        goalColor: palette.stateWarning,
      ),
      (
        mode: CaffeineGoalMode.quitting,
        title: 'Quitting Completely',
        desc: 'Zero caffeine goal. Count caffeine-free days.',
        goalText: '0mg Goal',
        goalColor: palette.stateDanger,
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheetTop),
        ),
        border: Border(top: BorderSide(color: palette.stone700, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Switch Mode',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: palette.textMuted, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mode Option Cards matching Image 4
              for (final item in modes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () async {
                      try {
                        await ref
                            .read(onboardingControllerProvider.notifier)
                            .saveMode(item.mode);
                        if (context.mounted) {
                          Navigator.pop(context);
                          AppToast.show(
                            context,
                            'Switched to ${item.title}',
                            icon: Icons.check_circle_outline,
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          AppToast.show(
                            context,
                            'Could not save mode.',
                            isError: true,
                          );
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: active == item.mode
                            ? palette.surfaceRaised
                            : palette.stone900,
                        border: Border.all(
                          color: active == item.mode
                              ? palette.brand500
                              : palette.stone800,
                          width: active == item.mode ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    color: palette.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.desc,
                                  style: TextStyle(
                                    color: palette.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.goalText,
                            style: TextStyle(
                              color: item.goalColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
