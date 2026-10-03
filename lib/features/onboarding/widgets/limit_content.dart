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
    final limit = state.preferences.caffeineLimitMg;

    final (statusLabel, statusColor, statusIcon) = switch (limit) {
      <= 150 => ('Gentle', palette.stateSuccess, Icons.eco_outlined),
      <= 300 => ('Moderate', palette.brand400, Icons.bolt_rounded),
      <= 400 => ('FDA Safe', palette.brand500, Icons.verified_outlined),
      _ => ('High Intake', palette.stateWarning, Icons.warning_amber_rounded),
    };

    final cupsCount = (limit / 95).toStringAsFixed(1);
    final shotsCount = (limit / 75).toStringAsFixed(1);

    final sleepAdvice = switch (limit) {
      <= 150 =>
        'Minimal sleep disruption. Low risk of insomnia even in late afternoon.',
      <= 300 =>
        'Optimal energy balance. Cut off intake 7-8 hours before bed for deep sleep.',
      <= 400 =>
        'Within FDA guidelines (max 400mg/day). Cut off by 2:00 PM for restful sleep.',
      _ =>
        'Above typical safe daily threshold. May prolong sleep latency and elevate heart rate.',
    };

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
              ? 'Pick a realistic target you can hit consistently.'
              : "We'll track your daily intake against this threshold.",
        ),
        const SizedBox(height: AppSpacing.x6),
        Container(
          padding: const EdgeInsets.all(AppSpacing.x5),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.largeCard),
            border: Border.all(color: palette.stone800),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DAILY THRESHOLD',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: palette.textMuted,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Semantics(
                label: 'Daily caffeine threshold',
                value: '$limit milligrams',
                child: Text.rich(
                  TextSpan(
                    text: '$limit',
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
              const SizedBox(height: AppSpacing.x3),
              // Preset quick chips
              Row(
                children: [
                  _PresetChip(
                    label: '100 mg',
                    sub: 'Gentle',
                    isSelected: limit == 100,
                    onTap: () => controller.setCaffeineLimit(100),
                  ),
                  const SizedBox(width: 8),
                  _PresetChip(
                    label: '200 mg',
                    sub: 'Moderate',
                    isSelected: limit == 200,
                    onTap: () => controller.setCaffeineLimit(200),
                  ),
                  const SizedBox(width: 8),
                  _PresetChip(
                    label: '400 mg',
                    sub: 'FDA Limit',
                    isSelected: limit == 400,
                    onTap: () => controller.setCaffeineLimit(400),
                  ),
                  const SizedBox(width: 8),
                  _PresetChip(
                    label: '600 mg',
                    sub: 'High',
                    isSelected: limit == 600,
                    onTap: () => controller.setCaffeineLimit(600),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  showValueIndicator: ShowValueIndicator.never,
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                  activeTrackColor: palette.brand500,
                  inactiveTrackColor: palette.stone800,
                  thumbColor: palette.brand400,
                ),
                child: Slider(
                  min: 50,
                  max: 600,
                  value: limit.toDouble(),
                  onChanged: controller.setCaffeineLimit,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '50 mg',
                      style: TextStyle(color: palette.textSubtle, fontSize: 11),
                    ),
                    Text(
                      'FDA 400 mg',
                      style: TextStyle(
                        color: palette.brand300,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '600 mg',
                      style: TextStyle(color: palette.textSubtle, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        // Educational Equivalent & Sleep Guidance Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            color: palette.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: palette.stone800),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.coffee_rounded, size: 16, color: palette.brand400),
                  const SizedBox(width: 6),
                  Text(
                    'EQUIVALENT IN DRINKS',
                    style: TextStyle(
                      color: palette.brand300,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(AppRadii.control),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '~$cupsCount Standard',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Cups of coffee (95mg)',
                            style: TextStyle(
                              color: palette.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(AppRadii.control),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '~$shotsCount Espresso',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Single shots (75mg)',
                            style: TextStyle(
                              color: palette.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.nights_stay_outlined,
                    size: 15,
                    color: palette.brand400,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      sleepAdvice,
                      style: TextStyle(
                        color: palette.textMuted,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
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
