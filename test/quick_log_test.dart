import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_tracker/app/theme/app_theme.dart';
import 'package:coffee_tracker/core/models/coffee_theme_preset.dart';
import 'package:coffee_tracker/features/onboarding/models/onboarding_preferences.dart';
import 'package:coffee_tracker/features/onboarding/models/onboarding_repository.dart';
import 'package:coffee_tracker/features/onboarding/providers/onboarding_repository_provider.dart';
import 'package:coffee_tracker/features/today/today_page.dart';
import 'package:coffee_tracker/features/today/widgets/edit_quick_log_sheet.dart';
import 'package:coffee_tracker/features/tracking/models/tracking_models.dart';
import 'package:coffee_tracker/features/tracking/models/tracking_repository.dart';
import 'package:coffee_tracker/features/tracking/providers/tracking_providers.dart';

class _MockOnboardingRepo implements OnboardingRepository {
  _MockOnboardingRepo({OnboardingPreferences? initial})
      : preferences = initial ?? OnboardingPreferences.initial;

  OnboardingPreferences preferences;

  @override
  Future<OnboardingPreferences> loadPreferences() async => preferences;

  @override
  Future<void> savePreferences(OnboardingPreferences value) async {
    preferences = value;
  }
}

class _MockTrackingRepo implements TrackingRepository {
  final List<DrinkDraft> addedDrinks = [];

  @override
  Future<TrackingSnapshot> load() async =>
      const TrackingSnapshot(drinks: [], ideas: []);
  @override
  Future<void> addDrink(DrinkDraft draft) async => addedDrinks.add(draft);
  @override
  Future<void> updateDrink(int id, DrinkDraft draft) async {}
  @override
  Future<void> deleteDrink(int id) async {}
  @override
  Future<void> addIdea(String title, String description, bool anonymous) async {}
  @override
  Future<void> toggleVote(int id, bool voted) async {}
}

void main() {
  testWidgets('Quick Log renders shortcuts and opens customization sheet', (
    tester,
  ) async {
    final onboardingRepo = _MockOnboardingRepo(
      initial: OnboardingPreferences.initial.copyWith(
        onboardingComplete: true,
        favoriteDrinkIds: ['espresso', 'americano'],
      ),
    );
    final trackingRepo = _MockTrackingRepo();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(onboardingRepo),
          trackingRepositoryProvider.overrideWithValue(trackingRepo),
        ],
        child: MaterialApp(
          theme: AppTheme.build(CoffeeThemePreset.coffee),
          home: Scaffold(
            body: TodayPage(
              snapshot: const TrackingSnapshot(drinks: [], ideas: []),
              onLog: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('QUICK LOG'), findsOneWidget);
    expect(find.text('Espresso'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Add'), findsNothing);

    // Tap quick log item to log it
    await tester.tap(find.text('Espresso'));
    await tester.pumpAndSettle();
    expect(trackingRepo.addedDrinks, hasLength(1));
    expect(trackingRepo.addedDrinks.first.name, 'Espresso');

    // Tap Edit to open Customize Quick Log sheet
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Customize Quick Log'), findsOneWidget);
    expect(find.byType(EditQuickLogSheet), findsOneWidget);

    // Tap Custom button
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();

    expect(find.text('Add Custom Drink'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'e.g. Double Cortado'),
      'Cortado Special',
    );
    await tester.tap(find.text('Add Drink'));
    await tester.pumpAndSettle();

    expect(find.text('Add Custom Drink'), findsNothing);
    expect(find.text('Cortado Special'), findsOneWidget);

    // Save changes
    await tester.tap(find.text('Save Quick Log'));
    await tester.pumpAndSettle();

    expect(find.byType(EditQuickLogSheet), findsNothing);
  });

  testWidgets('Saving empty quick log restores the 3 onboarding favorites', (
    tester,
  ) async {
    final onboardingRepo = _MockOnboardingRepo(
      initial: OnboardingPreferences.initial.copyWith(
        onboardingComplete: true,
        favoriteDrinkIds: ['espresso', 'americano', 'latte'],
      ),
    );
    final trackingRepo = _MockTrackingRepo();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(onboardingRepo),
          trackingRepositoryProvider.overrideWithValue(trackingRepo),
        ],
        child: MaterialApp(
          theme: AppTheme.build(CoffeeThemePreset.coffee),
          home: Scaffold(
            body: TodayPage(
              snapshot: const TrackingSnapshot(drinks: [], ideas: []),
              onLog: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Edit
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    // Remove all 3 pinned shortcuts
    for (int i = 0; i < 3; i++) {
      final closeBtn = find.byIcon(Icons.close_rounded).first;
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();
    }

    expect(find.text('PINNED SHORTCUTS (0/10)'), findsOneWidget);

    // Tap Save Quick Log while empty
    await tester.tap(find.text('Save Quick Log'));
    await tester.pumpAndSettle();

    // Verify it restored the 3 onboarding favorites
    expect(onboardingRepo.preferences.favoriteDrinkIds, hasLength(3));
    expect(onboardingRepo.preferences.favoriteDrinkIds, [
      'espresso',
      'americano',
      'latte',
    ]);
  });
}
