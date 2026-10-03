import 'package:coffee_tracker/app/theme/app_theme.dart';
import 'package:coffee_tracker/core/models/coffee_theme_preset.dart';
import 'package:coffee_tracker/features/calendar/widgets/earned_badges_card.dart';
import 'package:coffee_tracker/features/tracking/models/tracking_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EarnedBadgesCard shows badges and details on tap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 840);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final now = DateTime(2026, 10, 4, 10, 0); // 10:00 AM (before 2 PM)
    final testDrinks = [
      DrinkRecord(
        id: 1,
        name: 'Espresso',
        caffeineMg: 75,
        volumeMl: 30,
        consumedAtUtc: now.toUtc(),
        priceCents: 250,
        temperature: 'Hot',
        location: 'home',
        cupStyle: 'Ceramic Mug',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(CoffeeThemePreset.coffee),
        home: Scaffold(
          body: EarnedBadgesCard(drinks: testDrinks, caffeineLimitMg: 400),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('EARNED BADGES'), findsOneWidget);
    expect(find.text('First Sip'), findsOneWidget);
    expect(find.text('Under 400'), findsOneWidget);
    expect(find.text('7-Day Run'), findsOneWidget);
    expect(find.text('No-Crash'), findsOneWidget);

    // Tap on First Sip to open details modal
    await tester.tap(find.text('First Sip'));
    await tester.pumpAndSettle();

    expect(find.text('Earned'), findsOneWidget);
    expect(
      find.text('Logged your very first drink in the app.'),
      findsOneWidget,
    );
    expect(find.text('How to earn: Log at least one drink.'), findsOneWidget);

    // Tap close
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('How to earn: Log at least one drink.'), findsNothing);
  });
}
