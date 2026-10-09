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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? palette.surfaceRaised : palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: selected ? palette.brand500 : palette.stone800,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected
                      ? accentColor.withValues(alpha: 0.15)
                      : palette.stone800,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? accentColor.withValues(alpha: 0.3)
                        : palette.stone700,
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: palette.textPrimary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: palette.textMuted,
                            height: 1.3,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked,
                size: 20,
                color: selected ? palette.brand500 : palette.stone700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
