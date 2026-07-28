# Playground — Future Expansion

> **Audience:** AI agents and developers planning future iterations of the Playground feature.
> **Purpose:** Document the long-term expansion vectors — multiple worlds, seasonal maps, weather, guilds, events, AI mentor buildings, premium areas, co-op missions, and additional learning centers — together with the architectural touch points and constraints each expansion imposes on the current implementation.
> **Related docs:** [Folder Structure](./PLAYGROUND_FOLDER_STRUCTURE.md), [Widget Architecture](./PLAYGROUND_WIDGET_ARCHITECTURE.md), [Data Flow](./PLAYGROUND_DATA_FLOW.md), [State Management](./PLAYGROUND_STATE_MANAGEMENT.md), [Gameplay Flow](./PLAYGROUND_GAMEPLAY_FLOW.md).

---

## 1. Multiple Worlds

The first version of Playground ships with a single world (e.g. "BCS World"). Future versions will support **multiple worlds** for different exam tracks, locales, or curricula.

### 1.1 Concept

| World              | Subjects                                  | Buildings                                         |
|--------------------|--------------------------------------------|---------------------------------------------------|
| BCS World          | Bangladesh, Intl. Affairs, English, GK, Math | Academy (theory), Library (practice)             |
| Bank World         | Banking, Finance, English, GK, Math       | Vault (formulas), Trading Floor (mock interviews)  |
| Primary Teacher    | Pedagogy, Bengali, Science, Math, GK       | Library, Museum (history), Studio (lesson plans) |
| University World   | Subject packs for university admissions    | Research Hall, Lab                                |

### 1.2 Architectural touch points

- **Entity**: `WorldEntity` gains `worldId` and `biomeId`. `NodeEntity` stays unchanged.
- **Repository**: `PlaygroundRepository.getWorldMap(userId, worldId)`.
- **Use case**: `GetWorldMap` takes a `worldId`. `worldMapProvider.family<…, String>` keys by `worldId`.
- **Provider**: `worldMapProvider.family<…, String>` becomes a family. Add `selectedWorldIdProvider` (`StateProvider<String>`).
- **World selector**: a new widget `WorldSelector` (carousel / pill row) at the top of `WorldMapScreen`.
- **Builder**: `world_map_builder.dart` switches decoration sets by `biomeId`.

### 1.3 Constraints

- The map's `(x, y)` geometry is recomputed per world — the polyline algorithm remains the same.
- The HUD stays the same across worlds.
- Cross-world progression is allowed only via explicit world-completion events.

### 1.4 Files to add

| New file                                              | Purpose                                              |
|-------------------------------------------------------|------------------------------------------------------|
| `domain/entities/world_meta_entity.dart`              | Static world metadata (title, theme, biome, image).  |
| `data/models/world_meta_model.dart`                   | JSON ↔ world meta.                                   |
| `presentation/widgets/cards/world_card.dart`          | Card representing a world in the selector.           |
| `presentation/widgets/world/world_selector.dart`     | The carousel.                                         |
| `presentation/utils/biome_palette.dart`               | Per-biome color tokens.                              |

### 1.5 Files to modify

- `playground_provider.dart`: split `worldMapProvider` into family + add `selectedWorldIdProvider`.
- `world_map_screen.dart`: insert `WorldSelector` above the map.
- `node_position_calculator.dart`: accept world width hint per biome.

---

## 2. Seasonal Maps

A *seasonal map* is a temporary variant of a base world, themed around a holiday or campaign.

### 2.1 Concept

- Winter BCS World: snowy backgrounds, frosty nodes, snowman decorations.
- Eid Special: lanterns, festive banners, special "Eid Boss" with bonus rewards.
- Back-to-School: chalkboard-themed buildings, paper-airplane decorations.

### 2.2 Architectural touch points

- **Configuration**: `seasonal_config.dart` lives in `lib/features/playground/presentation/utils/`. It is loaded at boot and consulted by `world_map_builder.dart`.
- **Asset bundle**: per-season assets live under `assets/playground/seasons/{seasonId}/`.
- **Decoration swap**: `playground_decorations_provider` (new) returns decoration overrides per `seasonId`.
- **Reward rule**: seasonal bosses reward a unique badge.

