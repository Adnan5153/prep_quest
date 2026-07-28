# Playground — Folder Structure

> **Audience:** AI agents and developers who must understand or extend the Playground feature without prior context.
> **Purpose:** Define the complete file/folder layout of `lib/features/playground/`, justify every grouping, and document the responsibility of each of the 93 Dart files.
> **Related docs:** [Widget Architecture](./PLAYGROUND_WIDGET_ARCHITECTURE.md), [Future Expansion](./PLAYGROUND_FUTURE_EXPANSION.md), [Screen Architecture](./PLAYGROUND_SCREEN_ARCHITECTURE.md).

---

## 1. Complete Folder Tree

The Playground feature follows a three-layer Clean Architecture (**Data → Domain → Presentation**) with the presentation layer further split by *role* rather than by feature size. Every file currently exists on disk as a stub; the file/folder layout is final.

```
lib/features/playground/
│
├── data/                                         # Transport + persistence layer
│   ├── datasources/
│   │   └── playground_remote_datasource.dart
│   ├── models/
│   │   ├── challenge_model.dart
│   │   ├── level_model.dart
│   │   ├── node_model.dart
│   │   └── world_model.dart
│   └── repositories/
│       └── playground_repository_impl.dart
│
├── domain/                                       # Pure-Dart business layer
│   ├── entities/
│   │   ├── challenge_entity.dart
│   │   ├── level_entity.dart
│   │   ├── node_entity.dart
│   │   └── world_entity.dart
│   ├── repositories/
│   │   └── playground_repository.dart
│   └── usecases/
│       ├── complete_level.dart
│       ├── get_challenges.dart
│       ├── get_level.dart
│       ├── get_world_map.dart
│       ├── start_level.dart
│       └── unlock_next_level.dart
│
└── presentation/                                 # Flutter + Riverpod UI layer
    ├── constants/
    │   ├── playground_assets.dart
    │   ├── playground_constants.dart
    │   ├── playground_sizes.dart
    │   └── playground_strings.dart
    │
    ├── extensions/
    │   ├── node_status_extension.dart
    │   └── world_extension.dart
    │
    ├── providers/
    │   └── playground_provider.dart
    │
    ├── screens/
    │   ├── boss_challenge_screen.dart
    │   ├── challenge_screen.dart
    │   ├── level_completed_screen.dart
    │   ├── level_screen.dart
    │   ├── playground_screen.dart
    │   └── world_map_screen.dart
    │
    ├── utils/
    │   ├── node_position_calculator.dart
    │   ├── path_generator.dart
    │   ├── playground_helpers.dart
    │   └── world_map_builder.dart
    │
    └── widgets/
        │  # ── root composites (cross-cutting) ──
        ├── boss_gate.dart
        ├── challenge_tile.dart
        ├── level_card.dart
        ├── level_reward_dialog.dart
        ├── locked_level.dart
        ├── map_node.dart
        ├── progress_path.dart
        ├── world_map.dart
        │
        │  # ── animations/ ──
        ├── animations/
        │   ├── chest_animation.dart
        │   ├── node_glow_animation.dart
        │   ├── path_animation.dart
        │   └── unlock_animation.dart
        │
        │  # ── buildings/ ──
        ├── buildings/
        │   ├── academy_building.dart
        │   ├── building_label.dart
        │   ├── building_progress.dart
        │   ├── library_building.dart
        │   └── playground_building.dart
        │
        │  # ── cards/ ──
        ├── cards/
        │   ├── level_progress_card.dart
        │   └── mission_card.dart
        │
        │  # ── decorations/ ──
        ├── decorations/
        │   ├── bridge.dart
        │   ├── bush.dart
        │   ├── cloud.dart
        │   ├── flag.dart
        │   ├── mountain.dart
        │   ├── particles.dart
        │   ├── playground_particle_layer.dart
        │   ├── river.dart
        │   └── tree.dart
        │
        │  # ── map/ ──
        ├── map/
        │   ├── playground_background.dart
        │   ├── playground_camera.dart
        │   ├── playground_legend.dart
        │   ├── playground_map.dart
        │   └── playground_scroll_view.dart
        │
        │  # ── nodes/ ──
        ├── nodes/
        │   ├── node_badge.dart
        │   ├── node_icon.dart
        │   ├── node_label.dart
        │   ├── node_progress_indicator.dart
        │   ├── node_ring.dart
        │   └── playground_node.dart
        │
        │  # ── overlays/ ──
        ├── overlays/
        │   ├── coin_counter.dart
        │   ├── energy_indicator.dart
        │   ├── playground_top_bar.dart
        │   ├── profile_summary.dart
        │   ├── streak_card.dart
        │   └── xp_indicator.dart
        │
        │  # ── painters/ ──
        ├── painters/
        │   ├── dashed_path_painter.dart
        │   ├── node_glow_painter.dart
        │   └── playground_path_painter.dart
        │
        │  # ── path/ ──
        ├── path/
        │   ├── animated_path.dart
        │   ├── completed_path.dart
        │   └── path_segment.dart
        │
        │  # ── rewards/ ──
        ├── rewards/
        │   ├── coin_reward.dart
        │   ├── reward_chest.dart
        │   ├── reward_popup.dart
        │   └── xp_reward.dart
        │
        │  # ── sheets/ ──
        └── sheets/
            ├── boss_bottom_sheet.dart
            ├── library_bottom_sheet.dart
            ├── mission_bottom_sheet.dart
            └── reward_bottom_sheet.dart
```

