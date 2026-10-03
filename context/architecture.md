# Architecture

## System boundary

Coffeeaholic is a native Flutter client for Android and iOS. User data remains on-device; no remote service is part of the supplied product design.

```text
Flutter Android / iOS
        |
        | local persistence
        v
On-device app data
```

The client owns presentation, navigation, domain rules, local persistence, and feedback. No API layer, identity service, or server-side business logic is currently in scope.

## Application pattern

Use MVVM with a feature-first structure at the scale needed by the app:

1. Model: immutable domain entities, enums, value objects, and feature state.
2. ViewModel: Riverpod `Notifier` or `AsyncNotifier` classes that own screen state and user actions. Inject repositories through providers.
3. View: Flutter `ConsumerWidget` or `ConsumerStatefulWidget` screens that watch provider state and call ViewModel methods.
4. Data: local persistence adapters and repository implementations behind feature contracts.

Views must not access persistence directly. ViewModels must not contain widget layout. Keep calculations such as daily totals, caffeine decay estimates, and trends out of widget builds. Use `AsyncValue` for asynchronous loading and error states. Avoid unused layers and packages.

## Suggested structure

```text
lib/
  main.dart
  app/
    bootstrap/
    navigation/
    providers/
    theme/
  core/
    storage/
    errors/
    platform/
  shared/
    widgets/
    formatting/
  features/
    onboarding/
      controllers/
      providers/
      views/
      models/
      data/
    today/
    drink_log/
    calendar/
    statistics/
    achievements/
    feature_board/
    settings/
```

Create folders when production code needs them. Do not precreate empty feature layers.

## Ownership

| Area | Responsibility |
|---|---|
| `app` | App composition, theme selection, navigation, startup |
| `core` | Shared storage primitives, platform integration, common errors, app-wide providers |
| `shared` | Widgets and pure helpers reused by multiple features |
| `features/<name>` | Feature models, ViewModels in `controllers/`, feature providers in `providers/`, views (use `views/` as the feature grows), and data contracts/implementations |

Features must not reach into another feature's private persistence or controller implementation.

## State, navigation, and local data

Wrap the application in one root `ProviderScope`. Use Riverpod for application state and dependency injection. Keep feature providers near their feature and shared resource providers in `core` or `app`. Review `context/library-docs.md` before changing package versions or adding another state or routing package. Keep bottom-tab destinations stable where practical; sheets and detail flows return to their caller; native back works on both platforms.

Persist onboarding completion, theme, mode, daily threshold, favorite drinks, logged entries, and other user-created settings locally. Persist durable preferences and tracking data in one Drift database on SQLite. Define a versioned schema and migration path; recover safely from malformed or unsupported data. Do not imply cross-device sync or guaranteed recovery.

## Domain rules

- Store timestamps in a stable machine-readable representation and render in the user's locale and timezone.
- Store caffeine in milligrams and serving size with an explicit unit.
- Document daily-limit, mode, drink-estimate, and sleep-cutoff calculations before implementation.
- Handle new-user empty states and local-day/timezone boundaries explicitly.
- Inject a controllable clock into time-dependent behavior.
- Treat health-related estimates as product-reviewed content; do not create medical advice.

## Native platform behavior

Respect Android and iOS safe areas, system bars, keyboard insets, accessibility text scaling, back gestures, lifecycle, and permission prompts. Request a platform permission only when an implemented feature needs it, explain the benefit in context, and handle denial.

## Delivery slices

Build complete local-first journeys: onboarding and preferences; drink logging and Today; calendar/history; statistics; then achievements and the feature board. Keep persisted-data migrations explicit as the schema evolves.

