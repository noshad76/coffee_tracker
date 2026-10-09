import 'package:coffee_tracker/core/storage/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('version 1 preferences survive the migration to version 3', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE local_app_settings (id INTEGER NOT NULL, onboarding_complete INTEGER NOT NULL CHECK (onboarding_complete IN (0, 1)), goal_mode TEXT NOT NULL, caffeine_limit_mg INTEGER NOT NULL, theme_preset TEXT NOT NULL, PRIMARY KEY (id))',
          );
          raw.execute(
            'CREATE TABLE favorite_drink_rows (drink_id TEXT NOT NULL, position INTEGER NOT NULL, PRIMARY KEY (drink_id))',
          );
          raw.execute(
            "INSERT INTO local_app_settings VALUES (1, 1, 'tracking', 400, 'forest')",
          );
          raw.execute("INSERT INTO favorite_drink_rows VALUES ('espresso', 0)");
          raw.execute('PRAGMA user_version = 1');
        },
      ),
    );
    addTearDown(database.close);

    final settings = await database
        .select(database.localAppSettings)
        .getSingle();
    final favorites = await database.select(database.favoriteDrinkRows).get();
    expect(settings.themePreset, 'forest');
    expect(favorites.single.drinkId, 'espresso');
    expect(await database.select(database.drinkEntries).get(), isEmpty);
    expect(await database.select(database.featureIdeas).get(), isEmpty);
  });

  test('version 2 drink entries survive the version 3 photo_path migration', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE local_app_settings (id INTEGER NOT NULL, onboarding_complete INTEGER NOT NULL CHECK (onboarding_complete IN (0, 1)), goal_mode TEXT NOT NULL, caffeine_limit_mg INTEGER NOT NULL, theme_preset TEXT NOT NULL, PRIMARY KEY (id))',
          );
          raw.execute(
            'CREATE TABLE favorite_drink_rows (drink_id TEXT NOT NULL, position INTEGER NOT NULL, PRIMARY KEY (drink_id))',
          );
          raw.execute(
            'CREATE TABLE drink_entries (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, caffeine_mg INTEGER NOT NULL, volume_ml INTEGER NOT NULL, consumed_at_utc INTEGER NOT NULL, price_cents INTEGER NOT NULL DEFAULT 0, temperature TEXT NOT NULL DEFAULT \'Hot\', location TEXT NOT NULL DEFAULT \'home\', cafe_name TEXT, cup_style TEXT NOT NULL DEFAULT \'Ceramic Mug\', note TEXT)',
          );
          raw.execute(
            'CREATE TABLE feature_ideas (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, anonymous INTEGER NOT NULL DEFAULT 0, voted INTEGER NOT NULL DEFAULT 0, created_at_utc INTEGER NOT NULL)',
          );
          raw.execute(
            "INSERT INTO drink_entries (name, caffeine_mg, volume_ml, consumed_at_utc, price_cents, temperature, location, cup_style, note) VALUES ('Latte', 120, 300, 1727900000, 350, 'Hot', 'cafe', 'Ceramic Mug', 'Oat milk')",
          );
          raw.execute('PRAGMA user_version = 2');
        },
      ),
    );
    addTearDown(database.close);

    final drinks = await database.select(database.drinkEntries).get();
    expect(drinks, hasLength(1));
    expect(drinks.first.name, 'Latte');
    expect(drinks.first.caffeineMg, 120);
    expect(drinks.first.note, 'Oat milk');
    expect(drinks.first.photoPath, isNull);
    expect(await database.select(database.localReminders).get(), isEmpty);
  });

  test('version 3 database upgrades to version 4 with reminders', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE local_app_settings (id INTEGER NOT NULL, onboarding_complete INTEGER NOT NULL CHECK (onboarding_complete IN (0, 1)), goal_mode TEXT NOT NULL, caffeine_limit_mg INTEGER NOT NULL, theme_preset TEXT NOT NULL, PRIMARY KEY (id))',
          );
          raw.execute(
            'CREATE TABLE favorite_drink_rows (drink_id TEXT NOT NULL, position INTEGER NOT NULL, PRIMARY KEY (drink_id))',
          );
          raw.execute(
            'CREATE TABLE drink_entries (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, caffeine_mg INTEGER NOT NULL, volume_ml INTEGER NOT NULL, consumed_at_utc INTEGER NOT NULL, price_cents INTEGER NOT NULL DEFAULT 0, temperature TEXT NOT NULL DEFAULT \'Hot\', location TEXT NOT NULL DEFAULT \'home\', cafe_name TEXT, cup_style TEXT NOT NULL DEFAULT \'Ceramic Mug\', note TEXT, photo_path TEXT)',
          );
          raw.execute(
            'CREATE TABLE feature_ideas (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, anonymous INTEGER NOT NULL DEFAULT 0, voted INTEGER NOT NULL DEFAULT 0, created_at_utc INTEGER NOT NULL)',
          );
          raw.execute(
            "INSERT INTO local_app_settings VALUES (1, 1, 'tracking', 400, 'forest')",
          );
          raw.execute('PRAGMA user_version = 3');
        },
      ),
    );
    addTearDown(database.close);

    final settings = await database
        .select(database.localAppSettings)
        .getSingle();
    expect(settings.smartReminderEnabled, isFalse);
    expect(await database.select(database.localReminders).get(), isEmpty);
  });

  test('version 4 database upgrades to version 5 with custom locations', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE local_app_settings (id INTEGER NOT NULL, onboarding_complete INTEGER NOT NULL CHECK (onboarding_complete IN (0, 1)), goal_mode TEXT NOT NULL, caffeine_limit_mg INTEGER NOT NULL, theme_preset TEXT NOT NULL, smart_reminder_enabled INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (id))',
          );
          raw.execute(
            'CREATE TABLE favorite_drink_rows (drink_id TEXT NOT NULL, position INTEGER NOT NULL, PRIMARY KEY (drink_id))',
          );
          raw.execute(
            'CREATE TABLE drink_entries (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, caffeine_mg INTEGER NOT NULL, volume_ml INTEGER NOT NULL, consumed_at_utc INTEGER NOT NULL, price_cents INTEGER NOT NULL DEFAULT 0, temperature TEXT NOT NULL DEFAULT \'Hot\', location TEXT NOT NULL DEFAULT \'home\', cafe_name TEXT, cup_style TEXT NOT NULL DEFAULT \'Ceramic Mug\', note TEXT, photo_path TEXT)',
          );
          raw.execute(
            'CREATE TABLE feature_ideas (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, anonymous INTEGER NOT NULL DEFAULT 0, voted INTEGER NOT NULL DEFAULT 0, created_at_utc INTEGER NOT NULL)',
          );
          raw.execute(
            'CREATE TABLE local_reminders (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, hour INTEGER NOT NULL, minute INTEGER NOT NULL, enabled INTEGER NOT NULL DEFAULT 1)',
          );
          raw.execute(
            "INSERT INTO drink_entries (name, caffeine_mg, volume_ml, consumed_at_utc, location) VALUES ('Cold Brew', 200, 350, 1000, 'Gym')",
          );
          raw.execute('PRAGMA user_version = 4');
        },
      ),
    );
    addTearDown(database.close);

    final locations = await database.select(database.customLocations).get();
    expect(locations, hasLength(1));
    expect(locations.first.name, 'Gym');
  });
}