### 2.3 Constraints

- A season never breaks the core progression — even if a user misses a season, their XP and unlocks persist.
- Seasonal decorations never alter node logic.
- Seasonal assets must be lazy-loaded to keep bundle size small.

### 2.4 Files to add

| New file                                            | Purpose                                          |
|-----------------------------------------------------|--------------------------------------------------|
| `presentation/utils/seasonal_config.dart`           | Static season metadata (id, dates, theme).        |
| `presentation/widgets/decorations/seasonal/*`       | Per-season decoration variants.                  |
| `presentation/providers/seasonal_provider.dart`     | Exposes the active season config.                |

### 2.5 Files to modify

- `world_map_builder.dart`: prefer seasonal decoration if available.
- `playground_background.dart`: switch to seasonal sky gradient if configured.

---

## 3. Weather System

A *weather* system makes the world feel alive and adds a tiny optional gameplay layer.

### 3.1 Concept

| Weather        | Effect on map                                              | Effect on gameplay                                       |
|----------------|------------------------------------------------------------|-----------------------------------------------------------|
| Sunny          | Default.                                                   | None.                                                      |
| Cloudy         | Slight desaturation, slower cloud drift.                   | None.                                                      |
| Rainy          | Animated rain layer; puddle reflections on path.           | Hearts regenerate +1 per hour.                            |
| Snowy          | Animated snow layer; snowy mountains.                     | XP from completed nodes × 1.1.                              |
| Foggy          | Reduced visibility on far nodes; subtle vignette.          | Boss nodes easier (timer +5 s per question).                |
| Aurora         | Animated aurora overlay; rare.                              | Doubles streak-shield drop chance for the day.              |

Weather is cosmetic + lightweight mechanic — never a *requirement*.

### 3.2 Architectural touch points

- **Provider**: `weatherProvider` (new). Returns `WeatherState { kind, intensity, expiresAt }`.
- **Layer**: new `widgets/decorations/weather_layer.dart` that overlays ambient effects (rain / snow / aurora).
- **Painter**: `painters/weather_particle_painter.dart` for the per-frame particles.
- **Effects**: a small `WeatherEffectsApplier` utility applies gameplay multipliers.
- **Config**: `weather_config.dart` controls probabilities and durations.

### 3.3 Constraints

- Weather effects never break accessibility. They have a static fallback for reduced motion.
- Weather never locks content (no "you must wait for sunny to play").
- Weather is opt-out for users who disable animations entirely.

### 3.4 Files to add

| New file                                                   | Purpose                              |
|------------------------------------------------------------|--------------------------------------|
| `presentation/providers/weather_provider.dart`             | Active weather state.                |
| `presentation/utils/weather_config.dart`                   | Probabilities + durations.           |
| `presentation/widgets/decorations/weather_layer.dart`      | Overlay layer.                       |
| `presentation/widgets/painters/weather_particle_painter.dart` | Painter for rain/snow.            |
| `presentation/utils/weather_effects_applier.dart`          | Gameplay multipliers.                |

---

## 4. Guild System

A *guild* is a small group of learners (3–8) who progress together.

### 4.1 Concept

