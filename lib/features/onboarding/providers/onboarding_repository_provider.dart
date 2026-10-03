import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_database_provider.dart';
import '../data/drift_onboarding_repository.dart';
import '../models/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return DriftOnboardingRepository(ref.watch(appDatabaseProvider));
});
