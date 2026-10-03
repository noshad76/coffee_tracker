import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/coffee_card.dart';
import '../onboarding/providers/onboarding_providers.dart';
import '../tracking/models/tracking_models.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key, required this.snapshot});
  final TrackingSnapshot snapshot;

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  int range = 1;
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
    final start = switch (range) {
      0 => DateTime(now.year, now.month, now.day),
      1 => DateTime(now.year, now.month, now.day - now.weekday + 1),
      2 => DateTime(now.year, now.month),
      _ => DateTime(now.year),
    };
    final drinks = widget.snapshot.drinks
        .where((drink) => !drink.localTime.isBefore(start))
        .toList();
    final caffeine = drinks.fold<int>(
      0,
      (sum, drink) => sum + drink.caffeineMg,
    );
    final cost = drinks.fold<int>(0, (sum, drink) => sum + drink.priceCents);
    final cafe = drinks.where((drink) => drink.location == 'cafe').length;
    final countByDay = <DateTime, int>{};
    for (final drink in drinks) {
      final time = drink.localTime;
      final day = DateTime(time.year, time.month, time.day);
      countByDay[day] = (countByDay[day] ?? 0) + drink.caffeineMg;
    }
    final days = [
      for (var i = 6; i >= 0; i--) DateTime(now.year, now.month, now.day - i),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
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
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CoffeeCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Caffeine',
                      style: TextStyle(color: palette.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$caffeine mg',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${drinks.length} drinks',
                      style: TextStyle(
                        color: palette.stateSuccess,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CoffeeCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending Tracked',
                      style: TextStyle(color: palette.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${(cost / 100).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: palette.stateSuccess,
                      ),
                    ),
                    Text(
                      '$cafe cafe · ${drinks.length - cafe} home brews',
                      style: TextStyle(color: palette.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Target ${limit}mg',
                    style: TextStyle(color: palette.textSubtle, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 128,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final day in days)
                      Expanded(
                        child: Semantics(
                          label:
                              '${MaterialLocalizations.of(context).formatMediumDate(day)}: ${countByDay[day] ?? 0} milligrams',
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 24,
                                height:
                                    ((countByDay[day] ?? 0) /
                                            (limit > 0 ? limit : 400) *
                                            90)
                                        .clamp(4, 90)
                                        .toDouble(),
                                decoration: BoxDecoration(
                                  color:
                                      (countByDay[day] ?? 0) >
                                          (limit > 0 ? limit : 400)
                                      ? palette.stateWarning
                                      : palette.brand500,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
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
                                  color: palette.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (drinks.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Log drinks to see your trends.',
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textMuted),
            ),
          ),
      ],
    );
  }
}
