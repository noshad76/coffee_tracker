import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../../../shared/widgets/drink_artwork.dart';
import '../../achievements/models/badge_item.dart';
import '../../tracking/models/tracking_models.dart';

class EarnedBadgesCard extends StatelessWidget {
  const EarnedBadgesCard({
    super.key,
    required this.drinks,
    required this.caffeineLimitMg,
  });

  final List<DrinkRecord> drinks;
  final int caffeineLimitMg;

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
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: palette.surfaceRaised,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: badge.earned ? palette.brand500 : palette.stone800,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: badge.svgAsset != null
                      ? DrinkArtwork(id: badge.svgAsset!, size: 48)
                      : Icon(
                          badge.icon,
                          color: badge.earned
                              ? palette.brand300
                              : palette.textSubtle,
                          size: 38,
                        ),
                ),
              ),
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
                  badge.earned ? '✓ Unlocked' : '🔒 Locked',
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: palette.stone900,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: palette.stone800),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 14,
                      color: palette.brand300,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        badge.requirement,
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
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
    final allBadges = BadgeCalculator.computeBadges(
      drinks: drinks,
      caffeineLimitMg: caffeineLimitMg,
    );
    final earnedBadges = allBadges.where((b) => b.earned).toList();

    return CoffeeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: palette.brand500.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${earnedBadges.length} / ${allBadges.length} Unlocked',
                  style: TextStyle(
                    color: palette.brand300,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (earnedBadges.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: palette.surfaceRaised,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: palette.stone800),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    color: palette.textMuted,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No Badges Earned Yet',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Log drinks and hit milestones to unlock your first trophy!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: earnedBadges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                final badge = earnedBadges[index];
                return InkWell(
                  onTap: () => _showBadgeDetail(context, badge),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: palette.stone900,
                      border: Border.all(
                        color: palette.brand500.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (badge.svgAsset != null)
                          DrinkArtwork(id: badge.svgAsset!, size: 36)
                        else
                          Icon(
                            badge.icon,
                            color: palette.brand300,
                            size: 32,
                          ),
                        const SizedBox(height: 4),
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
                );
              },
            ),
        ],
      ),
    );
  }
}
