import 'package:coffee_tracker/app/coffeeaholic_app.dart';
import 'package:coffee_tracker/features/onboarding/models/onboarding_preferences.dart';
import 'package:coffee_tracker/features/onboarding/models/onboarding_repository.dart';
import 'package:coffee_tracker/features/onboarding/providers/onboarding_repository_provider.dart';
import 'package:coffee_tracker/features/tracking/models/tracking_models.dart';
import 'package:coffee_tracker/features/tracking/models/tracking_repository.dart';
import 'package:coffee_tracker/features/tracking/providers/tracking_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryOnboardingRepository implements OnboardingRepository {
  OnboardingPreferences preferences = OnboardingPreferences.initial;

  @override
  Future<OnboardingPreferences> loadPreferences() async => preferences;

  @override
  Future<void> savePreferences(OnboardingPreferences value) async {
    preferences = value;
  }
}

class _EmptyTrackingRepository implements TrackingRepository {
  @override
  Future<TrackingSnapshot> load() async =>
      const TrackingSnapshot(drinks: [], ideas: []);
  @override
  Future<void> addDrink(DrinkDraft draft) async {}
  @override
  Future<void> updateDrink(int id, DrinkDraft draft) async {}
  @override
  Future<void> deleteDrink(int id) async {}
  @override
  Future<void> addIdea(
    String title,
    String description,
    bool anonymous,
  ) async {}
  @override
  Future<void> toggleVote(int id, bool voted) async {}
}

void main() {
  testWidgets('onboarding keeps the reference steps and saves choices', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 840);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _MemoryOnboardingRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(repository),
          trackingRepositoryProvider.overrideWithValue(
            _EmptyTrackingRepository(),
          ),
        ],
        child: const CoffeeaholicApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Know your\ncoffee.'), findsOneWidget);
    expect(find.text('One-tap logging'), findsOneWidget);
    expect(
      find.text('Everything stays on your phone. No account, no server.'),
      findsOneWidget,
    );
    expect(find.text('Skip'), findsNothing);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('What brings you here?'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Cutting back'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Set your daily goal'), findsOneWidget);
    expect(find.text('200 mg'), findsWidgets);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What do you usually drink?'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Espresso'));
    await tester.tap(find.text('Americano'));
    await tester.tap(find.text('Latte'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(3));
    await tester.tap(find.text('Matcha Latte'));
    await tester.pumpAndSettle();
    expect(
      find.text('You can choose up to 3 favorite drinks.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(3));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Never miss a brew'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(repository.preferences.onboardingComplete, isTrue);
    expect(repository.preferences.goalMode, CaffeineGoalMode.cuttingBack);
    expect(repository.preferences.favoriteDrinkIds, contains('espresso'));
    expect(repository.preferences.favoriteDrinkIds, hasLength(3));
    expect(repository.preferences.favoriteDrinkIds, isNot(contains('matcha')));
    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('tapping Skip in header completes onboarding with defaults', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 840);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _MemoryOnboardingRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(repository),
          trackingRepositoryProvider.overrideWithValue(
            _EmptyTrackingRepository(),
          ),
        ],
        child: const CoffeeaholicApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(repository.preferences.onboardingComplete, isTrue);
    expect(repository.preferences.goalMode, CaffeineGoalMode.tracking);
    expect(repository.preferences.caffeineLimitMg, 400);
    expect(find.text('Today'), findsOneWidget);
  });
}
