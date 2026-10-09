import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../tracking/models/tracking_models.dart';

enum BadgeCategory {
  all('All'),
  streaks('Streaks'),
  mindfulness('Mindfulness'),
  rituals('Rituals'),
  variety('Variety'),
  milestones('Milestones');

  const BadgeCategory(this.label);
  final String label;
}

class BaristaRank {
  const BaristaRank({
    required this.level,
    required this.title,
    required this.tagline,
    required this.icon,
    required this.color,
  });

  final int level;
  final String title;
  final String tagline;
  final IconData icon;
  final Color color;
}

class BadgeItem {
  const BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.requirement,
    required this.category,
    required this.icon,
    this.svgAsset,
    required this.earned,
    required this.progress,
    required this.progressMax,
    required this.tip,
  });

  final String id;
  final String title;
  final String description;
  final String requirement;
  final BadgeCategory category;
  final IconData icon;
  final String? svgAsset;
  final bool earned;
  final int progress;
  final int progressMax;
  final String tip;

  double get progressFraction =>
      progressMax > 0 ? (progress / progressMax).clamp(0.0, 1.0) : 0.0;
}

class BadgeCalculator {
  static BaristaRank getRank(int earnedCount) {
    if (earnedCount >= 47) {
      return const BaristaRank(
        level: 6,
        title: 'Legendary Grandmaster',
        tagline: 'Ultimate coffee mastery, zen balance & supreme palate',
        icon: Icons.military_tech_rounded,
        color: Color(0xFFF59E0B),
      );
    } else if (earnedCount >= 38) {
      return const BaristaRank(
        level: 5,
        title: 'Master Roaster',
        tagline: 'Advanced palate, disciplined habits & elite streaks',
        icon: Icons.workspace_premium_rounded,
        color: Color(0xFFC084FC),
      );
    } else if (earnedCount >= 25) {
      return const BaristaRank(
        level: 4,
        title: 'Craft Barista',
        tagline: 'Expert brew technique, timing & flavor variety',
        icon: Icons.local_fire_department_rounded,
        color: Color(0xFF38BDF8),
      );
    } else if (earnedCount >= 13) {
      return const BaristaRank(
        level: 3,
        title: 'Coffee Enthusiast',
        tagline: 'Exploring diverse roasts, recipes & daily rhythms',
        icon: Icons.coffee_rounded,
        color: Color(0xFF4ADE80),
      );
    } else if (earnedCount >= 5) {
      return const BaristaRank(
        level: 2,
        title: 'Casual Sipper',
        tagline: 'Finding daily rhythm & favorite cups',
        icon: Icons.local_cafe_rounded,
        color: Color(0xFFA3E635),
      );
    } else {
      return const BaristaRank(
        level: 1,
        title: 'Green Bean',
        tagline: 'Sprouting into your mindful coffee journey',
        icon: Icons.eco_rounded,
        color: Color(0xFF86EFAC),
      );
    }
  }

