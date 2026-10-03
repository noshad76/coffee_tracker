import '../../../core/models/coffee_theme_preset.dart';

enum CaffeineGoalMode { tracking, cuttingBack, quitting }

class OnboardingPreferences {
  const OnboardingPreferences({
    required this.onboardingComplete,
    required this.goalMode,
    required this.caffeineLimitMg,
    required this.favoriteDrinkIds,
    required this.themePreset,
  });

  static const initial = OnboardingPreferences(
    onboardingComplete: false,
    goalMode: CaffeineGoalMode.tracking,
    caffeineLimitMg: 400,
    favoriteDrinkIds: [],
    themePreset: CoffeeThemePreset.coffee,
  );

  final bool onboardingComplete;
  final CaffeineGoalMode goalMode;
  final int caffeineLimitMg;
  final List<String> favoriteDrinkIds;
  final CoffeeThemePreset themePreset;

  OnboardingPreferences copyWith({
    bool? onboardingComplete,
    CaffeineGoalMode? goalMode,
    int? caffeineLimitMg,
    List<String>? favoriteDrinkIds,
    CoffeeThemePreset? themePreset,
  }) => OnboardingPreferences(
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    goalMode: goalMode ?? this.goalMode,
    caffeineLimitMg: caffeineLimitMg ?? this.caffeineLimitMg,
    favoriteDrinkIds: favoriteDrinkIds ?? this.favoriteDrinkIds,
    themePreset: themePreset ?? this.themePreset,
  );
}
