import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding_preferences.dart';
import '../models/onboarding_repository.dart';
import '../providers/onboarding_repository_provider.dart';
import '../../../core/models/coffee_theme_preset.dart';
import '../../settings/providers/reminders_provider.dart';

@immutable
class OnboardingState {
  const OnboardingState({
    required this.preferences,
    this.step = 0,
    this.saving = false,
    this.errorMessage,
  });

  final OnboardingPreferences preferences;
  final int step;
  final bool saving;
  final String? errorMessage;

  OnboardingState copyWith({
    OnboardingPreferences? preferences,
    int? step,
    bool? saving,
    String? errorMessage,
    bool clearError = false,
  }) => OnboardingState(
    preferences: preferences ?? this.preferences,
    step: step ?? this.step,
    saving: saving ?? this.saving,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}

class OnboardingController extends AsyncNotifier<OnboardingState> {
  late OnboardingRepository _repository;

  @override
  Future<OnboardingState> build() async {
    _repository = ref.watch(onboardingRepositoryProvider);
    return OnboardingState(preferences: await _repository.loadPreferences());
  }

  OnboardingState? get _current => state.valueOrNull;

  void start() => _update(
    (current) => current.copyWith(
      preferences: current.preferences.copyWith(onboardingComplete: false),
      step: 1,
      clearError: true,
    ),
  );

  void selectMode(CaffeineGoalMode mode) {
    final defaultLimit = switch (mode) {
      CaffeineGoalMode.tracking => 400,
      CaffeineGoalMode.cuttingBack => 200,
      CaffeineGoalMode.quitting => 0,
    };
    _update(
      (current) => current.copyWith(
        preferences: current.preferences.copyWith(
          goalMode: mode,
          caffeineLimitMg: defaultLimit,
        ),
      ),
    );
  }

  Future<void> saveMode(CaffeineGoalMode mode) async {
    final current = _current;
    if (current == null) return;
    final limit = switch (mode) {
      CaffeineGoalMode.tracking => 400,
      CaffeineGoalMode.cuttingBack => 200,
      CaffeineGoalMode.quitting => 0,
    };
    final preferences = current.preferences.copyWith(
      goalMode: mode,
      caffeineLimitMg: limit,
    );
    await _repository.savePreferences(preferences);
    _set(current.copyWith(preferences: preferences));
  }

  Future<void> saveTheme(CoffeeThemePreset preset) async {
    final current = _current;
    if (current == null) return;
    final preferences = current.preferences.copyWith(themePreset: preset);
    await _repository.savePreferences(preferences);
    _set(current.copyWith(preferences: preferences));
  }

  void continueFromMode() => _update(
    (current) => current.copyWith(
      step: current.preferences.goalMode == CaffeineGoalMode.quitting ? 3 : 2,
      clearError: true,
    ),
  );

  void setCaffeineLimit(double value) {
    final snapped = (50 + ((value - 50) / 25).round() * 25).clamp(50, 600);
    _update(
      (current) => current.copyWith(
        preferences: current.preferences.copyWith(caffeineLimitMg: snapped),
      ),
    );
  }

  void continueFromLimit({required bool skip}) => _update((current) {
    final defaultLimit =
        current.preferences.goalMode == CaffeineGoalMode.cuttingBack
        ? 200
        : 400;
    return current.copyWith(
      preferences: skip
          ? current.preferences.copyWith(caffeineLimitMg: defaultLimit)
          : current.preferences,
      step: 3,
      clearError: true,
    );
  });

  void toggleFavorite(String drinkId) => _update((current) {
    final selected = [...current.preferences.favoriteDrinkIds];
    if (selected.contains(drinkId)) {
      selected.remove(drinkId);
    } else {
      if (selected.length >= 3) {
        return current.copyWith(
          errorMessage: 'You can choose up to 3 favorite drinks.',
        );
      }
      selected.add(drinkId);
    }
    return current.copyWith(
      preferences: current.preferences.copyWith(favoriteDrinkIds: selected),
      clearError: true,
    );
  });

  Future<void> saveFavorites(List<String> drinkIds) async {
    final current = _current;
    if (current == null) return;
    final preferences = current.preferences.copyWith(
      favoriteDrinkIds: drinkIds,
    );
    await _repository.savePreferences(preferences);
    _set(current.copyWith(preferences: preferences));
  }

  void continueFromFavorites() =>
      _update((current) => current.copyWith(step: 4, clearError: true));

  void setSmartReminder(bool enabled) => _update(
    (current) => current.copyWith(
      preferences: current.preferences.copyWith(smartReminder: enabled),
    ),
  );

  void setMorningReminder(bool enabled) => _update(
    (current) => current.copyWith(
      preferences: current.preferences.copyWith(morningReminder: enabled),
    ),
  );

  void setMorningReminderTime(int hour, int minute) => _update(
    (current) => current.copyWith(
      preferences: current.preferences.copyWith(
        morningReminderHour: hour,
        morningReminderMinute: minute,
      ),
    ),
  );

  void back() => _update((current) {
    final step = current.step;
    if (step == 4) {
      return current.copyWith(step: 3, clearError: true);
    }
    if (step == 3) {
      return current.copyWith(
        step: current.preferences.goalMode == CaffeineGoalMode.quitting ? 1 : 2,
        clearError: true,
      );
    }
    return current.copyWith(step: step > 0 ? step - 1 : 0, clearError: true);
  });

  Future<void> continueFromReminders({required bool skip}) async {
    final current = _current;
    if (current == null) return;
    if (skip) {
      _update(
        (c) => c.copyWith(
          preferences: c.preferences.copyWith(
            smartReminder: false,
            morningReminder: false,
          ),
        ),
      );
    }
    await finish();
  }

  Future<void> skipAll() async {
    final current = _current;
    if (current == null || current.saving) return;
    _set(current.copyWith(saving: true, clearError: true));
    final defaultPrefs = current.preferences.copyWith(
      onboardingComplete: true,
      goalMode: CaffeineGoalMode.tracking,
      caffeineLimitMg: 400,
      favoriteDrinkIds: const ['espresso', 'americano', 'cappuccino'],
      themePreset: CoffeeThemePreset.coffee,
      smartReminder: false,
      morningReminder: false,
    );
    try {
      await _repository.savePreferences(defaultPrefs);
      ref.invalidate(remindersProvider);
      _set(
        current.copyWith(
          preferences: defaultPrefs,
          step: 0,
          saving: false,
          clearError: true,
        ),
      );
    } catch (_) {
      _set(
        current.copyWith(
          saving: false,
          errorMessage: 'Could not skip setup. Please try again.',
        ),
      );
    }
  }

  Future<void> finish() async {
    final current = _current;
    if (current == null || current.saving) return;
    _set(current.copyWith(saving: true, clearError: true));
    final completed = current.preferences.copyWith(onboardingComplete: true);
    try {
      await _repository.savePreferences(completed);
      ref.invalidate(remindersProvider);
      _set(
        current.copyWith(
          preferences: completed,
          step: 0,
          saving: false,
          clearError: true,
        ),
      );
    } catch (_) {
      _set(
        current.copyWith(
          saving: false,
          errorMessage: 'Your setup could not be saved. Please try again.',
        ),
      );
    }
  }

  void _update(OnboardingState Function(OnboardingState current) transform) {
    final current = _current;
    if (current != null) _set(transform(current));
  }

  void _set(OnboardingState value) => state = AsyncData(value);
}
