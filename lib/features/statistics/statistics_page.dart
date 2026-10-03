import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/coffee_card.dart';
import '../../shared/widgets/drink_artwork.dart';
import '../onboarding/providers/onboarding_providers.dart';
import '../today/drink_artwork_id.dart';
import '../tracking/models/tracking_models.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key, required this.snapshot});
  final TrackingSnapshot snapshot;

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  int range = 1; // 0: Day, 1: Week, 2: Month, 3: Year
  static const labels = ['Day', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final limit =
        ref
            .watch(onboardingControllerProvider)
            .valueOrNull
            ?.preferences
            .caffeineLimitMg ??
        400;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final rangeStart = switch (range) {
      0 => todayStart,
      1 => todayStart.subtract(Duration(days: now.weekday - 1)),
      2 => DateTime(now.year, now.month, 1),
      _ => DateTime(now.year, 1, 1),
    };

    final filteredDrinks = widget.snapshot.drinks
        .where((drink) => !drink.localTime.isBefore(rangeStart))
        .toList();

    // 1. Calculations: Total Caffeine & Daily Average
    final totalCaffeine = filteredDrinks.fold<int>(
      0,
      (sum, drink) => sum + drink.caffeineMg,
    );

    final daysInRange = switch (range) {
      0 => 1,
      1 => math.max(1, now.weekday),
      2 => math.max(1, now.day),
      _ => math.max(1, now.difference(DateTime(now.year, 1, 1)).inDays + 1),
    };

    final dailyAvgCaffeine = (totalCaffeine / daysInRange).round();

    // 2. Calculations: Spending & Home Brew Savings
    final totalCents = filteredDrinks.fold<int>(
      0,
      (sum, drink) => sum + drink.priceCents,
    );
    final homeCount = filteredDrinks.where((d) => d.location == 'home').length;
    final cafeCount = filteredDrinks.where((d) => d.location == 'cafe').length;
    // Assume average cafe drink costs $4.00, home brew costs $0.50
    final estimatedSavings = (homeCount * 3.50);

    // 3. Calculations: Top Drink
    final drinkCounts = <String, int>{};
    final drinkCaffeine = <String, int>{};
    for (final drink in filteredDrinks) {
      drinkCounts[drink.name] = (drinkCounts[drink.name] ?? 0) + 1;
      drinkCaffeine[drink.name] =
          (drinkCaffeine[drink.name] ?? 0) + drink.caffeineMg;
    }

    String topDrinkName = 'None';
    int topDrinkCount = 0;
    for (final entry in drinkCounts.entries) {
      if (entry.value > topDrinkCount) {
        topDrinkCount = entry.value;
        topDrinkName = entry.key;
      }
    }
    final topDrinkPercent = filteredDrinks.isEmpty
        ? 0
        : (topDrinkCount / filteredDrinks.length * 100).round();

    // 4. Calculations: Sleep-Safe Adherence
    final drinksGroupedByDay = <DateTime, List<DrinkRecord>>{};
    for (final drink in filteredDrinks) {
      final day = DateTime(
        drink.localTime.year,
        drink.localTime.month,
        drink.localTime.day,
      );
      drinksGroupedByDay.putIfAbsent(day, () => []).add(drink);
    }

    var sleepSafeDays = 0;
    for (final dayDrinks in drinksGroupedByDay.values) {
      final lastDrink = dayDrinks.reduce(
        (a, b) => a.localTime.isAfter(b.localTime) ? a : b,
      );
      if (lastDrink.localTime.hour < 14) {
        sleepSafeDays++;
      }
    }
    final sleepSafeRate = drinksGroupedByDay.isEmpty
        ? 100
        : ((sleepSafeDays / drinksGroupedByDay.length) * 100).round();

    // 5. Calculations: Time of Day Breakdown
    var morningCups = 0;
    var afternoonCups = 0;
    var eveningCups = 0;
    for (final drink in filteredDrinks) {
      final hour = drink.localTime.hour;
      if (hour < 12) {
        morningCups++;
      } else if (hour < 17) {
        afternoonCups++;
      } else {
        eveningCups++;
      }
    }
    final totalCups = filteredDrinks.length;
    final morningPct = totalCups == 0
        ? 0
        : ((morningCups / totalCups) * 100).round();
    final afternoonPct = totalCups == 0
        ? 0
        : ((afternoonCups / totalCups) * 100).round();
    final eveningPct = totalCups == 0
        ? 0
        : ((eveningCups / totalCups) * 100).round();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        // Range Selector
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: palette.surface,
            border: Border.all(color: palette.stone800),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => range = i),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: range == i ? palette.brand500 : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: range == i
                              ? palette.textPrimary
                              : palette.textMuted,
                          fontSize: 12,
                          fontWeight: range == i
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2x2 Metric Cards Grid
        Row(
          children: [
            Expanded(
              child: _statCard(
                context,
                title: 'Total Caffeine',
                mainValue: '$totalCaffeine mg',
                subValue: 'Avg $dailyAvgCaffeine mg/day',
                statusText: dailyAvgCaffeine <= limit
                    ? 'Under Target'
                    : 'Over Limit',
                statusColor: dailyAvgCaffeine <= limit
                    ? palette.stateSuccess
                    : palette.stateWarning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                context,
                title: 'Spending Tracked',
                mainValue: '\$${(totalCents / 100).toStringAsFixed(2)}',
                subValue: '$cafeCount cafe · $homeCount home',
                statusText: estimatedSavings > 0
                    ? 'Saved ~\$${estimatedSavings.toStringAsFixed(0)}'
                    : 'Tracked',
                statusColor: palette.stateSuccess,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statCard(
                context,
                title: 'Top Beverage',
                mainValue: topDrinkName,
                subValue: topDrinkCount > 0
                    ? '$topDrinkCount cups ($topDrinkPercent%)'
                    : 'No drinks yet',
                statusText: topDrinkName != 'None' ? 'Favorite' : 'Pending',
                statusColor: palette.brand300,
                iconWidget: topDrinkName != 'None'
                    ? DrinkArtwork(id: drinkArtworkId(topDrinkName), size: 20)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                context,
                title: 'Sleep-Safe Rate',
                mainValue: '$sleepSafeRate%',
                subValue:
                    '$sleepSafeDays / ${drinksGroupedByDay.length} days before 2 PM',
                statusText: sleepSafeRate >= 70
                    ? 'Sleep Optimal'
                    : 'Late Caffeine',
                statusColor: sleepSafeRate >= 70
                    ? palette.stateSuccess
                    : palette.stateWarning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Trend Chart Card
        CoffeeCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Intake Trend',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: palette.surfaceRaised,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: palette.stone800),
                    ),
                    child: Text(
                      'Target ${limit}mg',
                      style: TextStyle(color: palette.brand300, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTrendChart(context, filteredDrinks, limit),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Drink Breakdown Card
        CoffeeCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DRINK BREAKDOWN',
                style: TextStyle(
                  color: palette.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              if (drinkCounts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'Log drinks to view consumption breakdown.',
                      style: TextStyle(color: palette.textSubtle, fontSize: 12),
                    ),
                  ),
                )
              else
                for (final entry in drinkCounts.entries) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: palette.stone900,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: palette.stone800),
                          ),
                          child: Center(
                            child: DrinkArtwork(
                              id: drinkArtworkId(entry.key),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      color: palette.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${entry.value} cups · ${drinkCaffeine[entry.key] ?? 0} mg',
                                    style: TextStyle(
                                      color: palette.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: entry.value / filteredDrinks.length,
                                  minHeight: 5,
                                  backgroundColor: palette.stone800,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    palette.brand500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Time of Day Consumption Breakdown
        CoffeeCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CONSUMPTION TIMING',
                style: TextStyle(
                  color: palette.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _timingSegment(
                      context,
                      label: 'Morning',
                      subLabel: 'Before 12 PM',
                      percent: morningPct,
                      count: morningCups,
                      color: palette.stateSuccess,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _timingSegment(
                      context,
                      label: 'Afternoon',
                      subLabel: '12 PM – 5 PM',
                      percent: afternoonPct,
                      count: afternoonCups,
                      color: palette.brand300,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _timingSegment(
                      context,
                      label: 'Evening',
                      subLabel: 'After 5 PM',
                      percent: eveningPct,
                      count: eveningCups,
                      color: palette.stateDanger,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: palette.stone900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      size: 14,
                      color: palette.brand300,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        morningPct >= 60
                            ? 'Great habit! Having the majority of caffeine in the morning prevents sleep disruptions.'
                            : 'Tip: Shifting more caffeine before 2:00 PM will improve your sleep quality.',
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String title,
    required String mainValue,
    required String subValue,
    required String statusText,
    required Color statusColor,
    Widget? iconWidget,
  }) {
    final palette = AppTheme.paletteOf(context);
    return CoffeeCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: palette.textMuted, fontSize: 11),
                ),
              ),
              if (iconWidget != null) ...[const SizedBox(width: 4), iconWidget],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            mainValue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subValue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: palette.textSubtle, fontSize: 10.5),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timingSegment(
    BuildContext context, {
    required String label,
    required String subLabel,
    required int percent,
    required int count,
    required Color color,
  }) {
    final palette = AppTheme.paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: palette.stone900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.stone800),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subLabel,
            style: TextStyle(color: palette.textSubtle, fontSize: 9),
          ),
          const SizedBox(height: 6),
          Text(
            '$percent%',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$count cups',
            style: TextStyle(color: palette.textMuted, fontSize: 9.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(
    BuildContext context,
    List<DrinkRecord> drinks,
    int limit,
  ) {
    final palette = AppTheme.paletteOf(context);
    final now = DateTime.now();

    // Last 7 days for trend
    final days = [
      for (var i = 6; i >= 0; i--) DateTime(now.year, now.month, now.day - i),
    ];

    final dayTotals = <DateTime, int>{};
    for (final drink in drinks) {
      final d = DateTime(
        drink.localTime.year,
        drink.localTime.month,
        drink.localTime.day,
      );
      dayTotals[d] = (dayTotals[d] ?? 0) + drink.caffeineMg;
    }

    final maxVal = limit > 0 ? limit : 400;

    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final day in days) ...[
            Expanded(
              child: Builder(
                builder: (context) {
                  final mg = dayTotals[day] ?? 0;
                  final heightRatio = (mg / maxVal).clamp(0.05, 1.1);
                  final barHeight = (heightRatio * 80).clamp(6.0, 92.0);
                  final isOver = mg > maxVal;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (mg > 0)
                        Text(
                          '$mg',
                          style: TextStyle(
                            color: isOver
                                ? palette.stateWarning
                                : palette.textSubtle,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 3),
                      Container(
                        width: 22,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: mg == 0
                              ? palette.stone800
                              : (isOver
                                    ? palette.stateWarning
                                    : palette.brand500),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ][day.weekday - 1],
                        style: TextStyle(
                          color: day.day == now.day
                              ? palette.brand300
                              : palette.textMuted,
                          fontSize: 10,
                          fontWeight: day.day == now.day
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
