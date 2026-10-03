part of '../onboarding_screen.dart';

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
  });

  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String description;
  final _ModeAccent accent;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final accentColor = switch (accent) {
      _ModeAccent.brand => palette.brand300,
      _ModeAccent.warning => palette.stateWarning,
      _ModeAccent.danger => palette.stateDanger,
    };
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            color: selected ? palette.surfaceRaised : palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: selected ? palette.brand500 : palette.stone800,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: AppTargets.minimumInteractive,
                height: AppTargets.minimumInteractive,
                decoration: BoxDecoration(
                  color: palette.stone800,
                  borderRadius: BorderRadius.circular(AppRadii.control),
                ),
                child: Icon(icon, color: accentColor),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
