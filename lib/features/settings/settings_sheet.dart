import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../core/models/coffee_theme_preset.dart';
import '../onboarding/providers/onboarding_providers.dart';
import 'reminders_sheet.dart';
import 'theme_sheet.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppTheme.paletteOf(context);
    final preferences = ref
        .watch(onboardingControllerProvider)
        .valueOrNull
        ?.preferences;
    final preset = preferences?.themePreset ?? CoffeeThemePreset.coffee;

    final themeName = switch (preset.basePreset()) {
      CoffeeThemePreset.coffee => 'Espresso',
      CoffeeThemePreset.ocean => 'Iced Latte',
      CoffeeThemePreset.forest => 'Matcha',
      CoffeeThemePreset.amber => 'Amber Tea',
      _ => 'Espresso',
    };
    final modeLabel = preset.isLight ? 'Light' : 'Dark';

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheetTop),
        ),
        border: Border(top: BorderSide(color: palette.stone700, width: 1.2)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
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
              _buildSettingTile(
                context,
                icon: preset.isLight
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                title: 'Theme',
                subtitle: '$modeLabel • $themeName',
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const ThemeSheet(),
                  );
                },
              ),
              _buildSettingTile(
                context,
                icon: Icons.notifications_outlined,
                title: 'Reminders',
                subtitle: 'Daily 9:00 PM check-in & quiet hours',
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const RemindersSheet(),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final palette = AppTheme.paletteOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.stone800),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: palette.brand500.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: palette.brand300, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: palette.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: palette.textSubtle, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
