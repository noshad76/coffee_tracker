# UI Tokens

Production widgets use named semantic theme tokens. Raw color literals belong in the centralized theme implementation only. Values below are transcribed from the theme variables and visible Tailwind scales in `ui/coffeeaholic-tracker-1-5.html`.

## Theme palettes (Dark Mode)

Each dark theme provides the listed brand steps plus `background`, `surface`, `surfaceRaised`, and neutral `stone700` through `stone900`.

| Token | Coffee | Ocean | Forest | Amber |
|---|---|---|---|---|
| `brand50` | `#FDF8F4` | `#F2F9FC` | `#F3FAF0` | `#FFF9EE` |
| `brand100` | `#F7ECE2` | `#E3F3F9` | `#E8F7DE` | `#FCF1D6` |
| `brand200` | `#EEDBCB` | `#C7E8F3` | `#D2EFC0` | `#FAE4B1` |
| `brand300` | `#E2C4A8` | `#A3D7E8` | `#B5E298` | `#F7D487` |
| `brand400` | `#E2C4A8` | `#A3D7E8` | `#B5E298` | `#F7D487` |
| `brand500` | `#A6663E` | `#459CB8` | `#67AA48` | `#D99426` |
| `brand600` | `#8B512E` | `#358099` | `#528C37` | `#B27519` |
| `brand700` | `#6B3C1F` | `#266175` | `#3C6A27` | `#8A570E` |
| `brand900` | `#3A1E0E` | `#112E3B` | `#1B3615` | `#452A07` |
| `background` | `#191310` | `#0E161C` | `#0E1711` | `#18130B` |
| `surface` | `#261D18` | `#16232D` | `#15251B` | `#251E12` |
| `surfaceRaised` | `#352922` | `#203342` | `#1E3526` | `#352B1A` |

## Theme palettes (Light Mode)

Each light theme provides clean, warm specialty cafe aesthetics with high contrast:

| Token | Coffee Light | Ocean Light | Forest Light | Amber Light |
|---|---|---|---|---|
| `brand50` | `#FAF3EC` | `#EFF7FB` | `#F1F9EE` | `#FDF7EB` |
| `brand100` | `#EEDECF` | `#D0E8F4` | `#D7EFCB` | `#F7E2B7` |
| `brand200` | `#D4B39A` | `#91C9DF` | `#A3D590` | `#ECC279` |
| `brand300` | `#A6663E` | `#3B92B5` | `#5EA143` | `#CF8A23` |
| `brand400` | `#A6663E` | `#3B92B5` | `#5EA143` | `#CF8A23` |
| `brand500` | `#8A5333` | `#2A7B9B` | `#488732` | `#B57418` |
| `brand600` | `#704126` | `#1E617C` | `#376A25` | `#91590F` |
| `brand700` | `#532E19` | `#14475B` | `#274D19` | `#6E4007` |
| `brand900` | `#381D0E` | `#0F2E3B` | `#193610` | `#472802` |
| `background` | `#FAF6F0` | `#F2F6F9` | `#F2F7F1` | `#FAF5ED` |
| `surface` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| `surfaceRaised` | `#F2E9DE` | `#E3EDF4` | `#E2EFE0` | `#F3E8D5` |
| `textPrimary` | `#261912` | `#12222D` | `#162515` | `#261C0E` |
| `textSecondary` | `#5C473A` | `#3E5868` | `#425A3E` | `#5F492E` |
| `textMuted` | `#8A7263` | `#678394` | `#6B8667` | `#8B7354` |
| `textSubtle` | `#AF9C8F` | `#94ABB9` | `#98AF95` | `#AF9D84` |

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



