# Playground — Widget Architecture

> **Audience:** AI agents and developers who build, refactor, review, or extend Playground presentation widgets.
> **Purpose:** Describe the current on-disk widget architecture, public composition surfaces, folder boundaries, painter ownership, reusable atoms, and extension rules.
> **Scope:** `lib/features/playground/presentation/widgets/`.
> **Related docs:** [Folder Structure](./PLAYGROUND_FOLDER_STRUCTURE.md), [Screen Architecture](./PLAYGROUND_SCREEN_ARCHITECTURE.md), [UI Guidelines](./PLAYGROUND_UI_GUIDELINES.md), [Animation System](./PLAYGROUND_ANIMATION_SYSTEM.md), [Rendering Pipeline](./PLAYGROUND_RENDERING_PIPELINE.md).

---

## 1. Current Widget Inventory

The Playground widget library currently contains **152 Dart files**. Public APIs are grouped by responsibility; barrel files re-export implementations and are not separate runtime widgets.

### 1.1 Top-level composition

```text
presentation/widgets/
├── world_map.dart                    ⚠ placeholder — see §13
├── map_node.dart                     ⚠ placeholder — see §13
├── progress_path.dart                ProgressPath + ProgressPathVisual
├── level_card.dart                   LevelCard + LevelCardVisual
├── locked_level.dart                 LockedLevel + LockedLevelVisual
├── challenge_tile.dart               ChallengeTile + ChallengeTileVisual
├── boss_gate.dart                    BossGate + BossGateVisual
└── level_reward_dialog.dart          LevelRewardDialog + LevelRewardDialogVisual
```

The root files are cross-bucket composites or presentation entry points. They may compose atoms from `path/`, `nodes/`, `rewards/`, `animations/`, and `painters/`, but must not import `data/`, repositories, or screens. Files marked ⚠ are 1-byte placeholders awaiting implementation; they are tracked in §13.

### 1.2 Map-stage composition

```text
PlaygroundMap
├── PlaygroundBackground
│   └── BackgroundPainter
├── PlaygroundScrollView
│   └── PlaygroundCamera
├── path layer
│   ├── AnimatedPath
│   │   ├── PathShadowPainter
│   │   ├── PathPainter
│   │   ├── PathGlowPainter
│   │   └── AnimatedPathPainter
│   ├── CompletedPath
│   │   ├── PathShadowPainter
│   │   └── CompletedPathPainter
│   └── PathSegment
│       ├── PathShadowPainter
│       ├── PathDashPainter
│       ├── PathGlowPainter
│       └── PathPainter
├── PlaygroundMapBuilding × N
│   └── PlaygroundBuilding
│       ├── AcademyBuilding
│       ├── LibraryBuilding
│       ├── BuildingLabel
│       └── BuildingProgress
├── PlaygroundMapDecoration × N
│   ├── Tree
│   ├── Bush
│   ├── Cloud
│   ├── Mountain
│   ├── River
│   ├── Bridge
│   ├── Flag
│   └── PlaygroundParticleLayer
│       └── ParticlePainter
├── PlaygroundMapNode × N
│   └── PlaygroundNode
│       ├── NodeRing
│       ├── NodeIcon
│       ├── NodeBadge
│       ├── NodeLabel
│       └── NodeProgressIndicator
└── PlaygroundLegend
    ├── LegendItem
    ├── LegendTile
    └── LegendSwatch
```

`PlaygroundMapNode`, `PlaygroundMapBuilding`, and `PlaygroundMapDecoration` are immutable map placement records exported by `map/playground_map.dart`; they are not independent visual widgets.

### 1.3 HUD composition

```text
PlaygroundTopBar
├── ProfileSummary
├── XpIndicator
├── StreakCard
├── CoinCounter
└── EnergyIndicator
```

Every HUD element receives an immutable visual object (`ProfileVisual`, `XpVisual`, `StreakVisual`, `CoinVisual`, `EnergyVisual`) and callbacks. The top bar owns layout only.

### 1.4 Card composition

```text
LevelProgressCard
└── LevelProgressSurface
    ├── LevelProgressHeader
    │   └── LevelProgressBadge
    ├── LevelProgressBar
    ├── LevelProgressStages
    │   └── LevelProgressStageDot × N
    ├── LevelProgressStars
    └── LevelProgressRewardPill

MissionCard
└── MissionCardContainer
    └── MissionCardBody
        ├── MissionCardHeader
        │   ├── MissionIcon
        │   ├── MissionStatusChip
        │   └── MissionBadge
        ├── MissionProgress
        ├── MissionMetadata
        ├── MissionCardFooter
        │   └── MissionRewardPill
        └── MissionActionButton
```

