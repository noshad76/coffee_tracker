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

### App toast notifications

Files: `lib/shared/widgets/app_toast.dart`

Floating dark toast pill overlaying the bottom screen area above the bottom navigation bar. Styled with `stone900` surface, 1px brand border, rounded 24px radius, status icon (success, warning, info, error), and subtle drop shadow. Replaces default full-width Material SnackBars across the app.

### Earned badges card

Files: `lib/features/calendar/widgets/earned_badges_card.dart`

Four-column badge showcase featuring 8 milestones: First Sip, Under Target, 7-Day Run, No-Crash, Weekend Warrior, Cold Brew, Tea Master, and Century Club. Includes an unlocked counter indicator ("X / 8 Unlocked"), full opacity for earned achievements and 0.4 opacity for locked ones. Tapping any badge opens a native modal sheet describing the milestone, its earned status, and how to earn it.

### Trophy room & achievements

Files: `lib/features/achievements/achievements_page.dart`, `lib/features/achievements/widgets/trophy_header_card.dart`, `lib/features/achievements/widgets/badge_filter_bar.dart`, `lib/features/achievements/widgets/badge_card.dart`, `lib/features/achievements/widgets/badge_detail_sheet.dart`, `lib/features/achievements/models/badge_item.dart`

100% offline dedicated 4th tab replacing the Roadmap/Features board. Features:
- `TrophyHeaderCard`: Displays current Barista Rank & Level (Level 1 Green Bean up to Level 6 Legendary Grandmaster) with custom rank icon and color, plus an animated overall trophy progress bar with percentage.
- `BadgeFilterBar`: Horizontal pill chip selector for `All (50)`, `Streaks (10)`, `Mindfulness (10)`, `Rituals (10)`, `Variety (10)`, and `Milestones (10)`.
- `BadgeCard`: Rich card displaying artwork or icon, title, category tag, unlock status badge ("EARNED" or progress like "3 / 7"), requirement summary, and progress bar for multi-step goals.
- `BadgeDetailSheet`: Modal bottom sheet with large artwork, unlocked/locked status banner, requirement breakdown, and educational barista insight tips.

### Native sheets

Files: `lib/features/drink_log/log_drink_sheet.dart`, `lib/features/settings/mode_sheet.dart`, `lib/features/settings/theme_sheet.dart`, `lib/features/feature_board/suggest_feature_sheet.dart`

Sheets use the semantic card surface with 32 pixel top corners and native back dismissal:
- `LogDrinkSheet`: 68x68 horizontal drink scroll selector, side-by-side Name & Caffeine and Volume & Price fields, Hot/Iced and Home/Cafe segmented pill toggles, Cup Style dropdown, Time picker, Photo button, and sticky full-width Log Entry action.
- `ModeSheet`: 3 selectable cards ("Just Tracking", "Cutting Back", "Quitting Completely") with color-coded badges ("400mg Limit", "200mg Goal", "0mg Goal") and radio checkmarks.
- `ThemeSheet`: Preset theme selector (Coffee, Ocean, Forest, Amber).
- `SuggestFeatureSheet`: Local device idea submission.
- `EditQuickLogSheet`: (`lib/features/today/widgets/edit_quick_log_sheet.dart`) Quick Log shortcut customization sheet. Pinned shortcuts section with delete/edit actions, 11-drink catalog browser with quick pin toggles, custom drink builder dialog with name, caffeine mg, volume ml, and SVG icon picker, and full-width Save button.

### Coffee photo capture & brew scrapbook

Files: `lib/shared/widgets/photo_detail_dialog.dart`, `lib/features/achievements/widgets/brew_gallery_card.dart`, `lib/features/drink_log/log_drink_sheet.dart`, `lib/features/today/widgets/today_drink_row.dart`

- `LogDrinkSheet`: Photo capture and picker action using `image_picker` (Camera or Gallery bottom sheet). Displays real-time 44x44 photo preview chip with dismissible `✕` overlay.
- `PhotoDetailDialog`: High-fidelity dark dialog presenting full-resolution coffee photo with rounded corners, drink name, time, caffeine badge, cafe/location tag, and user notes.
- `BrewGalleryCard`: "BREW SCRAPBOOK" carousel embedded at the top of the Trophy Room (`AchievementsPage`). Displays a horizontally scrolling gallery of photo cards with date pills, drink labels, caffeine tags, and tap-to-inspect modal. Empty state invites users to snap their first brew.
- `TodayDrinkRow`: Replaces generic vector drink artwork with the actual user-captured photo thumbnail when available, complete with a subtle camera overlay icon that triggers `PhotoDetailDialog` on tap.

### Single-row Quick Log carousel

File: `lib/features/today/today_page.dart`

Clean single horizontal scrolling row displaying user-configured quick-log shortcut cards. Each shortcut has a 56x56 icon box, drink title, and caffeine badge. Quick Log items log with a single tap accompanied by an `AppToast`. Redundant `+ Add` tile removed; full customization remains accessible via the section header's `Edit` button.

### Metabolism & sleep cutoff card

File: `lib/features/today/widgets/metabolism_card.dart`

Faithful reconstruction of the prototype's metabolism component (`ui/coffeeaholic-tracker-1-5.html:323-345`). Features:
- Moon icon and `Metabolism & Sleep Cutoff` title with active sleep status pill.
- Large active caffeine figure (`$activeMg mg active in system`) and human-readable bedtime forecast (`✓ Drops to X mg by 11 PM` or `⚠ X mg at 11 PM bedtime`).
- 72px smooth Bézier decay curve with vertical gradient fill and current-time dot.
- Dashed red sleep impact line at 50mg with `Sleep impact limit (50mg)` label.
- Four timeline labels along the x-axis: `Now`, `+3h`, `+6h (Half-life)`, and `Sleep (11 PM)`.





