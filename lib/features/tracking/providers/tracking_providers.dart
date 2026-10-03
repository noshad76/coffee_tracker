import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_database_provider.dart';
import '../controllers/tracking_controller.dart';
import '../data/drift_tracking_repository.dart';
import '../models/tracking_models.dart';
import '../models/tracking_repository.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>(
  (ref) => DriftTrackingRepository(ref.watch(appDatabaseProvider)),
);

final trackingControllerProvider =
    AsyncNotifierProvider<TrackingController, TrackingSnapshot>(
      TrackingController.new,
    );
