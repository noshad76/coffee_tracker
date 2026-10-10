part of '../onboarding_screen.dart';

// ignore: unused_element
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.onPressed,
    // ignore: unused_element_parameter
    this.height = 56,
  });
  final String label;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.paletteOf(context).textSecondary,
        backgroundColor: AppTheme.paletteOf(context).stone800,
        side: BorderSide(color: AppTheme.paletteOf(context).stone800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.largeCard),
        ),
      ),
      child: Text(label),
    ),
  );
}
