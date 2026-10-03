import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../core/models/coffee_theme_preset.dart';
import '../onboarding/providers/onboarding_providers.dart';

class ThemeSheet extends ConsumerWidget {
  const ThemeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppTheme.paletteOf(context);
    final active = ref
        .watch(onboardingControllerProvider)
        .valueOrNull
        ?.preferences
        .themePreset;
    final names = ['Espresso', 'Iced Latte', 'Matcha', 'Tea'];
    final descriptions = [
      'Classic dark roast',
      'Cool, icy and creamy',
      'Fresh green tea',
      'Warm amber black tea',
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheetTop),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Choose a theme',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            for (final (index, preset) in CoffeeThemePreset.values.indexed)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () async {
                    try {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .saveTheme(preset);
                      if (context.mounted) Navigator.pop(context);
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not save theme.'),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: palette.stone900,
                      border: Border.all(
                        color: active == preset
                            ? palette.brand500
                            : palette.stone800,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            for (final color in [
                              AppTheme.palettes[preset]!.surface,
                              AppTheme.palettes[preset]!.brand500,
                              AppTheme.palettes[preset]!.brand300,
                            ])
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsetsDirectional.only(
                                  end: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: palette.stone900,
                                    width: 2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                names[index],
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                descriptions[index],
                                style: TextStyle(
                                  color: palette.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (active == preset)
                          Icon(Icons.check, color: palette.brand300),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
