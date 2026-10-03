import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../../../shared/widgets/drink_artwork.dart';
import '../../tracking/models/tracking_models.dart';

class BadgeItem {
  const BadgeItem({
    required this.id,
    required this.artwork,
    required this.title,
    required this.description,
    required this.requirement,
    required this.earned,
  });

  final String id;
  final String artwork;
  final String title;
  final String description;
  final String requirement;
  final bool earned;
}

class EarnedBadgesCard extends StatelessWidget {
  const EarnedBadgesCard({
    super.key,
    required this.drinks,
    required this.caffeineLimitMg,
  });

  final List<DrinkRecord> drinks;
  final int caffeineLimitMg;

  List<BadgeItem> _computeBadges() {
    final hasFirstSip = drinks.isNotEmpty;

    // Group drinks by local day
    final dayTotals = <DateTime, int>{};
    final dayLastDrinkTime = <DateTime, DateTime>{};

    for (final drink in drinks) {
      final local = drink.localTime;
      final day = DateTime(local.year, local.month, local.day);
      dayTotals[day] = (dayTotals[day] ?? 0) + drink.caffeineMg;
      final existingLast = dayLastDrinkTime[day];
      if (existingLast == null || local.isAfter(existingLast)) {
        dayLastDrinkTime[day] = local;
      }
    }

    // Under 400: Has at least one day with logged drinks where total caffeine <= limit (or <= 400)
    final effectiveLimit = caffeineLimitMg > 0 ? caffeineLimitMg : 400;
    final hasUnderLimitDay = dayTotals.values.any(
      (total) => total > 0 && total <= effectiveLimit,
    );

    // 7-Day Run: 7 consecutive calendar days of logging
    final recordedDays = dayTotals.keys.toSet();
    var hasSevenDayRun = false;
    for (final day in recordedDays) {
      var isRun = true;
      for (var offset = 0; offset < 7; offset++) {
        final checkDay = DateTime(day.year, day.month, day.day + offset);
        if (!recordedDays.contains(checkDay)) {
          isRun = false;
          break;
        }
      }
      if (isRun) {
        hasSevenDayRun = true;
        break;
      }
    }

    // No-Crash: Had a day where last drink was before 2:00 PM (14:00) so caffeine cleared before bedtime
    final hasNoCrash = dayLastDrinkTime.values.any((time) => time.hour < 14);

    return [
      BadgeItem(
        id: 'first_sip',
        artwork: 'badge-sprout',
        title: 'First Sip',
        description: 'Logged your very first drink in the app.',
        requirement: 'Log at least one drink.',
        earned: hasFirstSip,
      ),
      BadgeItem(
        id: 'under_400',
        artwork: 'badge-bolt',
        title: 'Under $effectiveLimit',
        description: 'Kept daily caffeine within your safe threshold.',
        requirement:
            'Stay under $effectiveLimit mg on any day with logged drinks.',
        earned: hasUnderLimitDay,
      ),
      BadgeItem(
        id: 'seven_day_run',
        artwork: 'badge-target',
        title: '7-Day Run',
        description: 'Logged your caffeine habits for a full consecutive week.',
        requirement: 'Log drinks for 7 consecutive days.',
        earned: hasSevenDayRun,
      ),
      BadgeItem(
        id: 'no_crash',
        artwork: 'badge-zen',
        title: 'No-Crash',
        description:
            'Stopped caffeine early enough to protect your natural sleep.',
        requirement: 'Finish your last caffeinated drink before 2:00 PM.',
        earned: hasNoCrash,
      ),
    ];
  }

  void _showBadgeDetail(BuildContext context, BadgeItem badge) {
    final palette = AppTheme.paletteOf(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheetTop),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: palette.stone800,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              DrinkArtwork(id: badge.artwork, size: 56),
              const SizedBox(height: 12),
              Text(
                badge.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badge.earned
                      ? palette.stateSuccess.withValues(alpha: 0.15)
                      : palette.stone800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge.earned ? 'Earned' : 'Locked',
                  style: TextStyle(
                    color: badge.earned
                        ? palette.stateSuccess
                        : palette.textSubtle,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge.description,
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.textPrimary, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                'How to earn: ${badge.requirement}',
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.textMuted, fontSize: 11),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.brand500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.control),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final badges = _computeBadges();

    return CoffeeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EARNED BADGES',
            style: TextStyle(
              color: palette.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final badge in badges)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      onTap: () => _showBadgeDetail(context, badge),
                      borderRadius: BorderRadius.circular(16),
                      child: Opacity(
                        opacity: badge.earned ? 1.0 : 0.4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: palette.stone900,
                            border: Border.all(
                              color: badge.earned
                                  ? palette.brand500.withValues(alpha: 0.5)
                                  : palette.stone800,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DrinkArtwork(id: badge.artwork, size: 38),
                              const SizedBox(height: 6),
                              Text(
                                badge.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: palette.textPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
