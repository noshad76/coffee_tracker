# Progress Tracker

## Current status

**Phase:** Complete Native Flutter Client

**Last completed:**
- Onboarding Skip Action: Added a prominent "Skip" option on the first step (and header) allowing users to bypass onboarding immediately into the main app with sensible defaults (tracking mode, 400mg limit, 3 default favorite drinks).
- Onboarding Reminders Customization: Empowered users to add and manage fixed coffee break alarms directly during Onboarding Step 5 with time picker, enable/disable switches, and delete controls, alongside the smart routine reminder.
- Removed Check-In Card from UI: Removed the 9:00 PM check-in card from both RemindersSheet and Onboarding to keep the UI clean while quietly scheduling the evening check-in notification automatically in the background.
- Dedicated SQLite Custom Locations Architecture: Upgraded Drift database schema to version 5 with a dedicated `custom_locations` table and backward migration. Adding and deleting locations now operates directly against SQLite, eliminating bugs and ensuring 100% persistent local storage.
- Streamlined Location Selector: Refined `LogDrinkSheet` dropdown visual to match the reference (clean items without inline trash icons, and `Manage Locations...` at the bottom). Unified adding and deleting custom places inside an all-in-one "Manage Locations" dialog.
- Full test suite passed (15/15 tests, 0 analyze warnings).

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




