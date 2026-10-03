# Code Standards

## General

1. Read the project context in the order recorded in root `AGENTS.md`.
2. Build one coherent local-first user journey at a time.
3. Keep platform integration and local persistence behind clear interfaces.
4. Do not add a remote API, login, cloud sync, or backend without a product decision changing scope.
5. Never commit credentials or log personal drink history.
6. Keep user-visible copy localizable; current reference language is English.

## Dart

- Follow `flutter_lints` and keep `flutter analyze` clean.
- Format changed files with `dart format`.
- Prefer immutable data and `final` values.
- Avoid `dynamic`; validate values read from local storage before constructing domain models.
- Use exhaustive switches for enums and sealed states.
- Keep files focused; avoid abstraction for one-off trivial code.

## Boundaries

1. Views use Riverpod consumers to render provider state and report user intent.
2. ViewModels live in each feature's `controllers/` folder, own screen state, and call feature contracts.
3. Providers live in feature `providers/` folders, except shared resources in `core` or `app`.
4. Repositories map persisted data into domain models and expose expected errors.
5. Domain models do not import Flutter widgets or storage plugins.
6. Do not import private internals from another feature.
7. Keep deterministic calculations in pure domain/helper code.

## Local persistence and privacy

- Store only data needed for the user's chosen features.
- Validate stored records; handle missing, malformed, and old-version values gracefully.
- Define migrations before persisted schema changes.
- Do not place sensitive history in logs, analytics, crash reports, or unencrypted backups without an explicit privacy decision.
- Do not claim data is backed up or synchronized unless implemented and explained.

## Domain and time

- Use explicit units for caffeine (mg) and volume (ml/oz if supported).
- Keep timestamps machine-readable; render local time separately.
- Test or otherwise verify day-boundary and timezone behavior for date-based summaries.
- Inject clocks for date-dependent logic.
- Keep caffeine estimates and health-related copy aligned with reviewed product content.

## UI

- Use semantic theme values from `lib/app/theme/`.
- Put each Flutter widget in a separate Dart file; use feature `widgets/` or `shared/widgets/` for components.
- Keep raw color values in theme definitions only.
- Use directional layout values and safe-area-aware composition.
- Include meaningful empty, validation, error, disabled, and success states.
- Support accessibility semantics, minimum touch targets, and text scaling.

## Verification

- Run `flutter analyze` after route, model, persistence, or state changes.
- Add or update focused tests when requested or required by the feature workflow.
- Verify native platform behavior for Android and iOS when the toolchains are available.
- Do not run browser builds or previews as routine verification for this native app.
