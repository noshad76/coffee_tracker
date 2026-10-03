import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/coffee_card.dart';
import '../../shared/widgets/drink_artwork.dart';
import '../tracking/models/tracking_models.dart';
import '../onboarding/providers/onboarding_providers.dart';
import 'widgets/earned_badges_card.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key, required this.snapshot});
  final TrackingSnapshot snapshot;

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? selected;

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
    final firstOffset = month.weekday % 7;
    final dayCount = DateTime(month.year, month.month + 1, 0).day;
    final monthName = MaterialLocalizations.of(context).formatMonthYear(month);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        CoffeeCard(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Previous month',
                    onPressed: () => setState(
                      () => month = DateTime(month.year, month.month - 1),
                    ),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      monthName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next month',
                    onPressed: () => setState(
                      () => month = DateTime(month.year, month.month + 1),
                    ),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _legend(palette.stateSuccess, 'Under Limit'),
                  const SizedBox(width: 12),
                  _legend(palette.stateDanger, 'Over'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (final day in const ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                    Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: palette.textSubtle,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: firstOffset + dayCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  if (index < firstOffset) return const SizedBox.shrink();
                  final date = DateTime(
                    month.year,
                    month.month,
                    index - firstOffset + 1,
                  );
                  final drinks = _forDay(date);
                  final total = drinks.fold<int>(
                    0,
                    (sum, drink) => sum + drink.caffeineMg,
                  );
                  final isSelected =
                      selected != null && _sameDay(selected!, date);
                  return InkWell(
                    onTap: () => setState(() => selected = date),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? palette.surfaceRaised
                            : palette.stone900,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? palette.brand500
                              : palette.stone800,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontSize: 12,
                            ),
                          ),
                          if (drinks.isNotEmpty)
                            Expanded(
                              child: Center(
                                child: total > limit
                                    ? const DrinkArtwork(id: 'bolt', size: 24)
                                    : DrinkArtwork(
                                        id: _artworkId(drinks.first.name),
                                        size: 28,
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        CoffeeCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selected == null
                    ? 'Select a day'
                    : MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(selected!),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              if (selected == null || _forDay(selected!).isEmpty)
                Text(
                  'No drinks logged for this day.',
                  style: TextStyle(color: palette.textMuted, fontSize: 12),
                )
              else
                for (final drink in _forDay(selected!))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(drink.name)),
                        Text(
                          '${drink.caffeineMg} mg',
                          style: TextStyle(color: palette.brand300),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        EarnedBadgesCard(
          drinks: widget.snapshot.drinks,
          caffeineLimitMg: limit,
        ),
      ],
    );
  }

  List<DrinkRecord> _forDay(DateTime date) => widget.snapshot.drinks
      .where((drink) => _sameDay(drink.localTime, date))
      .toList();
  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _legend(Color color, String label) => Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 10)),
    ],
  );

  String _artworkId(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('espresso')) return 'espresso';
    if (normalized.contains('americano')) return 'americano';
    if (normalized.contains('matcha')) return 'matcha';
    if (normalized.contains('latte')) return 'latte';
    if (normalized.contains('tea')) return 'tea';
    if (normalized.contains('cold brew')) return 'coldbrew';
    return 'blackcoffee';
  }
}
