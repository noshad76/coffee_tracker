import 'dart:io';
import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../../../shared/widgets/photo_detail_dialog.dart';
import '../../tracking/models/tracking_models.dart';

class BrewGalleryCard extends StatelessWidget {
  const BrewGalleryCard({super.key, required this.drinks});

  final List<DrinkRecord> drinks;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final photoDrinks = drinks
        .where((d) => d.photoPath != null && d.photoPath!.isNotEmpty)
        .toList();

    return CoffeeCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.photo_camera_rounded,
                    size: 18,
                    color: palette.brand400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'BREW SCRAPBOOK',
                    style: TextStyle(
                      color: palette.brand300,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: palette.surfaceRaised,
                  borderRadius: BorderRadius.circular(AppRadii.control),
                  border: Border.all(color: palette.stone800),
                ),
                child: Text(
                  '${photoDrinks.length} Photos',
                  style: TextStyle(
                    color: photoDrinks.isNotEmpty
                        ? palette.brand400
                        : palette.textSubtle,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          if (photoDrinks.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: palette.surfaceRaised.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: palette.stone800),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: palette.brand500.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: palette.brand400,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No coffee photos yet',
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap 📷 Photo when logging a drink to save visual coffee memories here.',
                          style: TextStyle(
                            color: palette.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: photoDrinks.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final drink = photoDrinks[index];
                  final file = File(drink.photoPath!);
                  final exists = file.existsSync();

                  return InkWell(
                    onTap: () => PhotoDetailDialog.show(context, drink),
                    borderRadius: BorderRadius.circular(AppRadii.card),
                    child: Container(
                      width: 110,
                      decoration: BoxDecoration(
                        color: palette.surfaceRaised,
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        border: Border.all(color: palette.stone800),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: exists
                                ? Image.file(
                                    file,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 28,
                                        color: palette.textMuted,
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: palette.stone900,
                                    child: Icon(
                                      Icons.local_cafe,
                                      color: palette.brand400,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  drink.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${drink.consumedAtUtc.toLocal().month}/${drink.consumedAtUtc.toLocal().day} • ${drink.caffeineMg}mg',
                                  style: TextStyle(
                                    color: palette.brand300,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
