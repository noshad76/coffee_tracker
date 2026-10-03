part of '../onboarding_screen.dart';

class _InlineError extends StatelessWidget {
  const _InlineError(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: palette.stateDanger.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(AppRadii.control),
        border: Border.all(color: palette.stateDanger.withValues(alpha: .35)),
      ),
      child: Text(message, style: TextStyle(color: palette.stateDanger)),
    );
  }
}
