# Prep Quest — Application Flow Guide

> **Audience:** this is the canonical planning doc for the mobile (non-admin) app. It explains what's already built, what's missing, the order in which to build the rest, and how to automate the work.

> **Last updated:** 2026-07-26
> **Scope:** User-facing app only. The admin app is intentionally excluded (it lives in `lib/features/admin`, `lib/admin_host_app.dart`, `lib/src/admin_host/`, and the `/admin...` deeplink branch).

---

## 1. One-paragraph elevator pitch

Prep Quest is a BCS/Bank/Primary-Teacher exam-prep app whose **visual and emotional center is a Duolingo-style "Playground" world map**. Tapping a level node opens a level, the level opens a challenge, the challenge feeds a quiz or reading task, completing it grants XP / coins / streak, and the next node unlocks. Around the Playground orbit Home, Guidebook, Question Bank, Daily Quiz, Mock Tests, AI Tutor, AI Exam Simulator, Smart Prompt, Leaderboard, Weakness Tracker, Subscription, Gamification, Profile, and Settings. Admin (out of scope here) manages the content for those features.

---

## 2. Current state of the repo (the honest picture)

The repository is **"playground-first, scaffold-everywhere-else"**. Out of 19 user-facing features, only one — `playground` — has a real implementation; the other 18 are folder skeletons with empty Dart files waiting to be filled. The router, theme, and config are real; Firebase, network (Dio), DI (GetIt), Hive, secure storage, localization, and Riverpod providers are all stubbed.

### 2.1 What is real today (concrete inventory)

| Layer | Status | Files |
|---|---|---|
| **Entry point** | ✅ Real | `lib/main.dart`, `lib/bootstrap.dart`, `lib/app.dart`, `lib/router.dart` |
| **Admin routing bridge** | ✅ Real (excluded) | `lib/admin_host_app.dart`, `lib/src/admin_host/*` |
| **Config singleton** | ✅ Real | `lib/core/config/app_config.dart` (env, locale, themeMode, isProduction). No Firebase/Hive init yet. |
| **Theme** | ✅ Real | `lib/core/theme/app_theme.dart` (Material 3, Duolingo-inspired primary `#0E7C4A`). |
| **Constants** | ✅ Real | `lib/core/constants/*` (14 design-token files: colors, sizes, spacing, strings, gradients, fonts, assets, API endpoints, etc.) |
| **Router** | ⚠️ Partial | `/` → `/playground`. Only `/widget-builder` and `/playground` are routed. No auth, no tabs. |
| **Playground presentation** | ✅ Mostly real (~24,800 LOC across 148 files) | All CustomPaint map, paths, nodes, buildings, decorations, HUD overlays, rewards, sheets, legend. |
| **Playground domain** | ❌ Empty stubs | `data/*`, `domain/*` (entities, repository, 6 use-cases, models, datasource) |
| **Playground provider** | ❌ Empty stub | `presentation/providers/playground_provider.dart` |
| **Playground secondary screens** | ❌ Empty stubs | `world_map_screen`, `level_screen`, `challenge_screen`, `boss_challenge_screen`, `level_completed_screen` |
| **Other 17 user features** | ❌ Empty stubs | splash, onboarding, authentication, home, profile, settings, daily_quiz, mock_test, question_bank, guidebook, leaderboard, gamification, weakness_tracker, notifications, subscription, smart_prompt, ai_tutor, ai_exam_simulator |
| **Core services** | ❌ Empty stubs | network (Dio), providers (theme/language), services (auth/notification/storage/cache/etc.), di (GetIt), security (secure storage), cache (Hive), localization, errors, extensions, utils |
| **Shared layer** | ❌ Empty stubs | enums, models, repositories, mixins, typedefs, validators, widgets |
| **Firebase wiring** | ❌ Configs empty | `firebase.json`, `.firebaserc`, `firestore.rules`, `storage.rules` all 0 bytes. TS Cloud Functions code is staged in `functions/` but not deployed. |
| **Tests** | ⚠️ Smoke only | `test/widget_test.dart` (boots PlaygroundScreen) |
| **Dependencies** | ✅ Conservative | `go_router ^17.3.0`, `flutter_riverpod ^2.5.1`, `lottie ^3.5.1`, `vector_math`, `crypto`, `collection`, `intl`, `uuid`, `web`. **Missing:** `firebase_*`, `dio`, `hive`, `get_it`, `flutter_secure_storage`, `flutter_local_notifications`, `in_app_purchase`, `sign_in_with_apple`, `google_sign_in`. |

