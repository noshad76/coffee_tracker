import 'package:coffee_tracker/app/theme/app_theme.dart';
import 'package:coffee_tracker/core/models/coffee_theme_preset.dart';
import 'package:coffee_tracker/features/onboarding/models/onboarding_preferences.dart';
import 'package:coffee_tracker/features/onboarding/models/onboarding_repository.dart';
import 'package:coffee_tracker/features/onboarding/providers/onboarding_repository_provider.dart';
import 'package:coffee_tracker/features/shell/main_shell.dart';
import 'package:coffee_tracker/features/tracking/models/tracking_models.dart';
import 'package:coffee_tracker/features/tracking/models/tracking_repository.dart';
import 'package:coffee_tracker/features/tracking/providers/tracking_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _SettingsRepository implements OnboardingRepository {
  OnboardingPreferences value = OnboardingPreferences.initial.copyWith(
    onboardingComplete: true,
    favoriteDrinkIds: ['espresso', 'americano', 'latte'],
  );

  @override
  Future<OnboardingPreferences> loadPreferences() async => value;

  @override
  Future<void> savePreferences(OnboardingPreferences preferences) async {
    value = preferences;
  }
}

class _TrackingRepository implements TrackingRepository {
  final drinks = <DrinkRecord>[];
  final ideas = <FeatureIdea>[];

  @override
  Future<TrackingSnapshot> load() async =>
      TrackingSnapshot(drinks: [...drinks], ideas: [...ideas]);

  @override
  Future<void> addDrink(DrinkDraft draft) async {
    drinks.add(
      DrinkRecord(
        id: drinks.length + 1,
        name: draft.name,
        caffeineMg: draft.caffeineMg,
        volumeMl: draft.volumeMl,
        consumedAtUtc: draft.consumedAtUtc,
        priceCents: draft.priceCents,
        temperature: draft.temperature,
        location: draft.location,
        cupStyle: draft.cupStyle,
      ),
    );
  }

  @override
  Future<void> updateDrink(int id, DrinkDraft draft) async {
    final index = drinks.indexWhere((drink) => drink.id == id);
    drinks[index] = DrinkRecord(
      id: id,
      name: draft.name,
      caffeineMg: draft.caffeineMg,
      volumeMl: draft.volumeMl,
      consumedAtUtc: draft.consumedAtUtc,
      priceCents: draft.priceCents,
      temperature: draft.temperature,
      location: draft.location,
      cupStyle: draft.cupStyle,
    );
  }

  @override
  Future<void> deleteDrink(int id) async =>
      drinks.removeWhere((drink) => drink.id == id);

  @override
  Future<void> addIdea(String title, String description, bool anonymous) async {
    ideas.add(
      FeatureIdea(
        id: ideas.length + 1,
        title: title,
        description: description,
        anonymous: anonymous,
        voted: false,
        createdAtUtc: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Future<void> toggleVote(int id, bool voted) async {
    final index = ideas.indexWhere((idea) => idea.id == id);
    final old = ideas[index];
    ideas[index] = FeatureIdea(
      id: old.id,
      title: old.title,
      description: old.description,
      anonymous: old.anonymous,
      voted: voted,
      createdAtUtc: old.createdAtUtc,
    );
  }
}

void main() {
  testWidgets('main tabs reflect a saved quick log and local idea', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 840);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final tracking = _TrackingRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(_SettingsRepository()),
          trackingRepositoryProvider.overrideWithValue(tracking),
        ],
        child: MaterialApp(
          theme: AppTheme.build(CoffeeThemePreset.coffee),
          home: const MainShell(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('QUICK LOG'), findsOneWidget);

    await tester.tap(find.text('Espresso').first);
    await tester.pumpAndSettle();
    expect(tracking.drinks, hasLength(1));
    expect(find.text('75'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Calendar').last);
    await tester.pumpAndSettle();
    expect(find.text('EARNED BADGES'), findsOneWidget);

    await tester.tap(find.text('Stats').last);
    await tester.pumpAndSettle();
    expect(find.text('Intake Trend'), findsOneWidget);

    await tester.tap(find.text('Roadmap'));
    await tester.pumpAndSettle();
    expect(find.text('Feature Board'), findsOneWidget);
    await tester.tap(find.text('+ Propose'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Home widget',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Description'),
      'A faster quick log.',
    );
    await tester.tap(find.text('Post Suggestion'));
    await tester.pumpAndSettle();
    expect(tracking.ideas, hasLength(1));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsOneWidget);

    await tester.tap(find.byTooltip('Change theme'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Matcha'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a theme'), findsNothing);

    await tester.tap(find.byTooltip('Switch mode'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cutting Back'));
    await tester.pumpAndSettle();
    expect(find.text('Switch Mode'), findsNothing);

    await tester.tap(find.byTooltip('Log drink'));
    await tester.pumpAndSettle();
    expect(find.text('Log Drink'), findsOneWidget);
    await tester.ensureVisible(find.text('Log Entry'));
    await tester.tap(find.text('Log Entry'));
    await tester.pumpAndSettle();
    expect(tracking.drinks, hasLength(2));

    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byTooltip('Actions for Latte'), 250);
    await tester.tap(find.byTooltip('Actions for Latte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Drink Name'),
      'Edited Latte',
    );
    await tester.ensureVisible(find.text('Save Changes'));
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();
    expect(tracking.drinks.last.name, 'Edited Latte');
  });
}