  static List<BadgeItem> computeBadges({
    required List<DrinkRecord> drinks,
    required int caffeineLimitMg,
  }) {
    final effectiveLimit = caffeineLimitMg > 0 ? caffeineLimitMg : 400;

    // Group drinks by local day
    final dayTotals = <DateTime, int>{};
    final dayDrinks = <DateTime, List<DrinkRecord>>{};
    final dayLastDrinkTime = <DateTime, DateTime>{};
    final dayFirstDrinkTime = <DateTime, DateTime>{};
    final uniqueDrinkNames = <String>{};

    var homeCount = 0;
    var cafeCount = 0;
    var espressoCount = 0;
    var icedCount = 0;
    var teaCount = 0;
    var matchaCount = 0;
    var filterCount = 0;
    var specialtyCount = 0;
    var detailedLogsCount = 0;

    for (final drink in drinks) {
      final local = drink.localTime;
      final day = DateTime(local.year, local.month, local.day);
      dayTotals[day] = (dayTotals[day] ?? 0) + drink.caffeineMg;
      dayDrinks.putIfAbsent(day, () => []).add(drink);

      final existingLast = dayLastDrinkTime[day];
      if (existingLast == null || local.isAfter(existingLast)) {
        dayLastDrinkTime[day] = local;
      }
      final existingFirst = dayFirstDrinkTime[day];
      if (existingFirst == null || local.isBefore(existingFirst)) {
        dayFirstDrinkTime[day] = local;
      }

      final lowerName = drink.name.trim().toLowerCase();
      uniqueDrinkNames.add(lowerName);

      final loc = drink.location.toLowerCase();
      if (loc == 'home' || loc == 'home brew') {
        homeCount++;
      } else if (loc == 'cafe' || loc == 'at cafe' || drink.priceCents > 0) {
        cafeCount++;
      }

      if (lowerName.contains('espresso')) espressoCount++;
      if (drink.temperature.toLowerCase() == 'iced' ||
          lowerName.contains('cold brew') ||
          lowerName.contains('iced')) {
        icedCount++;
      }
      if (lowerName.contains('tea')) teaCount++;
      if (lowerName.contains('matcha')) matchaCount++;
      if (lowerName.contains('pour') ||
          lowerName.contains('drip') ||
          lowerName.contains('filter') ||
          lowerName.contains('americano')) {
        filterCount++;
      }
      if (lowerName.contains('latte') ||
          lowerName.contains('cappuccino') ||
          lowerName.contains('mocha') ||
          lowerName.contains('caramel') ||
          lowerName.contains('vanilla')) {
        specialtyCount++;
      }
      if (drink.volumeMl > 0 && drink.priceCents > 0) {
        detailedLogsCount++;
      }
    }

    final sortedDays = dayTotals.keys.toList()..sort();
    final recordedDays = dayTotals.keys.toSet();

    // Streak calculation helper
    int calculateMaxStreak() {
      if (sortedDays.isEmpty) return 0;
      var maxStreak = 1;
      var current = 1;
      for (var i = 1; i < sortedDays.length; i++) {
        final diff = sortedDays[i].difference(sortedDays[i - 1]).inDays;
        if (diff == 1) {
          current++;
          if (current > maxStreak) maxStreak = current;
        } else if (diff > 1) {
          current = 1;
        }
      }
      return maxStreak;
    }

    final maxStreak = calculateMaxStreak();

    // Consecutive under limit streak
    int calculateMaxUnderLimitStreak() {
      if (sortedDays.isEmpty) return 0;
      var maxUnder = 0;
      var current = 0;
      for (var i = 0; i < sortedDays.length; i++) {
        final day = sortedDays[i];
        final total = dayTotals[day] ?? 0;
        if (total > 0 && total <= effectiveLimit) {
          if (i == 0 ||
              sortedDays[i].difference(sortedDays[i - 1]).inDays == 1) {
            current++;
          } else {
            current = 1;
          }
          if (current > maxUnder) maxUnder = current;
        } else {
          current = 0;
        }
      }
      return maxUnder;
    }

    final maxUnderLimitStreak = calculateMaxUnderLimitStreak();

    // Weekday streak (Mon-Fri)
    var hasWorkweekStreak = false;
    for (final day in recordedDays) {
      if (day.weekday == DateTime.monday) {
        var isWeek = true;
        for (var offset = 1; offset < 5; offset++) {
          final nextDay = DateTime(day.year, day.month, day.day + offset);
          if (!recordedDays.contains(nextDay)) {
            isWeek = false;
            break;
          }
        }
        if (isWeek) {
          hasWorkweekStreak = true;
          break;
        }
      }
    }

    // Weekend Warrior
    var weekendWarriorEarned = false;
    for (final day in recordedDays) {
      if (day.weekday == DateTime.saturday) {
        final sunday = DateTime(day.year, day.month, day.day + 1);
        if (recordedDays.contains(sunday)) {
          weekendWarriorEarned = true;
          break;
        }
      }
    }

    final underTargetDays = dayTotals.values
        .where((t) => t > 0 && t <= effectiveLimit)
        .length;
    final safeSlumberDays = dayLastDrinkTime.values
        .where((t) => t.hour < 14)
        .length;
    final before3PmDays = dayLastDrinkTime.values
        .where((t) => t.hour < 15)
        .length;
    final before1PmDays = dayLastDrinkTime.values
        .where((t) => t.hour < 13)
        .length;
    final lowBuzzDays = dayTotals.values.where((t) => t > 0 && t < 50).length;
    final microDoseDrinks = drinks.where((d) => d.caffeineMg <= 30).length;
    final halfCaffDrinks = drinks.where((d) => d.caffeineMg <= 60).length;

    // Time & Ritual checks
    final dawnDrinks = drinks.where((d) => d.localTime.hour < 8).length;
    final sunriseDrinks = drinks.where((d) => d.localTime.hour < 7).length;
    final morningRitualDays = dayFirstDrinkTime.values
        .where((t) => t.hour >= 8 && t.hour < 10)
        .length;
    final noonBoostDrinks = drinks
        .where(
          (d) =>
              d.localTime.hour == 12 ||
              (d.localTime.hour == 11 && d.localTime.minute >= 30) ||
              (d.localTime.hour == 13 && d.localTime.minute <= 30),
        )
        .length;
    final sundaySlowdownDays = dayTotals.entries
        .where((e) => e.key.weekday == DateTime.sunday && e.value <= 150)
        .length;
    final mondayMorningDrinks = drinks
        .where(
          (d) => d.localTime.weekday == DateTime.monday && d.localTime.hour < 9,
        )
        .length;
    final fridayAfternoonDrinks = drinks
        .where(
          (d) =>
              d.localTime.weekday == DateTime.friday && d.localTime.hour >= 13,
        )
        .length;
    final doubleShotMorningDays = dayDrinks.values.where((list) {
      final morningCount = list.where((d) => d.localTime.hour < 12).length;
      return morningCount >= 2;
    }).length;
    final goldenHourDrinks = drinks
        .where((d) => d.localTime.hour >= 14 && d.localTime.hour < 16)
        .length;

    return [
      // ==========================================
      // --- 1. STREAKS & HABITS (10 Trophies) ---
      // ==========================================
      BadgeItem(
        id: 'first_sip',
        title: 'First Sip',
        description: 'Logged your very first drink in the app.',
        requirement: 'Log at least one drink.',
        category: BadgeCategory.streaks,
        icon: Icons.local_cafe_rounded,
        svgAsset: 'badge-sprout',
        earned: drinks.isNotEmpty,
        progress: drinks.isNotEmpty ? 1 : 0,
        progressMax: 1,
        tip: 'The journey of a thousand cups begins with a single pour.',
      ),
      BadgeItem(
        id: 'two_day_spark',
        title: 'Two-Day Spark',
        description: 'Logged coffee 2 days in a row.',
        requirement: 'Log drinks 2 consecutive days.',
        category: BadgeCategory.streaks,
        icon: Icons.electric_bolt_rounded,
        earned: maxStreak >= 2,
        progress: math.min(maxStreak, 2),
        progressMax: 2,
        tip: 'Momentum starts with the second consecutive day.',
      ),
      BadgeItem(
        id: 'three_day_habit',
        title: '3-Day Habit',
        description: 'Tracked your coffee for 3 consecutive days.',
        requirement: 'Log drinks 3 days in a row.',
        category: BadgeCategory.streaks,
        icon: Icons.repeat_rounded,
        earned: maxStreak >= 3,
        progress: math.min(maxStreak, 3),
        progressMax: 3,
        tip: 'Consistency creates mindful daily awareness.',
      ),
      BadgeItem(
        id: 'five_day_flow',
        title: 'Workweek Flow',
        description: 'Logged every weekday from Monday through Friday.',
        requirement: 'Log all 5 weekdays (Mon-Fri) in a row.',
        category: BadgeCategory.streaks,
        icon: Icons.work_outline_rounded,
        earned: hasWorkweekStreak,
        progress: hasWorkweekStreak ? 5 : math.min(maxStreak, 4),
        progressMax: 5,
        tip: 'Workday tracking keeps mid-afternoon slumps predictable.',
      ),
      BadgeItem(
        id: 'seven_day_run',
        title: '7-Day Run',
        description: 'A full week of mindful caffeine tracking.',
        requirement: 'Log drinks for 7 consecutive days.',
        category: BadgeCategory.streaks,
        icon: Icons.local_fire_department_rounded,
        svgAsset: 'badge-bolt',
        earned: maxStreak >= 7,
        progress: math.min(maxStreak, 7),
        progressMax: 7,
        tip: 'One week in! You have established a solid tracking rhythm.',
      ),
      BadgeItem(
        id: 'ten_day_streak',
        title: 'Tenacious',
        description: 'Ten unbroken days of coffee tracking.',
        requirement: 'Log drinks 10 days in a row.',
        category: BadgeCategory.streaks,
        icon: Icons.stars_rounded,
        earned: maxStreak >= 10,
        progress: math.min(maxStreak, 10),
        progressMax: 10,
        tip: 'Double digit streak! You are in the top 15% of mindful trackers.',
      ),
      BadgeItem(
        id: 'two_week_streak',
        title: 'Fortnight Master',
        description: 'Two continuous weeks of steady daily tracking.',
        requirement: 'Log drinks 14 days in a row.',
        category: BadgeCategory.streaks,
        icon: Icons.bolt_rounded,
        earned: maxStreak >= 14,
        progress: math.min(maxStreak, 14),
        progressMax: 14,
        tip:
            '14 days without skipping gives highly accurate circadian insights.',
      ),
      BadgeItem(
        id: 'twenty_one_habit',
        title: 'Habit Formed',
        description: '21 consecutive days — tracking is now second nature.',
        requirement: 'Log drinks 21 days in a row.',
        category: BadgeCategory.streaks,
        icon: Icons.psychology_rounded,
        earned: maxStreak >= 21,
        progress: math.min(maxStreak, 21),
        progressMax: 21,
        tip: 'Neuroscience shows 21 days solidifies a new mindfulness routine.',
      ),
      BadgeItem(
        id: 'monthly_legend',
        title: 'Monthly Legend',
        description: 'A complete 30-day streak of coffee logging.',
        requirement: 'Log drinks 30 days in a row.',
        category: BadgeCategory.streaks,
        icon: Icons.star_rounded,
        earned: maxStreak >= 30,
        progress: math.min(maxStreak, 30),
        progressMax: 30,
        tip: 'You are now among the most disciplined coffee lovers!',
      ),
      BadgeItem(
        id: 'sixty_day_streak',
        title: '60-Day Titan',
        description: 'Two full months of unwavering tracking excellence.',
        requirement: 'Log drinks 60 days in a row.',
        category: BadgeCategory.streaks,
        icon: Icons.shield_rounded,
        earned: maxStreak >= 60,
        progress: math.min(maxStreak, 60),
        progressMax: 60,
        tip:
            'Elite status! Your metabolism data is extraordinarily comprehensive.',
      ),

      // ==============================================
      // --- 2. MINDFULNESS & SLEEP (10 Trophies) ---
      // ==============================================
      BadgeItem(
        id: 'under_target',
        title: 'Under $effectiveLimit',
        description: 'Kept daily caffeine within your target limit.',
        requirement:
            'Stay under $effectiveLimit mg on any day with logged drinks.',
        category: BadgeCategory.mindfulness,
        icon: Icons.track_changes_rounded,
        svgAsset: 'badge-target',
        earned: underTargetDays > 0,
        progress: math.min(underTargetDays, 1),
        progressMax: 1,
        tip: 'Staying under your limit prevents jitters and sleep latency.',
      ),
      BadgeItem(
        id: 'three_day_under',
        title: 'In The Zone',
        description: 'Stayed within your daily goal 3 days in a row.',
        requirement: 'Keep daily caffeine under target 3 consecutive days.',
        category: BadgeCategory.mindfulness,
        icon: Icons.verified_rounded,
        earned: maxUnderLimitStreak >= 3,
        progress: math.min(maxUnderLimitStreak, 3),
        progressMax: 3,
        tip:
            'Consistent threshold adherence trains balanced adenosine sensitivity.',
      ),
      BadgeItem(
        id: 'seven_day_under',
        title: 'Discipline Master',
        description: 'A full week without ever exceeding your caffeine limit.',
        requirement: 'Stay under goal for 7 consecutive days.',
        category: BadgeCategory.mindfulness,
        icon: Icons.workspace_premium_rounded,
        earned: maxUnderLimitStreak >= 7,
        progress: math.min(maxUnderLimitStreak, 7),
        progressMax: 7,
        tip: 'Absolute mastery over your daily stimulation levels.',
      ),
      BadgeItem(
        id: 'no_crash',
        title: 'No-Crash',
        description: 'Enjoyed your last caffeine before 2:00 PM.',
        requirement: 'Finish all coffee before 14:00 on any logged day.',
        category: BadgeCategory.mindfulness,
        icon: Icons.bedtime_rounded,
        svgAsset: 'badge-zen',
        earned: safeSlumberDays > 0,
        progress: math.min(safeSlumberDays, 1),
        progressMax: 1,
        tip:
            'Caffeine has a 5-6 hour half-life; stopping early protects deep sleep.',
      ),
      BadgeItem(
        id: 'three_pm_cutoff',
        title: '3 PM Sentinel',
        description:
            'Logged your last coffee before 3:00 PM on 3 separate days.',
        requirement: 'Finish all drinks before 15:00 on 3 days.',
        category: BadgeCategory.mindfulness,
        icon: Icons.alarm_on_rounded,
        earned: before3PmDays >= 3,
        progress: math.min(before3PmDays, 3),
        progressMax: 3,
        tip:
            'A rigid afternoon cutoff is the single highest-impact sleep upgrade.',
      ),
      BadgeItem(
        id: 'sleep_protector',
        title: 'Sleep Protector',
        description: 'Finished all caffeine before 1:00 PM.',
        requirement: 'Last drink logged before 13:00 on any day.',
        category: BadgeCategory.mindfulness,
        icon: Icons.nights_stay_rounded,
        earned: before1PmDays > 0,
        progress: math.min(before1PmDays, 1),
        progressMax: 1,
        tip:
            'Ending caffeine by 1 PM leaves near-zero residual adenosine blockade by bedtime.',
      ),
      BadgeItem(
        id: 'zen_day',
        title: 'Low Buzz',
        description: 'Maintained a gentle day with under 50 mg caffeine.',
        requirement: 'Log a day with 1 - 49 mg total caffeine.',
        category: BadgeCategory.mindfulness,
        icon: Icons.spa_rounded,
        earned: lowBuzzDays > 0,
        progress: math.min(lowBuzzDays, 1),
        progressMax: 1,
        tip:
            'Occasional low-caffeine reset days resensitize your adenosine receptors.',
      ),
      BadgeItem(
        id: 'micro_dose',
        title: 'Micro Doser',
        description: 'Logged a gentle drink with 30 mg or less of caffeine.',
        requirement: 'Log a drink with <= 30 mg caffeine.',
        category: BadgeCategory.mindfulness,
        icon: Icons.grain_rounded,
        earned: microDoseDrinks > 0,
        progress: math.min(microDoseDrinks, 1),
        progressMax: 1,
        tip:
            'Small, strategic doses can enhance focus without stimulating anxiety.',
      ),
      BadgeItem(
        id: 'half_caff',
        title: 'Half-Caff Hero',
        description: 'Logged a low-stimulant beverage under 60 mg caffeine.',
        requirement: 'Log a drink with <= 60 mg caffeine.',
        category: BadgeCategory.mindfulness,
        icon: Icons.filter_vintage_rounded,
        earned: halfCaffDrinks > 0,
        progress: math.min(halfCaffDrinks, 1),
        progressMax: 1,
        tip:
            'Half-caff gives you all the warm ritual with half the stimulant load.',
      ),
      BadgeItem(
        id: 'steady_intake',
        title: 'Balanced Rhythm',
        description:
            'Maintained steady caffeine within 50 mg of each other for 3 days.',
        requirement: 'Log 3 days with similar balanced totals.',
        category: BadgeCategory.mindfulness,
        icon: Icons.equalizer_rounded,
        earned: dayTotals.length >= 3,
        progress: math.min(dayTotals.length, 3),
        progressMax: 3,
        tip:
            'Avoiding erratic spikes prevents adrenal fatigue and rebound headaches.',
      ),

      // ==========================================
      // --- 3. TIME & RITUALS (10 Trophies) ---
      // ==========================================
      BadgeItem(
        id: 'early_bird',
        title: 'Dawn Brew',
        description: 'Greeted the sunrise with coffee before 8:00 AM.',
        requirement: 'Log a drink before 8:00 AM.',
        category: BadgeCategory.rituals,
        icon: Icons.wb_sunny_rounded,
        earned: dawnDrinks > 0,
        progress: math.min(dawnDrinks, 1),
        progressMax: 1,
        tip:
            'Waiting 60-90 min after waking optimizes your natural cortisol boost.',
      ),
      BadgeItem(
        id: 'sunrise_sipper',
        title: 'Sunrise Sipper',
        description: 'Early morning dedication! Logged coffee before 7:00 AM.',
        requirement: 'Log a drink before 7:00 AM.',
        category: BadgeCategory.rituals,
        icon: Icons.wb_twilight_rounded,
        earned: sunriseDrinks > 0,
        progress: math.min(sunriseDrinks, 1),
        progressMax: 1,
        tip:
            'First light and fresh coffee create an invigorating morning mindfulness anchor.',
      ),
      BadgeItem(
        id: 'morning_ritual',
        title: 'Morning Ritual',
        description:
            'Logged your favorite brew between 8 AM and 10 AM on 5 days.',
        requirement: 'Log morning coffee between 8:00-10:00 AM on 5 days.',
        category: BadgeCategory.rituals,
        icon: Icons.schedule_rounded,
        earned: morningRitualDays >= 5,
        progress: math.min(morningRitualDays, 5),
        progressMax: 5,
        tip:
            'The 9:00 AM window coincides with when morning cortisol naturally dips.',
      ),
      BadgeItem(
        id: 'noon_boost',
        title: 'Midday Fuel',
        description: 'Powered through the midday stretch around lunch.',
        requirement: 'Log a drink between 11:30 AM and 1:30 PM.',
        category: BadgeCategory.rituals,
        icon: Icons.lunch_dining_rounded,
        earned: noonBoostDrinks > 0,
        progress: math.min(noonBoostDrinks, 1),
        progressMax: 1,
        tip:
            'A quick espresso after lunch keeps the afternoon post-prandial slump away.',
      ),
      BadgeItem(
        id: 'weekend_warrior',
        title: 'Weekend Warrior',
        description: 'Kept tracking across both Saturday and Sunday.',
        requirement: 'Log drinks on Saturday and Sunday in the same weekend.',
        category: BadgeCategory.rituals,
        icon: Icons.weekend_rounded,
        earned: weekendWarriorEarned,
        progress: weekendWarriorEarned
            ? 2
            : (recordedDays.any((d) => d.weekday == 6 || d.weekday == 7)
                  ? 1
                  : 0),
        progressMax: 2,
        tip: 'Tracking on weekends keeps your sleep clock in tune for Monday.',
      ),
      BadgeItem(
        id: 'sunday_slowdown',
        title: 'Sunday Slowdown',
        description: 'Kept a calm Sunday with under 150 mg caffeine.',
        requirement: 'Log a Sunday with <= 150 mg caffeine.',
        category: BadgeCategory.rituals,
        icon: Icons.self_improvement_rounded,
        earned: sundaySlowdownDays > 0,
        progress: math.min(sundaySlowdownDays, 1),
        progressMax: 1,
        tip:
            'A calm Sunday evening ensures you wake up fully energized on Monday.',
      ),
      BadgeItem(
        id: 'monday_motivation',
        title: 'Monday Fuel',
        description:
            'Kicked off the workweek with a Monday morning coffee before 9 AM.',
        requirement: 'Log a coffee on Monday before 9:00 AM.',
        category: BadgeCategory.rituals,
        icon: Icons.rocket_launch_rounded,
        earned: mondayMorningDrinks > 0,
        progress: math.min(mondayMorningDrinks, 1),
        progressMax: 1,
        tip: 'Start the workweek focused, mindful and fully intentional.',
      ),
      BadgeItem(
        id: 'friday_celebration',
        title: 'Friday Brew',
        description: 'Welcomed the weekend with a Friday afternoon coffee.',
        requirement: 'Log a Friday drink after 1:00 PM.',
        category: BadgeCategory.rituals,
        icon: Icons.celebration_rounded,
        earned: fridayAfternoonDrinks > 0,
        progress: math.min(fridayAfternoonDrinks, 1),
        progressMax: 1,
        tip: 'Celebrate a productive week with a mindful coffee break.',
      ),
      BadgeItem(
        id: 'double_shot_morning',
        title: 'Power Start',
        description: 'Logged 2 separate coffees before noon on the same day.',
        requirement: 'Log 2 morning drinks on a single day.',
        category: BadgeCategory.rituals,
        icon: Icons.battery_charging_full_rounded,
        earned: doubleShotMorningDays > 0,
        progress: math.min(doubleShotMorningDays, 1),
        progressMax: 1,
        tip:
            'Spacing your morning coffees 90-120 minutes apart sustains steady energy.',
      ),
      BadgeItem(
        id: 'golden_hour',
        title: 'Golden Hour',
        description: 'Sipped an afternoon cup between 2 PM and 4 PM.',
        requirement: 'Log a drink between 14:00 and 16:00.',
        category: BadgeCategory.rituals,
        icon: Icons.wb_shade_rounded,
        earned: goldenHourDrinks > 0,
        progress: math.min(goldenHourDrinks, 1),
        progressMax: 1,
        tip: 'Late afternoon drinks should preferably be decaf or light tea.',
      ),

      // ===================================================
      // --- 4. DRINK VARIETY & EXPLORATION (10 Trophies) ---
      // ===================================================
      BadgeItem(
        id: 'arctic_chill',
        title: 'Arctic Chill',
        description: 'Chilled out with an iced drink or cold brew.',
        requirement: 'Log an iced coffee or cold brew.',
        category: BadgeCategory.variety,
        icon: Icons.ac_unit_rounded,
        svgAsset: 'coldbrew',
        earned: icedCount > 0,
        progress: math.min(icedCount, 1),
        progressMax: 1,
        tip: 'Cold brew typically has lower acidity and smooth sweetness.',
      ),
      BadgeItem(
        id: 'ice_ice_baby',
        title: 'Glacier Mode',
        description: 'Cold coffee connoisseur! Logged 5 or more iced drinks.',
        requirement: 'Log 5 cold or iced coffees.',
        category: BadgeCategory.variety,
        icon: Icons.severe_cold_rounded,
        earned: icedCount >= 5,
        progress: math.min(icedCount, 5),
        progressMax: 5,
        tip:
            'Slow cold immersion extraction produces rich chocolate and berry notes.',
      ),
      BadgeItem(
        id: 'tea_sommelier',
        title: 'Tea Sommelier',
        description: 'Explored clean energy with green tea or matcha.',
        requirement: 'Log at least 1 tea or matcha drink.',
        category: BadgeCategory.variety,
        icon: Icons.emoji_nature_rounded,
        svgAsset: 'matcha',
        earned: (teaCount + matchaCount) > 0,
        progress: math.min(teaCount + matchaCount, 1),
        progressMax: 1,
        tip: 'Tea contains L-theanine which smooths out caffeine jitters.',
      ),
      BadgeItem(
        id: 'matcha_maven',
        title: 'Matcha Maven',
        description:
            'Celebrated the ceremonial green powder with 3 matcha drinks.',
        requirement: 'Log 3 matcha drinks.',
        category: BadgeCategory.variety,
        icon: Icons.grass_rounded,
        earned: matchaCount >= 3,
        progress: math.min(matchaCount, 3),
        progressMax: 3,
        tip:
            'Matcha provides a steady 4-6 hour boost with high antioxidant EGCG content.',
      ),
      BadgeItem(
        id: 'pure_extraction',
        title: 'Pure Extraction',
        description: 'Pure, concentrated coffee. Logged 3+ espressos.',
        requirement: 'Log 3 or more espresso shots.',
        category: BadgeCategory.variety,
        icon: Icons.coffee_rounded,
        svgAsset: 'espresso',
        earned: espressoCount >= 3,
        progress: math.min(espressoCount, 3),
        progressMax: 3,
        tip:
            'Espresso extracts about 60-75mg caffeine per single shot in ~28 seconds.',
      ),
      BadgeItem(
        id: 'espresso_purist',
        title: 'Espresso Purist',
        description: 'True connoisseur! Logged 10 concentrated espresso shots.',
        requirement: 'Log 10 espresso shots.',
        category: BadgeCategory.variety,
        icon: Icons.coffee_maker_rounded,
        earned: espressoCount >= 10,
        progress: math.min(espressoCount, 10),
        progressMax: 10,
        tip: 'Nine bars of pressure produce rich, aromatic emulsified crema.',
      ),
      BadgeItem(
        id: 'filter_artisan',
        title: 'Filter Artisan',
        description: 'Clean pour-over, batch drip, or classic Americano.',
        requirement: 'Log a pour-over, drip, or Americano.',
        category: BadgeCategory.variety,
        icon: Icons.filter_vintage_rounded,
        svgAsset: 'americano',
        earned: filterCount > 0,
        progress: math.min(filterCount, 1),
        progressMax: 1,
        tip:
            'Paper filters capture cafestol, highlighting floral and fruit notes.',
      ),
      BadgeItem(
        id: 'specialty_sip',
        title: 'Specialty Sip',
        description: 'Indulged in a velvety latte, mocha, or cappuccino.',
        requirement: 'Log a specialty or milk-based drink.',
        category: BadgeCategory.variety,
        icon: Icons.cookie_rounded,
        svgAsset: 'latte',
        earned: specialtyCount > 0,
        progress: math.min(specialtyCount, 1),
        progressMax: 1,
        tip: 'Steamed microfoam pairs beautifully with medium and dark roasts.',
      ),
      BadgeItem(
        id: 'foam_artist',
        title: 'Foam Connoisseur',
        description: 'Logged 5 creamy milk-based specialty drinks.',
        requirement: 'Log 5 lattes, cappuccinos, or mochas.',
        category: BadgeCategory.variety,
        icon: Icons.water_drop_rounded,
        earned: specialtyCount >= 5,
        progress: math.min(specialtyCount, 5),
        progressMax: 5,
        tip:
            'Whole milk textured to 60-65°C yields peak natural lactose sweetness.',
      ),
      BadgeItem(
        id: 'flavor_explorer',
        title: 'Flavor Explorer',
        description: 'Explored 4 distinct varieties of caffeinated drinks.',
        requirement: 'Log 4 or more unique drink types.',
        category: BadgeCategory.variety,
        icon: Icons.explore_rounded,
        earned: uniqueDrinkNames.length >= 4,
        progress: math.min(uniqueDrinkNames.length, 4),
        progressMax: 4,
        tip: 'Diversity in roasts and origins makes every morning exciting.',
      ),

      // ===============================================
      // --- 5. MILESTONES & CRAFT (10 Trophies) ---
      // ===============================================
      BadgeItem(
        id: 'precision_brewer',
        title: 'Precision Brewer',
        description: 'Logged an entry with complete volume and price details.',
        requirement: 'Log a drink with both volume (ml) and price.',
        category: BadgeCategory.milestones,
        icon: Icons.tune_rounded,
        earned: detailedLogsCount > 0,
        progress: math.min(detailedLogsCount, 1),
        progressMax: 1,
        tip: 'Detailed logs unlock accurate financial and volume statistics.',
      ),
      BadgeItem(
        id: 'detailed_log_5',
        title: 'Metric Master',
        description: 'Logged 5 drinks with precise volume and cost data.',
        requirement: 'Log 5 drinks with volume and price.',
        category: BadgeCategory.milestones,
        icon: Icons.analytics_rounded,
        earned: detailedLogsCount >= 5,
        progress: math.min(detailedLogsCount, 5),
        progressMax: 5,
        tip:
            'Precise financial data helps calculate your yearly home-brew savings.',
      ),
      BadgeItem(
        id: 'kitchen_cafe',
        title: 'Kitchen Cafe',
        description: 'Crafted 5 or more home-brewed coffees.',
        requirement: 'Log 5 drinks brewed at home.',
        category: BadgeCategory.milestones,
        icon: Icons.home_rounded,
        earned: homeCount >= 5,
        progress: math.min(homeCount, 5),
        progressMax: 5,
        tip: 'Brewing at home saves hundreds of dollars every year.',
      ),
      BadgeItem(
        id: 'home_barista_pro',
        title: 'Master of the Hearth',
        description: 'Dedicated home barista! Logged 15 home-crafted cups.',
        requirement: 'Log 15 drinks brewed at home.',
        category: BadgeCategory.milestones,
        icon: Icons.cottage_rounded,
        earned: homeCount >= 15,
        progress: math.min(homeCount, 15),
        progressMax: 15,
        tip:
            'Dialing in grind size and water temperature at home is true craft.',
      ),
      BadgeItem(
        id: 'neighborhood_regular',
        title: 'Cafe Regular',
        description: 'Supported local baristas with 3+ cafe visits.',
        requirement: 'Log 3 drinks at a coffee shop.',
        category: BadgeCategory.milestones,
        icon: Icons.storefront_rounded,
        earned: cafeCount >= 3,
        progress: math.min(cafeCount, 3),
        progressMax: 3,
        tip:
            'Local cafes build community and showcase seasonal single origins.',
      ),
      BadgeItem(
        id: 'local_supporter',
        title: 'Cafe Connoisseur',
        description:
            'A patron of coffee culture! Logged 10 drinks at coffee shops.',
        requirement: 'Log 10 drinks at cafes.',
        category: BadgeCategory.milestones,
        icon: Icons.local_activity_rounded,
        earned: cafeCount >= 10,
        progress: math.min(cafeCount, 10),
        progressMax: 10,
        tip:
            'Exploring specialty roasters broadens your appreciation of origin terroir.',
      ),
      BadgeItem(
        id: 'double_digits',
        title: 'Double Digits',
        description: 'Reached 10 total tracked beverages.',
        requirement: 'Log 10 total drinks.',
        category: BadgeCategory.milestones,
        icon: Icons.looks_two_rounded,
        earned: drinks.length >= 10,
        progress: math.min(drinks.length, 10),
        progressMax: 10,
        tip: 'The first ten cups reveal your core preferences and timings.',
      ),
      BadgeItem(
        id: 'quarter_century',
        title: 'Quarter Century',
        description: '25 drinks logged! Your coffee journey is flourishing.',
        requirement: 'Log 25 total drinks.',
        category: BadgeCategory.milestones,
        icon: Icons.countertops_rounded,
        earned: drinks.length >= 25,
        progress: math.min(drinks.length, 25),
        progressMax: 25,
        tip:
            '25 drinks provides a solid statistical sample for monthly intake trends.',
      ),
      BadgeItem(
        id: 'half_hundred',
        title: 'Half-Century',
        description: '50 drinks recorded! True coffee lover dedication.',
        requirement: 'Log 50 total drinks.',
        category: BadgeCategory.milestones,
        icon: Icons.military_tech_rounded,
        earned: drinks.length >= 50,
        progress: math.min(drinks.length, 50),
        progressMax: 50,
        tip:
            'At 50 drinks, you have saved weeks of sleep latency and gained mastery.',
      ),
      BadgeItem(
        id: 'century_club',
        title: 'Century Club',
        description: 'Logged 100 cups! A monumental coffee milestone.',
        requirement: 'Log 100 total drinks.',
        category: BadgeCategory.milestones,
        icon: Icons.emoji_events_rounded,
        earned: drinks.length >= 100,
        progress: math.min(drinks.length, 100),
        progressMax: 100,
        tip: 'True coffee mastery. You know your personal caffeine rhythm.',
      ),
    ];
  }
}
