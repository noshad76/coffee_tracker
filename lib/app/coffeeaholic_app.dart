import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/coffee_theme_preset.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/providers/onboarding_providers.dart';
import '../features/shell/main_shell.dart';
import 'theme/app_theme.dart';

class CoffeeaholicApp extends ConsumerWidget {
  const CoffeeaholicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingControllerProvider);
    final themePreset =
        onboarding.valueOrNull?.preferences.themePreset ??
        CoffeeThemePreset.coffee;
    return MaterialApp(
      title: 'Coffeeaholic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(themePreset),
      home: onboarding.valueOrNull?.preferences.onboardingComplete == true
          ? const MainShell()
          : const OnboardingScreen(),
    );
  }
}
