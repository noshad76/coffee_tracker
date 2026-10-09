part of '../onboarding_screen.dart';

class _ModeContent extends StatelessWidget {
  const _ModeContent({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _StepLabel(number: 2),
      const SizedBox(height: AppSpacing.x1),
      Text(
        'What brings you here?',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: AppSpacing.x1),
      const _Description('Pick your personal focus for tailored metrics.'),
      const SizedBox(height: AppSpacing.x6),
      for (final option in _modeOptions) ...[
        _ModeCard(
          selected: state.preferences.goalMode == option.mode,
          onTap: () => controller.selectMode(option.mode),
          icon: option.icon,
          title: option.title,
          description: option.description,
          accent: option.accent,
        ),
        const SizedBox(height: AppSpacing.x3),
      ],
    ],
  );
}
