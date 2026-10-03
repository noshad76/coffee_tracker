import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../../../shared/widgets/drink_artwork.dart';
import '../models/badge_item.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key, required this.badge, required this.onTap});

  final BadgeItem badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: CoffeeCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Badge icon container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: badge.earned
                    ? palette.brand500.withValues(alpha: 0.15)
                    : palette.stone900,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: badge.earned
                      ? palette.brand500.withValues(alpha: 0.4)
                      : palette.stone800,
                ),
              ),
              child: Opacity(
                opacity: badge.earned ? 1.0 : 0.35,
                child: Center(
                  child: badge.svgAsset != null
                      ? DrinkArtwork(id: badge.svgAsset!, size: 30)
                      : Icon(
                          badge.icon,
                          color: badge.earned
                              ? palette.brand300
                              : palette.textSubtle,
                          size: 26,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          badge.title,
                          style: TextStyle(
                            color: badge.earned
                                ? palette.textPrimary
                                : palette.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (badge.earned)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: palette.stateSuccess.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 10,
                                color: palette.stateSuccess,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'EARNED',
                                style: TextStyle(
                                  color: palette.stateSuccess,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: palette.stone900,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: palette.stone800),
                          ),
                          child: Text(
                            '${badge.progress} / ${badge.progressMax}',
                            style: TextStyle(
                              color: palette.textSubtle,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    badge.description,
                    style: TextStyle(color: palette.textMuted, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!badge.earned && badge.progressMax > 1) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: badge.progressFraction,
                        minHeight: 4,
                        backgroundColor: palette.stone800,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          palette.brand500.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: palette.stone700,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
