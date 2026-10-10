import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracking_models.dart';
import '../models/tracking_repository.dart';
import '../providers/tracking_providers.dart';
import '../../onboarding/providers/onboarding_providers.dart';
import '../../settings/providers/reminders_provider.dart';
import '../../../core/services/widget_sync_service.dart';

class TrackingController extends AsyncNotifier<TrackingSnapshot> {
  late TrackingRepository _repository;

  @override
  Future<TrackingSnapshot> build() async {
    _repository = ref.watch(trackingRepositoryProvider);
    final snapshot = await _repository.load();
    _syncWidgets(snapshot.drinks);
    return snapshot;
  }

  Future<void> refresh() async {
    final snapshot = await _repository.load();
    state = AsyncData(snapshot);
    _syncWidgets(snapshot.drinks);
  }

  void _syncWidgets(List<DrinkRecord> drinks) {
    try {
      final preferences =
          ref.read(onboardingControllerProvider).valueOrNull?.preferences;
      if (preferences == null) {
        // Never overwrite widget data with fallback defaults before preferences load!
        return;
      }
      final favorites = preferences.favoriteDrinkIds;
      final limit = preferences.caffeineLimitMg;
      final themePreset = preferences.themePreset;
      WidgetSyncService.syncWidgets(
        drinks: drinks,
        favoriteDrinkIds: favorites,
        caffeineLimitMg: limit,
        themePreset: themePreset,
      );
    } catch (_) {}
  }

  Future<void> addDrink(DrinkDraft draft) async {
    await _repository.addDrink(draft);
    await refresh();
    ref.invalidate(remindersProvider);
  }

  Future<void> updateDrink(int id, DrinkDraft draft) async {
    await _repository.updateDrink(id, draft);
    await refresh();
    ref.invalidate(remindersProvider);
  }

  Future<void> deleteDrink(int id) async {
    await _repository.deleteDrink(id);
    await refresh();
    ref.invalidate(remindersProvider);
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