**File count:** 93 Dart files distributed across **17** presentation sub-folders, plus the canonical `data/`, `domain/`, and `presentation/` roots.

---

## 2. Why This Shape

### 2.1 Clean Architecture at the top

The top three directories mirror the standard Clean Architecture split:

| Layer        | Knows about                                  | Knows nothing about                  |
|--------------|----------------------------------------------|--------------------------------------|
| `data/`      | Transport (JSON, Firestore), domain entities | Flutter, Riverpod, widgets           |
| `domain/`    | Pure-Dart types                              | Flutter, JSON, transport             |
| `presentation/` | Widgets, Riverpod, constants, utils       | `data/` internals (only via repo iface) |

**Dependency rule:** arrows point inward. Presentation → Domain ← Data. Domain owns the contracts; Data implements them; Presentation consumes the abstractions.

### 2.2 Presentation role-buckets

A flat `widgets/` folder would quickly grow to 60+ files with no semantic clustering. We instead split `presentation/widgets/` into **role-based buckets** so files are small, ownership is obvious, and merge conflicts stay local. Each bucket represents a *kind of UI concern*:

| Bucket          | Owns                                                         |
|-----------------|--------------------------------------------------------------|
| Root composites | Multi-bucket assemblies (`world_map`, `map_node`, `progress_path`). |
| `animations/`   | Reusable transitions / tweens (chest, glow, path draw, unlock burst). |
| `buildings/`    | Storybook buildings (academy, library) and their ornaments. |
| `cards/`        | Mid-size cards that don't fit on a node or in an overlay.   |
| `decorations/`  | Static scenery (trees, clouds, rivers, bridges).             |
| `map/`          | Camera, scrolling, background, legend — the *stage* itself. |
| `nodes/`        | Atomic parts that compose one `playground_node.dart`.        |
| `overlays/`     | Always-visible HUD elements pinned to the screen edge.      |
| `painters/`     | Pure `CustomPainter` implementations.                        |
| `path/`         | Path segments and animated reveal paths.                     |
| `rewards/`      | Reward popups and floating counters.                         |
| `sheets/`       | Modal bottom sheets attached to map interactions.            |

### 2.3 Cross-cutting helpers

Three folders exist at `presentation/` because they are *not* widgets but support the whole layer:

- **`constants/`** — strings, sizes, asset paths, feature-wide enums. Zero logic.
- **`extensions/`** — Dart `extension` methods on existing types for readability.
- **`utils/`** — pure functions (path math, builders, formatters).

---

## 3. Responsibilities of Every Folder

### `data/`