### 2.2 The single-screen app right now

When a user opens the app today they land on `PlaygroundScreen`, which renders a beautifully painted map showing seven hardcoded progression steps:

```
Foundations (completed) → Grammar (completed) → Mathematics (active, 65%)
   → Library (milestone) → Daily Reward (reward) → Mock Test (regular)
   → BCS Boss (boss)
```

The top-bar HUD is hardcoded to "Adnan / Level 12 / 4820 XP / 1240 coins / 4 of 5 energy / 7-day streak / Premium". None of the visible controls do anything yet — `_openProfile`, `_openXp`, `_openCoins`, `_openEnergy`, `_openStreak` are empty, and the bottom nav routes every tap back to `/playground`.

### 2.3 The documented vision

`Plans/appflow.md` already enumerates 32 screens grouped under the Free / Premium / Admin access matrix in `Plans/design.md`. That vision is what the rest of this document is working toward.

---

## 3. The architectural pattern to follow

You have already chosen Clean Architecture + Riverpod + GoRouter. Use it everywhere new.

```
lib/features/<feature>/
├── data/                  # datasources, models, repository_impl
├── domain/                # entities, repositories (abstract), usecases
└── presentation/
    ├── constants/
    ├── extensions/
    ├── providers/         # Riverpod providers
    ├── screens/
    ├── utils/
    └── widgets/
```

Cross-cutting infrastructure lives in `lib/core/` (config, theme, network, services, providers, di, security, cache, localization, errors) and reusable building blocks in `lib/shared/` (enums, models, repositories, mixins, typedefs, validators, widgets).

The `playground` feature has done the **presentation layer correctly** but skipped the **data and domain layers**. Every new feature should fill all three layers.

---

## 4. The target end-to-end application flow

This is the user journey we are building toward. Every flow that runs on a phone or web browser is listed; the admin panel is excluded.

### 4.1 Boot sequence

```
main()
  → bootstrap()
       → WidgetsFlutterBinding.ensureInitialized()
       → AppConfig.bootstrap()          # environment, locale, themeMode
       → AdminLocation.isAdminPath()    # decides mobile vs admin mount
       → runApp(AdminHostApp(...))
            ├── if admin URL → AdminApp   (out of scope)
            └── else         → PrepQuestApp
                                → MaterialApp.router (createAppRouter)
                                → ProviderScope (Riverpod root)
```

### 4.2 First-time user

```
Splash (lottie + brand)            # NEW
  ↓
Onboarding (3-5 intro screens)     # NEW
  ↓
Auth — phone + OTP                 # NEW (or fallback anonymous for MVP)
  ↓
Profile setup                      # NEW
  ↓
Playground (home)                  # ✅ screen exists, needs data
```

### 4.3 Returning user

```
Splash (auto-routes by auth state)
  ↓
Playground (resumes last position)
```

### 4.4 Main app shell (after Playground becomes truly interactive)

The bottom nav exposes four logical surfaces: **Play (Playground)**, **Learn (Guidebook)**, **Quiz (Daily Quiz + Question Bank + Mock Tests hub)**, **Profile**. From anywhere, the user can:

```
Playground tab      → /playground (world map)
Learn tab           → /guidebook → /guidebook/subject/:id → /guidebook/chapter/:id
Quiz tab            → /quiz  (hub with Daily / Practice / Mock Tests / AI Sim)
                     → /quiz/daily
                     → /quiz/practice/:subjectId
                     → /quiz/practice/:subjectId/question/:qId
                     → /quiz/mock  (list of mock tests)
                     → /quiz/mock/:testId           (instructions → exam → result)
                     → /quiz/ai-simulator           (premium)
Profile tab         → /profile
                     → /profile/edit
                     → /profile/achievements
                     → /profile/settings
                            → /settings/language
                            → /settings/theme
                            → /settings/notifications
                            → /settings/privacy
                            → /settings/subscription
                            → /settings/support
```

