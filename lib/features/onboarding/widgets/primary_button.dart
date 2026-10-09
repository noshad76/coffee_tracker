part of '../onboarding_screen.dart';

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 52,
  });
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: height,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppTheme.paletteOf(context).brand500,
        foregroundColor: AppTheme.paletteOf(context).textPrimary,
        disabledBackgroundColor: AppTheme.paletteOf(context).brand700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.largeCard),
        ),
        textStyle: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      child: icon == null
          ? Text(label)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon!,
                const SizedBox(width: AppSpacing.x2),
                Text(label),
              ],
            ),
    ),
  );
}
