part of '../onboarding_screen.dart';

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.sub,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String sub;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.control),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? palette.brand500.withValues(alpha: 0.15)
                : palette.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadii.control),
            border: Border.all(
              color: isSelected ? palette.brand500 : palette.stone800,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? palette.brand400 : palette.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 9,
                  color: isSelected ? palette.brand300 : palette.textSubtle,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
