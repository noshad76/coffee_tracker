import 'package:coffee_tracker/core/models/coffee_theme_preset.dart';
import 'package:coffee_tracker/core/services/widget_sync_service.dart';
import 'package:coffee_tracker/features/tracking/models/tracking_models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final savedData = <String, dynamic>{};
  final updatedWidgets = <String>[];

  setUp(() {
    savedData.clear();
    updatedWidgets.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('home_widget'), (
          call,
        ) async {
          if (call.method == 'saveWidgetData') {
            final args = call.arguments as Map<dynamic, dynamic>;
            savedData[args['id'] as String] = args['data'];
            return true;
          } else if (call.method == 'updateWidget') {
            final args = call.arguments as Map<dynamic, dynamic>;
            updatedWidgets.add(args['android'] as String);
            return true;
          } else if (call.method == 'setAppGroupId') {
            return true;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('home_widget'), null);
  });

  test('syncWidgets saves empty metabolism data when zero drinks logged', () async {
    final now = DateTime(2026, 10, 10, 10, 0);
    await WidgetSyncService.syncWidgets(
      drinks: const [],
      favoriteDrinkIds: const ['espresso', 'americano', 'latte'],
      caffeineLimitMg: 400,
      now: now,
    );

    expect(savedData['metabolism_active_mg'], 0);
    expect(savedData['metabolism_status_text'], 'Sleep-Safe Now');
    expect(savedData['metabolism_status_color'], 'success');
    expect(savedData['metabolism_half_life_mg'], 0);
    expect(savedData['today_total_mg'], 0);
    expect(savedData['today_limit_mg'], 400);
    expect(savedData['quick_drink_count'], 3);
    expect(savedData['quick_drink_0_id'], 'espresso');
    expect(savedData['quick_drink_0_name'], 'Espresso');
    expect(savedData['quick_drink_0_mg'], 75);
    expect(updatedWidgets, contains('MetabolismWidgetProvider'));
    expect(updatedWidgets, contains('QuickLogWidgetProvider'));
  });

  test('syncWidgets calculates accurate decay when drinks exist', () async {
    final now = DateTime.utc(2026, 10, 10, 12, 0);
    final drinks = [
      DrinkRecord(
        id: 1,
        name: 'Espresso',
        caffeineMg: 150,
        volumeMl: 60,
        consumedAtUtc: now.subtract(const Duration(hours: 6)),
        priceCents: 350,
        temperature: 'Hot',
        location: 'home',
        cupStyle: 'mug',
      ),
    ];

    await WidgetSyncService.syncWidgets(
      drinks: drinks,
      favoriteDrinkIds: const ['espresso', 'americano', 'cappuccino', 'latte'],
      caffeineLimitMg: 400,
      now: now.toLocal(),
    );

    // After 6 hours, 150mg decays to 75mg
    expect(savedData['metabolism_active_mg'], 75);
    expect(savedData['metabolism_half_life_mg'], 38);
    expect(savedData['metabolism_status_text'], contains('Safe by'));
    expect(savedData['today_total_mg'], 150);
    expect(savedData['today_limit_mg'], 400);
    expect(savedData['quick_drink_count'], 4);
    expect(savedData['quick_drink_0_id'], 'espresso');
  });

  test('syncWidgets saves theme preset and theme colors', () async {
    final now = DateTime(2026, 10, 10, 10, 0);
    await WidgetSyncService.syncWidgets(
      drinks: const [],
      favoriteDrinkIds: const ['espresso'],
      themePreset: CoffeeThemePreset.ocean,
      now: now,
    );

    expect(savedData['theme_preset'], 'ocean');
    expect(savedData['theme_text_primary'], isA<int>());
    expect(savedData['theme_text_muted'], isA<int>());
    expect(savedData['theme_brand_accent'], isA<int>());
  });
}
