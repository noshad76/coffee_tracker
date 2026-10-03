import 'tracking_models.dart';

abstract class TrackingRepository {
  Future<TrackingSnapshot> load();
  Future<void> addDrink(DrinkDraft draft);
  Future<void> updateDrink(int id, DrinkDraft draft);
  Future<void> deleteDrink(int id);
  Future<void> addIdea(String title, String description, bool anonymous);
  Future<void> toggleVote(int id, bool voted);
}
