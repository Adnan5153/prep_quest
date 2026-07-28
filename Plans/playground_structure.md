# Playground Feature — Structure & Implementation Plan

> **Feature:** `lib/features/playground`
> **Purpose:** Duolingo-inspired world map & level-based learning journey. Acts as the primary post-onboarding home experience where users progress through levels, complete challenges, earn XP, and unlock new missions.
> **Architecture:** Clean Architecture (Data → Domain → Presentation) with a richly-modularized feature-first folder organization.
> **Status:** Folder structure upgraded — 93 stub files spanning 12+ subfolders. This document is the source of truth for what each file owns.
> **Related docs:** `BCS_Booster_AI_SRS.md` (FR-11.x, S-06A), `design.md` (§3.5), `widgetdesign.md` (§10, §13.1), `appflow.md` (§3.6).

---

## 1. Overview

The Playground feature is the **emotional and visual center** of PrepQuest. It turns learning into a game-like progression where:

- The user sees a **world map** of level nodes (instead of plain lists).
- Each node represents a **level** containing several **challenges**.
- Completing challenges unlocks the next level, awards **XP**, triggers **rewards**, and may unlock **boss gates** for major milestones.
- The feature follows **Clean Architecture** with three clear layers: **data**, **domain**, and **presentation**.
- The **presentation layer** is itself modularized into `constants/`, `extensions/`, `utils/`, `providers/`, `screens/`, and a deeply-categorized `widgets/` tree so the rich, game-like UI is easy to scale.

The current state on disk:

- 93 `*.dart` stub files, all empty.
- Folder layout is **final** — implement against it directly.
- This doc assigns a single responsibility to every file so no widget ends up doing two jobs.

---

## 2. High-Level Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                        │
│  Screens ◀──▶ Providers (Riverpod) ◀──▶ Widgets              │
│  + constants / extensions / utils (helpers)                  │
└────────────────────────┬─────────────────────────────────────┘
                         │  uses
┌────────────────────────▼─────────────────────────────────────┐
│                       DOMAIN LAYER                            │
│  Entities ◀──▶ Repositories (abstract) ◀──▶ Use Cases         │
└────────────────────────┬─────────────────────────────────────┘
                         │  implemented by
┌────────────────────────▼─────────────────────────────────────┐
│                        DATA LAYER                             │
│  Models ◀──▶ Remote Datasource (Firestore / API)             │
│  Repository Implementation (concrete)                        │
└──────────────────────────────────────────────────────────────┘
```

**Dependency rule:** outer layers depend on inner layers. Domain knows nothing about Flutter, JSON, or Firestore. Presentation never calls datasources directly. Helpers (`constants`, `extensions`, `utils`, sub-widget folders) are leaf-level — they never import from `domain/` or `data/`.

---

## 3. Folder Tree (Upgraded — source of truth)

```
lib/features/playground/
│
├── data/
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
├── domain/
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
└── presentation/
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
        ├── boss_gate.dart                  # top-level composite
        ├── challenge_tile.dart
        ├── level_card.dart
        ├── level_reward_dialog.dart
        ├── locked_level.dart
        ├── map_node.dart                    # top-level composite
        ├── progress_path.dart
        ├── world_map.dart                   # top-level composite
        │
        ├── animations/
        │   ├── chest_animation.dart
        │   ├── node_glow_animation.dart
        │   ├── path_animation.dart
        │   └── unlock_animation.dart
        │
        ├── buildings/
        │   ├── academy_building.dart
        │   ├── building_label.dart
        │   ├── building_progress.dart
        │   ├── library_building.dart
        │   └── playground_building.dart
        │
        ├── cards/
        │   ├── level_progress_card.dart
        │   └── mission_card.dart
        │
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
        ├── map/
        │   ├── playground_background.dart
        │   ├── playground_camera.dart
        │   ├── playground_legend.dart
        │   ├── playground_map.dart
        │   └── playground_scroll_view.dart
        │
        ├── nodes/
        │   ├── node_badge.dart
        │   ├── node_icon.dart
        │   ├── node_label.dart
        │   ├── node_progress_indicator.dart
        │   ├── node_ring.dart
        │   └── playground_node.dart
        │
        ├── overlays/
        │   ├── coin_counter.dart
        │   ├── energy_indicator.dart
        │   ├── playground_top_bar.dart
        │   ├── profile_summary.dart
        │   ├── streak_card.dart
        │   └── xp_indicator.dart
        │
        ├── painters/
        │   ├── dashed_path_painter.dart
        │   ├── node_glow_painter.dart
        │   └── playground_path_painter.dart
        │
        ├── path/
        │   ├── animated_path.dart
        │   ├── completed_path.dart
        │   └── path_segment.dart
        │
        ├── rewards/
        │   ├── coin_reward.dart
        │   ├── reward_chest.dart
        │   ├── reward_popup.dart
        │   └── xp_reward.dart
        │
        └── sheets/
            ├── boss_bottom_sheet.dart
            ├── library_bottom_sheet.dart
            ├── mission_bottom_sheet.dart
            └── reward_bottom_sheet.dart
