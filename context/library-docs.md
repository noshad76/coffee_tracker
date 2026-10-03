# Library Docs

This file records Coffeeaholic-specific package usage. Before adding a third-party package, load a matching installed skill when one exists and review official package documentation. No Drift skill is installed in this repository, so follow the official Drift documentation and the conventions below.

## Flutter SDK

- Use Flutter's Material and Cupertino capabilities where they match the reference.
- Keep the custom Coffeeaholic theme consistent across Android and iOS while respecting native system behavior.

## Drift and SQLite

Selected for all durable application data, including preferences and future drink history. Keep one local database rather than splitting data between preferences and a database.

- `drift` owns typed tables, queries, transactions, and schema migration definitions.
- `drift_flutter` opens the native database with `driftDatabase(name: 'coffeeaholic')`.
- Run `dart run build_runner build --force-jit` to generate Drift source on the current Dart 3.10 toolchain. The default AOT path fails while compiling a build hook; the JIT path succeeds.
- Keep the generated database type behind feature repository contracts. Views never import Drift.
- Set `schemaVersion` and define a `MigrationStrategy` whenever the schema changes. A new empty database begins at version 1.
- The live schema is version 2. Its upgrade creates `drink_entries` and `feature_ideas` without replacing version 1 settings or favorites; keep the migration test when changing it.
- Store onboarding mode, caffeine target, completion state, selected theme, and favorite drink IDs in typed columns/tables.
- Store drink timestamps in UTC and query/render by local calendar-day boundaries.
- Use transactions for related writes, such as saving preferences and replacing favorite-drink rows.
- Never log full user records. Decide explicitly before enabling database export, encryption, or cloud backup.
- The Flutter project currently uses Dart 3.10.1. Package resolution must use a trusted pub registry.

Official references:

- [Drift package](https://pub.dev/packages/drift)
- [Drift Flutter setup](https://pub.dev/packages/drift_flutter)
- [Drift migrations](https://drift.simonbinder.eu/migrations/)
- [Drift transactions](https://drift.simonbinder.eu/dart_api/transactions/)

## State management and routing

Riverpod is selected for MVVM state and dependency injection. No Riverpod-specific skill is installed, so use the official documentation below. Use `flutter_riverpod` 2.6.1 with `Notifier` or `AsyncNotifier` and explicit providers. Keep ViewModels under feature `controllers/` folders and providers under feature `providers/` folders; put shared resource providers in `core` or `app`. Views should use `ConsumerWidget`/`ConsumerStatefulWidget`, watch immutable state, and call ViewModel methods with `ref.read`. Do not access Drift from views.

Riverpod 3.x does not currently resolve with this project's Dart 3.10, Flutter test SDK, and Drift generator constraints. Use the tested 2.6.1 line until those constraints change. Riverpod provider code generation is not required for this setup.

Official references:

- [Riverpod Flutter package 2.6.1](https://pub.dev/packages/flutter_riverpod/versions/2.6.1)
- [Riverpod (Async)NotifierProvider](https://docs-v2.riverpod.dev/docs/providers/notifier_provider)

No third-party router package is selected. Add one only when actual navigation requirements exceed the native onboarding and tab shell.

## Icons and imagery

The HTML uses Lucide icons from a CDN and code-drawn drink illustrations. The native app must not rely on a CDN. Use Flutter icons or local code/vector artwork after reviewing the visual fit.

`flutter_svg` renders the local drink SVG assets extracted from the supplied HTML artwork. Keep these files bundled in `assets/drinks/` and load them with `SvgPicture.asset`; do not fetch images at runtime. Package reference: [flutter_svg on pub.dev](https://pub.dev/packages/flutter_svg).

The app bundles the official Inter variable font in `assets/fonts/`, with its SIL Open Font License in the same directory. `AppTheme` applies the font; there is no runtime font download.

## Verification

Run `flutter analyze` after route, model, persistence, or state changes. Add focused tests when requested or required by the feature workflow. Do not build or preview web output for this native-only product.
