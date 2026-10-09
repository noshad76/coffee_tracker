import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_tracker/app/theme/app_theme.dart';
import 'package:coffee_tracker/core/models/coffee_theme_preset.dart';

void main() {
  group('Theme and Light Mode System', () {
    test('presets have correct isLight flags and conversions', () {
      expect(CoffeeThemePreset.coffee.isLight, isFalse);
      expect(CoffeeThemePreset.ocean.isLight, isFalse);
      expect(CoffeeThemePreset.forest.isLight, isFalse);
      expect(CoffeeThemePreset.amber.isLight, isFalse);

      expect(CoffeeThemePreset.coffeeLight.isLight, isTrue);
      expect(CoffeeThemePreset.oceanLight.isLight, isTrue);
      expect(CoffeeThemePreset.forestLight.isLight, isTrue);
      expect(CoffeeThemePreset.amberLight.isLight, isTrue);

      expect(CoffeeThemePreset.coffee.toLight(), CoffeeThemePreset.coffeeLight);
      expect(CoffeeThemePreset.coffeeLight.toDark(), CoffeeThemePreset.coffee);
      expect(CoffeeThemePreset.ocean.toLight(), CoffeeThemePreset.oceanLight);
      expect(CoffeeThemePreset.forest.toLight(), CoffeeThemePreset.forestLight);
      expect(CoffeeThemePreset.amber.toLight(), CoffeeThemePreset.amberLight);
    });

    test(
      'all 8 presets have configured palettes with corresponding isDark property',
      () {
        for (final preset in CoffeeThemePreset.values) {
          final palette = AppTheme.palettes[preset];
          expect(
            palette,
            isNotNull,
            reason: 'Palette for $preset should exist',
          );
          expect(
            palette!.isDark,
            !preset.isLight,
            reason: 'isDark must match preset light status for $preset',
          );
        }
      },
    );

    test(
      'AppTheme.build returns dark Brightness for dark presets and light for light presets',
      () {
        final darkTheme = AppTheme.build(CoffeeThemePreset.coffee);
        expect(darkTheme.brightness, Brightness.dark);
        expect(
          darkTheme.cardColor,
          AppTheme.palettes[CoffeeThemePreset.coffee]!.surface,
        );

        final lightTheme = AppTheme.build(CoffeeThemePreset.coffeeLight);
        expect(lightTheme.brightness, Brightness.light);
        expect(
          lightTheme.cardColor,
          AppTheme.palettes[CoffeeThemePreset.coffeeLight]!.surface,
        );
        expect(
          lightTheme.scaffoldBackgroundColor,
          AppTheme.palettes[CoffeeThemePreset.coffeeLight]!.background,
        );
      },
    );

    test('sheet and dialog themes avoid opaque black backgrounds', () {
      final theme = AppTheme.build(CoffeeThemePreset.coffee);
      expect(theme.bottomSheetTheme.backgroundColor, Colors.transparent);
      expect(theme.bottomSheetTheme.modalBackgroundColor, Colors.transparent);
      expect(theme.dialogTheme.backgroundColor, isNotNull);
      expect(theme.dialogTheme.backgroundColor, isNot(Colors.black));
    });
  });
}