`cards/level_progress_card.dart` and `cards/mission_card.dart` are barrel files. The concrete public widgets are implemented in their matching subfolders.

### 1.5 Reward composition

```text
RewardPopup
├── RewardPopupEntrance
├── RewardPopupContainer
└── RewardPopupBody
    ├── RewardPopupHeader
    ├── RewardChest
    │   └── RewardChestLayout
    │       ├── RewardChestGlow
    │       ├── RewardChestLightBeam
    │       ├── RewardChestLockBadge / RewardChestLockedOverlay
    │       ├── RewardChestSparkles
    │       └── RewardChestPainter
    ├── RewardPopupRewardList
    │   └── RewardPopupRewardTile × N
    │       └── RewardPopupBadgeReward when applicable
    └── RewardPopupActions
        ├── RewardPopupPrimaryButton
        └── RewardPopupSecondaryButton

XpReward
└── XpOrbPainter

CoinReward
├── CoinFloatAnimation
└── CoinRewardLayoutView
    ├── CoinRewardGlow
    ├── CoinRewardSurface
    │   └── CoinRewardAnimatedLayer
    ├── CoinRewardSparkles
    └── CoinRewardLabel
```

`rewards/coin_reward.dart`, `rewards/reward_chest.dart`, and `rewards/reward_popup.dart` are public barrels. Consumers should import those facades instead of subfolder internals unless they are extending the reward subsystem itself.

### 1.6 Bottom-sheet composition

```text
BossBottomSheet
LibraryBottomSheet
MissionBottomSheet
RewardBottomSheet
└── shared sheet skeleton
    ├── PlaygroundSheetContainer
    │   ├── PlaygroundSheetHandle
    │   └── PlaygroundSheetFrame
    ├── PlaygroundSheetEntrance
    ├── PlaygroundSheetLayout
    └── section atoms
        ├── PlaygroundSheetHeader
        ├── PlaygroundSheetStatTile
        ├── PlaygroundSheetStatGrid
        ├── PlaygroundSheetProgress
        ├── PlaygroundSheetActionRow
        ├── PlaygroundSheetDivider
        ├── PlaygroundSheetRarityBadge
        ├── PlaygroundSheetStagger
        └── AnimatedEntrance
```

---

## 2. Composition Tiers

| Tier | Role | Current examples | Rule |
|---|---|---|---|
| Tier 1 — Route/screen | Owns navigation and provider coordination | `PlaygroundScreen`, `WorldMapScreen` outside this folder | Screens compose root widgets and never paint decorative geometry directly. |
| Tier 2 — Root composite | Spans multiple buckets | `PlaygroundMap`, `ProgressPath`, `LevelCard`, `BossGate`, `LevelRewardDialog` | Lives at widget root or in `map/`; receives immutable visual data and callbacks. |
| Tier 3 — Feature composite | Orchestrates one subsystem | `PlaygroundNode`, `PlaygroundBuilding`, `RewardPopup`, `RewardChest`, `MissionCard` | May own animation controllers but not domain side effects. |
| Tier 4 — Atomic widget | One visual or layout job | `NodeRing`, `BuildingLabel`, `MissionBadge`, `RewardPopupHeader` | Small, reusable, independently testable. |
| Tier 0 — Painter | Canvas-only rendering | `PathPainter`, `TreePainter`, `RewardChestPainter` | Stateless, provider-free, side-effect-free, strict `shouldRepaint`. |

---

## 3. Responsibilities by Folder

### 3.1 Root widgets

| Public API | File | Responsibility |
|---|---|---|
| `WorldMap` | `world_map.dart` | Compatibility facade for the current map composition surface. |
| `MapNode` | `map_node.dart` | Compatibility facade for node placement/composition. |
| `ProgressPath` / `ProgressPathVisual` | `progress_path.dart` | Animated horizontal or vertical segmented progression strip built from `PathSegment`s and state markers. |
| `LevelCard` / `LevelCardVisual` / `LevelCardReward` | `level_card.dart` | Responsive level summary card with state, progress, difficulty, duration, energy, rewards, and tags. |
| `LockedLevel` / `LockedLevelVisual` / `LockedLevelRequirementSpec` | `locked_level.dart` | Disabled grayscale level surface with explicit unlock requirements. |
| `ChallengeTile` / `ChallengeTileVisual` | `challenge_tile.dart` | Compact reusable challenge row with type, difficulty, reward, locked/completed states, and gated interaction. |
| `BossGate` / `BossGateVisual` | `boss_gate.dart` | Animated boss milestone gate with rarity theme, lock/open state, pulse, shake, and unlock transition. |
| `LevelRewardDialog` / `LevelRewardDialogVisual` | `level_reward_dialog.dart` | Responsive level-completion modal that composes chest, XP, coins, badges, unlocked items, actions, and celebration particles. |

