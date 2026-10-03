# Coffeeaholic Project Instructions

## Read before implementation

Read these files in this exact order before changing code or product context:

1. `context/project-overview.md`
2. `context/architecture.md`
3. `context/ui-tokens.md`
4. `context/ui-rules.md`
5. `context/ui-registry.md`
6. `context/code-standards.md`
7. `context/library-docs.md`
8. `context/build-plan.md`
9. `context/progress-tracker.md`

## Product boundary

- This repository contains the native Flutter client for Coffeeaholic on Android and iOS.
- `ui/coffeeaholic-tracker-1-5.html` is the product and visual reference.
- The reference promises local-only data, no account, and no server. Do not add authentication, remote APIs, cloud sync, backend code, or a database server unless product scope changes.
- Keep tracking data on device and do not log user records.
- Keep Feature Board ideas and votes on this device; shared community behavior requires a future scope change.

## Rules that apply to every change

- Build native Android and iOS experiences; web/PWA is not a product target.
- Use semantic tokens in `context/ui-tokens.md`; production widgets must not use raw hex colors or raw Tailwind palette classes.
- Keep each Flutter widget in its own Dart file, following `context/ui-rules.md`.
- Keep the HTML reference unchanged. Rebuild its experience in Flutter; do not port its Tailwind CSS, browser JavaScript, or CDN dependency.
- Update `context/progress-tracker.md` and `context/ui-registry.md` after each completed feature or reusable UI pattern.
- Before adding a third-party library, read its installed skill when available and the relevant section of `context/library-docs.md`.
- Use Riverpod `Notifier` or `AsyncNotifier` ViewModels in feature `controllers/` folders; keep providers in feature `providers/` folders and views as Riverpod consumers.
- Preserve local-first behavior. Decide persistence and migration behavior before introducing a storage package.
- Drift schema version 2 stores drink entries and local Feature Board ideas. Preserve version 1 preferences during upgrades.
- Use returnable navigation for flows opened from another surface; support native back and safe route restoration.

## Working workflow

- Use `/architect` before a complex feature or when a load-bearing product or data decision is missing.
- Use `/develop` when feature direction is clear.
- Use `/imprint` after building a reusable UI pattern.
- Use `/test` after building or changing a route, feature, or fix.
- Use `/review` before demo or handoff when the UI feels inconsistent.
- Use `/sync` as the final documentation reconciliation step after a completed change.
- Use `/remember save` for work spanning sessions and `/remember restore` when returning.

## UI reference workflow

1. Read the context files above in order before changing product context or UI.
2. Inspect the relevant markup and styling in `ui/coffeeaholic-tracker-1-5.html`.
3. Inspect current Flutter routes, widgets, assets, and Android/iOS configuration.
4. Rebuild the experience idiomatically in Flutter using semantic theme tokens and real local state.
5. Adapt for phone and tablet widths with constraints and safe areas; avoid device-label and orientation checks.
6. Format changed Dart files and run `flutter analyze`; run focused tests when requested or required by the feature workflow.
7. Update the UI registry and progress tracker after the change.

Do not launch a browser preview or create a release artifact for routine UI work. Run native builds only when explicitly requested or required by an agreed verification task.

## Verification

- Run `flutter analyze` after route, model, or state changes.
- Account for Android/iOS safe areas, keyboard, system back, gestures, lifecycle, text scaling, and accessibility.
- Web is out of scope unless the user changes the release targets.
