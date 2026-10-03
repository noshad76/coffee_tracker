import 'package:drift/drift.dart';

import '../../../core/storage/app_database.dart';
import '../models/tracking_models.dart' as model;
import '../models/tracking_repository.dart';

class DriftTrackingRepository implements TrackingRepository {
  const DriftTrackingRepository(this.database);
  final AppDatabase database;

  @override
  Future<model.TrackingSnapshot> load() async {
    final drinks = await (database.select(
      database.drinkEntries,
    )..orderBy([(row) => OrderingTerm.desc(row.consumedAtUtc)])).get();
    final ideas = await (database.select(
      database.featureIdeas,
    )..orderBy([(row) => OrderingTerm.desc(row.createdAtUtc)])).get();
    return model.TrackingSnapshot(
      drinks: [
        for (final row in drinks)
          model.DrinkRecord(
            id: row.id,
            name: row.name,
            caffeineMg: row.caffeineMg,
            volumeMl: row.volumeMl,
            consumedAtUtc: row.consumedAtUtc,
            priceCents: row.priceCents,
            temperature: row.temperature,
            location: row.location,
            cafeName: row.cafeName,
            cupStyle: row.cupStyle,
            note: row.note,
          ),
      ],
      ideas: [
        for (final row in ideas)
          model.FeatureIdea(
            id: row.id,
            title: row.title,
            description: row.description,
            anonymous: row.anonymous,
            voted: row.voted,
            createdAtUtc: row.createdAtUtc,
          ),
      ],
    );
  }

  @override
  Future<void> addDrink(model.DrinkDraft draft) async {
    await database
        .into(database.drinkEntries)
        .insert(
          DrinkEntriesCompanion.insert(
            name: draft.name,
            caffeineMg: draft.caffeineMg,
            volumeMl: draft.volumeMl,
            consumedAtUtc: draft.consumedAtUtc,
            priceCents: Value(draft.priceCents),
            temperature: Value(draft.temperature),
            location: Value(draft.location),
            cafeName: Value(draft.cafeName),
            cupStyle: Value(draft.cupStyle),
            note: Value(draft.note),
          ),
        );
  }

  @override
  Future<void> updateDrink(int id, model.DrinkDraft draft) async {
    await (database.update(
      database.drinkEntries,
    )..where((row) => row.id.equals(id))).write(
      DrinkEntriesCompanion(
        name: Value(draft.name),
        caffeineMg: Value(draft.caffeineMg),
        volumeMl: Value(draft.volumeMl),
        consumedAtUtc: Value(draft.consumedAtUtc),
        priceCents: Value(draft.priceCents),
        temperature: Value(draft.temperature),
        location: Value(draft.location),
        cafeName: Value(draft.cafeName),
        cupStyle: Value(draft.cupStyle),
        note: Value(draft.note),
      ),
    );
  }

  @override
  Future<void> deleteDrink(int id) async {
    await (database.delete(
      database.drinkEntries,
    )..where((row) => row.id.equals(id))).go();
  }

  @override
  Future<void> addIdea(String title, String description, bool anonymous) async {
    await database
        .into(database.featureIdeas)
        .insert(
          FeatureIdeasCompanion.insert(
            title: title,
            description: description,
            anonymous: Value(anonymous),
            createdAtUtc: DateTime.now().toUtc(),
          ),
        );
  }

  @override
  Future<void> toggleVote(int id, bool voted) async {
    await (database.update(database.featureIdeas)
          ..where((row) => row.id.equals(id)))
        .write(FeatureIdeasCompanion(voted: Value(voted)));
  }
}
