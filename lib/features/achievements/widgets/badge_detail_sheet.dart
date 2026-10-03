import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../../../shared/widgets/drink_artwork.dart';
import '../models/badge_item.dart';

class BadgeDetailSheet extends StatelessWidget {
  const BadgeDetailSheet({super.key, required this.badge});

  final BadgeItem badge;

  static Future<void> show(BuildContext context, BadgeItem badge) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppTheme.paletteOf(context).overlay.withValues(alpha: 0),
      builder: (context) => BadgeDetailSheet(badge: badge),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: palette.stone800),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.paddingOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: palette.stone700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Badge Hero Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: badge.earned
                  ? palette.brand500.withValues(alpha: 0.15)
                  : palette.stone900,
              shape: BoxShape.circle,
              border: Border.all(
                color: badge.earned
                    ? palette.brand500.withValues(alpha: 0.5)
                    : palette.stone800,
                width: 2,
              ),
            ),
            child: Opacity(
              opacity: badge.earned ? 1.0 : 0.4,
              child: Center(
                child: badge.svgAsset != null
                    ? DrinkArtwork(id: badge.svgAsset!, size: 42)
                    : Icon(
                        badge.icon,
                        color: badge.earned
                            ? palette.brand300
                            : palette.textSubtle,
                        size: 36,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Title & Category
          Text(
            badge.title,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: palette.stone900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.stone800),
            ),
            child: Text(
              badge.category.label.toUpperCase(),
              style: TextStyle(
                color: palette.brand300,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: badge.earned
                  ? palette.stateSuccess.withValues(alpha: 0.12)
                  : palette.stone900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: badge.earned
                    ? palette.stateSuccess.withValues(alpha: 0.4)
                    : palette.stone800,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  badge.earned
                      ? Icons.check_circle_rounded
                      : Icons.lock_outline_rounded,
                  color: badge.earned
                      ? palette.stateSuccess
                      : palette.textSubtle,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  badge.earned
                      ? 'Achievement Unlocked!'
                      : 'Locked (${badge.progress} / ${badge.progressMax})',
                  style: TextStyle(
                    color: badge.earned
                        ? palette.stateSuccess
                        : palette.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Requirement Box
          CoffeeCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag_rounded, size: 14, color: palette.brand300),
                    const SizedBox(width: 6),
                    Text(
                      'REQUIREMENT',
                      style: TextStyle(
                        color: palette.brand300,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  badge.requirement,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Barista Tip / Fact Box
          CoffeeCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_rounded,
                      size: 14,
                      color: palette.stateWarning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BARISTA INSIGHT',
                      style: TextStyle(
                        color: palette.stateWarning,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  badge.tip,
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Dismiss Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: palette.stone800),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
