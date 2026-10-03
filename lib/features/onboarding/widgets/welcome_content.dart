part of '../onboarding_screen.dart';

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const SizedBox(height: AppSpacing.x8),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: palette.brand500.withValues(alpha: .25),
                ),
              ),
              child: Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [palette.brand500, palette.brand700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: palette.brand900.withValues(alpha: .55),
                        blurRadius: 28,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.coffee_rounded,
                    size: 44,
                    color: palette.brand50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x6),
            Text.rich(
              TextSpan(
                text: 'Know your\n',
                children: [
                  TextSpan(
                    text: 'coffee.',
                    style: TextStyle(color: palette.brand300),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: palette.brand50,
                fontWeight: FontWeight.w800,
                letterSpacing: -.5,
                height: 1.1,
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 270),
              child: Text(
                'Track caffeine, see your patterns, and stay in control.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const _BenefitTile(
              icon: Icons.bolt_rounded,
              title: 'One-tap logging',
              subtitle: 'Add a drink in a second',
            ),
            const SizedBox(height: AppSpacing.x2),
            const _BenefitTile(
              icon: Icons.show_chart_rounded,
              title: 'Clear patterns',
              subtitle: 'Daily, weekly and monthly intake',
            ),
            const SizedBox(height: AppSpacing.x2),
            const _BenefitTile(
              icon: Icons.nights_stay_outlined,
              title: 'Sleep-safe cutoff',
              subtitle: 'Know when caffeine stops affecting you',
              informational: true,
            ),
            const SizedBox(height: AppSpacing.x4),
          ],
        ),
      ],
    );
  }
}