Cross-cutting shortcuts (premium subscription, leaderboard, weakness dashboard, AI Tutor, Smart Prompt, notifications inbox) are reached from the top-bar HUD chips, the side drawer, or deep-links triggered from Playground buildings.

### 4.5 Playground in-game flow (the heart of the app)

```
PlaygroundScreen (world map)
  ↓ tap active node
LevelScreen                         # NEW
  ↓ tap start
ChallengeScreen                     # NEW (one of: reading, MCQ, mini-game, AI)
  ↓ complete all challenges
LevelCompletedScreen (XP + coins + rewards popup)   # NEW
  ↓ unlock_next_level mutation
PlaygroundScreen (next node now active)
  ↓ reach milestone
AcademyBuilding / LibraryBuilding bottom sheet    # partial — sheet UI exists, routing doesn't
  ↓ tap "Read chapter"
GuidebookChapterReaderScreen
  ↓ tap "Practice"
QuestionPracticeScreen
  ↓ reach boss node
BossChallengeScreen                 # NEW
  ↓ defeat boss
RewardPopup (XP / chest / badge) + next world teaser
```

The full list of sub-routes the playground documentation expects lives in `docs/playground/PLAYGROUND_SCREEN_ARCHITECTURE.md`:

```
/playground                       ✅ routed (PlaygroundScreen)
/playground/map                   ❌ empty stub
/playground/level/:id             ❌ empty stub
/playground/challenge/:id         ❌ empty stub
/playground/boss/:id              ❌ empty stub
/playground/completed             ❌ empty stub
```

### 4.6 The complete screen map (non-admin)

Pulled and cross-referenced with `Plans/appflow.md`. ✅ = screen exists in code; ⚠️ = stubbed file only; ⬜ = not even stubbed.

