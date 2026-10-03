import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracking_models.dart';
import '../models/tracking_repository.dart';
import '../providers/tracking_providers.dart';

class TrackingController extends AsyncNotifier<TrackingSnapshot> {
  late TrackingRepository _repository;

  @override
  Future<TrackingSnapshot> build() async {
    _repository = ref.watch(trackingRepositoryProvider);
    return _repository.load();
  }

  Future<void> refresh() async => state = AsyncData(await _repository.load());

  Future<void> addDrink(DrinkDraft draft) async {
    await _repository.addDrink(draft);
    await refresh();
  }

  Future<void> updateDrink(int id, DrinkDraft draft) async {
    await _repository.updateDrink(id, draft);
    await refresh();
  }

  Future<void> deleteDrink(int id) async {
    await _repository.deleteDrink(id);
    await refresh();
  }

  Future<void> addIdea(String title, String description, bool anonymous) async {
    await _repository.addIdea(title, description, anonymous);
    await refresh();
  }

  Future<void> toggleVote(FeatureIdea idea) async {
    await _repository.toggleVote(idea.id, !idea.voted);
    await refresh();
  }
}
