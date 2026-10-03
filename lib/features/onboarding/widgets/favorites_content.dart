part of '../onboarding_screen.dart';

class _FavoritesContent extends StatelessWidget {
  const _FavoritesContent({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final selected = state.preferences.favoriteDrinkIds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepLabel(number: 4),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'What do you usually drink?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Pick up to 3. They\'ll become your one-tap quick log.',
          style: TextStyle(
            color: AppTheme.paletteOf(context).textMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 430 ? 3 : 2;
            final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: FavoriteDrink.catalog.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: AppSpacing.x3,
                mainAxisSpacing: AppSpacing.x3,
                mainAxisExtent: 112 + ((textScale - 1).clamp(0, 2) * 36),
              ),
              itemBuilder: (context, index) {
                final drink = FavoriteDrink.catalog[index];
                return _DrinkCard(
                  drink: drink,
                  selected: selected.contains(drink.id),
                  onTap: state.saving
                      ? null
                      : () => controller.toggleFavorite(drink.id),
                );
              },
            );
          },
        ),
        if (selected.length == 3) ...[
          const SizedBox(height: AppSpacing.x3),
          const _Description(
            'You can change your favorites anytime in Settings.',
            centered: true,
          ),
        ],
      ],
    );
  }
}
