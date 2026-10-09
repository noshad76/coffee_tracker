import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_tracker/core/storage/app_database.dart';
import 'package:coffee_tracker/core/storage/app_database_provider.dart';
import 'package:coffee_tracker/features/drink_log/providers/custom_locations_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('can add and remove custom locations', () async {
    final notifier = container.read(customLocationsProvider.notifier);

    // Initial state is empty
    final initial = await container.read(customLocationsProvider.future);
    expect(initial, isEmpty);

    // Add a custom location
    await notifier.addLocation('Gym');
    final afterAdd = container.read(customLocationsProvider).valueOrNull;
    expect(afterAdd, contains('Gym'));

    // Verify it is saved in SQLite database!
    final dbRows = await db.select(db.customLocations).get();
    expect(dbRows.map((r) => r.name), contains('Gym'));

    // Add another
    await notifier.addLocation('Office Library');
    final afterSecond = container.read(customLocationsProvider).valueOrNull;
    expect(afterSecond, containsAll(['Gym', 'Office Library']));

    // Remove one
    await notifier.removeLocation('Gym');
    final afterRemove = container.read(customLocationsProvider).valueOrNull;
    expect(afterRemove, isNot(contains('Gym')));
    expect(afterRemove, contains('Office Library'));

    // Verify it is removed from SQLite database!
    final dbRowsAfter = await db.select(db.customLocations).get();
    expect(dbRowsAfter.map((r) => r.name), isNot(contains('Gym')));
    expect(dbRowsAfter.map((r) => r.name), contains('Office Library'));
  });
}
