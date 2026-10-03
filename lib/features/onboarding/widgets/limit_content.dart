part of '../onboarding_screen.dart';

class _LimitContent extends StatelessWidget {
  const _LimitContent({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final cuttingBack =
        state.preferences.goalMode == CaffeineGoalMode.cuttingBack;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepLabel(number: 3),
        const SizedBox(height: AppSpacing.x1),
        Text(
          cuttingBack ? 'Set your daily goal' : 'Set a daily limit',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.x1),
        _Description(
          cuttingBack
              ? 'Pick a target you can actually hit.'
              : "We'll show how close you are each day.",
        ),
        const SizedBox(height: AppSpacing.x8),
        Container(
          padding: const EdgeInsets.all(AppSpacing.x6),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.largeCard),
            border: Border.all(color: palette.stone800),
          ),
          child: Column(
            children: [
              Text(
                'CAFFEINE THRESHOLD',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  color: palette.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              Semantics(
                label: 'Daily caffeine threshold',
                value: '${state.preferences.caffeineLimitMg} milligrams',
                child: Text.rich(
                  TextSpan(
                    text: '${state.preferences.caffeineLimitMg}',
                    children: [
                      TextSpan(
                        text: ' mg',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: palette.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Slider(
                min: 50,
                max: 600,
                divisions: 22,
                value: state.preferences.caffeineLimitMg.toDouble(),
                label: '${state.preferences.caffeineLimitMg} mg',
                onChanged: controller.setCaffeineLimit,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LimitScaleLabel('Low (100mg)'),
                  _LimitScaleLabel('FDA Safe (400mg)'),
                  _LimitScaleLabel('High (600mg)', alignEnd: true),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _Description(
          'You can change this anytime in Settings.',
          centered: true,
        ),
      ],
    );
  }
}