```

> **Counts:** 4 data files · 4 entities + 1 repository + 6 use cases = 11 domain files · 76 presentation files (4 constants + 2 extensions + 1 provider + 6 screens + 4 utils + 59 widgets across 12 sub-categories). **Total: 93 files** matching the on-disk state.

### Presentation sub-folders — what each owns

| Sub-folder      | Scope                                                                            |
|-----------------|----------------------------------------------------------------------------------|
| `constants/`    | Static config (asset paths, magic numbers, sizes, copy) — no logic.              |
| `extensions/`   | Dart `extension` methods on existing types (`NodeStatus`, `WorldEntity`).        |
| `utils/`        | Pure functions: path math, position calculation, builder helpers.                |
| `providers/`    | Riverpod state + controller.                                                     |
| `screens/`      | Full-page routes.                                                                |
| `widgets/`      | Reusable composites, organized by **role** (animations, nodes, overlays, …).   |

### Why widgets/ is split by category

The map is dense: nodes, paths, decorations, buildings, painters, and overlays all coexist. Grouping by role keeps files small, ownership obvious, and merges sane.

---

## 4. Domain Layer (Pure Dart, no Flutter)

The domain layer contains **entities** (immutable business objects), **repository contracts**, and **use cases** (single-purpose business actions). No imports from Flutter, Firestore, or JSON serialization.

### 4.1 Entities

#### `domain/entities/world_entity.dart`
Represents the entire playground world map for a user.

| Field           | Type               | Description                                      |
|-----------------|--------------------|--------------------------------------------------|
| `id`            | `String`           | Unique world id (e.g. `"main_world"`).           |
| `title`         | `String`           | Display name, e.g. `"BCS Quest Map"`.            |
| `nodes`         | `List<NodeEntity>` | All level nodes in render order.                 |
| `userLevel`     | `int`              | Current user level on the world.                 |
| `totalXp`       | `int`              | Cumulative XP across all worlds.                 |
| `currentStreak` | `int`              | Consecutive daily learning days.                 |

#### `domain/entities/node_entity.dart`
A single level node on the world map.

| Field      | Type                       | Description                                                   |
|------------|----------------------------|---------------------------------------------------------------|
| `id`       | `String`                   | Unique node id.                                               |
| `index`    | `int`                      | Position on the path (0-based).                               |
| `title`    | `String`                   | Level name (e.g. `"Foundations of Bangladesh"`).              |
| `status`   | `NodeStatus` enum          | `locked`, `unlocked`, `inProgress`, `completed`, `boss`.      |
| `xpReward` | `int`                      | XP earned on completion.                                      |
| `isBoss`   | `bool`                     | Marks boss-gate milestones.                                   |
| `position` | `Offset` (or `{x,y}` rec.) | Logical map position for layout.                              |

> **Naming note:** the domain enum is `NodeStatus` (because the file is `node_status_extension.dart`). The presentation `extensions/` folder binds UI affordances to it.

#### `domain/entities/level_entity.dart`
Detailed level data once a node is opened.

| Field           | Type                    | Description                                       |
|-----------------|-------------------------|---------------------------------------------------|
| `id`            | `String`                | Level id.                                         |
| `nodeId`        | `String`                | Reference to parent node.                         |
| `title`         | `String`                | Level title.                                      |
| `description`   | `String`                | Short story / mission briefing.                   |
| `challenges`    | `List<ChallengeEntity>` | Ordered list of challenges.                       |
| `reward`        | `LevelReward`           | XP, badges, hearts, etc.                          |
| `requiresLevel` | `int`                   | Minimum user level to start.                      |

#### `domain/entities/challenge_entity.dart`
An individual task inside a level.

| Field         | Type             | Description                                          |
|---------------|------------------|------------------------------------------------------|
| `id`          | `String`         | Challenge id.                                        |
| `levelId`     | `String`         | Parent level id.                                     |
| `type`        | `ChallengeType`  | `reading`, `quiz`, `miniBoss`, `aiTask`, `mock`.     |
| `questionIds` | `List<String>`   | Linked questions (when type = quiz/mock).            |
| `xpReward`    | `int`            | XP for completing this challenge.                    |
| `completedAt` | `DateTime?`      | `null` if not completed.                             |

### 4.2 Repository Contract

#### `domain/repositories/playground_repository.dart`
Abstract class defining every data operation the feature needs. The presentation layer depends on this interface only.

```dart
abstract class PlaygroundRepository {
  Future<WorldEntity> getWorldMap(String userId);
  Future<LevelEntity> getLevel(String levelId);
  Future<List<ChallengeEntity>> getChallenges(String levelId);
  Future<void> startLevel({required String userId, required String levelId});
  Future<void> completeLevel({
    required String userId,
    required String levelId,
    required int earnedXp,
  });
  Future<LevelEntity> unlockNextLevel(String userId, String currentLevelId);
}
```

### 4.3 Use Cases

Each use case is a single-purpose class — one verb, one outcome.

| Use case              | Input                                       | Output / Effect                                     |
|-----------------------|---------------------------------------------|-----------------------------------------------------|
| `GetWorldMap`         | `userId`                                    | `Future<WorldEntity>`                               |
| `GetLevel`            | `levelId`                                   | `Future<LevelEntity>`                               |
| `GetChallenges`       | `levelId`                                   | `Future<List<ChallengeEntity>>`                     |
| `StartLevel`          | `userId`, `levelId`                         | Marks level as in-progress (persists state).        |
| `CompleteLevel`       | `userId`, `levelId`, `earnedXp`             | Awards XP, updates streaks, fires reward event.     |
| `UnlockNextLevel`     | `userId`, `currentLevelId`                  | Returns the next `LevelEntity` and unlocks its node. |

```dart
class CompleteLevel {
  final PlaygroundRepository _repo;
  CompleteLevel(this._repo);
  Future<LevelEntity> call({
    required String userId,
    required String levelId,
    required int earnedXp,
  }) => _repo.completeLevel(userId: userId, levelId: levelId, earnedXp: earnedXp);
}
```

---

## 5. Data Layer

The data layer **implements** the domain contracts and converts raw transport objects (JSON / Firestore docs) into domain entities. Models extend entities and add `.fromJson` / `.toJson` plus a `toEntity()`.

### 5.1 Models

Each model lives in `data/models/` and mirrors its domain entity one-to-one.

| Model file                       | Maps to                | Responsibility                                                 |
|----------------------------------|------------------------|-----------------------------------------------------------------|
| `data/models/world_model.dart`   | `WorldEntity`          | `fromJson` / `fromFirestore` / `toJson` / `toEntity`.           |
| `data/models/node_model.dart`    | `NodeEntity`           | `NodeStatus` enum (de)serialization.                            |
| `data/models/level_model.dart`   | `LevelEntity`          | Holds challenge metadata + reward payload.                      |
| `data/models/challenge_model.dart`| `ChallengeEntity`     | `ChallengeType` enum + nullable `completedAt`.                  |

### 5.2 Remote Datasource

#### `data/datasources/playground_remote_datasource.dart`
Talks to Firestore (or a future REST API). Exposes raw methods that return models, never entities.

- `Future<WorldModel> fetchWorldMap(String userId)`
- `Future<LevelModel> fetchLevel(String levelId)`
- `Future<List<ChallengeModel>> fetchChallenges(String levelId)`
- `Future<void> setLevelState({userId, levelId, state})`
- `Future<void> recordCompletion({userId, levelId, earnedXp})`
- `Stream<WorldModel> watchWorldMap(String userId)` — for live node updates.

### 5.3 Repository Implementation

#### `data/repositories/playground_repository_impl.dart`
Implements `PlaygroundRepository` by delegating to the datasource and converting models → entities via `toEntity()`.

```dart
class PlaygroundRepositoryImpl implements PlaygroundRepository {
  final PlaygroundRemoteDatasource remote;
  PlaygroundRepositoryImpl(this.remote);

