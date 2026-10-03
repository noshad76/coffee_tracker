import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../models/badge_item.dart';

class TrophyHeaderCard extends StatelessWidget {
  const TrophyHeaderCard({
    super.key,
    required this.rank,
    required this.unlockedCount,
    required this.totalCount,
  });

  final BaristaRank rank;
  final int unlockedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final percentage = totalCount > 0 ? (unlockedCount / totalCount) : 0.0;
    final percentInt = (percentage * 100).round();

    return CoffeeCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: rank.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: rank.color.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Icon(rank.icon, color: rank.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: rank.color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'LVL ${rank.level}',
                            style: TextStyle(
                              color: rank.color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rank.title,
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rank.tagline,
                      style: TextStyle(color: palette.textMuted, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress indicator
          Row(
            children: [
              Expanded(
                child: Text(
                  'Trophy Progress',
                  style: TextStyle(
                    color: palette.textSubtle,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$unlockedCount / $totalCount ($percentInt%)',
                style: TextStyle(
                  color: palette.brand300,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: palette.stone800,
              valueColor: AlwaysStoppedAnimation<Color>(palette.brand500),
            ),
          ),
        ],
      ),
    );
  }
}
