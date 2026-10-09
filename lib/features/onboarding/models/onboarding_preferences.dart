import '../../../core/models/coffee_theme_preset.dart';

enum CaffeineGoalMode { tracking, cuttingBack, quitting }

class OnboardingPreferences {
  const OnboardingPreferences({
    required this.onboardingComplete,
    required this.goalMode,
    required this.caffeineLimitMg,
    required this.favoriteDrinkIds,
    required this.themePreset,
    this.smartReminder = true,
    this.morningReminder = true,
    this.morningReminderHour = 21,
    this.morningReminderMinute = 0,
  });

  static const initial = OnboardingPreferences(
    onboardingComplete: false,
    goalMode: CaffeineGoalMode.tracking,
    caffeineLimitMg: 400,
    favoriteDrinkIds: [],
    themePreset: CoffeeThemePreset.coffee,
    smartReminder: true,
    morningReminder: true,
    morningReminderHour: 21,
    morningReminderMinute: 0,
  );

  final bool onboardingComplete;
  final CaffeineGoalMode goalMode;
  final int caffeineLimitMg;
  final List<String> favoriteDrinkIds;
  final CoffeeThemePreset themePreset;
  final bool smartReminder;
  final bool morningReminder;
  final int morningReminderHour;
  final int morningReminderMinute;

  OnboardingPreferences copyWith({
    bool? onboardingComplete,
    CaffeineGoalMode? goalMode,
    int? caffeineLimitMg,
    List<String>? favoriteDrinkIds,
    CoffeeThemePreset? themePreset,
    bool? smartReminder,
    bool? morningReminder,
    int? morningReminderHour,
    int? morningReminderMinute,
  }) => OnboardingPreferences(
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    goalMode: goalMode ?? this.goalMode,
    caffeineLimitMg: caffeineLimitMg ?? this.caffeineLimitMg,
    favoriteDrinkIds: favoriteDrinkIds ?? this.favoriteDrinkIds,
    themePreset: themePreset ?? this.themePreset,
    smartReminder: smartReminder ?? this.smartReminder,
    morningReminder: morningReminder ?? this.morningReminder,
    morningReminderHour: morningReminderHour ?? this.morningReminderHour,
    morningReminderMinute: morningReminderMinute ?? this.morningReminderMinute,
  );
}
