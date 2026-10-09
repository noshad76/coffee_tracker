import 'dart:io';
import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/drink_artwork.dart';
import '../../../shared/widgets/photo_detail_dialog.dart';
import '../../onboarding/models/favorite_drink.dart';
import '../../tracking/models/tracking_models.dart';
import '../drink_artwork_id.dart';

class TodayDrinkRow extends StatelessWidget {
  const TodayDrinkRow({
    super.key,
    required this.drink,
    required this.onEdit,
    required this.onDelete,
    this.favorites,
  });
  final DrinkRecord drink;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final List<FavoriteDrink>? favorites;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final source = drink.location == 'cafe'
        ? (drink.cafeName?.isNotEmpty == true ? drink.cafeName! : 'At Cafe')
        : 'Home Brew';
    final cost = drink.priceCents > 0
        ? ' · \$${(drink.priceCents / 100).toStringAsFixed(2)}'
        : '';
    final hasPhoto = drink.photoPath != null && drink.photoPath!.isNotEmpty;
    final photoFile = hasPhoto ? File(drink.photoPath!) : null;
    final photoExists = photoFile != null && photoFile.existsSync();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.stone800),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Row(
        children: [
          if (photoExists)
            InkWell(
              onTap: () => PhotoDetailDialog.show(context, drink),
              borderRadius: BorderRadius.circular(AppRadii.control),
              child: Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: palette.surfaceRaised,
                      borderRadius: BorderRadius.circular(AppRadii.control),
                      border: Border.all(color: palette.stone700),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.file(
                      photoFile,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Center(
                        child: DrinkArtwork(
                          id: drinkArtworkId(
                            drink.name,
                            cupStyle: drink.cupStyle,
                            favorites: favorites,
                          ),
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 9,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: palette.surfaceRaised,
                borderRadius: BorderRadius.circular(AppRadii.control),
              ),
              child: Center(
                child: DrinkArtwork(
                  id: drinkArtworkId(
                    drink.name,
                    cupStyle: drink.cupStyle,
                    favorites: favorites,
                  ),
                  size: 36,
                ),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drink.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${TimeOfDay.fromDateTime(drink.localTime).format(context)} · $source$cost',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: palette.textMuted, fontSize: 11),
                ),
                if (drink.note != null && drink.note!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '"${drink.note}"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.brand300,
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${drink.caffeineMg} mg',
                style: TextStyle(
                  color: palette.brand300,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                '${drink.volumeMl} ml',
                style: TextStyle(color: palette.textSubtle, fontSize: 10),
              ),
            ],
          ),
          PopupMenuButton<String>(
            tooltip: 'Actions for ${drink.name}',
            icon: Icon(Icons.more_vert, size: 18, color: palette.textMuted),
            padding: EdgeInsets.zero,
            position: PopupMenuPosition.under,
            color: palette.surfaceRaised,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.card),
              side: BorderSide(color: palette.stone700),
            ),
            constraints: const BoxConstraints(minWidth: 160),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                height: 48,
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20, color: palette.textPrimary),
                    const SizedBox(width: AppSpacing.x3),
                    Text('Edit', style: TextStyle(color: palette.textPrimary, fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                enabled: false,
                height: 1,
                padding: EdgeInsets.zero,
                child: Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: palette.stone700,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                height: 48,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: palette.stateDanger),
                    const SizedBox(width: AppSpacing.x3),
                    Text('Delete', style: TextStyle(color: palette.stateDanger, fontSize: 14)),
                  ],
                ),
              ),
            ],
            onSelected: (action) => action == 'edit' ? onEdit() : onDelete(),
          ),
        ],
      ),
    );
  }
}
