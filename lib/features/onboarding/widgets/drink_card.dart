part of '../onboarding_screen.dart';

class _DrinkCard extends StatelessWidget {
  const _DrinkCard({
    required this.drink,
    required this.selected,
    required this.onTap,
  });

  final FavoriteDrink drink;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      label:
          '${drink.name}, ${drink.caffeineMg} milligrams, ${drink.volumeMl} milliliters',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppSpacing.x3),
          decoration: BoxDecoration(
            color: selected ? palette.surfaceRaised : palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: selected ? palette.brand500 : palette.stone800,
              width: selected ? 2 : 1,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DrinkArtwork(id: drink.id, size: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drink.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '${drink.caffeineMg} mg · ${drink.volumeMl}ml',
                        maxLines: 1,
                        style: TextStyle(
                          color: palette.textMuted,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (selected)
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 22,
                    color: palette.brand300,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
