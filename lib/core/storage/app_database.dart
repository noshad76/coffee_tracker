import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class LocalAppSettings extends Table {
  IntColumn get id => integer()();

  BoolColumn get onboardingComplete => boolean()();

  TextColumn get goalMode => text()();

  IntColumn get caffeineLimitMg => integer()();

  TextColumn get themePreset => text()();

  BoolColumn get smartReminderEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FavoriteDrinkRows extends Table {
  TextColumn get drinkId => text()();

  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {drinkId};
}

class DrinkEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get caffeineMg => integer()();
  IntColumn get volumeMl => integer()();
  DateTimeColumn get consumedAtUtc => dateTime()();
  IntColumn get priceCents => integer().withDefault(const Constant(0))();
  TextColumn get temperature => text().withDefault(const Constant('Hot'))();
  TextColumn get location => text().withDefault(const Constant('home'))();
  TextColumn get cafeName => text().nullable()();
  TextColumn get cupStyle =>
      text().withDefault(const Constant('Ceramic Mug'))();
  TextColumn get note => text().nullable()();
  TextColumn get photoPath => text().nullable()();
}

class FeatureIdeas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get anonymous => boolean().withDefault(const Constant(false))();
  BoolColumn get voted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAtUtc => dateTime()();
}

class LocalReminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}

class CustomLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAtUtc => dateTime()();
}

@DriftDatabase(
  tables: [
    LocalAppSettings,
    FavoriteDrinkRows,
    DrinkEntries,
    FeatureIdeas,
    LocalReminders,
    CustomLocations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'coffeeaholic'));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(drinkEntries);
        await migrator.createTable(featureIdeas);
      } else if (from < 3) {
        await migrator.addColumn(drinkEntries, drinkEntries.photoPath);
      }
      if (from < 4) {
        await migrator.addColumn(
          localAppSettings,
          localAppSettings.smartReminderEnabled,
        );
        await migrator.createTable(localReminders);
      }
      if (from < 5) {
        await migrator.createTable(customLocations);
        try {
          final legacyDrinks = await select(drinkEntries).get();
          final existing = <String>{};
          for (final d in legacyDrinks) {
            final loc = d.location.trim();
            if (loc.isNotEmpty &&
                loc != 'home' &&
                loc != 'cafe' &&
                loc != 'work' &&
                loc != 'custom') {
              existing.add(loc);
            }
            final cafe = d.cafeName?.trim();
            if (cafe != null && cafe.isNotEmpty && d.location == 'custom') {
              existing.add(cafe);
            }
          }
          for (final name in existing) {
            await into(customLocations).insert(
              CustomLocationsCompanion.insert(
                name: name,
                createdAtUtc: DateTime.now().toUtc(),
              ),
              mode: InsertMode.insertOrIgnore,
            );
          }
        } catch (_) {}
      }
    },
  );
}
