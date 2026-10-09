import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_database.dart';
import '../../../core/storage/app_database_provider.dart';

final customLocationsProvider =
    AsyncNotifierProvider<CustomLocationsNotifier, List<String>>(
      CustomLocationsNotifier.new,
    );

class CustomLocationsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final db = ref.watch(appDatabaseProvider);
    final rows = await (db.select(
      db.customLocations,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
    return rows.map((r) => r.name).toList();
  }

  Future<void> addLocation(String name) async {
    final clean = name.trim();
    if (clean.isEmpty) return;
    final lower = clean.toLowerCase();
    if (lower == 'home' || lower == 'cafe' || lower == 'work') return;

    final current = state.valueOrNull ?? [];
    if (!current.contains(clean)) {
      final updated = [...current, clean]
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      state = AsyncData(updated);
    }

    final db = ref.read(appDatabaseProvider);
    await db
        .into(db.customLocations)
        .insert(
          CustomLocationsCompanion.insert(
            name: clean,
            createdAtUtc: DateTime.now().toUtc(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> removeLocation(String name) async {
    final clean = name.trim();
    if (clean.isEmpty) return;

    final current = state.valueOrNull ?? [];
    final updated = current.where((p) => p != clean).toList();
    state = AsyncData(updated);

    final db = ref.read(appDatabaseProvider);
    await (db.delete(
      db.customLocations,
    )..where((tbl) => tbl.name.equals(clean))).go();
  }
}