Owns *how* the world is persisted and transported. Never imports `flutter/material.dart`. Talks to Firestore, parses JSON, and exposes domain-shaped values through `PlaygroundRepositoryImpl`.

| File                                              | Purpose                                                                                              |
|---------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `data/datasources/playground_remote_datasource.dart` | Direct calls to Firestore collections: `users/{uid}/world`, `levels/{id}`, `challenges/{id}`. Returns models, never entities. |
| `data/models/world_model.dart`                    | JSON ⇄ `WorldEntity`. Owns `fromFirestore` and `toEntity()`.                                         |
| `data/models/node_model.dart`                     | JSON ⇄ `NodeEntity`. Owns `NodeStatus` (de)serialization.                                            |
| `data/models/level_model.dart`                    | JSON ⇄ `LevelEntity`. Embeds challenge metadata + reward payload.                                    |
| `data/models/challenge_model.dart`                | JSON ⇄ `ChallengeEntity`. Handles `ChallengeType` enum + nullable `completedAt`.                     |
| `data/repositories/playground_repository_impl.dart` | Implements `PlaygroundRepository` by delegating to the datasource and converting models → entities. |

### `domain/`

Pure Dart, zero Flutter. The contract surface the rest of the app depends on.

| File                                              | Purpose                                                                                              |
|---------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `domain/entities/world_entity.dart`               | Whole-map aggregate (title, nodes, user level, XP, streak).                                          |
| `domain/entities/node_entity.dart`                | Single level node (id, index, title, status, XP, isBoss, position).                                  |
| `domain/entities/level_entity.dart`               | Level content (title, briefing, challenges, reward, requiresLevel).                                  |
| `domain/entities/challenge_entity.dart`           | Individual task (type, questionIds, xpReward, completedAt).                                          |
| `domain/repositories/playground_repository.dart`  | Abstract interface (`getWorldMap`, `getLevel`, `getChallenges`, `startLevel`, `completeLevel`, `unlockNextLevel`). |
| `domain/usecases/get_world_map.dart`              | One verb: "give me the world for this user."                                                          |
| `domain/usecases/get_level.dart`                  | "Give me one level by id."                                                                            |
| `domain/usecases/get_challenges.dart`             | "Give me the challenges for this level."                                                              |
| `domain/usecases/start_level.dart`                | "Persist in-progress state for this level."                                                           |
| `domain/usecases/complete_level.dart`             | "Award XP and update streaks."                                                                        |
| `domain/usecases/unlock_next_level.dart`          | "Promote the next node to unlocked."                                                                  |

### `presentation/constants/`

Static configuration. No widgets, no providers, no async. If a value is used in 3+ files, it lives here.

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `presentation/constants/playground_constants.dart` | Feature-wide enums (animation durations, default colors, route ids).                            |
| `presentation/constants/playground_sizes.dart`    | Hardcoded dimensions: node diameter, ring stroke, path stroke, padding, sheet heights, icon sizes. |
| `presentation/constants/playground_assets.dart`   | Asset path constants for images, lottie, svg, and audio.                                         |
| `presentation/constants/playground_strings.dart`  | User-visible copy keys for i18n.                                                                  |

### `presentation/extensions/`

Dart `extension` methods. They add methods to existing types without inheritance and without polluting those types.

| File                                                   | Purpose                                                                                              |
|--------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `presentation/extensions/node_status_extension.dart`    | `NodeStatus` UI affordances: `.completed`, `.locked`, `.glowColor`, `.isActionable`, `.iconFor`.   |
| `presentation/extensions/world_extension.dart`         | Helpers on `WorldEntity`: `.nextNodeFor(current)`, `.progressPercent`, `.orderedNodes`.              |

### `presentation/providers/`

Riverpod. Single home for all Playground providers.

| File                                              | Purpose                                                                                              |
|---------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `presentation/providers/playground_provider.dart` | Defines `worldMapProvider`, `currentLevelProvider`, `challengesProvider`, `selectedNodeIdProvider`, `levelProgressProvider`, and `playgroundControllerProvider`. |

### `presentation/screens/`