### 3.2 `animations/`

| Public API | Responsibility |
|---|---|
| `PathAnimationDriver` | Shared path animation state/driver for reveal and path motion. |
| Private chest animation implementation | Drives reward-chest opening phases for the chest subsystem. |
| Private node glow animation implementation | Drives looping active-node glow with reduced-motion behavior. |
| Private unlock animation implementation | Drives a one-shot unlock transition. |

Only `PathAnimationDriver` is currently public. The other animation files expose private implementation details and should be consumed through their owning widgets.

### 3.3 `buildings/`

| Public API | Responsibility |
|---|---|
| `PlaygroundBuilding` / `BuildingVisual` | Shared interactive building shell and immutable presentation model. |
| `AcademyBuilding` | Academy-themed building rendered by `AcademyBuildingPainter`. |
| `LibraryBuilding` | Library-themed building rendered by `LibraryBuildingPainter`. |
| `BuildingLabel` | Responsive floating building label with placement/emphasis variants. |
| `BuildingProgress` / `BuildingProgressChip` | Progress badge/chip for building completion or level-up state. |

### 3.4 `cards/level_progress_card/`

| Public API | Source file | Responsibility |
|---|---|---|
| `LevelProgressCard` | `level_progress_card.dart` | Public compact level-progress card entry point. |
| `LevelProgressVisual` | `level_progress_visual.dart` | Immutable card input model and derived progress/state flags. |
| `LevelProgressSurface` | `level_progress_surface.dart` | Card surface, padding, border, opacity, and premium depth. |
| `LevelProgressHeader` / `LevelProgressBadge` | `level_progress_header.dart`, `level_progress_badge.dart` | Level title/status row. |
| `LevelProgressBar` | `level_progress_bar.dart` | XP progress visualization. |
| `LevelProgressStages` / `LevelProgressStageDot` | `level_progress_stages.dart`, `level_progress_stage_dot.dart` | Stage completion sequence. |
| `LevelProgressStars` | `level_progress_stars.dart` | Earned-star row. |
| `LevelProgressReward` / `LevelProgressRewardPill` | `level_progress_reward.dart`, `level_progress_reward_pill.dart` | Typed reward value and compact reward display. |
| `LevelProgressShadows`, `LevelProgressRewards`, `LevelProgressSemanticResolver`, `LevelProgressOpacity` | `level_progress_utils.dart` | Pure helpers for styling, formatting, semantics, and state opacity. |
| `LevelCardState`, `LevelCardSize`, `LevelProgressRewardKind` (enums) | `level_progress_enums.dart` | Card state, sizing variant, and reward-kind taxonomy. |

### 3.5 `cards/mission_card/`

| Public API | Source file | Responsibility |
|---|---|---|
| `MissionCard` / `MissionVisual` | `mission_card.dart`, `mission_card_visual.dart` | Public mission card and immutable visual model. |
| `MissionCardContainer` / `MissionCardBody` | `mission_card_container.dart`, `mission_card_body.dart` | Surface and body composition. |
| `MissionCardHeader` / `MissionCardFooter` | `mission_card_header.dart`, `mission_card_footer.dart` | Primary card regions. |
| `MissionIcon`, `MissionStatusChip`, `MissionBadge` | `mission_icon.dart`, `mission_status_chip.dart`, `mission_badge.dart` | Mission identity and status atoms. |
| `MissionProgress` / `MissionMetadata` | `mission_progress.dart`, `mission_metadata.dart` | Progress and supporting metadata. |
| `MissionCardReward` / `MissionRewardPill` | `mission_reward.dart` | Typed reward model and display. |
| `MissionActionButton` | `mission_action_button.dart` | Mission CTA with enabled/completed/locked behavior. |
| `MissionCardDefaults` | `mission_constants.dart` | Mission-specific defaults. |
| Mission utility classes | `mission_utils.dart` | Pure state copy, palette, icon, progress, border, opacity, shadow, and semantics resolution (`MissionProgressFormatter`, `MissionSemanticResolver`, `MissionStateCopy`, `MissionStatePalette`, `MissionTagCopy`, `MissionTagPalette`, `MissionStateIcons`, `MissionRewardPalette`, `MissionProgressPalette`, `MissionIconPalette`, `MissionShadowResolver`, `MissionOpacityResolver`, `MissionBorderResolver`). |
| `MissionCardState`, `MissionCardSize`, `MissionCardRewardKind`, `MissionCardTag` (enums) | `mission_card_enums.dart` | Card state, sizing variant, reward-kind, and tag taxonomy. |

