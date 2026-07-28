# Playground — UI Guidelines

> **Audience:** AI agents and developers who must produce UI that matches the Playground's design language.
> **Purpose:** Define the spacing system, sizing rules, typography, iconography, color palette, visual hierarchy, design tokens, consistency rules, and responsive guidelines. Every numeric value in this document is intended to land in `presentation/constants/playground_sizes.dart`, `playground_assets.dart`, and `playground_strings.dart`.
> **Related docs:** [Widget Architecture](./PLAYGROUND_WIDGET_ARCHITECTURE.md), [Animation System](./PLAYGROUND_ANIMATION_SYSTEM.md), [Future Expansion](./PLAYGROUND_FUTURE_EXPANSION.md).

---

## 1. Spacing System

Playground uses an **8pt grid** with 4pt sub-steps for compact UI.

### 1.1 Spacing scale

| Token            | Value  | Use                                                                                |
|------------------|--------|-----------------------------------------------------------------------------------|
| `space0`         | `0`    | Reset only.                                                                        |
| `space1`         | `2`    | Tight icon gaps inside a single component.                                          |
| `space2`         | `4`    | Inner padding of small chips and badges.                                            |
| `space3`         | `6`    | Sub-grid (rare).                                                                  |
| `space4`         | `8`    | Default inter-element gap inside cards.                                             |
| `space6`         | `12`   | Card padding, button row spacing.                                                   |
| `space8`         | `16`   | Card-to-card gap, sheet row gap.                                                    |
| `space12`        | `24`   | Section separation inside a sheet.                                                  |
| `space16`        | `32`   | Top-of-screen to HUD, sheet handle to first content.                                |
| `space20`        | `40`   | Vertical padding around the legend.                                                 |
| `space24`        | `48`   | Map content top padding (below HUD).                                                |
| `space32`        | `64`   | Hero spacing (reward dialog).                                                       |

### 1.2 Usage rules

1. **All** paddings and gaps must come from this scale.
2. Never use odd values like `7`, `13`, or `15`. If a value feels off, switch to the nearest token.
3. Use `Padding(padding: EdgeInsets.all(PlaygroundSizes.space8))` over raw numbers.
4. Sub-grid (`space3 = 6`) is reserved for icon-text baselines inside chips.

### 1.3 Edge cases

- **Bottom sheets** use `space16` between sections.
- **Reward popup** uses `space32` between hero elements (chest, +XP, +Coins).
- **Locked nodes** have `space1` extra outer ring to visually distinguish from completed nodes.

---

## 2. Sizing Rules

### 2.1 Base sizes (phone)

| Element                                | Size                       |
|----------------------------------------|----------------------------|
| `PlaygroundMap` stage (logical)        | `360 × 720` logical units  |
| `MapNode` total hit area               | `64 × 64` dp               |
| `MapNode` visible diameter             | `48 × 48` dp               |
| `NodeRing` outer stroke                | `4` dp                     |
| `PlaygroundBuilding` (academy)         | `120 × 96` dp              |
| `PlaygroundBuilding` (library)         | `96 × 96` dp               |
| `Decoration` (tree, bush, river)       | `64–120` dp                |
| `Decoration` (mountain, parallax)      | full-width × `180` dp      |
| `Decoration` (cloud)                   | `120 × 60` dp              |
| `Decoration` (bridge)                  | `160 × 28` dp              |
| `ProgressPath` stroke width            | `6` dp (completed) / `4` dp (dashed) |
| `PlaygroundTopBar` height              | `64` dp + safe-area        |
| `OverlayCard` (level progress, mission)| `320 × 96` dp              |
| `BottomSheet` height                   | min `240`, max `0.6 × screen` |
| `RewardPopup` width                    | `0.86 × screen width`      |
| `LevelRewardDialog` width              | `0.84 × screen width`      |
| `Legend` collapsed                     | `40 × 40` dp               |
| `Legend` expanded                      | `220 × 96` dp              |
| `Icon` (HUD indicators)                | `20` dp                    |
| `Icon` (buttons)                       | `24` dp                    |
| `Avatar` (profile summary)             | `36 × 36` dp               |

### 2.2 Responsive scaling

| Class    | Multiplier | Notes                                                                |
|----------|------------|----------------------------------------------------------------------|
| Phone    | `1.0`      | Base reference.                                                       |
| Tablet   | `1.15`     | Round up to nearest integer dp.                                       |
| Web/Desktop | `1.3`    | Top-bar gains rail padding; map stage adds 120dp horizontal margin.  |