Top-level routes. Each screen is a `ConsumerWidget` that listens to providers and assembles widgets.

| File                                                  | Purpose                                                                                              |
|-------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `presentation/screens/playground_screen.dart`         | Tab shell. Hosts `WorldMapScreen` + side navigation.                                                 |
| `presentation/screens/world_map_screen.dart`          | The map. The primary post-onboarding experience.                                                     |
| `presentation/screens/level_screen.dart`              | Briefing + challenge list for a tapped node.                                                         |
| `presentation/screens/challenge_screen.dart`          | Plays a single challenge (quiz, reading, mini-task).                                                |
| `presentation/screens/boss_challenge_screen.dart`     | Plays a boss challenge. Higher stakes, dramatic visuals.                                             |
| `presentation/screens/level_completed_screen.dart`    | Reward / celebration screen shown after `completeLevel` succeeds.                                    |

### `presentation/utils/`

Pure functions. No Riverpod, no async, no widgets. Easy to unit-test.

| File                                                  | Purpose                                                                                              |
|-------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `presentation/utils/node_position_calculator.dart`    | Computes `(x, y)` for each node index using the chosen path algorithm (sinusoidal, zigzag, branching). |
| `presentation/utils/path_generator.dart`              | Generates the polyline / bezier that connects two nodes.                                             |
| `presentation/utils/world_map_builder.dart`           | Builds the full UI tree (nodes, paths, decorations, overlays) from a `WorldEntity`.                  |
| `presentation/utils/playground_helpers.dart`          | Cross-cutting helpers: progress math, color mixing, formatters, ID generators.                      |

### `presentation/widgets/`

#### Root composites (cross-cutting)

| File                                              | Purpose                                                                                              |
|---------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `presentation/widgets/world_map.dart`             | Map composition: assembles background, paths, nodes, buildings, overlays.                            |
| `presentation/widgets/map_node.dart`              | Node composite that wires `nodes/playground_node.dart` and its animations.                            |
| `presentation/widgets/progress_path.dart`         | Path visual that delegates rendering to `path/` and `painters/`.                                     |
| `presentation/widgets/level_card.dart`            | Quest-style level summary card.                                                                       |
| `presentation/widgets/locked_level.dart`          | Muted variant of `level_card.dart` with a lock icon.                                                  |
| `presentation/widgets/challenge_tile.dart`        | Mission card per challenge — objective, reward, CTA.                                                  |
| `presentation/widgets/boss_gate.dart`             | Dramatic milestone visual for boss nodes.                                                             |
| `presentation/widgets/level_reward_dialog.dart`   | Centered reward modal with sparkle, XP, badges, claim CTA.                                           |

#### `presentation/widgets/animations/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `animations/chest_animation.dart`             | Chest-opening reward reveal (used by `rewards/reward_chest`).                                         |
| `animations/node_glow_animation.dart`         | Reusable pulse / glow tween for active nodes.                                                        |
| `animations/path_animation.dart`              | Animates a path stroke being drawn between nodes.                                                     |
| `animations/unlock_animation.dart`            | Celebration burst when a node transitions `locked → unlocked`.                                       |

#### `presentation/widgets/buildings/`

| File                                              | Purpose                                                                                              |
|---------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `buildings/playground_building.dart`              | Abstract building base — sprite layer, size, state, interaction.                                      |
| `buildings/academy_building.dart`                 | Knowledge-themed building.                                                                           |
| `buildings/library_building.dart`                 | Library-themed building.                                                                             |
| `buildings/building_label.dart`                  | Floating name tag above any building.                                                                |
| `buildings/building_progress.dart`               | "Level up" progress chip pinned to a building.                                                       |

#### `presentation/widgets/cards/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `cards/level_progress_card.dart`              | XP / streak / hearts at-a-glance card pinned at the top of the map.                                  |
| `cards/mission_card.dart`                     | Daily / weekly mission CTA card.                                                                     |

#### `presentation/widgets/decorations/`

