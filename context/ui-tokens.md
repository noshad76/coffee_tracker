# UI Tokens

Production widgets use named semantic theme tokens. Raw color literals belong in the centralized theme implementation only. Values below are transcribed from the theme variables and visible Tailwind scales in `ui/coffeeaholic-tracker-1-5.html`.

## Theme palettes

Each theme overrides the listed brand steps plus `background`, `surface`, `surfaceRaised`, and neutral `stone700` through `stone900`. Brand steps absent from the source must not be interpolated without a design decision.

| Token | Coffee | Ocean | Forest | Amber |
|---|---|---|---|---|
| `brand50` | `#FDF8F5` | `#F2F8FB` | `#F3F8EE` | `#FFF9ED` |
| `brand100` | `#F5EBE1` | `#E3EFF5` | `#E3EFD7` | `#FBEFD3` |
| `brand200` | `#E7D5C4` | `#C7DEEA` | `#C9DFB2` | `#F3DCA8` |
| `brand300` | `#D5BAA0` | `#9CC4D9` | `#A5C97F` | `#E8C27A` |
| `brand400` | `#D5BAA0` | `#9CC4D9` | `#A5C97F` | `#E8C27A` |
| `brand500` | `#8C5A3C` | `#4F8FAE` | `#5E8F3E` | `#C98A2B` |
| `brand600` | `#6E452D` | `#3E7391` | `#497330` | `#A06E1F` |
| `brand700` | `#5A3622` | `#2C566E` | `#355524` | `#7A5217` |
| `brand900` | `#2E180E` | `#142A38` | `#182A12` | `#3A260A` |
| `background` | `#18120F` | `#0F1519` | `#0E1510` | `#17120A` |
| `surface` | `#241B16` | `#172128` | `#16211A` | `#241C10` |
| `surfaceRaised` | `#322620` | `#20303A` | `#1F3125` | `#33281A` |

Default to the Coffee palette. Theme selection in the reference changes the full accent and dark-surface palette; keep semantic component roles stable across variants.

## Shared neutrals and feedback colors

The prototype overrides its dark neutral ramp by theme:

| Token | Coffee | Ocean | Forest | Amber |
|---|---|---|---|---|
| `stone700` | `#44403C` | `#2F4352` | `#2F4535` | `#4A412F` |
| `stone800` | `#292524` | `#1D2A33` | `#1C2A20` | `#2E281C` |
| `stone900` | `#1C1917` | `#111A20` | `#111A13` | `#1C1810` |

Use these theme-specific neutrals for outlines and low-emphasis dark layers; avoid borrowing one theme's neutral ramp for another.

Shared text and feedback tokens:

| Token | Value | Use |
|---|---|---|
| `textPrimary` | `#FFFFFF` | Main content |
| `textSecondary` | `#D6D3D1` | Supporting content |
| `textMuted` | `#A8A29E` | Secondary labels |
| `textSubtle` | `#78716C` | Low-emphasis metadata |
| `stateSuccess` | `#34D399` | Success and positive status |
| `stateSuccessStrong` | `#10B981` | Strong success indicator |
| `stateWarning` | `#FBBF24` | Warning / caffeine threshold context |
| `stateWarningStrong` | `#F59E0B` | Strong warning accents |
| `stateDanger` | `#FB7185` | Destructive or quit-mode status |
| `stateDangerStrong` | `#F43F5E` | Strong danger accent |
| `stateInfo` | `#818CF8` | Informational accent |
| `stateInfoStrong` | `#6366F1` | Strong informational accent |
| `white` | `#FFFFFF` | Text and high contrast icon on dark brand controls |
| `overlay` | `#000000` | Modal scrim base; apply opacity in the scrim component |

Keep text and icons with status color so state is not communicated by color alone. State colors stay consistent across the four accent themes.

## Typography

The HTML declares `Inter, system-ui, -apple-system, sans-serif`. The app bundles the official Inter variable TTF in `assets/fonts/` and applies it through `AppTheme`; use the platform sans-serif fallback when a glyph is unavailable. Do not assume Vazirmatn or another language font.

| Role | Source scale | Weight |
|---|---:|---:|
| Display/hero | 36–48 px | 700–900 |
| Page title | 18 px | 700 |
| Section title | 20–24 px | 700 |
| Card title | 14–16 px | 600–700 |
| Body | 14–16 px | 400–600 |
| Supporting | 12–14 px | 400–500 |
| Metadata | 9–11 px | 400–600 |
| Numeric data | 48 px for prominent values; use tabular figures where supported | 900 |

Use line-height around 1.25 for headings, 1.5 for body, and 1.625 for relaxed descriptions where needed. The reference uses uppercase and letter spacing for small eyebrow labels; preserve that sparingly.

## Spacing

The source follows a 4 px base with Tailwind spacing values. Use a named 4 px scale:

| Token | Value |
|---|---:|
| `space1` | 4 |
| `space1_5` | 6 |
| `space2` | 8 |
| `space2_5` | 10 |
| `space3` | 12 |
| `space3_5` | 14 |
| `space4` | 16 |
| `space5` | 20 |
| `space6` | 24 |
| `space8` | 32 |
| `space10` | 40 |

## Shapes, elevation, layout

- Common control radii: 6 px, 8 px, and 12 px.
- Card radii: 16 px (`rounded-2xl`) and 24 px (`rounded-3xl`).
- Modal top corners: 32 px.
- The 40 px app-window corners in the HTML are a browser preview frame at `sm` widths; do not apply that outer device frame to the native app.
- Buttons commonly use 16 px vertical padding; primary onboarding actions use full-width rounded controls.
- Cards are distinguished by dark surface steps and subtle outlines. Shadows are restrained, except for highlighted primary actions and modal elevation.
- Main reference viewport is phone-sized, approximately 430 px wide; the HTML demo frame is 840 px tall at larger browser width. These are reference proportions, not fixed Flutter dimensions.
- Maintain safe areas and a practical minimum 44 logical pixel touch target. Grow content at tablet widths with constraints and responsive grids only where the reference composition supports it.



