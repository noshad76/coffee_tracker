part of '../onboarding_screen.dart';

class _RemindersContent extends ConsumerStatefulWidget {
  const _RemindersContent({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  ConsumerState<_RemindersContent> createState() => _RemindersContentState();
}

class _RemindersContentState extends ConsumerState<_RemindersContent> {
  @override
  void initState() {
    super.initState();
    // Proactively request native notification permission as soon as user lands here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().requestPermissions();
    });
  }

  Future<void> _ensurePermission() async {
    await NotificationService().requestPermissions();
  }

  Future<void> _pickAndAddReminder() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      await _ensurePermission();
      await ref
          .read(remindersProvider.notifier)
          .addFixedReminder(picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final prefs = widget.state.preferences;
    final remindersState = ref.watch(remindersProvider).valueOrNull;
    final fixedReminders = remindersState?.fixedReminders ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepLabel(number: 5),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Never miss a brew',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Set custom coffee break alarms and smart reminders to stay on top of your daily caffeine.',
          style: TextStyle(color: palette.textMuted, fontSize: 12),
        ),
        const SizedBox(height: AppSpacing.x6),

        // Smart Reminder Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            color: palette.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: prefs.smartReminder
                  ? palette.brand500.withValues(alpha: 0.5)
                  : palette.stone800,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.brand500.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: palette.brand300,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Routine Reminder',
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Learns your habits and prompts you around your typical coffee time.',
                      style: TextStyle(color: palette.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Switch(
                value: prefs.smartReminder,
                activeThumbColor: palette.brand300,
                onChanged: widget.state.saving
                    ? null
                    : (val) async {
                        if (val) await _ensurePermission();
                        widget.controller.setSmartReminder(val);
                        ref
                            .read(remindersProvider.notifier)
                            .toggleSmartReminder(val);
                      },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x6),

        // Coffee Break Alarms Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'COFFEE BREAK REMINDERS',
                style: TextStyle(
                  color: palette.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _pickAndAddReminder,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(44, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(
                Icons.add,
                size: 16,
                color: palette.isDark ? palette.brand300 : palette.brand600,
              ),
              label: Text(
                'Add',
                style: TextStyle(
                  color: palette.isDark ? palette.brand300 : palette.brand600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (fixedReminders.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: palette.surfaceRaised.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.stone800),
            ),
            child: Column(
              children: [
                Icon(Icons.alarm_outlined, size: 28, color: palette.textSubtle),
                const SizedBox(height: 8),
                Text(
                  'No coffee alarms set yet.',
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Tap "+ Add Reminder" to set a morning brew or afternoon coffee alarm.',
                  style: TextStyle(color: palette.textMuted, fontSize: 11.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          for (final reminder in fixedReminders)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: palette.surfaceRaised,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: reminder.enabled
                        ? palette.brand500.withValues(alpha: 0.35)
                        : palette.stone800,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.alarm_rounded,
                      color: reminder.enabled
                          ? palette.brand300
                          : palette.textSubtle,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: reminder.hour,
                              minute: reminder.minute,
                            ),
                          );
                          if (picked != null) {
                            await ref
                                .read(remindersProvider.notifier)
                                .updateFixedReminder(
                                  reminder.id,
                                  picked.hour,
                                  picked.minute,
                                );
                          }
                        },
                        child: Text(
                          TimeOfDay(
                            hour: reminder.hour,
                            minute: reminder.minute,
                          ).format(context),
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Switch(
                      value: reminder.enabled,
                      activeThumbColor: palette.brand300,
                      onChanged: (val) {
                        ref
                            .read(remindersProvider.notifier)
                            .toggleFixedReminder(reminder.id, val);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: palette.stateDanger,
                        size: 20,
                      ),
                      onPressed: () {
                        ref
                            .read(remindersProvider.notifier)
                            .deleteFixedReminder(reminder.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
