import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../core/services/notification_service.dart';
import 'providers/reminders_provider.dart';

class RemindersSheet extends ConsumerStatefulWidget {
  const RemindersSheet({super.key});

  @override
  ConsumerState<RemindersSheet> createState() => _RemindersSheetState();
}

class _RemindersSheetState extends ConsumerState<RemindersSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final stateAsync = ref.watch(remindersProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reminders',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Add coffee reminder',
                        icon: Icon(Icons.add_rounded, color: palette.brand300),
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 9, minute: 0),
                          );
                          if (time != null) {
                            ref
                                .read(remindersProvider.notifier)
                                .addFixedReminder(time.hour, time.minute);
                          }
                        },
                      ),
                      IconButton(
                        tooltip: 'Close',
                        icon: Icon(Icons.close, color: palette.textMuted),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: stateAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(
                  child: Text(
                    'Error: $e',
                    style: TextStyle(color: palette.stateDanger),
                  ),
                ),
                data: (state) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // 1. Smart Routine Reminder
                      _buildSmartReminderTile(
                        context,
                        ref,
                        state.smartReminderEnabled,
                      ),
                      const SizedBox(height: 24),

                      // 3. User's Custom Coffee Reminders
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CUSTOM COFFEE REMINDERS',
                            style: TextStyle(
                              color: palette.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            'Remind you to drink',
                            style: TextStyle(
                              color: palette.textSubtle,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (state.fixedReminders.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: palette.surfaceRaised.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: palette.stone800),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.alarm_outlined,
                                size: 28,
                                color: palette.textSubtle,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No custom coffee alarms set.',
                                style: TextStyle(
                                  color: palette.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Tap "+" in the header to set personal reminders to drink coffee (e.g. morning brew or afternoon break).',
                                style: TextStyle(
                                  color: palette.textMuted,
                                  fontSize: 11.5,
                                  height: 1.35,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      for (final reminder in state.fixedReminders)
                        _buildFixedReminderTile(context, ref, reminder),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartReminderTile(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) {
    final palette = AppTheme.paletteOf(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: enabled
              ? palette.brand500.withValues(alpha: 0.35)
              : palette.stone800,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.brand500.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: palette.brand300,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Routine Reminder',
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Learns your usual coffee time from past logs and reminds you around that time.',
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: enabled,
            activeThumbColor: palette.brand300,
            activeTrackColor: palette.brand500.withValues(alpha: 0.4),
            onChanged: (val) {
              ref.read(remindersProvider.notifier).toggleSmartReminder(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFixedReminderTile(
    BuildContext context,
    WidgetRef ref,
    dynamic reminder,
  ) {
    final palette = AppTheme.paletteOf(context);
    final time = TimeOfDay(
      hour: reminder.hour,
      minute: reminder.minute,
    ).format(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.stone800),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: reminder.hour,
              minute: reminder.minute,
            ),
          );
          if (picked != null) {
            ref
                .read(remindersProvider.notifier)
                .updateFixedReminder(reminder.id, picked.hour, picked.minute);
          }
        },
        title: Text(
          time,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Tap to edit reminder time',
          style: TextStyle(color: palette.textMuted, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: reminder.enabled,
              activeThumbColor: palette.brand300,
              activeTrackColor: palette.brand500.withValues(alpha: 0.4),
              onChanged: (val) {
                ref
                    .read(remindersProvider.notifier)
                    .toggleFixedReminder(reminder.id, val);
              },
            ),
            IconButton(
              tooltip: 'Delete',
              icon: Icon(Icons.delete_outline, color: palette.stateDanger),
              onPressed: () {
                ref
                    .read(remindersProvider.notifier)
                    .deleteFixedReminder(reminder.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
