import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../calendar/calendar_page.dart';
import '../drink_log/log_drink_sheet.dart';
import '../onboarding/models/onboarding_preferences.dart';
import '../onboarding/providers/onboarding_providers.dart';
import '../feature_board/feature_board_page.dart';
import '../settings/mode_sheet.dart';
import '../settings/theme_sheet.dart';
import '../statistics/statistics_page.dart';
import '../today/today_page.dart';
import '../tracking/providers/tracking_providers.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int tab = 0;

  void _openLog() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppTheme.paletteOf(context).overlay.withValues(alpha: 0),
    builder: (context) => const LogDrinkSheet(),
  );

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
    final titles = ['Today', 'Calendar', 'Stats', 'Features'];
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
                      message: 'Change theme',
                      child: InkWell(
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          builder: (_) => const ThemeSheet(),
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
                                Icons.palette_outlined,
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
                                      color: palette.brand200,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
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
                      FeatureBoardPage(snapshot: snapshot),
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
                    _tabButton(3, Icons.lightbulb_outline, 'Roadmap'),
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
    final color = tab == index ? palette.brand300 : palette.textSubtle;
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