### 3.6 `decorations/`

| Public API | Painter/dependency | Responsibility |
|---|---|---|
| `Tree` | `TreePainter` | Themeable tree scenery with kind and ambient motion. |
| `Bush` | `BushPainter` | Bush scenery with kind/state tinting. |
| `Cloud` | `CloudPainter` | Animated cloud scenery. |
| `Mountain` | `MountainPainter` | Parallax mountain layer. |
| `River` | `RiverPainter` | Flowing river strip with curve variants. |
| `Bridge` | `BridgePainter` | Bridge scenery with style variants. |
| `Flag` | `FlagPainter` | Completion/landmark flag with color variants. |
| `PlaygroundParticleLayer` | `ParticlePainter` | Ambient-particle orchestration. |
| private particle internals | `ParticlePainter` | Individual particle state and rendering details. |

### 3.7 `map/`

| Public API | Responsibility |
|---|---|
| `PlaygroundMap` | Top-level map stage that positions background, path, buildings, decorations, nodes, and legend. |
| `PlaygroundBackground` | Background layer delegated to `BackgroundPainter`. |
| `PlaygroundScrollView` | Pannable/zoomable viewport wrapper. |
| `PlaygroundCamera` | Animated transform/camera framing wrapper. |
| `PlaygroundLegend` | Expandable map legend. |
| `LegendItem`, `LegendTile`, `LegendSwatch` | Legend data, row, and swatch atoms. |
| `PlaygroundMapNode`, `PlaygroundMapBuilding`, `PlaygroundMapDecoration` | Immutable placement records (position, anchor, scale, kind) consumed by `PlaygroundMap` to lay out widgets. Defined in `playground_map.dart`; not independent widgets. |

### 3.8 `nodes/`

| Public API | Responsibility |
|---|---|
| `PlaygroundNode` / `NodeVisual` | Interactive composite node assembled from ring, icon, badge, label, and progress. |
| `NodeRing` | State-aware circular bezel/ring rendered by `NodeRingPainter`. |
| `NodeIcon` | Central typed icon with visual variants. |
| `NodeBadge` | Small node-status badge. |
| `NodeLabel` | Floating responsive title/subtitle label. |
| `NodeProgressIndicator` | Semantic mini progress arc rendered by `NodeProgressArcPainter`. |

### 3.9 `overlays/`

| Public API | Responsibility |
|---|---|
| `PlaygroundTopBar` | Responsive HUD layout. |
| `ProfileSummary` / `ProfileVisual` | Avatar/name/profile action. |
| `XpIndicator` / `XpVisual` | XP amount, level, and progress. |
| `StreakCard` / `StreakVisual` | Streak count and at-risk state; flame rendering uses `StreakFlamePainter`. |
| `CoinCounter` / `CoinVisual` | Coin balance and gain animation. |
| `EnergyIndicator` / `EnergyVisual` | Heart/energy state and low-energy signaling. |

### 3.10 `path/`

| Public API | Responsibility |
|---|---|
| `AnimatedPath` | Active path with flow, glow, shimmer, and reveal animation. |
| `CompletedPath` | Completed path segment with optional shadow. |
| `PathSegment` | Single locked/active/completed segment with straight, curved, or Bézier geometry. |

### 3.11 `rewards/coin_reward/`

| Public API | Responsibility |
|---|---|
| `CoinReward` | Public coin reward entry point. |
| `CoinFloatAnimation` | Coin rise/float transition. |
| `CoinRewardLayoutView` | Composes coin visual, label, glow, and sparkles. |
| `CoinRewardGlow` | Reward halo. |
| `CoinRewardSurface` / `CoinRewardAnimatedLayer` | Coin face and animated visual layer. |
| `CoinRewardSparkles` | Sparkle field. |
| `CoinRewardLabel` | Amount/description typography. |
| `CoinSparkleSpec` and utility classes | Immutable sparkle data plus sizing, semantics, rarity, and layout helpers. |

### 3.12 `rewards/reward_chest/`

| Public API | Responsibility |
|---|---|
| `RewardChest` | Public chest entry point. |
| `RewardChestController` | Coordinates controlled opening state. |
| `RewardChestLayout` | Chest composition and phase layout. |
| `RewardChestGlow` | Chest halo. |
| `RewardChestLightBeam` | Open-state light beam. |
| `RewardChestLockBadge` / `RewardChestLockedOverlay` | Locked-state visuals. |
| `RewardChestSparkle`, `RewardChestSparkles`, `RewardChestSingleSparkle` | Chest sparkle atoms/orchestration. |
| reward chest model/utility classes | State, size, rarity colors, phase, sizing, semantics, and sparkle field helpers. |