| File                                                  | Purpose                                                                                              |
|-------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `decorations/playground_particle_layer.dart`          | Top-level orchestrator that mixes particles, clouds, and ambience.                                  |
| `decorations/particles.dart`                          | Ambient particles (pollen, fireflies).                                                               |
| `decorations/cloud.dart`                              | Drifting cloud sprite with subtle animation.                                                          |
| `decorations/tree.dart`                               | Tree sprite with wind sway.                                                                          |
| `decorations/bush.dart`                               | Foreground bush.                                                                                     |
| `decorations/mountain.dart`                           | Background mountain silhouette (parallax).                                                           |
| `decorations/river.dart`                              | Flowing water strip across the map.                                                                  |
| `decorations/bridge.dart`                             | Bridge over the river (interactive node on top).                                                     |
| `decorations/flag.dart`                               | Level completion flag.                                                                               |

#### `presentation/widgets/map/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `map/playground_map.dart`                     | Top-level map stage consumed by `widgets/world_map.dart`.                                            |
| `map/playground_background.dart`              | Parallax background (sky + hills).                                                                   |
| `map/playground_scroll_view.dart`             | Custom scrollable container handling horizontal/vertical journey.                                    |
| `map/playground_camera.dart`                  | Camera framing logic (centers on next unlocked node, follows on tap).                                 |
| `map/playground_legend.dart`                  | Toggleable legend explaining node icons and colors.                                                  |

#### `presentation/widgets/nodes/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `nodes/playground_node.dart`                  | Composite node assembled by `widgets/map_node.dart`.                                                 |
| `nodes/node_ring.dart`                        | Pulsing / glowing outer ring.                                                                        |
| `nodes/node_icon.dart`                        | Central subject icon.                                                                                |
| `nodes/node_badge.dart`                       | Small status badge (boss crown, "new", completed check).                                             |
| `nodes/node_label.dart`                       | Floating level title.                                                                                |
| `nodes/node_progress_indicator.dart`          | Mini progress arc showing challenge completion inside the level.                                     |

#### `presentation/widgets/overlays/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `overlays/playground_top_bar.dart`            | Top app-bar shell hosting `xp_indicator`, `streak_card`, profile.                                    |
| `overlays/xp_indicator.dart`                  | Current XP / level progress.                                                                         |
| `overlays/streak_card.dart`                   | Daily streak flame + day count.                                                                      |
| `overlays/coin_counter.dart`                  | Soft-currency balance.                                                                               |
| `overlays/energy_indicator.dart`              | Hearts / energy meter.                                                                               |
| `overlays/profile_summary.dart`               | Avatar + name quick view.                                                                            |

#### `presentation/widgets/painters/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `painters/playground_path_painter.dart`       | Main painter that draws the journey path with gradient + glow.                                       |
| `painters/dashed_path_painter.dart`           | Dashed variant for "not yet completed" segments.                                                     |
| `painters/node_glow_painter.dart`             | Soft radial glow halo around active nodes.                                                           |

#### `presentation/widgets/path/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `path/animated_path.dart`                     | Path with a one-shot reveal animation.                                                               |
| `path/completed_path.dart`                    | Solid path styling for completed segments.                                                           |
| `path/path_segment.dart`                      | A single segment between two nodes.                                                                  |

#### `presentation/widgets/rewards/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `rewards/reward_popup.dart`                   | Top-level popup orchestrator (XP + coins + chest).                                                   |
| `rewards/reward_chest.dart`                   | Animated chest using `animations/chest_animation.dart`.                                             |
| `rewards/xp_reward.dart`                      | "+XP" floating counter.                                                                              |
| `rewards/coin_reward.dart`                    | "+Coins" floating counter.                                                                           |

#### `presentation/widgets/sheets/`

| File                                          | Purpose                                                                                              |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------|
| `sheets/boss_bottom_sheet.dart`               | Confirm CTA + difficulty preview for boss nodes.                                                     |
| `sheets/mission_bottom_sheet.dart`            | Daily mission details + accept CTA.                                                                  |
| `sheets/library_bottom_sheet.dart`            | Library building details + accept CTA.                                                               |
| `sheets/reward_bottom_sheet.dart`             | Post-completion summary + claim CTA.                                                                 |

