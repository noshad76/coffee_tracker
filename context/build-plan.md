# Build Plan

Build Coffeeaholic as a native, local-first Android and iOS app. Reconstruct the supplied HTML with Flutter; do not port the web implementation.

## Phase 0: Product foundation

1. Replace stale ClassNote context with Coffeeaholic product, platform, privacy, and design guidance.
2. Inspect the supplied HTML's screen structure, behaviors, theme variants, and visual patterns.
3. Confirm current Flutter SDK/platform targets and configure Android and iOS project identifiers when known.
4. Use Drift with SQLite and `drift_flutter` for durable local data; use typed migrations and repository boundaries. Use Riverpod for MVVM ViewModels and dependency injection.
5. Add semantic theme tokens, theme switching, safe-area-aware app shell, and localization-ready copy structure.

## Phase 1: Onboarding and preferences

1. Welcome and value proposition.
2. Select tracking, cutting-back, or quitting mode.
3. Set daily caffeine threshold with bounded accessible controls.
4. Choose up to three favorite drink shortcuts.
5. Persist onboarding completion and preferences locally.
6. Allow theme selection among Coffee, Ocean, Forest, and Amber.

## Phase 2: Drink logging and Today

1. Quick log from favorite drinks.
2. Full drink logging flow for drink, amount/serving, caffeine, and time as supported by the product design.
3. Today's intake total, limit progress, streak, and recent records.
4. Edit/remove records with confirmation where needed.
5. Handle first-use empty state, storage errors, and day boundaries.

## Phase 3: History and statistics

1. Calendar browsing by local date.
2. Intake summaries by selectable date range.
3. Trend and pattern visuals with accessible text summaries.
4. Correctly handle daylight saving changes and timezone changes.

## Phase 4: Engagement and settings

1. Earned badge presentation based on documented rules.
2. Feature board browsing, suggestion, and upvoting. Since the reference's no-server promise conflicts with a shared board, decide whether these are local-only demo items or remove/replace them before presenting them as community features.
3. Tracking mode/theme and any location/temperature controls actually needed by implemented features.
4. Permission prompts only when a shipped function truly requires them.

## Delivery readiness

1. Confirm package name, Android application ID, iOS bundle ID, icons, and launch assets.
2. Verify local persistence, migration behavior, deletion/reset, privacy, and platform lifecycle handling.
3. Review caffeine estimates and health-related language with the product owner.
4. Verify accessibility, text scaling, safe areas, native navigation, and Android/iOS behavior.
5. Add app store release configuration only when requested.