### 3.13 `rewards/reward_popup/`

| Public API | Source file | Responsibility |
|---|---|---|
| `RewardPopup` | `reward_popup.dart` | Public reward-popup orchestrator. |
| `RewardPopupDialog` | `reward_popup_dialog.dart` | Dialog presentation helper. |
| `RewardPopupEntrance` | `reward_popup_animation.dart` | Popup entrance transition. |
| `RewardPopupContainer` | `reward_popup_container.dart` | Responsive themed popup frame. |
| `RewardPopupBody` | `reward_popup_body.dart` | Header, chest/reward list, and action composition. |
| `RewardPopupHeader` | `reward_popup_header.dart` | Title/subtitle/rarity header. |
| `RewardPopupRewardList` / `RewardPopupRewardTile` | `reward_popup_reward_list.dart`, `reward_popup_reward_tile.dart` | Reward collection and per-entry row. |
| `RewardPopupBadgeReward` | `reward_popup_badge_reward.dart` | Badge-specific reward visualization. |
| `RewardPopupActions`, `RewardPopupPrimaryButton`, `RewardPopupSecondaryButton` | `reward_popup_actions.dart`, `reward_popup_primary_button.dart`, `reward_popup_secondary_button.dart` | Popup CTAs. |
| `RewardEntry` / `RewardEntryKind` | `reward_entry.dart`, `reward_entry_kind.dart` | Typed reward input. |
| `RewardPopupRarityStyles` / `RewardPopupSizing` | `reward_popup_constants.dart` | Rarity and responsive sizing helpers. |

### 3.14 `rewards/xp_reward.dart`

| Public API | Responsibility |
|---|---|
| `XpReward` | XP orb/counter presentation with compact, standard, and large layouts. |
| `XpRewardSize` / `XpRewardLayout` | Public XP reward sizing/layout contracts. |

### 3.15 `sheets/`

| Public API | Responsibility |
|---|---|
| `BossBottomSheet` / `BossSheetVisual` | Boss briefing, requirements, difficulty, and action result. |
| `LibraryBottomSheet` / `LibrarySheetVisual` | Library progress, unlocked content, and quick actions. |
| `MissionBottomSheet` / `MissionSheetVisual` | Mission list, aggregate rewards, progress, and tracking action. |
| `RewardBottomSheet` / `RewardSheetVisual` | Reward summary, unlocked items, and claim/continue actions. |

Each sheet exposes a typed result enum and uses the shared sheet skeleton. Sheets receive visual models and callbacks; they do not own repositories, providers, or navigation policy beyond returning a result.

---

## 4. Painter Inventory

All painter implementations live in `widgets/painters/`. Decorative geometry belongs here, not inline in widgets.

| Painter/file | Owner / use |
|---|---|
| `AcademyBuildingPainter` | `AcademyBuilding` geometry. |
| `AnimatedPathPainter` | Active path flow/shimmer overlay. |
| `BackgroundPainter` / `BackgroundPalette` | Map sky, ground, and biome layers. |
| `BridgePainter` | Bridge geometry. |
| `BushPainter` | Bush geometry. |
| `CloudPainter` | Cloud geometry. |
| `CompletedPathPainter` | Completed path stroke. |
| `DashedPathPainter` | General dashed `Path` rendering. |
| `FlagPainter` | Flag and pole geometry. |
| `LegendSwatchPainter` | Dashed/solid legend path samples. |
| `LibraryBuildingPainter` | Library building geometry. |
| `MountainPainter` | Mountain silhouette/layer geometry. |
| `NodeGlowPainter` | Configurable node halo. |
| `NodeProgressArcPainter` | Node completion arc. |
| `NodeRingPainter` | Node bezel/ring styles and state tone. |
| `ParticlePainter` | Batched ambient particle rendering. |
| `PathDashPainter` | Locked path marching dashes. |
| `PathGlowPainter` | Active/completed path glow. |
| `PathPainter` | Base path stroke for `PlaygroundPathSpec`. |
| `PathShadowPainter` | Path shadow pass. |
| `PlaygroundPathPainter` | Multi-segment map path renderer. |
| `RewardChestGlowPainter` | Chest glow. |
| `RewardChestLightBeamPainter` | Chest opening beam. |
| `RewardChestPainter` | Chest wood/band/lock geometry. |
| `RiverPainter` | River geometry and flow bands. |
| `StreakFlamePainter` | Streak flame geometry. |
| `TreePainter` | Tree geometry. |
| `XpOrbPainter` | XP orb geometry. |
| `paint_utilities.dart` | Shared path, glow, particle specs and painter helpers; not a painter itself. |

### 4.1 Painter contract