Apply multipliers through a `ResponsiveLayout` block, *not* by hard-coding new sizes per breakpoint.

### 2.3 Size budgets

| Element                       | Min size | Ideal size  | Max size |
|-------------------------------|----------|-------------|----------|
| Bottom sheet content          | 240 dp   | 360 dp      | 540 dp   |
| Reward popup height           | 200 dp   | 320 dp      | 480 dp   |
| Building                      | 96 dp    | 120 dp      | 160 dp   |
| Map node                      | 48 dp    | 64 dp       | 80 dp    |
| Top bar                       | 56 dp    | 64 dp       | 80 dp    |

Sizes beyond `max` are forbidden — they break the layout grid.

---

## 3. Typography

Playground uses a custom token system on top of `Theme.of(context).textTheme`.

### 3.1 Type scale

| Token                  | Size / Line height        | Weight  | Use                                                              |
|------------------------|----------------------------|---------|------------------------------------------------------------------|
| `displayLarge`         | `32 / 40`                  | `800`   | Hero level names, reward popup headline.                          |
| `displayMedium`        | `28 / 36`                  | `800`   | Section hero text ("Library", "Boss").                            |
| `headlineMedium`       | `22 / 28`                  | `700`   | Bottom-sheet titles.                                              |
| `titleLarge`           | `18 / 24`                  | `700`   | Card titles, building labels.                                    |
| `titleMedium`          | `16 / 22`                  | `600`   | Challenge names, mission CTAs.                                   |
| `bodyLarge`            | `16 / 22`                  | `500`   | Body copy inside sheets and cards.                               |
| `bodyMedium`           | `14 / 20`                  | `500`   | Default body copy.                                                |
| `bodySmall`            | `12 / 16`                  | `500`   | Secondary copy.                                                   |
| `labelLarge`           | `14 / 18`                  | `700`   | HUD pills (XP, streak, coins).                                    |
| `labelSmall`           | `11 / 14`                  | `700`   | Tiny badges (NEW, BOSS).                                          |

### 3.2 Font family

