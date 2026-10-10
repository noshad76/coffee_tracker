import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../app/theme/app_theme.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/widget_sync_service.dart';
import '../../shared/widgets/app_toast.dart';
import '../calendar/calendar_page.dart';
import '../drink_log/log_drink_sheet.dart';
import '../onboarding/models/favorite_drink.dart';
import '../onboarding/models/onboarding_preferences.dart';
import '../onboarding/providers/onboarding_providers.dart';
import '../achievements/achievements_page.dart';
import '../settings/mode_sheet.dart';
import '../settings/settings_sheet.dart';
import '../statistics/statistics_page.dart';
import '../today/today_page.dart';
import '../tracking/models/tracking_models.dart';
import '../tracking/providers/tracking_providers.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {
  int tab = 0;
  int _lastHandledNotificationTrigger = 0;
  bool _isLogOpen = false;
  StreamSubscription<Uri?>? _widgetClickSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationService.openLogDrinkTrigger.addListener(
      _checkNotificationAction,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNotificationAction();
      _processPendingWidgetLogs();
    });
    WidgetSyncService.initialize();
    _initHomeWidget();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationService.openLogDrinkTrigger.removeListener(
      _checkNotificationAction,
    );
    _widgetClickSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _processPendingWidgetLogs();
      ref.read(trackingControllerProvider.notifier).refresh();
      _checkNotificationAction();
    }
  }

  Future<void> _processPendingWidgetLogs() async {
    try {
      final raw = await HomeWidget.getWidgetData<String>('pending_widget_logs');
      if (raw == null || raw.trim().isEmpty) return;
      await HomeWidget.saveWidgetData<String>('pending_widget_logs', '');

      final entries = raw.split(';');
      for (final entry in entries) {
        if (entry.trim().isEmpty) continue;
        final parts = entry.split('|');
        if (parts.length >= 6) {
          final name = parts[1];
          final caffeine = int.tryParse(parts[2]) ?? 80;
          final volume = int.tryParse(parts[3]) ?? 250;
          final artwork = parts[4];
          final timeMs =
              int.tryParse(parts[5]) ?? DateTime.now().millisecondsSinceEpoch;
          final time = DateTime.fromMillisecondsSinceEpoch(timeMs, isUtc: true);

          final trackingRepo = ref.read(trackingRepositoryProvider);
          final currentSnapshot = await trackingRepo.load();
          final alreadyExists = currentSnapshot.drinks.any(
            (d) =>
                d.name == name &&
                (d.consumedAtUtc.difference(time).inSeconds.abs() <= 5),
          );

          if (!alreadyExists) {
            await ref.read(trackingControllerProvider.notifier).addDrink(
              DrinkDraft(
                name: name,
                caffeineMg: caffeine,
                volumeMl: volume,
                consumedAtUtc: time,
                priceCents: 0,
                temperature: 'Hot',
                location: 'home',
                cupStyle: 'artwork:$artwork',
              ),
            );
          }
        }
      }
      await ref.read(trackingControllerProvider.notifier).refresh();
    } catch (_) {}
  }

  Future<void> _initHomeWidget() async {
    try {
      final initialUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (initialUri != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleWidgetUri(initialUri);
        });
      }
    } catch (_) {}

    _widgetClickSubscription = HomeWidget.widgetClicked.listen((uri) {
      if (uri != null) {
        _handleWidgetUri(uri);
      }
    });
  }

  Future<void> _handleWidgetUri(Uri uri) async {
    if (!mounted) return;
    final action = uri.host.isNotEmpty ? uri.host : uri.path;

    if (action == 'quicklog') {
      final drinkId = uri.queryParameters['id'];
      if (drinkId != null) {
        final drink = FavoriteDrink.findById(drinkId);
        if (drink != null) {
          try {
            await ref.read(trackingControllerProvider.notifier).addDrink(
              DrinkDraft(
                name: drink.name,
                caffeineMg: drink.caffeineMg,
                volumeMl: drink.volumeMl,
                consumedAtUtc: DateTime.now().toUtc(),
                priceCents: 0,
                temperature: 'Hot',
                location: 'home',
                cupStyle: 'artwork:${drink.artworkId}',
              ),
            );
            if (mounted) {
              AppToast.show(
                context,
                '${drink.name} logged',
                icon: Icons.local_cafe,
              );
            }
          } catch (_) {
            if (mounted) {
              AppToast.show(
                context,
                'Could not log drink. Try again.',
                isError: true,
              );
            }
          }
        }
      }
    } else if (action == 'log') {
      _openLog();
    } else if (action == 'metabolism' || action == 'today') {
      setState(() => tab = 0);
    }
  }

  void _checkNotificationAction() {
    if (!mounted) return;
    if (NotificationService.openLogDrinkTrigger.value >
        _lastHandledNotificationTrigger) {
      _lastHandledNotificationTrigger =
          NotificationService.openLogDrinkTrigger.value;
      _openLog();
    }
  }

  void _openLog() {
    if (_isLogOpen) return;
    _isLogOpen = true;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LogDrinkSheet(),
    ).whenComplete(() {
      if (mounted) {
        _isLogOpen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final tracking = ref.watch(trackingControllerProvider);
    final mode =
        ref
            .watch(onboardingControllerProvider)
            .valueOrNull
            ?.preferences
            .goalMode ??
        CaffeineGoalMode.tracking;
    final modeColor = switch (mode) {
      CaffeineGoalMode.tracking => palette.stateSuccess,
      CaffeineGoalMode.cuttingBack => palette.stateWarning,
      CaffeineGoalMode.quitting => palette.stateDanger,
    };
    final modeLabel = switch (mode) {
      CaffeineGoalMode.tracking => 'Tracking',
      CaffeineGoalMode.cuttingBack => 'Cutting Back',
      CaffeineGoalMode.quitting => 'Quitting',
    };
    final titles = ['Today', 'Calendar', 'Stats', 'Trophies'];
    return PopScope(
      canPop: tab == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && tab != 0) setState(() => tab = 0);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 8),
                decoration: BoxDecoration(
                  color: palette.background,
                  border: Border(bottom: BorderSide(color: palette.stone800)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COFFEEAHOLIC',
                            style: TextStyle(
                              color: palette.brand300,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            titles[tab],
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Tooltip(
                      message: 'Settings',
                      child: InkWell(
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const SettingsSheet(),
                        ),
                        borderRadius: BorderRadius.circular(24),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: palette.surfaceRaised,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: palette.brand500.withValues(alpha: .3),
                                ),
                              ),
                              child: Icon(
                                Icons.settings_outlined,
                                size: 18,
                                color: palette.brand300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Tooltip(
                      message: 'Switch mode',
                      child: InkWell(
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const ModeSheet(),
                        ),
                        borderRadius: BorderRadius.circular(24),
                        child: SizedBox(
                          height: 44,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: palette.surfaceRaised,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: palette.brand500.withValues(alpha: .3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: modeColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    modeLabel,
                                    style: TextStyle(
                                      color: palette.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 14,
                                    color: palette.textMuted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: tracking.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: TextButton(
                      onPressed: () =>
                          ref.invalidate(trackingControllerProvider),
                      child: const Text('Could not load local data. Retry'),
                    ),
                  ),
                  data: (snapshot) => IndexedStack(
                    index: tab,
                    children: [
                      TodayPage(snapshot: snapshot, onLog: _openLog),
                      CalendarPage(snapshot: snapshot),
                      StatisticsPage(snapshot: snapshot),
                      AchievementsPage(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: palette.background,
                  border: Border(top: BorderSide(color: palette.stone800)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _tabButton(0, Icons.local_cafe_outlined, 'Home'),
                    _tabButton(1, Icons.calendar_month_outlined, 'Calendar'),
                    Transform.translate(
                      offset: const Offset(0, -12),
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: palette.background,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton.filled(
                          tooltip: 'Log drink',
                          onPressed: _openLog,
                          style: IconButton.styleFrom(
                            backgroundColor: palette.brand500,
                            minimumSize: const Size(48, 48),
                          ),
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                    _tabButton(2, Icons.pie_chart_outline, 'Stats'),
                    _tabButton(3, Icons.emoji_events_outlined, 'Trophies'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(int index, IconData icon, String label) {
    final palette = AppTheme.paletteOf(context);
    final color = tab == index ? palette.brand300 : palette.textMuted;
    return InkWell(
      onTap: () => setState(() => tab = index),
      child: SizedBox(
        width: 60,
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}
