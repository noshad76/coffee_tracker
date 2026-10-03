part of '../onboarding_screen.dart';

class _SetupComplete extends StatelessWidget {
  const _SetupComplete({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final preferences = state.preferences;
    final modeName = switch (preferences.goalMode) {
      CaffeineGoalMode.tracking => 'Just tracking',
      CaffeineGoalMode.cuttingBack => 'Cutting back',
      CaffeineGoalMode.quitting => 'Quitting',
    };
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: palette.stateSuccess,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  Text(
                    'Your setup is ready',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  const _Description(
                    'Your preferences are saved on this device. You can update them anytime.',
                    centered: true,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  _SummaryRow(label: 'Focus', value: modeName),
                  if (preferences.goalMode != CaffeineGoalMode.quitting)
                    _SummaryRow(
                      label: 'Daily target',
                      value: '${preferences.caffeineLimitMg} mg',
                    ),
                  _SummaryRow(
                    label: 'Favorite drinks',
                    value: '${preferences.favoriteDrinkIds.length} selected',
                  ),
                  const SizedBox(height: AppSpacing.x8),
                  _PrimaryButton(
                    label: 'Edit setup',
                    onPressed: controller.start,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