| # | Screen | Current | Where it lives | Reachable from |
|---|---|---|---|---|
| 1 | Splash | ⬜ | `features/splash` | Cold start |
| 2 | Onboarding | ⬜ | `features/onboarding` | First run only |
| 3 | Login (phone) | ⬜ | `features/authentication` | Splash, profile-setup retry |
| 4 | OTP verify | ⬜ | `features/authentication` | Login |
| 5 | Profile setup | ⬜ | `features/authentication` or `profile` | OTP success (first run) |
| 6 | Playground | ✅ | `features/playground/presentation/screens/playground_screen.dart` | Auth complete, "Play" tab |
| 7 | World Map | ⚠️ | `playground_screen` already IS the world map | (de-dup — see §6.1) |
| 8 | Level | ⚠️ | `playground/presentation/screens/level_screen.dart` | Tap node |
| 9 | Challenge | ⚠️ | `playground/presentation/screens/challenge_screen.dart` | Tap start in level |
| 10 | Boss Challenge | ⚠️ | `playground/presentation/screens/boss_challenge_screen.dart` | Tap boss node |
| 11 | Level Completed | ⚠️ | `playground/presentation/screens/level_completed_screen.dart` | Last challenge done |
| 12 | Home dashboard | ⬜ | `features/home` | Optional — Playground already serves as home |
| 13 | Guidebook home | ⬜ | `features/guidebook` | "Learn" tab, Academy bottom-sheet |
| 14 | Subject detail | ⬜ | `features/guidebook` | Tap subject |
| 15 | Chapter list | ⬜ | `features/guidebook` | Tap subject |
| 16 | Chapter reader | ⬜ | `features/guidebook` | Tap chapter |
| 17 | Bookmarks | ⬜ | `features/guidebook` | Profile, reader overflow |
| 18 | Search | ⬜ | `features/guidebook` (or `shared`) | Top-bar search |
| 19 | Question bank home | ⬜ | `features/question_bank` | "Quiz" tab → Practice |
| 20 | Question detail / practice | ⬜ | `features/question_bank` | Tap question |
| 21 | Daily quiz | ⬜ | `features/daily_quiz` | "Quiz" tab, reward node, streak chip |
| 22 | Mock test hub | ⬜ | `features/mock_test` | "Quiz" tab, Mock Test node |
| 23 | Mock test instructions | ⬜ | `features/mock_test` | Tap test |
| 24 | Mock test exam | ⬜ | `features/mock_test` | Start button |
| 25 | Mock test result | ⬜ | `features/mock_test` | Submit exam |
| 26 | Leaderboard | ⬜ | `features/leaderboard` | Side drawer, result screen CTA |
| 27 | Weakness dashboard | ⬜ | `features/weakness_tracker` | Profile, result screen CTA |
| 28 | AI Tutor sheet | ⬜ | `features/ai_tutor` | After wrong answer (premium) |
| 29 | AI Exam Simulator setup | ⬜ | `features/ai_exam_simulator` | "Quiz" tab (premium) |
| 30 | Smart Prompt | ⬜ | `features/smart_prompt` | Side drawer, HUD chip (premium) |
| 31 | Subscription paywall | ⬜ | `features/subscription` | Premium feature lock, settings |
| 32 | Billing / Manage subscription | ⬜ | `features/subscription` | Paywall CTA, settings |
| 33 | Achievements / rewards | ⬜ | `features/gamification` (or `profile`) | Profile tab |
| 34 | Profile | ⬜ | `features/profile` | "Profile" tab |
| 35 | Settings | ⬜ | `features/settings` | Profile overflow |
| 36 | Notifications inbox | ⬜ | `features/notifications` | Top-bar bell |
| 37 | Drawer (side) | ⬜ | `shared/widgets` | AppBar leading |
| 37 | Error / empty / offline states | ⬜ | `shared/widgets` (already exists as stubs) | Global |

The big deltas vs. `Plans/appflow.md` are: (a) Playground is consolidated into one root screen with sub-routes rather than a separate Home dashboard, and (b) the four bottom-nav tabs collapse some hub screens (Quiz = daily + practice + mock tests in one).

---

## 5. Build phases — what to focus on and in what order

The phases are sequenced so that **each one ends with a runnable, demoable state**. Don't move to the next phase until the current one works on at least one real device.

### Phase 0 — Make the playground data-driven (1–2 weeks)

Goal: replace the hardcoded map with a real provider + repository wired to in-memory seed data.

1. Fill in the four domain entities (`WorldEntity`, `LevelEntity`, `NodeEntity`, `ChallengeEntity`) and the six use-cases (`GetWorldMap`, `GetLevel`, `GetChallenges`, `StartLevel`, `CompleteLevel`, `UnlockNextLevel`).
2. Fill in the data models with `fromJson`/`toJson` and the repository implementation (start with a stub `FakePlaygroundRemoteDataSource` returning seed JSON, not Firestore yet).
3. Implement a real Riverpod `PlaygroundNotifier` (extend `AsyncNotifier`) with providers for the world map, current level, selected node, level progress, and a central controller.
4. Refactor `PlaygroundScreen` to read from the provider instead of `_PlaygroundStageData` (keep `_PlaygroundStageData` as a fixture for tests/preview).
5. Wire the existing bottom-sheet widgets (mission, library, reward, boss) to the new providers.
6. Add unit tests for the layout engine, the path generator, and the new use-cases.

**Done when:** the playground shows real data (still seeded), node taps actually open the mission/reward bottom sheets, and completing a challenge unlocks the next node.

### Phase 1 — Core infrastructure (1–2 weeks, parallelizable)

Goal: the boring plumbing every other feature needs.