Every painter must:

- receive all changing values via its constructor;
- read no providers, repositories, `BuildContext`, or mutable application state;
- use constants/tokens for colors, strokes, alpha, blur, and animation multipliers;
- reuse static `Paint` objects where mutation is local and safe;
- implement field-aware `shouldRepaint` rather than returning `true` unconditionally;
- be consumed inside a `RepaintBoundary` when animated independently.

---

## 5. Public Barrels and Import Policy

| Barrel | Re-exports | Primary public surface |
|---|---|---|
| `cards/level_progress_card.dart` | `level_progress_card/level_progress_card.dart`, `level_progress_card/level_progress_enums.dart`, `level_progress_card/level_progress_reward.dart`, `level_progress_card/level_progress_visual.dart` | `LevelProgressCard`, `LevelProgressVisual`, `LevelProgressReward`, `LevelCardState`, `LevelCardSize`, `LevelProgressRewardKind`. |
| `cards/mission_card.dart` | `mission_card/mission_card.dart`, `mission_card/mission_card_enums.dart`, `mission_card/mission_card_visual.dart`, `mission_card/mission_reward.dart` | `MissionCard`, `MissionVisual`, `MissionCardReward`, `MissionRewardPill`, `MissionCardState`, `MissionCardSize`, `MissionCardRewardKind`, `MissionCardTag`. |
| `rewards/coin_reward.dart` | `coin_reward/coin_reward.dart` | `CoinReward` and its size/visual model. |
| `rewards/reward_chest.dart` | `reward_chest/reward_chest.dart` | `RewardChest` and its size/visual model. |
| `rewards/reward_popup.dart` | `reward_popup/reward_entry.dart`, `reward_popup/reward_entry_kind.dart`, `reward_popup/reward_popup.dart` | `RewardPopup`, `RewardEntry`, `RewardEntryKind`. |

Use barrels from consumers outside the subsystem. Internal files may import siblings directly to avoid circular exports. `decorations/particles.dart` is also a one-line barrel that re-exports `painters/particle_painter.dart` for the decorations tree.

---

## 6. Reusable Component Contracts

| Component | Primary consumers |
|---|---|
| `PlaygroundNode` | `PlaygroundMap`/map-node placement and previews. |
| `NodeRing`, `NodeIcon`, `NodeBadge`, `NodeLabel`, `NodeProgressIndicator` | `PlaygroundNode`. |
| `PlaygroundBuilding` | `AcademyBuilding`, `LibraryBuilding`, map placement. |
| `ProgressPath` | Level progression surfaces and level summaries. |
| `LevelCard` / `LockedLevel` | Level list and progression surfaces. |
| `ChallengeTile` | Challenge lists and level briefing surfaces. |
| `BossGate` | Boss entry/briefing surfaces. |
| `LevelRewardDialog` | Post-level completion flow. |
| `ProfileSummary`, `XpIndicator`, `StreakCard`, `CoinCounter`, `EnergyIndicator` | `PlaygroundTopBar` and standalone HUD previews. |
| `RewardChest`, `XpReward`, `CoinReward` | Reward popup, reward sheet, level reward dialog. |
| `PlaygroundSheetContainer`, `PlaygroundSheetFrame`, `PlaygroundSheetEntrance`, `PlaygroundSheetLayout` | Every Playground bottom sheet. |
| shared sheet section atoms | Boss, library, mission, and reward sheets as required. |
| path painter family | `AnimatedPath`, `CompletedPath`, `PathSegment`, `PlaygroundPathPainter`. |

Public reusable widgets should accept immutable visual/value objects plus callbacks. State ownership is limited to ephemeral interaction and animation state.

---

## 7. Folder Organization

| Bucket | Inclusion rule |
|---|---|
| Root | Cross-bucket composites and entry points (`progress_path`, `level_card`, `boss_gate`, dialogs). |
| `animations/` | Reusable animation drivers/transitions whose primary responsibility is motion. |
| `buildings/` | Building composites, labels, and progress attachments. |
| `cards/` | Independent card systems with dedicated atoms/subfolders. |
| `decorations/` | World scenery and ambient particle orchestration. |
| `map/` | Stage composition, placement records, background, camera, viewport, and legend. |
| `nodes/` | Atomic and composite map nodes. |
| `overlays/` | HUD elements anchored to screen edges. |
| `painters/` | Canvas-only geometry and shared paint specs/utilities. |
| `path/` | Widget wrappers around path painters and path animations. |
| `rewards/` | Reward surfaces, controllers, animations, and typed reward inputs. |
| `sheets/` | Bottom-sheet feature surfaces plus the shared sheet skeleton. |

