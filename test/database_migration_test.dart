import 'package:coffee_tracker/core/storage/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('version 1 preferences survive the version 2 table migration', () async {
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
}
