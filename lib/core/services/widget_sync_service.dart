import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../../app/theme/app_theme.dart';
import '../../features/onboarding/models/favorite_drink.dart';
import '../../features/today/metabolism_estimate.dart';
import '../../features/tracking/models/tracking_models.dart';
import '../models/coffee_theme_preset.dart';

class WidgetSyncService {
  static const appGroupId = 'group.com.coffeeaholic.app';
  static const metabolismWidgetAndroid = 'MetabolismWidgetProvider';
  static const quickLogWidgetAndroid = 'QuickLogWidgetProvider';
  static const metabolismWidgetIOS = 'MetabolismWidget';
  static const quickLogWidgetIOS = 'QuickLogWidget';

  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
    } catch (e) {
      debugPrint('Failed to set HomeWidget app group: $e');
    }
  }

  static Future<void> syncWidgets({
    required List<DrinkRecord> drinks,
    required List<String> favoriteDrinkIds,
    int caffeineLimitMg = 400,
    CoffeeThemePreset themePreset = CoffeeThemePreset.coffee,
    DateTime? now,
  }) async {
    try {
      final currentTime = now ?? DateTime.now();
      final estimate = MetabolismEstimate(drinks, currentTime);
      final activeMg = estimate.remainingAt(currentTime).round();
      final below50 = estimate.below50At;
      final isSleepSafe = activeMg <= 50;

      final today = drinks.where((drink) {
        final date = drink.localTime;
        return date.year == currentTime.year &&
            date.month == currentTime.month &&
            date.day == currentTime.day;
      }).toList();
      final todayTotal = today.fold<int>(
        0,
        (sum, drink) => sum + drink.caffeineMg,
      );

      final String statusText;
      final String statusColor;
      if (isSleepSafe) {
        statusText = 'Sleep-Safe Now';
        statusColor = 'success';
      } else if (below50 != null) {
        final hour = below50.hour;
        final minute = below50.minute.toString().padLeft(2, '0');
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        statusText = 'Safe by $displayHour:$minute $period';
        statusColor = below50.hour < 23 ? 'info' : 'warning';
      } else {
        statusText = 'Caffeine High';
        statusColor = 'warning';
      }

      final halfLifeMg = (activeMg * 0.5).round();

      final String hoursToClear;
      if (below50 != null) {
        final diffMinutes = below50.difference(currentTime).inMinutes;
        final hours = diffMinutes / 60.0;
        hoursToClear = hours <= 0
            ? '0'
            : hours % 1 == 0
            ? hours.toInt().toString()
            : hours.toStringAsFixed(1);
      } else {
        hoursToClear = '12+';
      }

      final hour = currentTime.hour;
      final minute = currentTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final lastUpdated = '$displayHour:$minute $period';

      // Export compact drinks data for native Kotlin/Swift autonomous 5-min decay calculation
      final cutoff48h = currentTime.subtract(const Duration(hours: 48));
      final recentDrinks = drinks
          .where((d) => d.localTime.isAfter(cutoff48h))
          .map((d) => '${d.localTime.millisecondsSinceEpoch}:${d.caffeineMg}')
          .join(',');

      // Save Metabolism Data
      await HomeWidget.saveWidgetData<int>('metabolism_active_mg', activeMg);
      await HomeWidget.saveWidgetData<String>(
        'metabolism_status_text',
        statusText,
      );
      await HomeWidget.saveWidgetData<String>(
        'metabolism_status_color',
        statusColor,
      );
      await HomeWidget.saveWidgetData<String>(
        'metabolism_hours_to_clear',
        hoursToClear,
      );
      await HomeWidget.saveWidgetData<int>(
        'metabolism_half_life_mg',
        halfLifeMg,
      );
      await HomeWidget.saveWidgetData<String>(
        'metabolism_last_updated',
        lastUpdated,
      );
      await HomeWidget.saveWidgetData<String>(
        'metabolism_drinks_data',
        recentDrinks,
      );
      await HomeWidget.saveWidgetData<int>('today_total_mg', todayTotal);
      await HomeWidget.saveWidgetData<int>('today_limit_mg', caffeineLimitMg);

      // Save Theme Preset & Semantic Colors for Native Widgets
      final palette =
          AppTheme.palettes[themePreset] ??
          AppTheme.palettes[CoffeeThemePreset.coffee]!;
      await HomeWidget.saveWidgetData<String>('theme_preset', themePreset.name);
      await HomeWidget.saveWidgetData<int>(
        'theme_text_primary',
        palette.textPrimary.toARGB32(),
      );
      await HomeWidget.saveWidgetData<int>(
        'theme_text_muted',
        palette.textMuted.toARGB32(),
      );
      await HomeWidget.saveWidgetData<int>(
        'theme_brand_accent',
        palette.brand300.toARGB32(),
      );

      // Save Quick Log Favorites Data (up to 6)
      final favorites = favoriteDrinkIds.isNotEmpty
          ? favoriteDrinkIds
                .map((id) => FavoriteDrink.findById(id))
                .whereType<FavoriteDrink>()
                .take(6)
                .toList()
          : FavoriteDrink.catalog.take(6).toList();

      await HomeWidget.saveWidgetData<int>(
        'quick_drink_count',
        favorites.length,
      );
      for (var i = 0; i < favorites.length; i++) {
        final drink = favorites[i];
        await HomeWidget.saveWidgetData<String>('quick_drink_${i}_id', drink.id);
        await HomeWidget.saveWidgetData<String>(
          'quick_drink_${i}_name',
          drink.name,
        );
        await HomeWidget.saveWidgetData<int>(
          'quick_drink_${i}_mg',
          drink.caffeineMg,
        );
      }

      // Trigger native widget reload
      await HomeWidget.updateWidget(
        name: metabolismWidgetAndroid,
        androidName: metabolismWidgetAndroid,
        iOSName: metabolismWidgetIOS,
      );
      await HomeWidget.updateWidget(
        name: quickLogWidgetAndroid,
        androidName: quickLogWidgetAndroid,
        iOSName: quickLogWidgetIOS,
      );
    } catch (e) {
      debugPrint('Error syncing widgets: $e');
    }
  }
}