  @override
  Future<WorldEntity> getWorldMap(String userId) async {
    final model = await remote.fetchWorldMap(userId);
    return model.toEntity();
  }
  // …same shape for every contract method…
}
```

---

## 6. Presentation Layer

The presentation layer renders UI, manages local UI state via Riverpod, and calls use cases. It **never** touches models or datasources.

### 6.1 Constants — `presentation/constants/`

Static, framework-agnostic config — no logic, no widgets, no providers.

| File                          | Purpose                                                                                   |
|-------------------------------|-------------------------------------------------------------------------------------------|
| `playground_constants.dart`   | Feature-wide enums and string ids (e.g. animation durations, color tokens, route names).  |
| `playground_sizes.dart`       | Hard-coded dimensions (node diameter, path stroke width, padding, etc.).                 |
| `playground_assets.dart`      | Asset path constants (images, lottie, svg).                                               |
| `playground_strings.dart`     | All user-visible copy keys (so localization is one swap away).                            |

> Rule of thumb: if a value is reused in 3+ files, it belongs here.

### 6.2 Extensions — `presentation/extensions/`

Dart `extension` methods on existing types — keeps call sites readable.

| File                              | Purpose                                                                            |
|-----------------------------------|------------------------------------------------------------------------------------|
| `node_status_extension.dart`      | `NodeStatus.completed`, `.locked`, `.glowColor`, `.isActionable` — UI affordances. |
| `world_extension.dart`            | `WorldEntity.nextNodeFor(current)`, `.progressPercent`, `.orderedNodes` helpers.  |

Extensions are pure presentational sugar — domain stays untouched.

### 6.3 Utils — `presentation/utils/`

Pure functions. No Riverpod, no async, no widgets.

| File                                  | Responsibility                                                                                          |
|---------------------------------------|---------------------------------------------------------------------------------------------------------|
| `node_position_calculator.dart`       | Computes the `(x,y)` for each node index using a path algorithm (sinusoidal, zigzag, branching, …).      |
| `path_generator.dart`                 | Generates the polyline (list of `Offset`s) connecting two nodes, including bezier curves for elegance.  |
| `world_map_builder.dart`              | Builds the full UI tree of nodes/paths/buildings/decorations from a `WorldEntity`.                     |
| `playground_helpers.dart`             | Cross-cutting utilities (progress math, color mixing, formatter helpers).                               |

### 6.4 Providers — `presentation/providers/`

#### `playground_provider.dart`
Single-file home for all Riverpod providers.

| Provider                         | Type                                     | Purpose                                          |
|----------------------------------|------------------------------------------|--------------------------------------------------|
| `worldMapProvider`               | `AsyncNotifierProvider<…, WorldEntity>`  | Loads and caches the world map.                  |
| `currentLevelProvider`           | `FutureProvider.family<…, String>`       | Loads a specific level.                          |
| `challengesProvider`             | `FutureProvider.family<…, String>`       | Loads challenges of a level.                     |
| `selectedNodeIdProvider`         | `StateProvider<String?>`                 | Currently focused node on the map.               |
| `levelProgressProvider`          | `AsyncNotifierProvider<…, Progress>`     | XP, hearts, streaks for the user.                |
| `playgroundControllerProvider`  | `Notifier<PlaygroundController>`        | Action methods (`startLevel`, `completeLevel`, `unlockNext`). |

The controller calls use cases and updates state — widgets stay dumb.

### 6.5 Screens — `presentation/screens/`

Each screen is a `ConsumerWidget` that listens to providers and composes widgets.

| Screen                          | Purpose                                                                 |
|---------------------------------|-------------------------------------------------------------------------|
| `playground_screen.dart`        | Top-level entry. Hosts tab/page between `WorldMapScreen` and profile.   |
| `world_map_screen.dart`         | **Primary screen** — the entire map of nodes with progress path.        |
| `level_screen.dart`             | Opens when a node is tapped: level briefing + challenges list.          |
| `challenge_screen.dart`         | Plays an individual challenge (quiz / reading / mini-task).             |
| `boss_challenge_screen.dart`    | Special screen for `isBoss` nodes. Higher stakes, dramatic visuals.     |
| `level_completed_screen.dart`   | Reward / celebration shown after `completeLevel` succeeds.              |

#### Navigation flow

```
playground_screen
   └── world_map_screen
         └── level_screen  (tap node)
               ├── challenge_screen      (regular)
               └── boss_challenge_screen (if boss)
         └── level_completed_screen  (after success → unlock next)
