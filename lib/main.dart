import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/coffeeaholic_app.dart';

import 'features/onboarding/providers/onboarding_providers.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  final container = ProviderContainer();
  // Keep the native launch screen visible until the saved palette is known.
  try {
    await container.read(onboardingControllerProvider.future);
  } catch (_) {
    // The app renders its normal retry state if local preferences cannot load.
  }
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CoffeeaholicApp(),
    ),
  );
}
