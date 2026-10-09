import 'package:drift/drift.dart';

import '../../../core/models/coffee_theme_preset.dart';
import '../../../core/storage/app_database.dart';
import '../models/onboarding_preferences.dart';
import '../models/onboarding_repository.dart';

class DriftOnboardingRepository implements OnboardingRepository {
  const DriftOnboardingRepository(this._database);

  final AppDatabase _database;

  @override
  Future<OnboardingPreferences> loadPreferences() async {
    var row = await (_database.select(
      _database.localAppSettings,
    )..where((settings) => settings.id.equals(1))).getSingleOrNull();

    if (row == null) {
      await _database
          .into(_database.localAppSettings)
          .insert(_defaultSettings());
      row = await (_database.select(
        _database.localAppSettings,
      )..where((settings) => settings.id.equals(1))).getSingle();
    }

    final favoriteRows = await (_database.select(
      _database.favoriteDrinkRows,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();

    return OnboardingPreferences(
      onboardingComplete: row.onboardingComplete,
      goalMode: _goalModeFromStorage(row.goalMode),
      caffeineLimitMg: _limitFromStorage(row.caffeineLimitMg, row.goalMode),
      favoriteDrinkIds: favoriteRows
          .map((favorite) => favorite.drinkId)
          .where(_isKnownFavorite)
          .take(10)
          .toList(growable: false),
      themePreset: _themeFromStorage(row.themePreset),
      smartReminder: row.smartReminderEnabled,
    );
  }

  @override
  Future<void> savePreferences(OnboardingPreferences preferences) async {
    final favoriteIds = preferences.favoriteDrinkIds
        .where(_isKnownFavorite)
        .take(10)
        .toList(growable: false);

    await _database.transaction(() async {
      await _database
          .into(_database.localAppSettings)
          .insertOnConflictUpdate(
            LocalAppSettingsCompanion.insert(
              id: const Value(1),
              onboardingComplete: preferences.onboardingComplete,
              goalMode: preferences.goalMode.name,
              caffeineLimitMg: _limitFromStorage(
                preferences.caffeineLimitMg,
                preferences.goalMode.name,
              ),
              themePreset: preferences.themePreset.name,
              smartReminderEnabled: Value(preferences.smartReminder),
            ),
          );

      // Default 9:00 PM check-in notification is managed globally by NotificationService
      // and not stored in user's custom fixed drink reminders table.

      await (_database.delete(_database.favoriteDrinkRows)).go();

      if (favoriteIds.isNotEmpty) {
        await _database.batch((batch) {
          batch.insertAll(_database.favoriteDrinkRows, [
            for (final entry in favoriteIds.indexed)
              FavoriteDrinkRowsCompanion.insert(
                drinkId: entry.$2,
                position: entry.$1,
              ),
          ]);
        });
      }
    });
  }

  LocalAppSettingsCompanion _defaultSettings() =>
      LocalAppSettingsCompanion.insert(
        id: Value(1),
        onboardingComplete: false,
        goalMode: 'tracking',
        caffeineLimitMg: 400,
        themePreset: 'coffee',
      );

  bool _isKnownFavorite(String id) =>
      id.startsWith('custom:') ||
      const {
        'espresso',
        'americano',
        'latte',
        'matcha',
        'tea',
        'cold_brew',
        'coldbrew',
        'blackcoffee',
        'cappuccino',
        'icedlatte',
        'energy',
        'other',
      }.contains(id);

  CaffeineGoalMode _goalModeFromStorage(String value) =>
      CaffeineGoalMode.values.firstWhere(
        (mode) => mode.name == value,
        orElse: () => CaffeineGoalMode.tracking,
      );

  CoffeeThemePreset _themeFromStorage(String value) =>
      CoffeeThemePreset.values.firstWhere(
        (preset) => preset.name == value,
        orElse: () => CoffeeThemePreset.coffee,
      );

  int _limitFromStorage(int value, String mode) {
    if (mode == CaffeineGoalMode.quitting.name) return 0;
    final bounded = value.clamp(50, 600);
    return (50 + (((bounded - 50) / 25).round() * 25)).clamp(50, 600);
  }
}
