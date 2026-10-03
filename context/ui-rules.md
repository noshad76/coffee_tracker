# UI Rules

## Visual source

`ui/coffeeaholic-tracker-1-5.html` is the sole supplied visual and interaction reference. It uses a dark-first theme, four theme palettes (Coffee, Ocean, Forest, Amber), Inter/system typography, rounded dark cards, subtle borders, warm colorful accents, bottom tab navigation, scrollable screens, and modal sheets. The HTML remains a reference; reproduce the design with Flutter widgets.

## Platform and layout

1. Ship Android and iOS native layouts. Do not build PWA navigation or desktop web layouts.
2. Design phone-first and adapt to tablets with `LayoutBuilder` constraints and comfortable content limits.
3. Respect status bar, home indicator, navigation/system gestures, safe areas, keyboard insets, and platform back behavior.
4. Use bottom tab navigation for the four main areas represented in the prototype: Today, Calendar, Stats, and Features.
5. Keep long content scrollable and persistent navigation clear of system insets.
6. Do not lock orientation or branch on hardware labels.

## Surfaces and color

1. App canvas uses semantic `background`; content uses `surface` and `surfaceRaised`.
2. Theme preference changes semantic brand colors without changing component behavior.
3. Brand accents identify primary actions, selected states, progress, and focus.
4. Use success, warning, danger, and info colors only for their meaning; pair with text or an icon.
5. Use dark neutral borders and restrained shadows to separate cards. Avoid introducing bright white page surfaces absent from the reference.
6. No raw hex or Tailwind palette classes in feature widgets.

## Components

Place each Flutter widget in its own Dart file. Screen files may compose widgets and own a single screen class, but do not collect several widget classes in one file. Keep a reusable component in a named file under the feature's `widgets/` folder or `lib/shared/widgets/`. A private widget may use a Dart `part` file when it must share screen-local state; the file still contains only that widget.

Build shared patterns when real screens need them:

- App shell with bottom tabs and safe-area handling.
- Primary/secondary buttons, icon buttons, selected choice cards, segmented filters.
- Drink card, quick-log tile, amount/progress summary, history row.
- Threshold slider/input with current value and bounds.
- Bottom sheet and full-screen modal patterns.
- Theme and tracking-mode selection.
- Loading, empty, error, success, and confirmation states.

Record stable patterns in `context/ui-registry.md` after implementation.

## Interaction

- Taps have clear selected, pressed, disabled, and pending feedback.
- Preserve form values when a local validation error occurs.
- Confirmation is required before destructive local-data actions.
- Empty states explain the next useful action, such as logging the first drink.
- Do not report an action as saved until local persistence succeeds.
- Bottom sheets and dialogs dismiss consistently with Android back and iOS gestures, while protecting unsaved form data.

## Accessibility

- Use at least 44 by 44 logical pixel interactive targets.
- Support accessibility text scaling without clipping key data or controls.
- Icon-only controls need tooltips and semantic labels.
- Keep focus order aligned with visual reading order and provide visible focus for keyboard/switch access.
- Do not communicate mode, progress, or warnings by color alone.
- Give charts and visual summaries accessible text alternatives.
- Respect reduced-motion preferences.

## Localization readiness

The reference is English and left-to-right. Do not fabricate Persian UI. Keep visible strings localizable and use directional layout primitives where supported so future localization does not require a structural rewrite.
