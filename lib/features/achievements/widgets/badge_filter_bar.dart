import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../models/badge_item.dart';

class BadgeFilterBar extends StatelessWidget {
  const BadgeFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
    required this.badgeCounts,
  });

  final BadgeCategory selectedCategory;
  final ValueChanged<BadgeCategory> onSelectCategory;
  final Map<BadgeCategory, int> badgeCounts;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: BadgeCategory.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = BadgeCategory.values[index];
          final isSelected = category == selectedCategory;
          final count = badgeCounts[category] ?? 0;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelectCategory(category),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? palette.brand500 : palette.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? palette.brand500 : palette.stone800,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${category.label} ($count)',
                    style: TextStyle(
                      color: isSelected ? Colors.white : palette.textMuted,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
