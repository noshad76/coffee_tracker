part of '../onboarding_screen.dart';

class _StepLabel extends StatelessWidget {
  const _StepLabel({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    return Text(
      'STEP $number OF 4',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: palette.brand300,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    );
  }
}
