import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_database_provider.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/services/notification_service.dart';

class RemindersState {
  final List<LocalReminder> fixedReminders;
  final bool smartReminderEnabled;

  RemindersState({
    required this.fixedReminders,
    required this.smartReminderEnabled,
  });
}

class RemindersNotifier extends AsyncNotifier<RemindersState> {
  @override
  Future<RemindersState> build() async {
    final db = ref.watch(appDatabaseProvider);

    final reminders = await db.select(db.localReminders).get();

    final settings = await (db.select(
      db.localAppSettings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();

    final smartEnabled = settings?.smartReminderEnabled ?? false;

    _scheduleNotifications(reminders, smartEnabled);

    return RemindersState(
      fixedReminders: reminders,
      smartReminderEnabled: smartEnabled,
    );
  }

  Future<void> _scheduleNotifications(
    List<LocalReminder> fixed,
    bool smartEnabled,
  ) async {
    final service = NotificationService();
    await service.cancelAllReminders();

    // Always schedule the default 9:00 PM evening check-in notification
    await service.scheduleDefaultDailyCheckIn();

    for (final r in fixed) {
      if (r.enabled) {
        await service.scheduleDailyReminder(
          r.id,
          r.hour,
          r.minute,
          '☕ Coffee Break Reminder',
          'Time for your brew! Enjoy your cup and remember to log it.',
        );
      }
    }

    if (smartEnabled) {
      await _scheduleSmartReminder(service);
    }
  }

  Future<void> _scheduleSmartReminder(NotificationService service) async {
    final db = ref.read(appDatabaseProvider);
    final drinks = await db.select(db.drinkEntries).get();

    if (drinks.isEmpty) {
      await service.scheduleDailyReminder(
        999999,
        10,
        0,
        '☕ Smart Coffee Reminder',
        'Ready for your first brew? Log it to start tracking your caffeine curve!',
      );
      return;
    }

    final minutesSinceMidnight = drinks.map((d) {
      final local = d.consumedAtUtc.toLocal();
      return local.hour * 60 + local.minute;
    }).toList();
    minutesSinceMidnight.sort();

    final medianMinutes =
        minutesSinceMidnight[minutesSinceMidnight.length ~/ 2];
    final hour = medianMinutes ~/ 60;
    final minute = medianMinutes % 60;

    await service.scheduleDailyReminder(
      999999,
      hour,
      minute,
      '☕ Your usual brew time!',
      'Don\'t forget to log your coffee to keep your metabolism curve accurate.',
    );
  }

  Future<void> addFixedReminder(int hour, int minute) async {
    final db = ref.read(appDatabaseProvider);
    final service = NotificationService();
    await service.requestPermissions();

    await db
        .into(db.localReminders)
        .insert(
          LocalRemindersCompanion.insert(
            hour: hour,
            minute: minute,
            enabled: const Value(true),
          ),
        );
    ref.invalidateSelf();
  }

  Future<void> toggleFixedReminder(int id, bool enabled) async {
    final db = ref.read(appDatabaseProvider);
    await (db.update(db.localReminders)..where((t) => t.id.equals(id))).write(
      LocalRemindersCompanion(enabled: Value(enabled)),
    );
    ref.invalidateSelf();
  }

  Future<void> deleteFixedReminder(int id) async {
    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.localReminders)..where((t) => t.id.equals(id))).go();
    ref.invalidateSelf();
  }

  Future<void> toggleSmartReminder(bool enabled) async {
    final db = ref.read(appDatabaseProvider);
    final service = NotificationService();
    if (enabled) {
      await service.requestPermissions();
    }
    await (db.update(db.localAppSettings)..where((t) => t.id.equals(1))).write(
      LocalAppSettingsCompanion(smartReminderEnabled: Value(enabled)),
    );
    ref.invalidateSelf();
  }
}

final remindersProvider =
    AsyncNotifierProvider<RemindersNotifier, RemindersState>(
      () => RemindersNotifier(),
    );
