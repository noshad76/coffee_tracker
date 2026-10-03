# UI Registry

Living inventory of Coffeeaholic's Flutter visual patterns. The browser prototype is a design reference, not an application asset or stylesheet.

## Reference

- Source: `ui/coffeeaholic-tracker-1-5.html`
- Native targets: Android and iOS
- Composition: dark mobile interface, phone-first, bottom tabs, scrollable surfaces, rounded cards, and bottom sheets
- Theme presets: Coffee (default), Ocean, Forest, Amber

## Token source

`context/ui-tokens.md` documents colors, typography, spacing, shapes, and layout measurements extracted from the HTML. Theme implementation should centralize values in `lib/app/theme/`; production features consume semantic tokens only.

## Component entry template

For each stable built pattern, record:

1. Component and source path.
2. Features/screens using it.
3. Semantic tokens and text roles.
4. Phone and tablet behavior, including safe-area handling.
5. Loading, empty, error, disabled, and focus behavior.
6. Accessibility and native dismissal/back behavior.

## Implemented foundation patterns

### Coffeeaholic semantic theme tokens

File: `lib/app/theme/app_theme.dart`

| Property | Flutter contract |
|---|---|
| Palettes | Coffee (default), Ocean, Forest, Amber, with shared text and status colors |
| Access | `CoffeeThemeExtension` on `ThemeData`; use `AppTheme.paletteOf(context)` |
| Typography | Material text roles with reference weights and system sans-serif fallback |
| Spacing | `AppSpacing` four-point scale matching the HTML spacing values |
| Shape | `AppRadii` control, card, large-card, and sheet-top radii |
| Targets | `AppTargets.minimumInteractive` is 44 logical pixels |
| Animation | Palette extension interpolates colors when the app theme changes |

The app root reads the saved theme preset and applies its palette. Theme selection UI is not implemented yet. Feature widgets must consume the active theme palette instead of embedding raw colors.

### Onboarding wizard

Files: `lib/features/onboarding/onboarding_screen.dart`, one widget per file in `lib/features/onboarding/widgets/`, `lib/features/onboarding/controllers/onboarding_controller.dart`, `lib/features/onboarding/providers/`

| Property | Flutter pattern |
|---|---|
| Canvas | Semantic `background` from the active Coffeeaholic theme |
| Cards | `surface` with `stone800` border; benefit and choice cards use the 16 pixel `card` radius, threshold card uses the 24 pixel `largeCard` radius |
| Selected choice | `surfaceRaised` with `brand500` border and a selected/check indicator |
| Main action | Full-width `brand500` button, white theme text, 56 logical pixels high |
| Type | Theme headline roles, muted descriptions, uppercase brand step label |
| Spacing | `AppSpacing` four-point scale |
| Layout | Centered content capped at 520 logical pixels, scrollable step body, safe-area aware |
| States | Initial database loading, database load error with retry, save pending, save error, and saved summary |
| Accessibility | Native buttons, selected semantics, threshold value semantics, minimum 44 logical pixel controls |

Pattern notes: The wizard follows the reference's welcome, goal, target, and favorite-drink sequence. The welcome hero and benefit group spread vertically on a phone while the body scrolls when space is short. Quitting skips the target. Target values use 25 mg increments from 50 to 600 mg; favorite drinks cap at three. Selected favorite cards show a checkmark in the top corner. The cards use the reference's local SVG artwork at 40 pixels and grow for accessibility text scaling. Footer actions remain visible while long content scrolls. Native back and a directional swipe return to the previous applicable step. Each widget is in its own Dart part file so screen-local state can remain private.

Reusable patterns introduced: `_PrimaryButton`, `_SecondaryButton`, `_InlineError`, `_StepLabel`, `_Description`, `_ModeCard`, and `_DrinkCard` are currently private to onboarding. Promote a pattern only when another feature needs it. Their source files are under `lib/features/onboarding/widgets/`.

## Reference pattern inventory

| Pattern in HTML | Intended Flutter use |
|---|---|
| Four-step onboarding | Welcome, intent, daily threshold, favorite drinks |
| Main tab shell | Today, Calendar, Stats, Features |
| Daily summary card | Daily caffeine total, threshold progress, streak |
| Quick-log drink tile | Add favorite drink with one action |
| Full log modal | Record a drink with quantity and time details |
| Mode/theme sheets | Select goal mode and palette |
| Calendar and stats cards | History and date-range patterns |
| Feature board cards | Review, suggest, and vote on ideas |
| Badge cards | Show earned milestones |

## Main app patterns

### Main tab shell

File: `lib/features/shell/main_shell.dart`

The shell uses a semantic `background` header and bottom navigation, a centered primary log action, four returnable tabs, and safe areas. Theme and mode actions open native sheets. The tab content is scrollable and uses `CoffeeCard` from `lib/shared/widgets/coffee_card.dart` (`surface`, `stone800` border, 24 pixel radius, 16 pixel padding).

### Local drink artwork and favorite tile

Files: `lib/shared/widgets/drink_artwork.dart`, `lib/features/onboarding/widgets/drink_card.dart`, `assets/drinks/`

Drink artwork is extracted from the HTML's inline SVG definitions and bundled locally. Favorite tiles use two columns at phone widths, 112 pixel default height, 12 pixel gap, `surface` or selected `surfaceRaised`, 16 pixel radius, and a selected checkmark at the top end. The tile's semantic selected state follows the stored selection. The phone layout was visually compared at 384 by 768 logical pixels with the bundled Inter font. Do not substitute generic cup icons for these illustrations.

### Today, calendar, statistics, and local board

Files: `lib/features/today/today_page.dart`, `lib/features/calendar/calendar_page.dart`, `lib/features/statistics/statistics_page.dart`, `lib/features/feature_board/feature_board_page.dart`

Today uses a circular caffeine total, quick log favorites, a local drink list, and a first-use empty card. Calendar uses local dates and accessible day totals. Statistics computes totals from stored records and describes chart bars for assistive technology. The Feature Board stores ideas and votes only on this device and says so in its copy. These pages share `CoffeeCard` and semantic accent, neutral, and status tokens.

### Today drink row

Files: `lib/features/today/widgets/today_drink_row.dart`

Card surface row displaying drink artwork thumbnail, name, local time formatted, source (Home Brew or Cafe Name), estimated price if tracked, caffeine in mg with tabular figures, volume in ml, and an accessible popup menu for Edit and Delete actions.

### Earned badges card

Files: `lib/features/calendar/widgets/earned_badges_card.dart`

Four-column badge showcase matching the HTML reference: First Sip, Under Limit, 7-Day Run, and No-Crash. Includes full opacity for earned achievements and 0.4 opacity for locked ones. Tapping any badge opens a native modal sheet describing the milestone, its earned status, and how to earn it.

### Native sheets

Files: `lib/features/drink_log/log_drink_sheet.dart`, `lib/features/settings/mode_sheet.dart`, `lib/features/settings/theme_sheet.dart`, `lib/features/feature_board/suggest_feature_sheet.dart`

Sheets use the semantic card surface with 32 pixel top corners and native back dismissal. The drink form handles keyboard insets, drink selection, amount, temperature, location, cost, cup, time, and notes. It can create or edit an existing record; Today offers edit and confirmed delete actions. Settings selections persist before the sheet closes. The idea sheet validates title and description and saves locally.



