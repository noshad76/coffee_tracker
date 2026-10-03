import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding/providers/onboarding_providers.dart';
import '../tracking/models/tracking_models.dart';
import 'models/badge_item.dart';
import 'widgets/badge_card.dart';
import 'widgets/badge_detail_sheet.dart';
import 'widgets/badge_filter_bar.dart';
import 'widgets/brew_gallery_card.dart';
import 'widgets/trophy_header_card.dart';

class AchievementsPage extends ConsumerStatefulWidget {
  const AchievementsPage({super.key, required this.snapshot});

  final TrackingSnapshot snapshot;

  @override
  ConsumerState<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends ConsumerState<AchievementsPage> {
  BadgeCategory _selectedCategory = BadgeCategory.all;

  @override
  Widget build(BuildContext context) {
    final limit =
        ref
            .watch(onboardingControllerProvider)
            .valueOrNull
            ?.preferences
            .caffeineLimitMg ??
        400;

    final badges = BadgeCalculator.computeBadges(
      drinks: widget.snapshot.drinks,
      caffeineLimitMg: limit,
    );

    final unlockedCount = badges.where((b) => b.earned).length;
    final totalCount = badges.length;
    final rank = BadgeCalculator.getRank(unlockedCount);

    final categoryCounts = <BadgeCategory, int>{
      for (final cat in BadgeCategory.values)
        cat: cat == BadgeCategory.all
            ? badges.length
            : badges.where((b) => b.category == cat).length,
    };

    final filteredBadges = _selectedCategory == BadgeCategory.all
        ? badges
        : badges.where((b) => b.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          // Header Card with Barista Rank & Progress
          TrophyHeaderCard(
            rank: rank,
            unlockedCount: unlockedCount,
            totalCount: totalCount,
          ),
          const SizedBox(height: 14),

          // Brew Scrapbook Photo Journal
          BrewGalleryCard(drinks: widget.snapshot.drinks),
          const SizedBox(height: 18),

          // Category Filter Bar
          BadgeFilterBar(
            selectedCategory: _selectedCategory,
            onSelectCategory: (cat) => setState(() => _selectedCategory = cat),
            badgeCounts: categoryCounts,
          ),
          const SizedBox(height: 14),

          // Badges List
          for (final badge in filteredBadges) ...[
            BadgeCard(
              badge: badge,
              onTap: () => BadgeDetailSheet.show(context, badge),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