A widget belongs to one bucket. Cross-bucket composites live at the root. Avoid new `common/`, `helpers/`, or `misc/` folders.

---

## 8. Dependency Rules

### 8.1 Allowed graph

```text
screens/
  └── widgets/root composites
       ├── map | overlays | cards | sheets | rewards
       ├── buildings | nodes | decorations | path
       ├── animations
       └── painters

widgets/* ──▶ presentation/constants + core/constants + core/widgets
painters/* ──▶ presentation/constants + core/constants + dart:ui/material
```

### 8.2 Forbidden dependencies

| Forbidden | Reason |
|---|---|
| widgets → `data/` or datasource classes | Persistence details must not reach presentation components. |
| widgets → concrete repositories | UI components receive visual values and callbacks. |
| painters → providers/domain/data/screens | Painters are pure rendering code. |
| widgets → screens | Prevents presentation cycles and embedded navigation policy. |
| constants → widgets/providers/screens | Constants remain leaf dependencies. |
| screens → painter internals | Screens compose widgets, not canvas passes directly. |

### 8.3 Navigation and state

- Deep widgets emit callbacks or typed sheet/dialog results.
- Screens/controllers decide navigation destinations.
- Widgets do not retain `BuildContext` beyond a synchronous call.
- Animation controllers are owned and disposed by the widget that drives them.
- `MediaQuery.disableAnimations` must short-circuit nonessential movement.

---

## 9. Single-Responsibility Matrix

| Component family | Single responsibility |
|---|---|
| `PlaygroundMap` | Places all map layers and map records in the correct z-order. |
| `PlaygroundBackground` | Renders the biome background. |
| `PlaygroundScrollView` | Provides viewport pan/zoom behavior. |
| `PlaygroundCamera` | Applies animated camera transforms. |
| `PlaygroundLegend` family | Explains map symbols and states. |
| `PlaygroundNode` family | Renders and interacts with one progression node. |
| `PlaygroundBuilding` family | Renders and interacts with one world building. |
| decoration widgets | Render one category of world scenery. |
| path widgets | Render one path state/composition. |
| `ProgressPath` | Summarizes multi-level progression in one strip. |
| `LevelCard` | Summarizes an available/in-progress/completed level. |
| `LockedLevel` | Explains why a level is unavailable. |
| `ChallengeTile` | Summarizes one challenge and its reward/state. |
| `BossGate` | Communicates and animates boss access state. |
| `LevelRewardDialog` | Presents post-level rewards and completion actions. |
| `LevelProgressCard` family | Presents aggregate level progress. |
| `MissionCard` family | Presents one mission and its progress/action. |
| HUD widgets | Present one player resource/status each. |
| `RewardChest` family | Presents and animates chest state. |
| `CoinReward` family | Presents and animates a coin reward. |
| `XpReward` | Presents and animates an XP reward. |
| `RewardPopup` family | Composes a modal reward summary. |
| bottom sheets | Present one contextual briefing/summary and return a typed result. |
| shared sheet atoms | Standardize modal geometry, motion, semantics, and sections. |
| painter classes | Render one canvas geometry pass without side effects. |

If a component takes on a second independent responsibility, split its surface, body, model, utility, animation, or painter into the owning subsystem.

---

## 10. Progression Widget Contracts

### 10.1 `ProgressPath`

- Input: `ProgressPathVisual`, axis, optional tap callback and semantic label.
- Supports horizontal and vertical layouts.
- Composes `PathSegment` rather than duplicating path paint logic.
- Owns only reveal and pulse animation state.

### 10.2 `LevelCard`

- Input: `LevelCardVisual` and optional tap callback.
- Interactive only for unlocked, in-progress, premium, and boss states.
- Displays title, subtitle, difficulty, progress, duration, energy, reward preview, and tags.
- Locked-state requirements belong in `LockedLevel`, not inside `LevelCard`.

### 10.3 `LockedLevel`

- Input: `LockedLevelVisual` with typed `LockedLevelRequirementSpec` entries.
- Must expose disabled semantics even when an informational tap callback is present.
- Uses muted/grayscale styling and never starts a level directly.

### 10.4 `ChallengeTile`

- Input: `ChallengeTileVisual` and optional tap callback.
- Challenge kinds are `reading`, `quiz`, `miniBoss`, `aiTask`, and `mock`.
- Locked and completed tiles gate interaction.

### 10.5 `BossGate`

- Input: `BossGateVisual`, `BossGateState`, callbacks.
- States are `locked`, `unlocking`, and `open`.
- Rarities are `common`, `rare`, `epic`, and `legendary`.
- Owns only pulse, open, and optional shake motion.

### 10.6 `LevelRewardDialog`

