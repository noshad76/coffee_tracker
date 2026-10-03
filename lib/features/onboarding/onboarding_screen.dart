import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widget_previews.dart';

import '../../app/theme/app_theme.dart';
import '../../core/models/coffee_theme_preset.dart';
import '../../shared/widgets/drink_artwork.dart';
import 'models/favorite_drink.dart';
import 'models/onboarding_preferences.dart';
import 'models/onboarding_repository.dart';
import 'controllers/onboarding_controller.dart';
import 'providers/onboarding_providers.dart';
import 'providers/onboarding_repository_provider.dart';

part 'widgets/onboarding_step.dart';
part 'widgets/welcome_content.dart';
part 'widgets/mode_content.dart';
part 'widgets/limit_content.dart';
part 'widgets/favorites_content.dart';
part 'widgets/setup_complete.dart';
part 'widgets/mode_card.dart';
part 'widgets/drink_card.dart';
part 'widgets/benefit_tile.dart';
part 'widgets/step_label.dart';
part 'widgets/description.dart';
part 'widgets/preset_chip.dart';
part 'widgets/primary_button.dart';
part 'widgets/secondary_button.dart';
part 'widgets/inline_error.dart';
part 'widgets/load_error.dart';
part 'widgets/summary_row.dart';

@Preview(name: 'Onboarding', group: 'Coffeeaholic')
Widget onboardingPreview() => ProviderScope(
  overrides: [
    onboardingRepositoryProvider.overrideWithValue(_PreviewRepository()),
  ],
  child: MaterialApp(
    theme: AppTheme.build(CoffeeThemePreset.coffee),
    home: const OnboardingScreen(),
  ),
);

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingControllerProvider);
    return onboarding.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => _LoadError(
        message: 'Your settings could not be loaded. Please try again.',
        onRetry: () => ref.invalidate(onboardingControllerProvider),
      ),
      data: (state) {
        final controller = ref.read(onboardingControllerProvider.notifier);
        if (state.preferences.onboardingComplete && state.step == 0) {
          return _SetupComplete(state: state, controller: controller);
        }
        return _OnboardingStep(state: state, controller: controller);
      },
    );
  }
}

enum _ModeAccent { brand, warning, danger }

class _ModeOption {
  const _ModeOption(
    this.mode,
    this.icon,
    this.title,
    this.description,
    this.accent,
    this.badge,
  );
  final CaffeineGoalMode mode;
  final IconData icon;
  final String title;
  final String description;
  final _ModeAccent accent;
  final String badge;
}

const _modeOptions = [
  _ModeOption(
    CaffeineGoalMode.tracking,
    Icons.bar_chart_rounded,
    'Just tracking',
    'Log what I drink and see where I stand.',
    _ModeAccent.brand,
    '400mg Limit',
  ),
  _ModeOption(
    CaffeineGoalMode.cuttingBack,
    Icons.trending_down_rounded,
    'Cutting back',
    'Gradually reduce my daily intake toward goal.',
    _ModeAccent.warning,
    '200mg Goal',
  ),
  _ModeOption(
    CaffeineGoalMode.quitting,
    Icons.block_rounded,
    'Quitting completely',
    'Zero caffeine. Track streak and cravings.',
    _ModeAccent.danger,
    '0mg Goal',
  ),
];

class _PreviewRepository implements OnboardingRepository {
  @override
  Future<OnboardingPreferences> loadPreferences() async =>
      OnboardingPreferences.initial;

  @override
  Future<void> savePreferences(OnboardingPreferences preferences) async {}
}
