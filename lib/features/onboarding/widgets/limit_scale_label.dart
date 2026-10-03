part of '../onboarding_screen.dart';

class _LimitScaleLabel extends StatelessWidget {
  const _LimitScaleLabel(this.text, {this.alignEnd = false});
  final String text;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Text(
      text,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        height: 1.35,
        fontSize: 11,
        fontFamily: 'monospace',
      ),
    ),
  );
}