- Entry point: `LevelRewardDialog.show(...)`.
- Input: `LevelRewardDialogVisual`, labels, callbacks, and optional scrim color.
- Composes existing reward widgets rather than implementing separate reward visuals.
- Celebration particles are decorative and excluded from interaction.

---

## 11. Extension Strategy

### 11.1 Add a node type

1. Extend the node kind/state contract.
2. Update node visual resolution and icon/badge mapping.
3. Add a new node atom only if the existing `PlaygroundNode` cannot express it.
4. Update map legend and previews.
5. Add painter support only for genuinely new geometry.

### 11.2 Add a building

1. Create `widgets/buildings/<name>_building.dart`.
2. Create `widgets/painters/<name>_building_painter.dart` for decorative geometry.
3. Reuse `PlaygroundBuilding`, `BuildingLabel`, and `BuildingProgress`.
4. Add a contextual sheet only if the existing library/boss/mission surfaces do not fit.

### 11.3 Add an overlay

1. Create one visual/value object plus one overlay widget.
2. Keep resource animation local and reduced-motion safe.
3. Add it to `PlaygroundTopBar` only when it is persistent HUD state.

### 11.4 Add a painter

1. Create `widgets/painters/<name>_painter.dart`.
2. Tokenize all color, alpha, stroke, blur, and animation multipliers.
3. Implement strict `shouldRepaint` comparisons.
4. Wrap animated consumers in `RepaintBoundary`.
5. Do not paint text, read providers, or own animation controllers.

### 11.5 Add a bottom sheet

1. Create `widgets/sheets/<name>_bottom_sheet.dart` with a visual model and typed result.
2. Reuse `PlaygroundSheetContainer`, `PlaygroundSheetFrame`, `PlaygroundSheetEntrance`, and `PlaygroundSheetLayout`.
3. Compose sections from `playground_sheet_sections.dart`.
4. Return actions to the caller; do not import screens or define navigation policy.

### 11.6 Add a reward type

1. Add a typed reward entry/kind.
2. Extend `RewardPopupRewardTile` or add one reward atom in `rewards/reward_popup/`.
3. Reuse popup container, entrance, list, and action components.
4. Add a painter only when the new reward requires custom vector geometry.

### 11.7 Avoid

- Inline `Paint`, gradient, blur, or path construction in composite widgets when a painter owns the geometry.
- New duplicated reward/dialog/card frameworks.
- Public APIs that expose private implementation types.
- Provider, repository, or datasource constructor arguments.
- Painter classes outside `widgets/painters/`.
- Screen imports from widget subfolders.

---

## 12. Maintenance Checklist

When adding, moving, or removing a Playground widget:

1. Update the inventory and relevant responsibility table in this document.
2. Update barrel exports when the subsystem has a public facade.
3. Update Widget Builder previews/selection if the component is intended for visual inspection.
4. Run `dart format` on touched Dart files.
5. Run `flutter analyze lib/features/playground`.
6. Run affected widget/golden tests.
7. Verify reduced motion, semantics, dark mode, and narrow layouts.

---

## 13. Placeholder / Empty Files (open work)

The following files exist on disk as 1-byte placeholders. They are reserved slots for future public APIs and are referenced by name elsewhere in this doc, but their public types are not yet implemented. Until each is implemented, it must not be imported by another widget or screen.

| File | Intended API | Status |
|---|---|---|
| `lib/features/playground/presentation/widgets/world_map.dart` | `WorldMap` facade | ⚠ placeholder |
| `lib/features/playground/presentation/widgets/map_node.dart` | `MapNode` facade | ⚠ placeholder |
| `lib/features/playground/presentation/widgets/animations/chest_animation.dart` | Chest open / shake animation driver | ⚠ placeholder |
| `lib/features/playground/presentation/widgets/animations/node_glow_animation.dart` | Node glow pulse driver | ⚠ placeholder |
| `lib/features/playground/presentation/widgets/animations/unlock_animation.dart` | Level unlock celebration driver | ⚠ placeholder |

> Note: the only animation file currently implemented is `animations/path_animation.dart`, which exposes `PathAnimationDriver`. The three placeholder siblings should grow to follow that pattern.

### Adoption rules for placeholder files

1. Do **not** `import` a placeholder file from another widget, screen, or test.
2. Do **not** add an `export` line in any barrel that would surface a placeholder's (non-existent) public symbols.
3. Once implemented, update §1.1, §3.1, §3.2 (or relevant table) and remove the ⚠ marker.
4. When implementing, follow the same `Driver` / `Spec` pattern used by `PathAnimationDriver` and pair it with an explicit token-only `AnimationController` lifecycle.

---

**End of document.**
