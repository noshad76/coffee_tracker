import 'onboarding_preferences.dart';

abstract interface class OnboardingRepository {
  Future<OnboardingPreferences> loadPreferences();

  Future<void> savePreferences(OnboardingPreferences preferences);
}
