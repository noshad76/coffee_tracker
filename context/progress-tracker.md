# Progress Tracker

## Current status

**Phase:** Complete Native Flutter Client

**Last completed:**
- Native Home Screen Widgets (Metabolism Overview & Quick Log):
  - Fixed SharedPreferences `ClassCastException` (`Long` to `Integer`) by introducing safe type conversion extension `SharedPreferences.getSafeInt()`, preventing crash on widget receiver startup.
  - Quick Log Confirmation Notification: When logging a drink via widget 1-tap, posts a high-priority system notification ("☕ [Drink] Logged • +[mg] caffeine • Today: [total] mg") in addition to system toast, with a tap action that opens the app's Today screen.
  - Always Connected to App Theme: Widgets dynamically adapt to all 8 theme presets (Coffee, Ocean, Forest, Amber × Dark & Light). Theme presets and semantic tokens (`theme_preset`, `theme_text_primary`, `theme_text_muted`, `theme_brand_accent`) are saved to widget storage and trigger live updates immediately when the user changes theme.
  - Sizing & Responsive Expansion:
    - Resizable horizontally & vertically (`minHeight="50dp"`, `minResizeHeight="40dp"`).
    - Weight-based Button Expansion: Eliminated dead space in large sizes by using `layout_weight="1"` container rows and `match_parent` drink item heights, allowing Quick Log buttons to scale and fill any launcher card height.
    - Large Metabolism Layout: Restored the full multi-metric dashboard (`In 6h`, `Today / Limit`, `Clears in`, and timestamp) side-by-side with active caffeine whenever `minWidth >= 180dp`, eliminating the empty black void on large/wide sizes.
    - Compact Mode Protection: Shows less in compact sizes without breaking. In 1-cell heights (< 100dp), Row 2 is hidden; in narrow widths (< 220dp), subtitle and Custom button are hidden; in ultra-narrow widths (< 180dp), 3rd column is hidden; in very short heights (< 65dp), status pills are tucked away cleanly.
  - Headless 1-Tap Quick Logging: 1-tap broadcasts log drinks silently directly into Drift's SQLite database without opening the app, posting a single heads-up confirmation notification, and queuing pending logs in widget storage.
  - Lifecycle Sync & Preference Integrity:
    - Fixed SharedPreferences namespace collision by standardizing on `HomeWidgetPreferences` across all native providers and Flutter.
    - Guarded `TrackingController._syncWidgets` against null preferences during startup/resume, eliminating accidental theme resets to 'coffee' or data wipes.
    - Added `_processPendingWidgetLogs` in `MainShell` to ingest queued widget logs into Drift reliably on resume without race conditions.
  - Full test suite passing (20/20 tests, 0 analyze warnings).

**Next:** Continuous maintenance and future feature iterations based on local offline coffee journeys.

## Product setup

- [x] Identify supplied product reference: `ui/coffeeaholic-tracker-1-5.html`
- [x] Extract Coffee, Ocean, Forest, and Amber palette values
- [x] Record typography, spacing, card, modal, and mobile shell patterns
- [x] Replace stale ClassNote context and root instructions
- [x] Inspect and configure Flutter Android/iOS targets and identifiers
- [x] Choose and document Drift with SQLite for local persistence
- [x] Resolve trusted pub registry access and generate the initial database
- [x] Define semantic palette, spacing, shape, and touch-target tokens in Flutter
- [x] Apply ThemeData at the app root using the persisted theme preset
- [x] Adopt Riverpod 2.6.1 for MVVM state management and dependency injection

## Features

- [x] Onboarding welcome
- [x] Goal mode selection (tracking / cutting back / quitting)
- [x] Daily caffeine threshold setup
- [x] Favorite drink setup
- [x] Local preference persistence
- [x] Refine onboarding layout, cards, and copy against the HTML reference
- [x] Separate onboarding widgets into individual Dart files
- [x] Today summary and daily progress
- [x] Quick drink logging
- [x] Full drink logging for drink, amount, time, temperature, location, and note
- [x] Drink history editing and confirmed deletion
- [x] Calendar history
- [x] Statistics and accessible charts from local records
- [x] Badge/achievement rules and display with interactive inspection modal
- [x] Theme and mode settings
- [x] Feature board scope decision: ideas and votes are local to this device
- [x] Native visual comparison on Android and iOS against the supplied HTML
- [x] Brew Scrapbook & coffee photo capture with full-screen photo detail inspection
- [x] Dedicated Trophy Room with 50 achievement milestones, categories, and Barista rank levels
- [x] Metabolism decay curve & 6-hour half-life bedtime sleep cutoff forecast
- [x] Floating AppToast feedback pills replacing default SnackBars
- [x] Quick Log shortcut customization & custom drink builder dialog
- [x] Settings & Reminders hub (`SettingsSheet`)
- [x] Custom notification reminders with median coffee time calculation and daily 9:00 PM check-in
- [x] Proactive notification permission requests in onboarding and settings
- [x] Dynamic custom location management and modern `AppDropdown` selector in full drink log
- [x] Light Mode theme engine and redesigned color palettes across Coffee, Ocean, Forest, and Amber
- [x] Refined modal sheet styling eliminating pitch-black overlays
- [x] Native Home Screen Widgets for Metabolism Overview (5-min decay & manual refresh) and Quick Log shortcuts (1-tap logging via deep-link)

## Known product decisions to resolve during implementation

1. Decide whether the app needs a user-facing local-data reset or export flow.
2. Which drink catalog and caffeine estimates are reviewed and editable.
3. Exact caffeine decay and sleep cutoff formula, if retained.
4. Whether the local Feature Board should seed suggested ideas. It currently starts empty and stores only user-created ideas and local votes.
5. Whether temperature/location controls are required and what permissions they need.
6. Android package/application ID, iOS bundle ID, app icon, and launch screen.

## Durable decisions

1. Product is Coffeeaholic, not ClassNote.
2. Native Android and iOS are the only release targets.
3. Drift with SQLite is the selected local persistence layer.
4. English is the reference language; no Persian-first requirement.
5. Dark-first interface with Coffee, Ocean, Forest, and Amber themes.
6. Local-only user data, no account, no server, and no sync.
7. Rebuild the HTML in Flutter; do not port its Tailwind CSS or browser JavaScript.
8. Product domain handles caffeine amounts in explicit units and local dates carefully.
9. Use Riverpod `AsyncNotifier` ViewModels and providers for app state and dependency injection.
10. The Feature Board stores suggestions and votes only on this device, as confirmed by the user.
11. Drink history and local Feature Board ideas use Drift schema version 3 (with `photoPath` column) with automatic backwards migrations from versions 1 and 2.

## Previous project context explicitly retired

ClassNote classroom features, Express API contracts, phone/password authentication, PWA targets, Vazirmatn, Persian-first RTL rules, and the old database schema are unrelated to this repository's supplied Coffeeaholic design and must not guide new work.