```

### 6.6 Widgets — `presentation/widgets/`

Two layout styles coexist:

- **Top-level composites** at the `widgets/` root (kept for legacy and convenience): `world_map.dart`, `map_node.dart`, `level_card.dart`, `locked_level.dart`, `boss_gate.dart`, `challenge_tile.dart`, `progress_path.dart`, `level_reward_dialog.dart`.
- **Role-categorized sub-folders** (preferred for new code) under `widgets/`.

#### Top-level composites (root of `widgets/`)

| Widget                       | Responsibility                                                                 |
|------------------------------|---------------------------------------------------------------------------------|
| `world_map.dart`             | Top-level map composition: assembles background, paths, nodes, buildings, overlays. |
| `map_node.dart`              | Composite that wires `nodes/playground_node.dart` together with its animations.  |
| `progress_path.dart`         | Connects two nodes visually; delegates rendering to `path/`.                     |
| `level_card.dart`            | Quest-style level summary card.                                                  |
| `locked_level.dart`          | Muted variant of `level_card` with a lock icon.                                 |
| `challenge_tile.dart`        | Mission card per challenge — objective, reward, CTA.                             |
| `boss_gate.dart`             | Dramatic milestone visual for boss nodes.                                       |
| `level_reward_dialog.dart`   | Centered reward modal with sparkle, XP, badges, claim CTA.                      |

#### `animations/`
Reusable transition / feedback animations.

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `chest_animation.dart`        | Chest-opening reward reveal (used in `rewards/reward_chest`).             |
| `node_glow_animation.dart`    | Reusable pulse / glow tween for active nodes.                            |
| `path_animation.dart`         | Animates a path stroke being drawn between nodes.                        |
| `unlock_animation.dart`       | Celebration burst played when a node transitions from `locked → unlocked`.|

#### `buildings/`
Storybook buildings that decorate the map (academy, library, …).

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `playground_building.dart`    | Abstract base — defines size, sprite layer, interaction state.          |
| `academy_building.dart`       | Subject-themed building (knowledge iconography).                          |
| `library_building.dart`       | Book-stack building variant.                                              |
| `building_label.dart`         | Floating label above any building.                                        |
| `building_progress.dart`      | "Level up" progress chip pinned to a building.                           |

#### `cards/`
Larger card-shaped composites.

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `level_progress_card.dart`    | XP / streak / hearts at-a-glance card (top of map).                      |
| `mission_card.dart`           | Daily / weekly mission CTA card.                                         |

#### `decorations/`
Non-interactive scenery that fills the map.

| File                                | Purpose                                                              |
|-------------------------------------|----------------------------------------------------------------------|
| `playground_particle_layer.dart`    | Top-level orchestrator that mixes particles, clouds, and ambience.  |
| `particles.dart`                    | Tiny ambient particles (pollen / fireflies).                         |
| `cloud.dart`                        | Drifting cloud sprite (animated).                                    |
| `tree.dart`                         | Tree sprite with wind sway.                                          |
| `bush.dart`                         | Foreground bush.                                                     |
| `mountain.dart`                     | Background mountain silhouette (parallax).                           |
| `river.dart`                        | Flowing water strip across the map.                                 |
| `bridge.dart`                       | Bridge over the river (interactive node on top).                     |
| `flag.dart`                         | Level completion flag.                                               |

#### `map/`
The map rendering pipeline (camera, scrolling, background, legend).

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `playground_map.dart`         | Top-level map stage used by `widgets/world_map.dart`.                   |
| `playground_background.dart`  | Parallax background (sky + hills).                                      |
| `playground_scroll_view.dart` | Custom scrollable container handling horizontal/vertical journey.       |
| `playground_camera.dart`      | Camera framing logic (centering on next unlocked node, follow-on-tap).  |
| `playground_legend.dart`      | Toggleable legend explaining node icons and colors.                     |

#### `nodes/`
Atomic pieces that make up a single map node.

| File                              | Purpose                                                          |
|-----------------------------------|------------------------------------------------------------------|
| `playground_node.dart`            | Composite node assembled by `map_node.dart`.                     |
| `node_ring.dart`                  | Pulsing / glowing outer ring.                                    |
| `node_icon.dart`                  | Central subject icon.                                            |
| `node_badge.dart`                 | Small status badge (boss crown, new, completed check).           |
| `node_label.dart`                 | Floating level title.                                            |
| `node_progress_indicator.dart`    | Mini progress arc showing challenge completion inside the level. |

#### `overlays/`
HUD elements layered on top of the map (always visible).

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `playground_top_bar.dart`     | Top app-bar shell — hosts `xp_indicator`, `streak_card`, profile.       |
| `xp_indicator.dart`           | Current XP / level progress.                                             |
| `streak_card.dart`            | Daily streak flame + day count.                                          |
| `coin_counter.dart`           | Soft-currency balance.                                                   |
| `energy_indicator.dart`       | Hearts / energy meter.                                                   |
| `profile_summary.dart`        | Avatar + name quick view.                                                |

#### `painters/`
`CustomPainter` implementations for paths/glows.

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `playground_path_painter.dart`| Main painter that draws the journey path with gradient + glow.         |
| `dashed_path_painter.dart`    | Dashed variant for "not-yet-completed" segments.                        |
| `node_glow_painter.dart`      | Soft radial glow halo around active nodes.                              |

#### `path/`
Composable path pieces (smaller than `progress_path.dart`).

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `animated_path.dart`          | Path with a one-shot reveal animation.                                   |
| `completed_path.dart`         | Solid path styling for completed segments.                               |
| `path_segment.dart`           | A single segment between two nodes.                                      |

#### `rewards/`
Reward presentation widgets, opened after `CompleteLevel`.

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `reward_popup.dart`           | Top-level popup orchestrator (XP + coins + chest).                       |
| `reward_chest.dart`           | Animated chest with `animations/chest_animation.dart`.                   |
| `xp_reward.dart`              | "+XP" floating counter.                                                  |
| `coin_reward.dart`            | "+Coins" floating counter.                                               |

#### `sheets/`
Modal bottom sheets attached to the map.

| File                          | Purpose                                                                  |
|-------------------------------|--------------------------------------------------------------------------|
| `boss_bottom_sheet.dart`      | Opens for boss nodes — confirm CTA, difficulty preview.                  |
| `mission_bottom_sheet.dart`   | Opens for daily missions.                                                |
| `library_bottom_sheet.dart`   | Opens for `library_building.dart`.                                       |
| `reward_bottom_sheet.dart`    | Opens after level completion — summary + claim CTA.                      |

---

## 7. End-to-End Data Flow

```
[User taps node on map]
        │
        ▼
