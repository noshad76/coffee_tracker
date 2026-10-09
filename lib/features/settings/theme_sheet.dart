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
    final active =
        ref
            .watch(onboardingControllerProvider)
            .valueOrNull
            ?.preferences
            .themePreset ??
        CoffeeThemePreset.coffee;

    final isLight = active.isLight;

    final baseOptions = [
      (
        base: CoffeeThemePreset.coffee,
        name: 'Espresso',
        desc: isLight
            ? 'Warm oat milk & dark roast'
            : 'Classic dark roast mocha',
      ),
      (
        base: CoffeeThemePreset.ocean,
        name: 'Iced Latte',
        desc: isLight
            ? 'Crisp coastal morning breeze'
            : 'Deep nordic cold brew ocean',
      ),
      (
        base: CoffeeThemePreset.forest,
        name: 'Matcha',
        desc: isLight
            ? 'Spring matcha milk & garden'
            : 'Deep botanical matcha ritual',
      ),
      (
        base: CoffeeThemePreset.amber,
        name: 'Amber Tea',
        desc: isLight
            ? 'Golden chamomile & wildflower honey'
            : 'Warm spiced rooibos & caramel',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheetTop),
        ),
        border: Border(top: BorderSide(color: palette.stone700, width: 1.2)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.stone700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose a theme',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: palette.textMuted, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // APPEARANCE MODE TOGGLE
            Text(
              'APPEARANCE',
              style: TextStyle(
                color: palette.textSubtle,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildModeButton(
                    context: context,
                    ref: ref,
                    title: 'Dark Mode',
                    icon: Icons.dark_mode_outlined,
                    isSelected: !isLight,
                    onTap: () {
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .saveTheme(active.toDark());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModeButton(
                    context: context,
                    ref: ref,
                    title: 'Light Mode',
                    icon: Icons.light_mode_outlined,
                    isSelected: isLight,
                    onTap: () {
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .saveTheme(active.toLight());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // PALETTE PRESET LIST
            Text(
              'COLOR PALETTE',
              style: TextStyle(
                color: palette.textSubtle,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            for (final option in baseOptions)
              _buildPaletteTile(
                context: context,
                ref: ref,
                basePreset: option.base,
                name: option.name,
                description: option.desc,
                isActive: active.basePreset() == option.base,
                isLight: isLight,
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final palette = AppTheme.paletteOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? palette.brand500.withValues(alpha: 0.16)
              : palette.surfaceRaised,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? palette.brand500 : palette.stone800,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? palette.brand300 : palette.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? palette.textPrimary : palette.textSecondary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaletteTile({
    required BuildContext context,
    required WidgetRef ref,
    required CoffeeThemePreset basePreset,
    required String name,
    required String description,
    required bool isActive,
    required bool isLight,
  }) {
    final palette = AppTheme.paletteOf(context);
    final targetPreset = isLight ? basePreset.toLight() : basePreset.toDark();
    final targetPalette = AppTheme.palettes[targetPreset]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () async {
          await ref
              .read(onboardingControllerProvider.notifier)
              .saveTheme(targetPreset);
          if (context.mounted) Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: palette.surfaceRaised,
            border: Border.all(
              color: isActive ? palette.brand500 : palette.stone800,
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Swatch circle dots
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final color in [
                    targetPalette.background,
                    targetPalette.surfaceRaised,
                    targetPalette.brand500,
                    targetPalette.brand300,
                  ])
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsetsDirectional.only(end: 3),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: palette.stone700, width: 1.5),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: palette.textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: palette.brand500,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 15),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
