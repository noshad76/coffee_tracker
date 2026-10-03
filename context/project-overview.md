# Coffeeaholic Project Overview

## Product

Coffeeaholic is a personal caffeine tracker for Android and iOS. It helps a person log drinks, understand daily caffeine intake and patterns, choose a daily threshold, and track progress toward tracking, cutting back, or quitting. The supplied prototype includes onboarding, drink favorites, quick logging, manual logging, Today, calendar history, statistics, badges, theme/mode settings, and a feature board.

The app is local-first. The reference says that data stays on the phone and there is no account or server. No authentication, backend, or cloud synchronization is in scope.

## Source of truth

1. `ui/coffeeaholic-tracker-1-5.html` for product screens, interactions, copy, and visual design.
2. `context/ui-tokens.md` for extracted, named Flutter design tokens.
3. The Flutter implementation and `pubspec.yaml` for actual runtime capabilities.
4. Remaining context files for architecture, constraints, and delivery planning.

The HTML is a browser prototype, not production code. Rebuild it with Flutter; do not port Tailwind classes, inline JavaScript, or CDN assets directly.

## Release targets

- Android native app.
- iOS native app.

Web, PWA, desktop, accounts, and server sync are outside scope unless the user changes the decision.

## Language and appearance

The HTML reference is English. Keep English as the current product language; do not carry over the prior ClassNote Persian-first requirement. Keep layout direction configurable for future localization. The UI is dark-first and offers Coffee, Ocean, Forest, and Amber themes. Typography uses Inter with system sans-serif fallbacks.

The design is phone-first: a narrow app composition, bottom tab navigation, scrollable content, safe areas, rounded cards, and modal/bottom-sheet interactions. Adapt naturally to larger phones and tablets without changing into a desktop dashboard.

## Product areas shown in the reference

- Onboarding: welcome, goal/mode selection, daily caffeine threshold, favorite drinks.
- Today: daily intake summary, streak, threshold progress, quick logging, recent drinks, and sleep-safe cutoff/metabolism information.
- Calendar: history by date.
- Stats: date-range summaries and consumption patterns.
- Feature board: browse, suggest, and upvote ideas.
- Drink logging: quick-log favorites and a full log flow.
- Preferences: theme, mode, and location/temperature mode where present.
- Achievements: earned badges.

Do not add medical claims beyond reviewed product content. Keep quantities and timestamps explicit in domain data.

## Current state

The repository has a Flutter native app with semantic theme tokens, bundled Inter and local drink artwork, Riverpod MVVM state management, and a version 2 Drift database. It includes the four-step onboarding flow, Today, local drink logging and editing, Calendar, Statistics, theme and mode settings, and a device-only Feature Board. The supplied HTML is the only product UI reference. Old ClassNote descriptions and external API assumptions are stale and do not apply. Native visual verification and the unresolved product details in the progress tracker remain.
