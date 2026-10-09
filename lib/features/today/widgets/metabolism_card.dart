import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../../tracking/models/tracking_models.dart';
import '../metabolism_estimate.dart';

class MetabolismCard extends StatelessWidget {
  const MetabolismCard({super.key, required this.drinks, required this.now});
  final List<DrinkRecord> drinks;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final estimate = MetabolismEstimate(drinks, now);
    final activeMg = estimate.remainingAt(now).round();
    final below = estimate.below50At;

    final isSleepSafeNow = activeMg <= 50;

    final statusText = isSleepSafeNow
        ? 'Sleep-Safe Now'
        : below == null
        ? 'Caffeine High'
        : 'Safe by ${TimeOfDay.fromDateTime(below).format(context)}';

    final statusColor = isSleepSafeNow
        ? palette.stateSuccess
        : (below != null && below.hour < 23
              ? palette.stateInfo
              : palette.stateWarning);

    final halfLifeTime = now.add(const Duration(hours: 6));
    final halfLifeMg = (activeMg * 0.5).round();

    final String hoursToClear;
    if (below != null) {
      final diffMinutes = below.difference(now).inMinutes;
      final hours = diffMinutes / 60.0;
      hoursToClear = hours <= 0
          ? '0'
          : hours % 1 == 0
          ? hours.toInt().toString()
          : hours.toStringAsFixed(1);
    } else {
      hoursToClear = '12+';
    }
    final hoursUnit = hoursToClear == '1' ? 'hour' : 'hours';

    return CoffeeCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Moon icon, title, and status pill
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: palette.brand500.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.nightlight_round,
                  size: 15,
                  color: palette.brand300,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Metabolism & Sleep',
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Active level and human-readable explanation
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$activeMg mg',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'active in system',
                style: TextStyle(color: palette.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                isSleepSafeNow
                    ? Icons.check_circle_rounded
                    : Icons.schedule_rounded,
                size: 14,
                color: isSleepSafeNow ? palette.stateSuccess : palette.brand300,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isSleepSafeNow
                      ? 'Below 50 mg sleep cutoff'
                      : 'Clears to safe sleep level in ~$hoursToClear $hoursUnit',
                  style: TextStyle(
                    color: isSleepSafeNow
                        ? palette.stateSuccess
                        : palette.brand300,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3-Milestone Clearance Journey
          Row(
            children: [
              // Milestone 1: Active Now
              Expanded(
                child: _milestoneBox(
                  context,
                  dotColor: palette.brand400,
                  stageLabel: 'Active Now',
                  caffeineValue: '$activeMg mg',
                  timeLabel: TimeOfDay.fromDateTime(now).format(context),
                  borderColor: palette.brand500.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(width: 8),

              // Milestone 2: Half-Life (+6h)
              Expanded(
                child: _milestoneBox(
                  context,
                  dotColor: palette.stateWarning,
                  stageLabel: 'In 6 Hours',
                  caffeineValue: '$halfLifeMg mg',
                  timeLabel: TimeOfDay.fromDateTime(
                    halfLifeTime,
                  ).format(context),
                  borderColor: palette.stone800,
                ),
              ),
              const SizedBox(width: 8),

              // Milestone 3: Sleep Safe (<50mg)
              Expanded(
                child: _milestoneBox(
                  context,
                  dotColor: palette.stateSuccess,
                  stageLabel: 'Sleep Safe',
                  caffeineValue: '< 50 mg',
                  timeLabel: below != null
                      ? TimeOfDay.fromDateTime(below).format(context)
                      : 'Overnight',
                  borderColor: isSleepSafeNow
                      ? palette.stateSuccess.withValues(alpha: 0.5)
                      : palette.stone800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Footnote Explanation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: palette.surfaceRaised.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 13,
                  color: palette.textMuted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isSleepSafeNow
                        ? 'Your system is clear of caffeine. Deep sleep and REM cycles are protected.'
                        : 'Caffeine has a ~6-hour half-life. Safe sleep is expected when levels drop below 50 mg.',
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 10.5,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _milestoneBox(
    BuildContext context, {
    required Color dotColor,
    required String stageLabel,
    required String caffeineValue,
    required String timeLabel,
    required Color borderColor,
  }) {
    final palette = AppTheme.paletteOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: palette.stone900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  stageLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              caffeineValue,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              timeLabel,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
