import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/drink_artwork.dart';
import '../../tracking/models/tracking_models.dart';
import '../drink_artwork_id.dart';

class TodayDrinkRow extends StatelessWidget {
  const TodayDrinkRow({
    super.key,
    required this.drink,
    required this.onEdit,
    required this.onDelete,
  });
  final DrinkRecord drink;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final source = drink.location == 'cafe'
        ? (drink.cafeName?.isNotEmpty == true ? drink.cafeName! : 'At Cafe')
        : 'Home Brew';
    final cost = drink.priceCents > 0
        ? ' · \$${(drink.priceCents / 100).toStringAsFixed(2)}'
        : '';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.stone800),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: palette.surfaceRaised,
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
            child: Center(
              child: DrinkArtwork(id: drinkArtworkId(drink.name), size: 36),
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
            constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (action) => action == 'edit' ? onEdit() : onDelete(),
          ),
        ],
      ),
    );
  }
}
