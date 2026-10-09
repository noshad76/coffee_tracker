import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_tracker/core/models/coffee_theme_preset.dart';
import 'package:coffee_tracker/features/onboarding/models/onboarding_preferences.dart';
import 'package:coffee_tracker/features/onboarding/models/onboarding_repository.dart';
import 'package:coffee_tracker/features/onboarding/providers/onboarding_providers.dart';
import 'package:coffee_tracker/features/onboarding/providers/onboarding_repository_provider.dart';

class _FakeOnboardingRepo implements OnboardingRepository {
  OnboardingPreferences prefs = OnboardingPreferences.initial;

  @override
  Future<OnboardingPreferences> loadPreferences() async => prefs;

  @override
  Future<void> savePreferences(OnboardingPreferences value) async {
    prefs = value;
  }
}

void main() {
  test('skipAll sets default values and completes onboarding', () async {
    final repo = _FakeOnboardingRepo();
    final container = ProviderContainer(
      overrides: [onboardingRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    // Load initial
    final initialState = await container.read(
      onboardingControllerProvider.future,
    );
    expect(initialState.preferences.onboardingComplete, isFalse);

    // Skip all
    await container.read(onboardingControllerProvider.notifier).skipAll();

    final skipped = container.read(onboardingControllerProvider).valueOrNull!;
    expect(skipped.preferences.onboardingComplete, isTrue);
    expect(skipped.preferences.goalMode, CaffeineGoalMode.tracking);
    expect(skipped.preferences.caffeineLimitMg, 400);
    expect(skipped.preferences.favoriteDrinkIds, [
      'espresso',
      'americano',
      'cappuccino',
    ]);
    expect(skipped.preferences.themePreset, CoffeeThemePreset.coffee);

    // Verify persisted to repo
    expect(repo.prefs.onboardingComplete, isTrue);
  });
}