Use **one** font family across the entire Playground. The default brand font is `Plus Jakarta Sans` (or the project's chosen brand font in `lib/core/theme/`). Bangla fallback is enabled via `fontFamilyFallback: ['Noto Sans Bengali']`.

### 3.3 Bangla rules

- All user-visible copy uses the `playground_strings.dart` keys for i18n.
- Bengali numerals are supported but Latin numerals are also rendered when set in the user profile.
- `letterSpacing` may need to be `0` for Bengali glyphs to keep the line tight.

### 3.4 Number rendering

XP, coin, and streak numbers use `tabular figures` (e.g. `fontFeatures: [FontFeature.tabularFigures()]`) so the digits don't jump during the +XP animation.

---

## 4. Iconography

### 4.1 Icon system

Playground ships its own icon set under `assets/icons/playground/`. The set is built from `package:flutter`'s `Icons` plus custom SVGs:

| Icon name             | Source         | Use                                                              |
|-----------------------|----------------|------------------------------------------------------------------|
| `node_lock`           | custom SVG     | Locked node ring.                                                |
| `node_check`          | custom SVG     | Completed node check badge.                                     |
| `node_boss_crown`     | custom SVG     | Boss gate badge.                                                 |
| `building_academy`    | custom SVG     | Academy building sprite.                                         |
| `building_library`    | custom SVG     | Library building sprite.                                         |
| `streak_flame`        | Lottie         | Animated streak flame on `streak_card.dart` and HUD chip.        |
| `xp_bolt`             | custom SVG     | XP indicator foreground.                                          |
| `coin`                | custom SVG     | Coin counter foreground.                                          |
| `heart_full`          | custom SVG     | One filled heart on `energy_indicator.dart`.                      |
| `heart_empty`         | custom SVG     | Empty heart slot.                                                |
| `legend_node`         | custom SVG     | Generic node icon for the legend.                                |
| `legend_locked`       | custom SVG     | Locked legend swatch.                                            |
| `legend_completed`    | custom SVG     | Completed legend swatch.                                          |
| `legend_active`       | custom SVG     | Active legend swatch.                                            |
| `legend_boss`         | custom SVG     | Boss legend swatch.                                              |

### 4.2 Icon size

| Context                              | Size  |
|--------------------------------------|-------|
| HUD indicators                       | 20 dp |
| Buttons                              | 24 dp |
| Buildings                            | 32–48 dp (sprite) |
| Legend                               | 16 dp |
| Bottom-sheet CTAs                    | 20 dp |

### 4.3 Icon color

Icons use `IconTheme.of(context).color` by default. Status-tinted icons (node states, hearts) set color through `NodeStatusExtension.iconColor`.

### 4.4 Icon rules

- Use the **same stroke weight** across all custom SVGs (2 dp).
- Use **rounded** line caps.
- Use the **same total canvas** (24 × 24 by default) to keep alignment.

---

## 5. Color Palette

Playground palette is a **semantic token system** in `lib/core/theme/playground_colors.dart`. The palette prioritizes calm educational blues with warm reward accents.

### 5.1 Core semantic tokens

| Token                       | Light             | Dark              | Use                                                                  |
|-----------------------------|-------------------|-------------------|-----------------------------------------------------------------------|
| `surface.primary`           | `#FAF7F2`         | `#0F1115`         | Background of map stage.                                             |
| `surface.secondary`         | `#FFFFFF`         | `#171A21`         | Cards, sheets, dialogs.                                              |
| `surface.tertiary`          | `#F1ECE2`         | `#1E232C`         | HUD pills, legend background.                                        |
| `surface.overlay`           | `rgba(0,0,0,0.4)`  | `rgba(0,0,0,0.6)` | Modal scrims.                                                        |
| `text.primary`              | `#1B1B1F`         | `#F5F5F7`         | Headings.                                                            |
| `text.secondary`            | `#49454F`         | `#C8C5D0`         | Body copy.                                                           |
| `text.disabled`             | `#7A7780`         | `#76737E`         | Disabled labels.                                                     |
| `border.subtle`             | `#E5E1D8`         | `#2A2F38`         | Card outline.                                                        |
| `border.strong`             | `#9C9690`         | `#5C6168`         | Active outline.                                                      |

### 5.2 Status tokens (NodeStatus-driven)

| Status          | Token                  | Light   | Dark    | Notes                                   |
|-----------------|------------------------|---------|---------|-----------------------------------------|
| `locked`        | `status.locked`        | `#A7A7B2`| `#5D5E66`| Dim, low contrast.                       |
| `unlocked`      | `status.unlocked`      | `#3F7CCC`| `#5BA0FF`| Cool primary blue.                       |
| `inProgress`    | `status.inProgress`    | `#F2A33A`| `#FFB85C`| Warm amber.                              |
| `completed`     | `status.completed`     | `#3FB37C`| `#5ED8A4`| Calming green.                          |
| `boss`          | `status.boss`          | `#B23A8A`| `#E66BB1`| Premium magenta.                          |

### 5.3 Accent tokens

| Token                 | Light   | Dark    | Use                                                                |
|-----------------------|---------|---------|--------------------------------------------------------------------|
| `accent.primary`      | `#3F7CCC`| `#5BA0FF`| Primary CTAs, focus rings.                                          |
| `accent.success`      | `#3FB37C`| `#5ED8A4`| Completion badges, +XP floats.                                      |
| `accent.warning`      | `#F2A33A`| `#FFB85C`| Streak-risk pulse, low-hearts pulse.                                |
| `accent.error`        | `#D24545`| `#FF6E6E`| Energy depleted, retry failure.                                     |
| `accent.premium`      | `#B23A8A`| `#E66BB1`| Boss nodes, premium content.                                       |
| `accent.xp`           | `#FFC857`| `#FFD980`| XP fills, ribbon highlights.                                        |
| `accent.coin`         | `#E6B34A`| `#F2C46A`| Coin fills.                                                        |
| `accent.streak`       | `#F26A4F`| `#FF8A6E`| Streak flame.                                                      |

### 5.4 Path tokens

| Token                    | Light                | Dark                 | Use                              |
|--------------------------|----------------------|----------------------|----------------------------------|
| `path.completed`         | `#5ED8A4`            | `#5ED8A4`            | Completed segment stroke.         |
| `path.active`            | `#5BA0FF`            | `#5BA0FF`            | Active segment stroke.            |
| `path.dashed`            | `#9C9690`            | `#5C6168`            | Dashed/uncompleted stroke.        |
| `path.glow`              | `rgba(91,160,255,0.4)` | `rgba(91,160,255,0.4)` | Path glow halo.                |

### 5.5 Building tokens

| Building     | Light   | Dark    |
|--------------|---------|---------|
| Academy      | `#3F7CCC`| `#5BA0FF`|
| Library      | `#A86B36`| `#D49261`|

### 5.6 Background sky gradient

| Stops              | Light                                             | Dark                                              |
|--------------------|---------------------------------------------------|---------------------------------------------------|
| Top                | `#CFE5FF`                                         | `#0E1424`                                          |
| Mid                | `#FAF7F2`                                         | `#1A2030`                                          |
| Bottom             | `#EFE8D7`                                         | `#0B0F18`                                          |

### 5.7 Color rules

1. Every color used in Playground must come from a token. Hard-coded hex values are prohibited outside `playground_colors.dart`.
2. Status semantics must never change. A locked node is *always* dim, never red.
3. Reward colors must pop only on the reward surface — never bleed into the HUD baseline.
4. Premium accents must include **shape** (crown / star) alongside color so color-blind users get the cue.

---

## 6. Visual Hierarchy

### 6.1 Primary, secondary, tertiary

| Tier        | Elements                                                                       |
|-------------|--------------------------------------------------------------------------------|
| Primary     | Map nodes, building sprites, current XP / streak / coins.                       |
| Secondary   | Path strokes, decor of moderate density (trees, bridges).                      |
| Tertiary    | Background, sky gradient, parallax mountains, ambient particles.                |

### 6.2 Z-order rules

1. **Locks**, badges, and labels always sit above their node — never below.
2. **HUD** always sits above the map.
3. **Sheets/dialogs** always sit above HUD. They never overlap a node *without* an explicit scrim.
4. **Particles** sit above the world but below nodes and HUD.
5. **Path glow** sits below path strokes (the glow is rendered first, then the stroke).

### 6.3 Emphasis principles

- A node's *ring* carries its primary state. Color and animation must be unambiguous.
- A node's *badge* carries secondary state (boss, NEW, completed).
- A node's *label* is optional and only shows on long-press or active focus.
- Buildings' *label* is shown at all times (because they have idle informational value).
- Decorations never have interactive emphasis. They are scenery.

### 6.4 Whitespace and breathing room

- The map must always show **at least 2 empty grid cells** between the HUD and the topmost node. No HUD should overlap a building.
- Bottom sheets have a fixed handle gap of `space8` and minimum top padding of `space16`.
- Dialogs and popups must reserve `space32` between hero elements.

---

## 7. Design Tokens

Design tokens are the **single source of truth** for sizes, colors, durations, and copies. They are consumed by `presentation/constants/playground_constants.dart`, `playground_sizes.dart`, `playground_assets.dart`, `playground_strings.dart`, and the central `lib/core/theme/playground_colors.dart`.

### 7.1 Token categories

| Category   | Constants file                            | Example                                                  |
|------------|--------------------------------------------|----------------------------------------------------------|
| Sizes      | `playground_sizes.dart`                    | `PlaygroundSizes.nodeDiameter = 64`                      |
| Colors     | `lib/core/theme/playground_colors.dart`    | `PlaygroundColors.statusCompleted`                       |
| Durations  | `playground_constants.dart`                | `PlaygroundDurations.pathReveal = Duration(milliseconds: 800)` |
| Assets     | `playground_assets.dart`                   | `PlaygroundAssets.iconNodeLock = 'assets/icons/playground/node_lock.svg'` |
| Strings    | `playground_strings.dart`                  | `PlaygroundStrings.xpLabel = 'XP'`                       |
| Curves     | `playground_constants.dart`                | `PlaygroundCurves.emphasized = Curves.easeOutCubic`      |

### 7.2 Token expansion

Add a new token by:

1. Deciding the category.
2. Adding the constant.
3. Documenting it in this file with its purpose and exact use sites.
4. Updating consumers.

### 7.3 Forbidden values

- Hard-coded `Colors.blue` or `16.0` in widget files: forbidden.
- `Duration(milliseconds: 500)` outside constants: forbidden.
- `EdgeInsets.all(16)` outside constants: forbidden.

---

## 8. Consistency Rules

### 8.1 Cross-feature consistency

- The **same** card radius (`16`), button radius (`12`), and sheet radius (`24`) used in Playground are also used in `home`, `guidebook`, and `mock_test` features (defined centrally).
- The **same** font family and weights throughout.
- The **same** focus-ring width and color.
- The **same** error icon (a triangle with `!`) shown across all features.

### 8.2 Within-Playground consistency

| Aspect                | Rule                                                                                       |
|-----------------------|---------------------------------------------------------------------------------------------|
| Corner radius         | Cards `16`, buttons `12`, sheets `24`, dialogs `28`, chips `999` (full pill).                |
| Elevation             | Cards `2`, sheets `8`, dialogs `16`, popups `12`.                                          |
| Hit areas             | Minimum `48 × 48 dp`. Always.                                                              |
| Tap feedback          | All tappables ripple via theme inkwell on light, glow on dark.                              |
| Loading affordances   | Always a calm shimmer, never a spinner with text.                                          |
| Empty affordances     | Always a friendly illustrated illustration + CTA.                                          |

### 8.3 Naming for tokens

- Use `lowerCamelCase` Dart identifier style for tokens.
- Token names should describe the *role*, not the value: `status.unlocked`, not `blue500`.
- For motion, describe the effect: `pathReveal`, not `800ms`.

---

## 9. Responsive Guidelines

### 9.1 Breakpoints (logical pixels)

| Range                | Class      | Layout                                                                   |
|----------------------|------------|--------------------------------------------------------------------------|
| `< 360`              | Compact    | HUD text shrinks one tier; map stage = full bleed.                       |
| `360 ≤ w < 600`      | Phone      | Default.                                                                 |
| `600 ≤ w < 1024`     | Tablet     | 2-column HUD or rail; legend persistent; map zoom range expanded.        |
| `1024 ≤ w < 1440`    | Desktop    | Side rail with mini-map; bottom navigation becomes left rail.            |
| `≥ 1440`             | Wide       | Up to 1280 dp map stage; everything else scales 1.3×.                    |

### 9.2 Orientation

| Orientation | Effect                                                                              |
|-------------|--------------------------------------------------------------------------------------|
| Portrait    | Default.                                                                            |
| Landscape   | HUD moves to right rail; map stage fills remaining width; sheets become centered modals. |

### 9.3 Density

| Form factor | Density    | Notes                                                              |
|-------------|------------|--------------------------------------------------------------------|
| Phone       | Compact    | Default.                                                            |
| Tablet      | Comfortable| `1.1` size multiplier.                                              |
| Web         | Comfortable+ | `1.15` size multiplier; `1.2` for typography.                    |

### 9.4 Implementation contract

- All responsive logic lives in `playground_helpers.dart` (a small `responsiveScale(BuildContext)` function).
- All breakpoints live in `playground_constants.dart`.
- All `EdgeInsets` and font sizes flow from `playground_sizes.dart` and the responsive helper.

### 9.5 What changes per breakpoint

| Element            | Phone     | Tablet               | Web                          |
|--------------------|-----------|----------------------|------------------------------|
| HUD layout         | Row       | Row                  | Rail + grid                  |
| Bottom nav         | Yes       | Yes                  | Left rail                    |
| Map stage margin   | 0         | 24 dp                | 120 dp                       |
| Legend             | Collapsed | Expanded             | Expanded                     |
| Bottom sheets      | Bottom    | Bottom or centered   | Centered modal               |
| Reward popup       | Full-width| Centered card        | Centered card, larger        |
| Camera zoom range  | 0.85–1.15 | 0.75–1.3             | 0.5–1.5                      |

### 9.6 What does *not* change per breakpoint

- Color tokens.
- Status semantics.
- Spacing scale (grid).
- Animation timings.

---

## 10. Glossary

| Term          | Meaning                                                                                  |
|---------------|------------------------------------------------------------------------------------------|
| Node          | A practice checkpoint on the world map.                                                  |
| Building      | A permanent knowledge hub on the map (academy, library).                                |
| Stage         | A sub-unit inside a node (a stage is a round of randomized questions).                  |
| Path          | The line that connects nodes.                                                            |
| HUD           | The always-visible top bar.                                                              |
| Sheet         | A bottom-anchored modal surface.                                                        |
| Dialog        | A centered modal surface.                                                                |
| Legend        | A toggleable UI explaining node states.                                                 |
| Camera        | The transform that frames a node on the map.                                              |
| Particle      | Ambient visual that adds life (cloud, pollen, firefly).                                |
| Reward popup  | The composite that plays chest + XP + coins.                                            |

---

**End of document.**