---

## 4. Layer Counts

| Layer / bucket                              | Files |
|---------------------------------------------|-------|
| Data                                        | 6     |
| Domain                                      | 11    |
| Presentation — constants                    | 4     |
| Presentation — extensions                   | 2     |
| Presentation — providers                    | 1     |
| Presentation — utils                        | 4     |
| Presentation — screens                      | 6     |
| Presentation — widgets (root composites)    | 8     |
| Presentation — widgets `animations/`        | 4     |
| Presentation — widgets `buildings/`         | 5     |
| Presentation — widgets `cards/`             | 2     |
| Presentation — widgets `decorations/`       | 9     |
| Presentation — widgets `map/`               | 5     |
| Presentation — widgets `nodes/`             | 6     |
| Presentation — widgets `overlays/`          | 6     |
| Presentation — widgets `painters/`          | 3     |
| Presentation — widgets `path/`              | 3     |
| Presentation — widgets `rewards/`           | 4     |
| Presentation — widgets `sheets/`           | 4     |
| **Total**                                   | **93** |

---

## 5. Scalability Strategy

### 5.1 Adding a new feature capability

If you need a new gameplay concept (for example, *"daily treasure chest on the map"*):

1. **New screen?** → add under `presentation/screens/`. Don't stuff logic into existing screens.
2. **New reusable widget?** → classify by role:
   - It animates → `animations/`
   - It paints → `painters/`
   - It's a card → `cards/`
   - It floats over the map → `overlays/`
   - It's modal → `sheets/`
   - It composes multiple roles → place at the `widgets/` root and import from each bucket.
3. **New state?** → add a provider in `presentation/providers/playground_provider.dart`. Keep one file unless the provider graph grows past ~20 definitions.
4. **New domain operation?** → add a use case in `domain/usecases/` and a method on `PlaygroundRepository`. Update `PlaygroundRepositoryImpl`.
5. **New entity?** → add `domain/entities/x_entity.dart`, `data/models/x_model.dart`, and `fromJson/toJson/toEntity`. Keep a 1:1 mapping.

### 5.2 Adding a new bucket

If a new category of UI emerges (e.g. *"minimap widgets"*), create a new sub-folder under `presentation/widgets/`. Each bucket should:

- Contain 3+ files. A bucket with one or two files belongs in the root or merged into a sibling bucket.
- Have a single, unambiguous responsibility.
- Not import across siblings except via the root composites (e.g. `widgets/world_map.dart` may import from any bucket).

### 5.3 Adding a new world (future)

When multiple worlds are introduced (see [Future Expansion](./PLAYGROUND_FUTURE_EXPANSION.md)), **do not** duplicate the whole feature per world. Instead:

- Make `WorldEntity` carry `worldId` and `biomeId`.
- Make `world_map_builder.dart` accept a biome config (asset set, palette, decoration set).
- Theme tokens (`playground_constants.dart`) gain a `BiomeTheme` lookup.
- A `worlds/` subfolder in `presentation/widgets/decorations/` could hold per-biome scenery variants (e.g. `snowy_tree.dart`, `desert_mountain.dart`).

### 5.4 When folders get large

If any sub-folder exceeds ~15 files, split it further along the same role principle. Examples:

- `decorations/` → `decorations/foliage/`, `decorations/water/`, `decorations/sky/`
- `overlays/` → `overlays/stats/`, `overlays/navigation/`, `overlays/notifications/`

The rule: a folder should be readable in one screen. If you scroll, split.

### 5.5 What *not* to do

- Don't add a `helpers/` folder. Use `utils/` for pure functions and `extensions/` for type extensions.
- Don't add per-feature sub-folders inside `domain/` or `data/` (e.g. `data/datasources/playground/`). The data layer stays flat; scaling happens via new files, not new folders.
- Don't place screens in `widgets/`. Screens are routes; widgets compose screens.
- Don't mix presentation concerns into the data layer. Models may import `dart:convert`, but never `package:flutter/*`.

---

**End of document.**