import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/coffee_card.dart';
import '../../shared/widgets/drink_artwork.dart';
import '../drink_log/log_drink_sheet.dart';
import '../onboarding/models/favorite_drink.dart';
import '../onboarding/models/onboarding_preferences.dart';
import '../onboarding/providers/onboarding_providers.dart';
import '../tracking/models/tracking_models.dart';
import '../tracking/providers/tracking_providers.dart';
import 'widgets/edit_quick_log_sheet.dart';
import 'widgets/metabolism_card.dart';
import 'widgets/today_drink_row.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key, required this.snapshot, required this.onLog});
  final TrackingSnapshot snapshot;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppTheme.paletteOf(context);
    final preferences = ref
        .watch(onboardingControllerProvider)
        .valueOrNull
        ?.preferences;
    final now = DateTime.now();
    final today = snapshot.drinks.where((drink) {
      final date = drink.localTime;
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();
    final total = today.fold<int>(0, (sum, drink) => sum + drink.caffeineMg);
    final cost = today.fold<int>(0, (sum, drink) => sum + drink.priceCents);
    final limit = preferences?.caffeineLimitMg ?? 400;
    final mode = preferences?.goalMode ?? CaffeineGoalMode.tracking;
    final streak = switch (mode) {
      CaffeineGoalMode.tracking => _streak(snapshot.drinks, now),
      CaffeineGoalMode.cuttingBack => _goalStreak(snapshot.drinks, now, limit),
      CaffeineGoalMode.quitting => total == 0 ? 1 : 0,
    };
    final favoriteIds = preferences?.favoriteDrinkIds ?? const <String>[];
    final favorites = favoriteIds.isNotEmpty
        ? favoriteIds
            .map((id) => FavoriteDrink.findById(id))
            .whereType<FavoriteDrink>()
            .toList()
        : FavoriteDrink.catalog.take(3).toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        CoffeeCard(
          child: Row(
            children: [
              Text('🔥', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      switch (mode) {
                        CaffeineGoalMode.tracking => 'Daily Log Streak',
                        CaffeineGoalMode.cuttingBack => 'Days Under Goal',
                        CaffeineGoalMode.quitting => 'Caffeine-Free Streak',
                      },
                      style: TextStyle(color: palette.textMuted, fontSize: 12),
                    ),
                    Text(
                      '$streak ${streak == 1 ? 'Day' : 'Days'} Strong',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'LIMIT / TARGET',
                    style: TextStyle(color: palette.textSubtle, fontSize: 10),
                  ),
                  Text(
                    '$limit mg',
                    style: TextStyle(
                      color: palette.brand300,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        CoffeeCard(
          padding: const EdgeInsets.all(AppSpacing.x6),
          child: Column(
            children: [
              SizedBox(
                width: 176,
                height: 176,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: limit > 0
                            ? (total / limit).clamp(0, 1).toDouble()
                            : (total == 0 ? 0 : 1),
                        strokeWidth: 14,
                        strokeCap: StrokeCap.round,
                        backgroundColor: palette.surfaceRaised,
                        color: total > limit
                            ? palette.stateDanger
                            : palette.brand500,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$total',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'mg caffeine',
                          style: TextStyle(
                            color: palette.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          total == 0
                              ? 'Zero Intake'
                              : total > limit
                              ? 'Limit Exceeded'
                              : 'Optimal Range',
                          style: TextStyle(
                            color: total > limit
                                ? palette.stateDanger
                                : palette.stateSuccess,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Divider(color: palette.stone800),
              Row(
                children: [
                  _metric(
                    context,
                    'Cups',
                    '${today.length}',
                    palette.textPrimary,
                  ),
                  _metric(
                    context,
                    'Remaining',
                    '${(limit - total).clamp(0, limit)} mg',
                    palette.brand300,
                  ),
                  _metric(
                    context,
                    'Cost (Est.)',
                    '\$${(cost / 100).toStringAsFixed(2)}',
                    palette.stateSuccess,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'QUICK LOG',
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '• 1-tap record',
                  style: TextStyle(color: palette.textSubtle, fontSize: 11),
                ),
              ],
            ),
            InkWell(
              onTap: () => EditQuickLogSheet.show(
                context,
                favorites.map((d) => d.id).toList(),
              ),
              borderRadius: BorderRadius.circular(AppRadii.control),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune_rounded, size: 13, color: palette.brand300),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: palette.brand300,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final drink in favorites) ...[
                SizedBox(
                  width: 104,
                  child: CoffeeCard(
                    padding: EdgeInsets.zero,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      onTap: () async {
                        try {
                          await ref
                              .read(trackingControllerProvider.notifier)
                              .addDrink(
                                DrinkDraft(
                                  name: drink.name,
                                  caffeineMg: drink.caffeineMg,
                                  volumeMl: drink.volumeMl,
                                  consumedAtUtc: DateTime.now().toUtc(),
                                  priceCents: 0,
                                  temperature: 'Hot',
                                  location: 'home',
                                  cupStyle: 'artwork:${drink.artworkId}',
                                ),
                              );
                          if (context.mounted) {
                            AppToast.show(
                              context,
                              '${drink.name} logged',
                              icon: Icons.local_cafe,
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            AppToast.show(
                              context,
                              'Could not save drink. Try again.',
                              isError: true,
                            );
                          }
                        }
                      },
                      onLongPress: () => EditQuickLogSheet.show(
                        context,
                        favorites.map((d) => d.id).toList(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DrinkArtwork(id: drink.artworkId, size: 38),
                            const SizedBox(height: 6),
                            Text(
                              drink.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${drink.caffeineMg}mg',
                              style: TextStyle(
                                color: palette.brand300,
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
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        MetabolismCard(drinks: snapshot.drinks, now: now),
        const SizedBox(height: AppSpacing.x4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TODAY'S DRINKS",
              style: TextStyle(
                color: palette.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            TextButton.icon(
              onPressed: onLog,
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Custom Log'),
            ),
          ],
        ),
        if (today.isEmpty)
          CoffeeCard(
            child: Column(
              children: [
                const DrinkArtwork(id: 'mug', size: 46),
                const SizedBox(height: 8),
                Text(
                  mode == CaffeineGoalMode.quitting
                      ? 'Day 1 starts now'
                      : 'Log your first drink',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  switch (mode) {
                    CaffeineGoalMode.tracking =>
                      'Tap one of your quick-log drinks to get started.',
                    CaffeineGoalMode.cuttingBack =>
                      'Keep your intake below ${limit}mg today.',
                    CaffeineGoalMode.quitting =>
                      'Log a drink only if you have one. Stay strong!',
                  },
                  style: TextStyle(color: palette.textMuted, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          for (final drink in today) ...[
            const SizedBox(height: 8),
            TodayDrinkRow(
              drink: drink,
              favorites: favorites,
              onEdit: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: palette.overlay.withValues(alpha: 0),
                builder: (_) => LogDrinkSheet(initialRecord: drink),
              ),
              onDelete: () => _confirmDelete(context, ref, drink),
            ),
          ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _metric(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) => Expanded(
    child: Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.paletteOf(context).textMuted,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  int _streak(List<DrinkRecord> drinks, DateTime now) {
    final days = drinks.map((drink) {
      final date = drink.localTime;
      return DateTime(date.year, date.month, date.day);
    }).toSet();
    var cursor = DateTime(now.year, now.month, now.day);
    if (!days.contains(cursor)) {
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    var count = 0;
    while (days.contains(cursor)) {
      count++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return count;
  }

  int _goalStreak(List<DrinkRecord> drinks, DateTime now, int limit) {
    final totals = <DateTime, int>{};
    for (final drink in drinks) {
      final time = drink.localTime;
      final day = DateTime(time.year, time.month, time.day);
      totals[day] = (totals[day] ?? 0) + drink.caffeineMg;
    }
    var cursor = DateTime(now.year, now.month, now.day);
    if (!totals.containsKey(cursor)) {
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    var count = 0;
    while (totals.containsKey(cursor) && totals[cursor]! <= limit) {
      count++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return count;
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    DrinkRecord drink,
  ) async {
    try {
      await ref.read(trackingControllerProvider.notifier).deleteDrink(drink.id);
      if (context.mounted) {
        final palette = AppTheme.paletteOf(context);
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: _UndoSnackbarContent(
              drinkName: drink.name,
              onComplete: () => messenger.hideCurrentSnackBar(),
            ),
            backgroundColor: palette.brand50,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            action: SnackBarAction(
              label: 'Undo',
              textColor: palette.brand700,
              onPressed: () async {
                final draft = DrinkDraft(
                  name: drink.name,
                  caffeineMg: drink.caffeineMg,
                  volumeMl: drink.volumeMl,
                  consumedAtUtc: drink.consumedAtUtc,
                  priceCents: drink.priceCents,
                  temperature: drink.temperature,
                  location: drink.location,
                  cupStyle: drink.cupStyle,
                  cafeName: drink.cafeName,
                  note: drink.note,
                  photoPath: drink.photoPath,
                );
                await ref.read(trackingControllerProvider.notifier).addDrink(draft);
              },
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        AppToast.show(context, 'Could not delete drink.', isError: true);
      }
    }
  }
}

class _UndoSnackbarContent extends StatelessWidget {
  const _UndoSnackbarContent({required this.drinkName, required this.onComplete});
  final String drinkName;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            '$drinkName deleted',
            style: TextStyle(color: palette.stone900, fontWeight: FontWeight.w500),
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: 0.0),
          duration: const Duration(seconds: 5),
          builder: (context, value, child) {
            return SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 2.5,
                color: palette.brand700.withValues(alpha: 0.8),
                backgroundColor: palette.brand700.withValues(alpha: 0.15),
              ),
            );
          },
          onEnd: onComplete,
        ),
      ],
    );
  }
}