1. Add to `pubspec.yaml`: `dio ^5`, `get_it ^7`, `hive ^2`, `hive_flutter ^1`, `flutter_secure_storage ^9`, `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `flutter_local_notifications ^17`, `sign_in_with_apple`, `google_sign_in`, `in_app_purchase ^3`, `connectivity_plus ^6`, `logger ^2`, `package_info_plus`, `device_info_plus`, `permission_handler ^11`, `share_plus ^9`, `cached_network_image ^3`, `flutter_svg ^2`, `pinput ^5`, `country_code_picker ^3`.
2. Wire each new package's bootstrap step inside `AppConfig.bootstrap` (Hive boxes, Firebase init, notification permission, etc.).
3. Implement the empty `core/services/*` (analytics, auth, cache, connectivity, language, notification, permission, share, storage, subscription, theme).
4. Implement the empty `core/network/*` (Dio client + auth/logger/retry interceptors, `NetworkInfo`).
5. Implement the empty `core/di/service_locator.dart` (GetIt registration of every service + repository).
6. Implement `core/providers/theme_provider.dart` and `language_provider.dart` as Riverpod state notifiers.
7. Implement `core/errors/failures.dart`, `core/exceptions/app_exception.dart`, `core/error_handler.dart`.
8. Implement `core/extensions/*`, `core/helpers/app_helpers.dart`, `core/utils/*`.
9. Implement `core/security/secure_storage.dart`.
10. Wire `core/localization/app_localizations.dart` (or move to Flutter's `gen-l10n` flow with an `app_en.arb` / `app_bn.arb`).
11. Decide and implement one of two patterns for shared `typedefs/result.dart` and `errors`.

**Done when:** `flutter analyze` is clean, `flutter test` is green, and `flutter run` on at least Android and Web boots through Splash with theme/language actually persisted.

### Phase 2 — Auth + first-run flow (1 week)

Goal: replace the missing pre-Playground screens.

1. Splash screen (`features/splash`).
2. Onboarding (3-5 carousel pages).
3. Phone + OTP auth (`features/authentication`). Firebase Auth phone provider behind `AuthService`. Use `pinput` for the OTP boxes.
4. Profile setup (name, exam track BCS/Bank/Primary Teacher, district).
5. Add auth-aware redirect in `lib/router.dart`: if no user → `/onboarding` or `/login`; if user without profile → `/profile-setup`; else → `/playground`.

**Done when:** a fresh install walks Splash → Onboarding → Login → OTP → Profile Setup → Playground, and on relaunch the user lands on Playground directly.

### Phase 3 — Wire the rest of the playground (1–2 weeks)

Goal: the world map is fully interactive, not just paintable.

1. Implement `WorldMapScreen` (or de-dup — see §6.1), `LevelScreen`, `ChallengeScreen`, `BossChallengeScreen`, `LevelCompletedScreen` — these stubs already exist.
2. Add the missing routes in `lib/router.dart` (`/playground/level/:id`, `/playground/challenge/:id`, `/playground/boss/:id`, `/playground/completed`).
3. Connect node taps (`isInteractive` already wired in `_PlaygroundStageData._buildNodeVisual`) to the router.
4. Implement the existing widget stubs: `widgets/chest_animation.dart`, `node_glow_animation.dart`, `unlock_animation.dart`, `rewards/coin_reward.dart`, `rewards/reward_chest.dart`, `rewards/reward_popup.dart`, `decorations/particles.dart`, `cards/level_progress_card.dart`, `cards/mission_card.dart`.
5. Connect the top-bar callbacks (`_openProfile`, `_openXp`, `_openCoins`, `_openEnergy`, `_openStreak`) to detail screens (most of these can be modal sheets for now).
6. Decide bottom-nav routing: today every tap re-routes to `/playground`. Make "Learn", "Quiz", "Profile" go to their respective hubs.

**Done when:** a level can be opened, challenges played, completion celebrated, and the next node unlocked — all with persistent state (in-memory for now).

### Phase 4 — Firestore + Cloud Functions wiring (2 weeks)

Goal: real backend instead of fake data sources.

1. Fill `firebase.json`, `.firebaserc`, `firestore.rules`, `storage.rules`.
2. Deploy the existing `functions/` TypeScript code (OTP, AI proxy, AI tutor, smart prompt, mock exam generator, XP/coins awards, badge unlocks, leaderboard, analytics, content CRUD).
3. Replace each `*RemoteDataSource` stub with a Firestore + Functions implementation (one feature at a time, starting with `playground` then `guidebook` then `question_bank`).
4. Implement `AuthService` against Firebase Auth.
5. Define the canonical Firestore schema: `users/{uid}`, `users/{uid}/progress`, `worlds/{worldId}`, `worlds/{worldId}/levels/{levelId}`, `levels/{levelId}/challenges/{challengeId}`, `subjects/{subjectId}/chapters/{chapterId}`, `questions/{questionId}`, `mockTests/{testId}`, `attempts/{attemptId}`, `leaderboard/{period}`, `subscriptions/{uid}`.

**Done when:** the playground + a basic guidebook load from Firestore, and completing a level writes back to `users/{uid}/progress`.

### Phase 5 — Learn / Quiz / Profile / Settings hubs (2–3 weeks)

Goal: every remaining hub screen has a working v1.

1. Guidebook (`features/guidebook`): home, subjects, chapter list, chapter reader, bookmarks, search.
2. Question bank (`features/question_bank`): filterable list, detail/practice with explanation, AI Tutor hook.
3. Daily quiz (`features/daily_quiz`): 20-question session, scoring, streak continuation.
4. Mock test (`features/mock_test`): hub, instructions, exam, result.
5. Profile + Settings (`features/profile`, `features/settings`): view/edit profile, theme, language, notifications, privacy, support.
6. Achievements / Rewards (`features/gamification`): badge grid, XP/level timeline.

**Done when:** the four bottom-nav tabs each have a fully usable screen, and the cross-cutting flows (bookmark from reader → bookmarks screen, attempt result → weakness dashboard) work end-to-end.

### Phase 6 — Premium + AI features (1–2 weeks)

Goal: paywall works, premium features are gated, AI flows are usable.

1. Subscription paywall (`features/subscription`) + billing management, gated by `subscriptionService`.
2. AI Tutor sheet (`features/ai_tutor`) reachable from wrong-answer state.
3. AI Exam Simulator (`features/ai_exam_simulator`).
4. Smart Prompt (`features/smart_prompt`).
5. Leaderboard (`features/leaderboard`) — global, weekly, friends.
6. Weakness tracker (`features/weakness_tracker`).
7. Notifications (`features/notifications`).

**Done when:** a free user hits a premium feature, gets a paywall, can purchase (or fall back to demo-billing on web), and the feature unlocks.

### Phase 7 — Polish, ship (1 week)

1. Localization fully wired (Bangla + English at minimum).
2. Empty / error / offline states for every screen.
3. Accessibility pass (semantic labels — `playground_strings.dart` already has them; extend to the rest).
4. Performance pass (rebuild-runs for the playground map, list virtualization in question bank, Firestore query caching).
5. Smoke + golden tests for the playground; integration tests for auth + one full level.

---

## 6. Architecture decisions to make early

These are choices the codebase doesn't make yet and they will affect every later feature.

### 6.1 `WorldMapScreen` vs `PlaygroundScreen`

The current implementation has only `PlaygroundScreen`, which IS the world map. The router only mounts `/playground`. There is also an empty `world_map_screen.dart` and an empty `widgets/world_map.dart`. Decide one of:

- **(A) Recommended.** De-dup. Delete the empty `world_map_screen.dart` and the empty `widgets/world_map.dart`. The "world map" is the `PlaygroundScreen` and the active widget is `widgets/map/playground_map.dart`. Sub-routes (`/playground/level/:id` etc.) belong under `PlaygroundScreen` push.
- (B) Keep both. Refactor `PlaygroundScreen` to a thin shell that hosts `WorldMapScreen` and sub-route stacks.

(A) is faster and matches the existing code structure; (B) is more orthodox for "world map as its own concept".

### 6.2 Backend choice

You have two viable paths; both reuse the same code because the datasource is already abstracted behind `data/datasources/*`:

- **Firestore + Cloud Functions.** The `functions/` directory already has all the TS modules. Lowest effort given what's there.
- **Your own REST API (e.g. Django/Fastify/Express).** Cleaner long-term, more flexibility, but you'd be writing the `functions/` code again.

Either way, the Flutter side changes minimally because of the repository abstraction.

### 6.3 State management

Riverpod is already in `pubspec.yaml`. Stick with it. Use:

- `FutureProvider` / `StreamProvider` for read-only fetches.
- `AsyncNotifierProvider` for mutations (complete challenge, unlock level).
- `StateNotifierProvider` (or `NotifierProvider`) for UI-only state (selected tab, sheet visibility).

### 6.4 Local persistence

Hive (already stubbed in `core/cache/hive_manager.dart`) is the lightest. Pair it with `flutter_secure_storage` for tokens and any PII. Avoid SharedPreferences for non-trivial objects.

### 6.5 Localization

Either `flutter_localizations` + `intl` `gen-l10n` with `.arb` files, or a custom approach (`core/localization/app_localizations.dart`). The custom file is currently empty. The `intl` package is in `pubspec.yaml` but not configured. Recommend `gen-l10n` for production.

### 6.6 Theming

Already real (`AppTheme.light/dark`). Add a `ThemeModeNotifier` provider and wire it through `core/providers/theme_provider.dart`. The HUD color tokens already exist in `playground_constants.dart` — when dark mode is enabled, audit these and provide overrides.

---

## 7. Automation tasks — how to finish this faster

The work is large (18 features × 3 layers + infra). The way to make it tractable is **heavy automation**. Here is a concrete plan you can run today.

### 7.1 Conventions and tooling to put in place

1. **Adopt Mason or Hygen-style code generation** for the data/domain/presentation skeleton. Every feature has the same shape — make a template and one command fills it.
2. **Install `flutter_gen` and `build_runner`** so that `assets.dart`, `colors.dart`, and JSON serialization (`json_serializable`) are generated, not hand-maintained.
3. **Install `flutter_lints ^6.0.0`** (already there) and enforce `very_good_analysis` or `pedantic` to keep the codebase consistent.
4. **Add `melos`** for multi-package workflows (if/when the repo splits).
5. **Add `dart_code_metrics`** for the maintainability gates (cyclomatic complexity, function length).

### 7.2 Scripts to wire

Add the following to a `tool/` directory at the repo root:

| Script | Purpose |
|---|---|
| `tool/new_feature.dart` | One command → creates the full Clean Architecture skeleton with the right file paths and Dart headers. |
| `tool/audit_empty.dart` | Lists every empty Dart file in `lib/features/` and `lib/core/` (we already inventoried them — script-ize it so it runs in CI). |
| `tool/coverage_gate.dart` | Fails CI if coverage drops below a threshold. |
| `tool/firestore_seed.dart` | Seeds a dev Firestore with one world, three subjects, one mock test, one daily quiz, a couple of achievements. |
| `tool/firebase_emulators_up.sh` | Boots Auth + Firestore + Functions + Storage emulators. |
| `tool/dev_run.sh` | `flutter run` with `--dart-define=APP_ENV=dev` + `firebase emulators:start` + `cd functions && npm run dev`. |
| `tool/release_build.sh` | Tags, builds Android App Bundle, iOS archive, web release, runs `flutter analyze`, uploads to Firebase App Distribution. |
| `tool/import_questions.dart` | One-off importer: takes a CSV/JSON from the content team and writes to Firestore emulator. |

### 7.3 CI pipeline (suggested)

```
.github/workflows/ci.yml
  1. flutter pub get
  2. dart run build_runner build --delete-conflicting-outputs
  3. flutter analyze --no-fatal-infos
  4. flutter test --coverage
  5. dart run tool/audit_empty.dart   # fails if a non-stub file is empty
  6. cd functions && npm ci && npm run build && npm test
  7. firebase emulators:exec --only firestore,auth,functions "flutter test integration_test"
  8. Build web release (smoke)
  9. Build Android debug APK (smoke)
```

`tool/audit_empty.dart` is the single most important automation: it prevents new features from shipping as 0-byte files the way most of the existing ones do.

### 7.4 Daily-driver recipes

Use these frequently so the work compounds:

- **Find a feature stub:** `rg -l "^$" lib/features/<name>` (or the audit script).
- **Find what depends on an entity:** `rg "<EntityName>" lib/`.
- **Find dead routes:** `rg "AppRoutes\." lib/` (every AppRoutes constant must be reachable).
- **Find empty widgets:** `rg -l "TODO" lib/` after seeding each feature.
- **Visualize the playground map after changes:** `flutter run -d chrome` and click around.

### 7.5 What to automate FIRST (in order)

If you only have time for three automations, do these:

1. **`tool/new_feature.dart`** — a feature generator that writes data/domain/presentation skeletons from one command.
2. **`tool/audit_empty.dart`** — a CI gate that fails the build when a feature file is empty.
3. **`tool/firebase_emulators_up.sh`** plus Firestore seed — so every feature can be wired to a real backend in <2 minutes.

Everything else is polish on top of those three.

---

## 8. Immediate next steps (the next 7 days)

If you do nothing else this week, do this:

1. Run `tool/audit_empty.dart` (write it first if needed) and put the output in `docs/appflow/empty_audit.md`. Now you have a real backlog of 100+ files to fill.
2. Replace the seven hardcoded `_PlaygroundStageData._steps` with a call to a new `worldMapProvider` that returns a hardcoded seed list. This forces you to write the first entity, use-case, and provider.
3. Wire `/playground/level/:id` and `/playground/completed` to the existing empty stub screens (just `Scaffold(body: Center(child: Text('level $id'))`) so you can verify the router plumbing is healthy.
4. Decide Question 6.1 (PlaygroundScreen vs WorldMapScreen) and write a one-paragraph ADR into `docs/appflow/decisions/0001-playground-screen-dedup.md`.
5. Add the missing `pubspec.yaml` dependencies and run `flutter pub get` + `flutter analyze`.

After those five things, the rest of the project is mechanical — fill phases 0 through 7 in order, with `tool/new_feature.dart` and `tool/audit_empty.dart` doing the boring parts.

---

## 9. Risks and how to mitigate them

| Risk | Likelihood | Mitigation |
|---|---|---|
| Scope explosion — 32 screens × 3 layers | High | Phase-gate every release; ship Phase 3 to TestFlight / Play internal before Phase 4. |
| Firestore costs from the world map being read on every screen | Medium | Cache world layout in Hive; only re-fetch when world version changes. |
| CustomPaint playground map performance on low-end Android | Medium | Use `RepaintBoundary` everywhere (already in place) and a static `shouldRepaint` for painters. |
| Riverpod over-engineering for screen-local state | Medium | Reserve Riverpod for cross-screen state and backend mirrors. Use `StatefulWidget` for purely local UI. |
| Firebase Functions TS code drifting from Flutter expectations | Medium | Define the request/response DTOs in one place (`shared/models/*`) and generate TS + Dart from JSON Schema. |
| Bangla typography regressions | Medium | Add a `Typography` test with golden files for both Latin and Bangla samples. |
| Empty-file rot (the current state) | High | Run `tool/audit_empty.dart` in CI; fail the build when a feature file is empty without an explicit `// stub: <reason>` comment. |

---

## 10. Appendix — File counts for the build backlog

To set expectations: today there are **686 Dart files in `lib/features/`**, of which roughly **148 are real (all in `playground`)** and the other **538 are empty stubs**. Once the audit + skeleton generator is in place, the average feature costs about 8 real files (data × 3 + domain × 5 + presentation × 12 = ~20 files) but only ~8 of those need new logic — the rest are plumbing that the generator writes. Net: **~8 focused implementation files per feature × 17 features + the playground domain layer ≈ 150 substantive files** to write to reach Phase 7. With automation that drops the manual count to roughly half.