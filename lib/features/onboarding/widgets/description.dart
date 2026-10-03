part of '../onboarding_screen.dart';

class _Description extends StatelessWidget {
  const _Description(this.text, {this.centered = false});
  final String text;
  final bool centered;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: centered ? TextAlign.center : TextAlign.start,
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
  );
}