- A guild has a shared "guild map" layered on top of each member's world map.
- Members can send each other "energy" (hearts) and "boosts" (XP multipliers).
- Guild bosses are co-op challenges (see [Co-op Missions](#8-co-op-missions)).
- Guild leaders can set a *weekly focus* (subject).

### 4.2 Architectural touch points

- **Domain**: new `GuildEntity` (`id`, `name`, `members`, `focus`, `weeklyXp`, `level`). New `GuildRepository`.
- **Provider**: `guildProvider`, `guildMembersProvider`, `guildActivityProvider`.
- **UI**: new screens `GuildScreen`, `GuildDetailScreen`, `GuildInviteSheet`.
- **Map integration**: `playground_building.dart` gains a `GuildHall` variant.
- **Notification**: a `GuildActivityProvider` emits events that flow into the existing `notifications` feature.

### 4.3 Constraints

- Guilds are *opt-in*. A user without a guild never sees guild-only content.
- Guild state never overrides individual progression.
- Guild size is capped to keep UX simple.

### 4.4 Files to add

| New file                                             | Purpose                              |
|------------------------------------------------------|--------------------------------------|
| `domain/entities/guild_entity.dart`                 | Guild aggregate.                      |
| `data/repositories/guild_repository_impl.dart`      | Guild CRUD.                            |
| `presentation/screens/guild_screen.dart`            | Guild hub.                             |
| `presentation/screens/guild_detail_screen.dart`     | One guild's detail.                   |
| `presentation/widgets/sheets/guild_invite_sheet.dart` | Invite flow.                       |
| `presentation/widgets/buildings/guild_hall_building.dart` | Guild hall on the map.            |
| `presentation/widgets/cards/guild_card.dart`        | Guild preview card.                    |

---

## 5. Events

Events are **time-limited** campaigns that overlay special challenges on the world.

### 5.1 Concept

| Event type          | Description                                                       |
|---------------------|-------------------------------------------------------------------|
| Limited boss        | A special boss node with a unique skin and exclusive badge.        |
| Themed sprint       | A 7-day "complete 10 nodes" challenge with leaderboard.            |
| Charity drive       | Each completion donates 1 coin to a "charity meter".                 |
| Co-op weekend       | Guild bosses only — see Co-op Missions.                            |
| Anniversary         | Anniversary celebration with new world.                              |

### 5.2 Architectural touch points

- **Domain**: `EventEntity` (`id`, `kind`, `startsAt`, `endsAt`, `config`, `progress`, `rewards`).
- **Provider**: `activeEventsProvider`, `eventProgressProvider`.
- **UI**: `event_banner.dart` (top banner) and `event_detail_screen.dart`.
- **Logic**: `event_rules_engine.dart` applies rules per event type.
- **Persistence**: events are timestamped; expired events gracefully disappear.

### 5.3 Constraints

- Events never gate core progression.
- Events must not exceed 1% of the screen real estate (a banner + maybe a tab).
- Events never lock content behind payments (premium can boost, not gate).

### 5.4 Files to add

| New file                                            | Purpose                            |
|-----------------------------------------------------|------------------------------------|
| `domain/entities/event_entity.dart`                 | Event aggregate.                   |
| `presentation/providers/events_provider.dart`      | Active events.                     |
| `presentation/widgets/cards/event_banner.dart`      | Top banner.                         |
| `presentation/screens/event_detail_screen.dart`    | Event detail.                       |
| `presentation/utils/event_rules_engine.dart`       | Per-event rule logic.               |

---

## 6. AI Mentor Buildings

AI Mentor Buildings are special buildings where the user can ask the AI tutor for **playground-specific** help.

### 6.1 Concept

- A "Mentor Hall" building per subject.
- The user asks the mentor: *"How do I beat the next boss?"*
- The mentor reviews the user's weak categories, suggests a study path, and (optionally) spawns a *custom mini-node* with AI-curated questions.

### 6.2 Architectural touch points

- **Building variant**: `widgets/buildings/ai_mentor_building.dart` (extends `PlaygroundBuilding`).
- **Bottom sheet**: `widgets/sheets/ai_mentor_bottom_sheet.dart`.
- **Deep-link**: passes `subjectId` to the `ai_tutor` feature.
- **Custom node**: a new `ChallengeEntity.type = aiCurated` with `questionIds` chosen by the AI.
- **Provider**: `aiMentorProvider` for chat history and suggestions.

### 6.3 Constraints

- AI Mentor Buildings are *not* unlocked by boss gates — they are always available, but require hearts to ask a question.
- AI Mentor responses never reveal the answer to current questions (anti-cheat).
- AI Mentor chats are scoped to a subject.

### 6.4 Files to add

| New file                                                     | Purpose                                  |
|--------------------------------------------------------------|------------------------------------------|
| `presentation/widgets/buildings/ai_mentor_building.dart`     | The building.                            |
| `presentation/widgets/sheets/ai_mentor_bottom_sheet.dart`    | The sheet.                                |
| `presentation/providers/ai_mentor_provider.dart`             | Mentor chat history.                      |
| `domain/usecases/ask_ai_mentor.dart`                         | Use case to ask the mentor.               |

---

## 7. Premium Areas

Premium areas are *gated sections* of the map offering richer rewards.

### 7.1 Concept

- A premium district behind a "Premium Gate" node.
- Includes:
  - Bonus XP nodes.
  - Exclusive mentor buildings.
  - Cosmetic node skins.
  - Daily bonus chest (premium only).

### 7.2 Architectural touch points

- **Entity**: `NodeEntity.gate == premium` (new value).
- **Building variant**: any building can have `premiumOnly: true`.
- **Repository**: `PlaygroundRepository.unlockPremiumDistrict(userId)`.
- **Provider**: `premiumStatusProvider` reads from `subscription` feature.
- **UI**: `premium_gate_node.dart`, `premium_district_overlay.dart`.

### 7.3 Constraints

- Premium is **never** the only path to progression — the entire free world remains complete-able.
- Premium visuals must be tasteful, not flashy — gold and clean, never gaudy.
- Premium never grants gameplay advantages that the free tier can't earn via effort.

### 7.4 Files to add

| New file                                                  | Purpose                                |
|-----------------------------------------------------------|----------------------------------------|
| `presentation/widgets/nodes/premium_gate_node.dart`       | The gate node.                          |
| `presentation/widgets/decorations/premium_ribbon.dart`    | Visual ribbon on premium content.       |
| `presentation/widgets/sheets/premium_unlock_sheet.dart`   | CTA to subscribe.                       |

---

## 8. Co-op Missions

Co-op missions are *synchronous* challenges where multiple users collaborate.

### 8.1 Concept

- A "Guild Boss" node unlocks for the entire guild.
- Up to 4 members can join the live session.
- Each member answers questions; combined score determines outcome.
- Rewards are split based on contribution.

### 8.2 Architectural touch points

- **Domain**: new `CoopSessionEntity` (`id`, `bossLevelId`, `participants`, `state`, `startedAt`, `endedAt`).
- **Realtime backend**: Firestore real-time listeners + `onSnapshot` (or future WebSocket integration).
- **Provider**: `coopSessionProvider` (a `StreamProvider`).
- **UI**: `coop_lobby_screen.dart`, `coop_battle_screen.dart`, `coop_results_screen.dart`.
- **Reuse**: `challenge_screen.dart` is reused inside `coop_battle_screen.dart` per participant.

### 8.3 Constraints

- Co-op is opt-in and clearly labeled.
- Free users can join co-op sessions hosted by their guild.
- Co-op never blocks solo progression.
- Co-op latency > 800 ms triggers a graceful fallback ("Continue solo").

### 8.4 Files to add

| New file                                                 | Purpose                            |
|----------------------------------------------------------|------------------------------------|
| `domain/entities/coop_session_entity.dart`              | Session aggregate.                  |
| `data/datasources/coop_remote_datasource.dart`           | Realtime API.                       |
| `presentation/screens/coop_lobby_screen.dart`            | Pre-battle lobby.                   |
| `presentation/screens/coop_battle_screen.dart`           | Live battle.                        |
| `presentation/screens/coop_results_screen.dart`          | Post-battle results.                |
| `presentation/widgets/cards/coop_member_card.dart`       | Member status card.                 |

---

## 9. Future Learning Centers

Future Learning Centers are *theme-based* buildings beyond Academy and Library.

### 9.1 Concept

| Center              | Purpose                                                       |
|---------------------|---------------------------------------------------------------|
| Museum              | Historical deep-dives, exhibits, AR tours.                     |
| Studio              | Lesson-plan creation for primary-teacher track.                |
| Trading Floor       | Mock interviews for bank exams.                                |
| Research Hall       | University-admissions research and essay practice.             |
| Workshop            | Hands-on coding / data analysis labs.                         |
| Forum               | Community-curated tips and question discussions.                |
| Newsroom            | Daily current-affairs briefings (auto-updated).                |

### 9.2 Architectural touch points

- **Building variants**: each center has its own subclass of `PlaygroundBuilding`.
- **Sheet**: each center has a tailored bottom sheet (e.g. `MuseumBottomSheet`).
- **Deep-link**: each center deep-links into a feature or external integration.
- **Discovery**: new centers appear as buildings after completing subject-relevant bosses.

### 9.3 Constraints

- Centers never duplicate Academy / Library responsibilities.
- Centers are introduced *gradually* — one per quarter.
- Centers never block core progression.

### 9.4 Files to add (per center)

| New file                                                  | Purpose                                  |
|-----------------------------------------------------------|------------------------------------------|
| `presentation/widgets/buildings/{center}_building.dart`   | The building.                            |
| `presentation/widgets/sheets/{center}_bottom_sheet.dart`  | The sheet.                                 |
| `presentation/widgets/decorations/{center}_sign.dart`     | Decoration that signals the center.      |

### 9.5 Cross-cutting pattern for new centers

1. Define a `CenterId` enum.
2. Add it to `world_config.dart`.
3. Implement the building + sheet + decoration.
4. Wire deep-link into the bottom sheet.
5. Add a small "What's new" hint when the user first visits.

---

## 10. Roadmap Considerations

### 10.1 Release tiers

| Tier       | Adds                                                                |
|------------|----------------------------------------------------------------------|
| v1.0       | Single world, no seasons, no weather.                                 |
| v1.1       | Seasonal maps (light).                                                |
| v1.2       | Weather system.                                                       |
| v1.3       | Multiple worlds (BCS / Bank / Primary).                              |
| v2.0       | Guild system + Co-op missions.                                       |
| v2.1       | AI Mentor Buildings.                                                  |
| v2.2       | Premium Areas.                                                        |
| v3.0       | Future Learning Centers (Museum, Studio, Forum, Newsroom).           |

### 10.2 Performance impact per tier

| Tier       | Bundle size impact | Frame-budget impact                                  |
|------------|--------------------|------------------------------------------------------|
| v1.1       | +5–10 MB seasonal assets. | Negligible.                                 |
| v1.2       | +1–2 MB particle textures. | +0.3 ms/frame in active weather.        |
| v1.3       | +2–4 MB per world biome.   | Negligible (assets lazy-loaded).        |
| v2.0       | +3 MB realtime plumbing.   | +0.5 ms/frame on co-op screens.          |
| v2.1       | +2 MB AI response caching. | Negligible.                                |
| v2.2       | +1 MB premium decorations.  | Negligible.                                |

### 10.3 Migration strategy

Each expansion must be:

- **Backward-compatible**: existing users keep their XP and unlocks.
- **Forward-isolated**: a new feature lives behind a flag (`feature_flags.dart`).
- **Telemetry-rich**: every expansion ships with explicit events for analytics.
- **Reversible**: a flag can disable a feature without code changes.

---

## 11. Architectural Invariants (always true)

The following invariants **must not** break across expansions:

1. **Domain purity.** Domain imports no Flutter, no Firestore.
2. **Repository abstraction.** Every read/write goes through `PlaygroundRepository`.
3. **Provider invalidation.** Every write invalidates the smallest possible subset of providers.
4. **Stateless widgets.** Widgets are stateless by default; state lives in providers.
5. **Token-driven design.** All sizes, colors, durations, and copy come from tokens.
6. **Reduced-motion respect.** Every animation respects `MediaQuery.disableAnimations`.
7. **Single-responsibility widgets.** Each widget has one job — see [Widget Architecture](./PLAYGROUND_WIDGET_ARCHITECTURE.md) §7.
8. **Accessibility floor.** Hit targets ≥ 48 dp, color contrast ≥ WCAG AA, semantics on every interactive element.

---

## 12. Cross-Document Map

| If you want to…                                            | Open                                                                |
|------------------------------------------------------------|---------------------------------------------------------------------|
| Add a new building variant                                 | [Widget Architecture](./PLAYGROUND_WIDGET_ARCHITECTURE.md) §8.2     |
| Add a new entity / provider for an expansion               | [Data Flow](./PLAYGROUND_DATA_FLOW.md) §2, §5                       |
| Add a new state slice                                      | [State Management](./PLAYGROUND_STATE_MANAGEMENT.md) §2             |
| Add a new animation (e.g. weather drift)                  | [Animation System](./PLAYGROUND_ANIMATION_SYSTEM.md) §6             |
| Find where to place a new file                            | [Folder Structure](./PLAYGROUND_FOLDER_STRUCTURE.md) §5             |

---

**End of document.**