world_map_screen  ──▶  selectedNodeIdProvider
        │
        ▼
level_screen  ──▶  currentLevelProvider.family(levelId)
        │                  │
        │                  └──▶  GetLevel (use case)
        │                              │
        │                              └──▶  PlaygroundRepository.getLevel
        │                                          │
        │                                          └──▶  PlaygroundRemoteDatasource
        │                                                     │
        │                                                     └──▶  Firestore
        ▼
[User completes all challenges]
        │
        ▼
CompleteLevel (use case)
        │
        ▼
PlaygroundRepository.completeLevel  ──▶  datasource.recordCompletion
        │
        ▼
UnlockNextLevel (use case)  ──▶  next node state = `unlocked`
        │
        ▼
level_completed_screen  ──▶  level_reward_dialog  ──▶  reward_popup  ──▶  reward_chest + xp_reward + coin_reward
        │
        ▼
world_map_provider invalidates → UI re-renders with new node states
        │
        ▼
unlock_animation  +  path_animation  +  node_glow_animation  fire on the freshly-unlocked node
```

---

## 8. Implementation Steps

Follow this order so each step compiles cleanly before the next.

1. **Domain entities** — `world`, `node`, `level`, `challenge`.
2. **Domain repository contract** — `PlaygroundRepository` abstract class.
3. **Domain use cases** — the 6 use cases calling the repository.
4. **Data models** — for each entity, add a model with `fromJson`, `toJson`, `toEntity`.
5. **Remote datasource** — wire Firestore collection paths and stub methods.
6. **Repository implementation** — bridge datasource to domain via `toEntity()`.
7. **Constants & extensions** — populate `constants/*.dart` and the two extensions, since widgets will import them heavily.
8. **Utils** — pure helpers (`node_position_calculator`, `path_generator`, `world_map_builder`, `playground_helpers`).
9. **Providers** — Riverpod providers + controller.
10. **Widgets — atomic layer** (`painters/`, `nodes/`, `animations/`, `decorations/`, `buildings/`, `path/`, `overlays/`).
11. **Widgets — composite layer** (`cards/`, `rewards/`, `sheets/`, root-level composites).
12. **Screens** — assemble widgets in screens; wire navigation.
13. **Router** — register playground routes in `lib/router.dart`.
14. **Polish** — staggered node entrance, confetti on reward, Bangla localization, responsive layout, error/empty/loading states.

---

## 9. Routing

Add these routes to `lib/router.dart`:

```dart
GoRoute(
  path: '/playground',
  builder: (_, __) => const PlaygroundScreen(),
  routes: [
    GoRoute(path: 'map',          builder: (_, __) => const WorldMapScreen()),
    GoRoute(path: 'level/:id',    builder: (_, s) => LevelScreen(levelId: s.pathParameters['id']!)),
    GoRoute(path: 'challenge/:id',builder: (_, s) => ChallengeScreen(challengeId: s.pathParameters['id']!)),
    GoRoute(path: 'boss/:id',     builder: (_, s) => BossChallengeScreen(levelId: s.pathParameters['id']!)),
    GoRoute(path: 'completed',    builder: (_, __) => const LevelCompletedScreen()),
  ],
),
```

The Splash → Onboarding → Playground transition is the **primary entry path** (per FR-11.2a).

---

## 10. Visual & Motion Guidelines (from `widgetdesign.md`)

- **Map nodes:** glowing circular / island style; completed nodes shine, active nodes pulse, locked nodes stay dimmed but inviting.
- **Progress path:** connected line between nodes, bright on completed segments.
- **Level card:** quest feel with title, status, XP reward, challenge hint.
- **Locked level:** muted card + lock icon — never feel dead, always feel like an inviting challenge.
- **Challenge tile:** mission card with objective, reward, bright CTA.
- **Boss gate:** dramatic silhouette, accent color, reward-style visual.
- **Reward dialog:** centered modal with sparkle, XP summary, badges, celebration motion, strong CTA.
- **Entrance:** staggered pop-in for nodes; soft celebration burst + progress fill on unlock; confetti/sparkle on completion.
- **Decorations (new):** parallax background, drifting clouds, ambient particles, flowing river — applied through `playground_particle_layer.dart` so the map feels alive.

---

## 11. State, Error & Edge Cases

| Scenario                          | Expected behavior                                                                 |
|-----------------------------------|------------------------------------------------------------------------------------|
| No internet on map load           | Show cached map + retry banner.                                                    |
| User taps locked node             | Show `locked_level` card with "Reach level N to unlock".                           |
| Hearts run out                    | `energy_indicator` pulses red; bottom sheet suggests waiting or reward claim.     |
| Boss challenge failed             | Allow retry once hearts regenerate; preserve partial XP.                           |
| Completion already recorded       | Idempotent — `completeLevel` called twice = same result.                           |
| Force-quit mid-challenge          | Resume on `startLevel` re-entry via `inProgress` state.                            |
| Camera off-center                 | `playground_camera.dart` re-centers on next unlocked node after completion.       |
| Long worlds overflow viewport     | `playground_scroll_view.dart` enables directional scroll, legend toggle helps.    |

---

## 12. Testing Strategy

- **Unit tests** for every use case (mock `PlaygroundRepository`).
- **Unit tests** for every model (`fromJson` / `toJson` round-trips).
- **Unit tests** for utils: `node_position_calculator`, `path_generator`, `world_map_builder`.
- **Widget tests** for `playground_node`, `level_card`, `challenge_tile`, `level_reward_dialog`, `boss_gate`, the four bottom sheets, and each overlay (XP / streak / coins / energy).
- **Painter tests** for `playground_path_painter`, `dashed_path_painter`, `node_glow_painter`.
- **Integration test** for the flow: open map → tap node → complete challenge → see reward popup → chest animation → bottom sheet → next node unlocked → camera recenters.
- **Golden tests** for visual regression on key widgets.

---

## 13. Dependencies

Already available (verify in `pubspec.yaml`):

- `flutter_riverpod` — providers/state.
- `go_router` — routing.
- `cloud_firestore` — remote datasource.
- `lottie` (likely) — boss gate / unlock animations in `animations/`.
- `freezed` / `json_serializable` (optional) — model immutability and JSON.

Add if missing:

- `riverpod_annotation` + `riverpod_generator` (optional codegen).

---

## 14. File-by-File Summary (93 files)

### Data layer (4 files)

| File                                              | Purpose                                          |
|---------------------------------------------------|--------------------------------------------------|
| `data/datasources/playground_remote_datasource.dart` | Firestore / API calls.                       |
| `data/models/world_model.dart`                    | World JSON ↔ entity mapping.                     |
| `data/models/node_model.dart`                     | Node JSON ↔ entity mapping.                      |
| `data/models/level_model.dart`                    | Level JSON ↔ entity mapping.                     |
| `data/models/challenge_model.dart`                | Challenge JSON ↔ entity mapping.                 |
| `data/repositories/playground_repository_impl.dart` | Domain contract implementation.              |

### Domain layer (11 files)

| File                                              | Purpose                                          |
|---------------------------------------------------|--------------------------------------------------|
| `domain/entities/world_entity.dart`               | Whole-map business object.                       |
| `domain/entities/node_entity.dart`                | Single level node.                               |
| `domain/entities/level_entity.dart`               | Detailed level content.                          |
| `domain/entities/challenge_entity.dart`           | Single task inside a level.                      |
| `domain/repositories/playground_repository.dart`  | Abstract data contract.                          |
| `domain/usecases/get_world_map.dart`              | Load world map for a user.                       |
| `domain/usecases/get_level.dart`                  | Load one level by id.                            |
| `domain/usecases/get_challenges.dart`             | Load challenges for a level.                     |
| `domain/usecases/start_level.dart`                | Persist "in progress" state for a level.         |
| `domain/usecases/complete_level.dart`             | Award XP + reward for completing a level.        |
| `domain/usecases/unlock_next_level.dart`          | Promote the next node from `locked → unlocked`.  |

### Presentation — Constants (4 files)

| File                                          | Purpose                                                              |
|-----------------------------------------------|----------------------------------------------------------------------|
| `presentation/constants/playground_constants.dart` | Feature-wide enums, route ids, animation durations.             |
| `presentation/constants/playground_sizes.dart`    | Hard-coded dimensions (node diameter, path stroke width, …).     |
| `presentation/constants/playground_assets.dart`   | Asset path constants (images, lottie, svg).                      |
| `presentation/constants/playground_strings.dart`  | All user-visible copy keys (i18n-friendly).                      |

### Presentation — Extensions (2 files)

| File                                                   | Purpose                                                           |
|--------------------------------------------------------|-------------------------------------------------------------------|
| `presentation/extensions/node_status_extension.dart`    | UI affordances on `NodeStatus` (color, glow, isActionable).      |
| `presentation/extensions/world_extension.dart`         | Convenience getters/methods on `WorldEntity`.                    |

### Presentation — Providers (1 file)

| File                                              | Purpose                                          |
|---------------------------------------------------|--------------------------------------------------|
| `presentation/providers/playground_provider.dart` | Riverpod providers + controller.                 |

### Presentation — Utils (4 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/utils/node_position_calculator.dart`    | (x,y) computation per node index.                                 |
| `presentation/utils/path_generator.dart`              | Polyline / bezier between two nodes.                              |
| `presentation/utils/world_map_builder.dart`           | Builds the full UI tree from a `WorldEntity`.                     |
| `presentation/utils/playground_helpers.dart`          | Cross-cutting math / formatters.                                  |

### Presentation — Screens (6 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/screens/playground_screen.dart`         | Top-level shell.                                                   |
| `presentation/screens/world_map_screen.dart`          | Map of level nodes.                                                |
| `presentation/screens/level_screen.dart`              | Level details + challenges list.                                   |
| `presentation/screens/challenge_screen.dart`          | Individual challenge runner.                                       |
| `presentation/screens/boss_challenge_screen.dart`     | Boss-level runner.                                                 |
| `presentation/screens/level_completed_screen.dart`    | Reward / celebration screen.                                       |

### Presentation — Widgets root composites (8 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/world_map.dart`                  | Map layout & painter orchestration.                                |
| `presentation/widgets/map_node.dart`                   | Single glowing node composite.                                     |
| `presentation/widgets/progress_path.dart`              | Connected journey between nodes.                                   |
| `presentation/widgets/level_card.dart`                 | Quest-style level summary card.                                    |
| `presentation/widgets/locked_level.dart`              | Muted locked variant of `level_card`.                              |
| `presentation/widgets/challenge_tile.dart`            | Mission card per challenge.                                        |
| `presentation/widgets/boss_gate.dart`                 | Boss milestone visual.                                             |
| `presentation/widgets/level_reward_dialog.dart`       | Reward modal with celebration.                                     |

### Presentation — Widgets `animations/` (4 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/animations/chest_animation.dart`| Chest-opening reward reveal.                                       |
| `presentation/widgets/animations/node_glow_animation.dart` | Reusable pulse/glow tween for active nodes.                    |
| `presentation/widgets/animations/path_animation.dart` | Animates a path stroke being drawn.                                |
| `presentation/widgets/animations/unlock_animation.dart` | Celebration burst on `locked → unlocked`.                        |

### Presentation — Widgets `buildings/` (5 files)

| File                                                       | Purpose                                                        |
|------------------------------------------------------------|----------------------------------------------------------------|
| `presentation/widgets/buildings/playground_building.dart`  | Abstract building base — size, sprite layer, state.            |
| `presentation/widgets/buildings/academy_building.dart`     | Knowledge-themed building.                                     |
| `presentation/widgets/buildings/library_building.dart`     | Library-themed building.                                       |
| `presentation/widgets/buildings/building_label.dart`      | Floating name tag above any building.                          |
| `presentation/widgets/buildings/building_progress.dart`   | "Level up" progress chip pinned to a building.                 |

### Presentation — Widgets `cards/` (2 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/cards/level_progress_card.dart`  | XP / streak / hearts at-a-glance card.                             |
| `presentation/widgets/cards/mission_card.dart`        | Daily / weekly mission CTA card.                                   |

### Presentation — Widgets `decorations/` (9 files)

| File                                                          | Purpose                                                    |
|---------------------------------------------------------------|------------------------------------------------------------|
| `presentation/widgets/decorations/playground_particle_layer.dart` | Mixes particles + clouds + ambience.                  |
| `presentation/widgets/decorations/particles.dart`              | Ambient particles (pollen / fireflies).                  |
| `presentation/widgets/decorations/cloud.dart`                  | Animated drifting cloud.                                 |
| `presentation/widgets/decorations/tree.dart`                   | Tree with wind sway.                                     |
| `presentation/widgets/decorations/bush.dart`                   | Foreground bush.                                         |
| `presentation/widgets/decorations/mountain.dart`               | Parallax background mountain.                           |
| `presentation/widgets/decorations/river.dart`                  | Flowing river strip.                                     |
| `presentation/widgets/decorations/bridge.dart`                 | Bridge over the river.                                   |
| `presentation/widgets/decorations/flag.dart`                   | Level completion flag.                                   |

### Presentation — Widgets `map/` (5 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/map/playground_map.dart`         | Top-level map stage.                                               |
| `presentation/widgets/map/playground_background.dart` | Parallax sky + hills.                                              |
| `presentation/widgets/map/playground_scroll_view.dart` | Directional scroll container for long worlds.                     |
| `presentation/widgets/map/playground_camera.dart`      | Camera framing logic.                                              |
| `presentation/widgets/map/playground_legend.dart`      | Toggleable legend explaining node icons.                           |

### Presentation — Widgets `nodes/` (6 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/nodes/playground_node.dart`      | Composite node assembled by `map_node.dart`.                       |
| `presentation/widgets/nodes/node_ring.dart`            | Pulsing / glowing outer ring.                                      |
| `presentation/widgets/nodes/node_icon.dart`            | Central subject icon.                                              |
| `presentation/widgets/nodes/node_badge.dart`           | Status badge (boss crown, new, completed).                         |
| `presentation/widgets/nodes/node_label.dart`           | Floating level title.                                              |
| `presentation/widgets/nodes/node_progress_indicator.dart` | Mini progress arc (challenge completion inside level).         |

### Presentation — Widgets `overlays/` (6 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/overlays/playground_top_bar.dart` | App-bar shell hosting XP / streak / profile.                     |
| `presentation/widgets/overlays/xp_indicator.dart`     | Current XP / level progress.                                       |
| `presentation/widgets/overlays/streak_card.dart`      | Daily streak flame + day count.                                    |
| `presentation/widgets/overlays/coin_counter.dart`     | Soft-currency balance.                                             |
| `presentation/widgets/overlays/energy_indicator.dart` | Hearts / energy meter.                                             |
| `presentation/widgets/overlays/profile_summary.dart`  | Avatar + name quick view.                                          |

### Presentation — Widgets `painters/` (3 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/painters/playground_path_painter.dart` | Gradient + glow journey path.                             |
| `presentation/widgets/painters/dashed_path_painter.dart`  | Dashed variant for incomplete segments.                       |
| `presentation/widgets/painters/node_glow_painter.dart`     | Radial glow halo around active nodes.                        |

### Presentation — Widgets `path/` (3 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/path/animated_path.dart`        | One-shot reveal animation path.                                   |
| `presentation/widgets/path/completed_path.dart`       | Solid styling for completed segments.                             |
| `presentation/widgets/path/path_segment.dart`        | Single segment between two nodes.                                 |

### Presentation — Widgets `rewards/` (4 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/rewards/reward_popup.dart`      | Popup orchestrator (XP + coins + chest).                           |
| `presentation/widgets/rewards/reward_chest.dart`      | Animated chest using `chest_animation.dart`.                       |
| `presentation/widgets/rewards/xp_reward.dart`         | "+XP" floating counter.                                            |
| `presentation/widgets/rewards/coin_reward.dart`       | "+Coins" floating counter.                                         |

### Presentation — Widgets `sheets/` (4 files)

| File                                                  | Purpose                                                            |
|-------------------------------------------------------|--------------------------------------------------------------------|
| `presentation/widgets/sheets/boss_bottom_sheet.dart`  | Confirm CTA + difficulty preview for boss nodes.                   |
| `presentation/widgets/sheets/mission_bottom_sheet.dart` | Daily mission details + accept CTA.                             |
| `presentation/widgets/sheets/library_bottom_sheet.dart` | Library building details + accept CTA.                           |
| `presentation/widgets/sheets/reward_bottom_sheet.dart` | Post-completion summary + claim CTA.                             |

---

### Layer counts

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
| Presentation — widgets `painters/`         | 3     |
| Presentation — widgets `path/`              | 3     |
| Presentation — widgets `rewards/`           | 4     |
| Presentation — widgets `sheets/`           | 4     |
| **Total**                                   | **93** |

---

## 15. Open Questions / Future Enhancements

- Should boss challenges require a special currency or just hearts?
- Do we add multiplayer/co-op boss gates later?
- Daily/weekly limited nodes for re-engagement?
- Adaptive difficulty (FR-11.5) — wire to the `weakness_tracker` feature.
- Should `decorations/` become configurable per-world (different biomes per exam track)?
- `playground_camera.dart` follow-mode for accessibility (auto-follow next unlocked node)?

---

**End of plan.**
