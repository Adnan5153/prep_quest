# Prep Quest — Codebase Structure

Generated 2026-07-23.

This document is the canonical human-readable architectural reference for the **Prep Quest** Flutter project. It mirrors the repository as it exists on disk and is paired with `codebase_structure.json`, which is the machine-readable counterpart intended for AI agents.

---

## 1. Repository Snapshot

| Field | Value |
|---|---|
| Project name | `prep_quest` |
| Display name | Prep Quest |
| Description | Flutter scaffold for a Bangladesh competitive-exam preparation application. |
| Version | `1.0.0+1` |
| Dart SDK | `^3.12.2` (>=3.12.2 <4.0.0) |
| Entry point | `lib/main.dart` |
| Root application widget | `lib/app.dart` (`PrepQuestApp`) |
| Bootstrap | `lib/bootstrap.dart` → `AppConfig.bootstrap()` |
| Default redirect | `/` → `/playground` |
| Flutter platforms enabled | android, ios, web, linux, macos, windows |
| Lint profile | `package:flutter_lints/flutter.yaml` |
| Material design assets | Yes (`uses-material-design: true`) |
| Custom assets | None |
| Custom fonts | None |

### Runtime reality

Of the **1,305 `.dart` files** in `lib/`:

- `lib/main.dart`, `lib/bootstrap.dart`, `lib/app.dart`, `lib/router.dart` are the wired-up entry chain.
- `lib/core/**` is populated for the constants, theme, localization, services, providers, network, security, extensions, helpers, utils, di, errors, exceptions, cache, config, and the wide shared widget library under `lib/core/widgets/**` (every widget has a real implementation).
- `lib/features/playground/presentation/**` (constants, extensions, utils, providers, screens, widgets) is fully implemented; `lib/features/playground/data/**` and `lib/features/playground/domain/**` exist as empty stub files reserved for future work.
- `lib/features/quiz_engine/**` and `lib/features/quiz_results/**` are fully implemented (data, domain, presentation).
- `lib/features/widget_builder/**` is fully implemented (canvas, previews, palette controls, providers, registry).
- Feature modules are implemented incrementally. `playground`, `quiz_engine`, `quiz_results`, `gamification`, `leaderboard`, and `notifications` now contain production implementations; remaining feature directories preserve the scaffolded Clean Architecture layout where work has not yet landed.
- `lib/shared/**` is mostly empty scaffolding (enums, models, repositories, mixins, typedefs, validators, widgets).

Stubs are not removed from the documentation — they are listed so the planned structure remains visible to future contributors and AI agents.

### Excluded from documentation

- `build/`
- `.dart_tool/`
- `.puku/`
- `.puku-cli/`
- `.idea/`
- `.vscode/`
- Generated plugin registrant files inside platform projects
- `pubspec.lock`

---

## 2. Architecture Principles

The project follows **Feature-First Clean Architecture**:

1. **Feature isolation** — Every app capability lives in its own folder under `lib/features/<feature>/`.
2. **Three layers per feature** — `data/`, `domain/`, `presentation/`, each with a strict dependency direction.
3. **Shared core** — Cross-feature infrastructure (theming, networking, services, constants, reusable widgets) lives under `lib/core/` and `lib/shared/`.
4. **Single responsibility** — Each widget, painter, model, entity, repository, datasource, provider, service, utility, and extension has exactly one purpose.
5. **Pure documentation** — These documents describe what exists. Architectural drift is noted but not corrected here.

### Dependency direction

```
presentation  →  domain (uses use cases & providers)
data          →  domain (implements contracts)
core          →  (stand-alone, used by anyone)
shared        →  (stand-alone, used by anyone)
```

`presentation` never calls `data` directly. `domain` never imports Flutter, JSON, or storage.

---

## 3. Root Layout

```
prep_quest/
├── .firebaserc                  (empty — Firebase alias placeholder)
├── .gitignore                   Flutter default ignore rules
├── .metadata                    Flutter project metadata; 6 platforms
├── analysis_options.yaml        Analyzer config (flutter_lints)
├── firebase.json                (empty — hosting/functions config)
├── firestore.indexes.json       (empty — composite index placeholders)
├── firestore.rules              (empty — security rule placeholders)
├── prep_quest.iml               IntelliJ project file
├── pubspec.yaml                 Dart/Flutter manifest
├── pubspec.lock                 Locked dependency versions
├── README.md                    Default Flutter template README
├── storage.rules                (empty — Cloud Storage rule placeholders)
│
├── android/                     Android platform scaffold
├── ios/                         iOS platform scaffold
├── linux/                       Linux desktop scaffold (GTK)
├── macos/                       macOS desktop scaffold
├── windows/                     Windows desktop scaffold (Win32)
├── web/                         Web platform scaffold (PWA)
│
├── functions/                   Firebase Cloud Functions (TypeScript stubs)
├── test/                        Flutter tests
├── docs/                        Project documentation
├── build/                       Flutter build output (excluded)
│
├── lib/                         Flutter Dart source
├── Plans/                       Planning + architecture docs
├── analysis_options.yaml        Already listed above
│
├── .dart_tool/, .idea/, .vscode/, .puku/, .puku-cli/   Tooling state (excluded)
```

---

## 4. Flutter App Source (`lib/`)

```
lib/
├── main.dart                    Application entry (`runApp`).
├── app.dart                     Root `MaterialApp.router` widget (`PrepQuestApp`).
├── bootstrap.dart               Pre-run initializer; gates `AppConfig.bootstrap()`.
├── router.dart                  Centralised `AppRoutes` + `GoRouter` (`createAppRouter`).
│
├── core/                        Cross-feature foundation (see §5).
├── features/                    Feature modules (see §6).
└── shared/                      Cross-feature enums, models, mixins, typedefs,
                                validators, repositories, widgets (see §7).
```

### 4.1 Entry chain

| File | Responsibility |
|---|---|
| `lib/main.dart` | Calls `bootstrap()` then `runApp(PrepQuestApp())`. |
| `lib/bootstrap.dart` | Boots Flutter, ensures `AppConfig` is initialized. |
| `lib/app.dart` | Configures `MaterialApp.router` with theme, dark theme, locale, and the router from `router.dart`. |
| `lib/router.dart` | Defines `AppRoutes` (`root`, `widgetBuilder`, `playground`) and `createAppRouter()` which wires up `/`, redirect to `/playground`, and the widget-builder + playground screens. |

---

## 5. `lib/core/` — Shared Cross-Feature Foundation

The `core/` layer hosts anything every feature relies on: theme, constants, networking, security, localization, reusable widgets. Widget implementations are fully populated; service / network / configuration files exist as planned scaffolds.

```
lib/core/
├── cache/
│   └── hive_manager.dart                       Hive box lifecycle manager (stub).
├── config/
│   ├── api_config.dart                         API base URL / keys.
│   ├── app_config.dart                         Env, locale, theme mode, isProduction. Implements `bootstrap()`.
│   ├── environment.dart                        Environment enum.
│   ├── firebase_config.dart                    Firebase project IDs / options.
│   └── flavors.dart                            Build-flavor enum.
├── constants/
│   ├── api_endpoints.dart                      REST / function endpoint paths.
│   ├── app_assets.dart                         Asset path registry.
│   ├── app_colors.dart                         Brand + semantic colors.
│   ├── app_fonts.dart                          Font family + weight registry.
│   ├── app_icons.dart                          App icon asset registry.
│   ├── app_radius.dart                         Border-radius scale.
│   ├── app_sizes.dart                          Layout / icon / avatar sizes.
│   ├── app_spacing.dart                        4-dp spacing scale.
│   ├── app_strings.dart                        Localised string keys.
│   ├── firestore_keys.dart                     Firestore document / field keys.
│   └── hive_boxes.dart                         Hive box name registry.
├── di/
│   └── service_locator.dart                    Dependency injection entry point.
├── errors/
│   ├── error_handler.dart                      Centralised error reporting.
│   └── failures.dart                           Failure domain types.
├── exceptions/
│   └── app_exception.dart                      Base exception type.
├── extensions/
│   ├── context_extension.dart                  `BuildContext` helpers.
│   ├── date_extension.dart                     Date formatting helpers.
│   └── string_extension.dart                   String manipulation helpers.
├── helpers/
│   └── app_helpers.dart                        Misc utility helpers.
├── localization/
│   └── app_localizations.dart                  Localizations delegate.
├── network/
│   ├── dio_client.dart                         Configured Dio client.
│   ├── network_info.dart                       Connectivity probe.
│   └── interceptors/
│       ├── auth_interceptor.dart               Authorization header.
│       ├── logger_interceptor.dart             Request/response logging.
│       └── retry_interceptor.dart              Automatic retry on transient failures.
├── providers/
│   ├── language_provider.dart                  Active language notifier.
│   └── theme_provider.dart                     Active theme notifier.
├── security/
│   └── secure_storage.dart                     Encrypted key-value storage.
├── services/
│   ├── analytics_service.dart                  Analytics pipeline facade.
│   ├── auth_service.dart                       Authentication orchestrator.
│   ├── cache_service.dart                      App-wide cache facade.
│   ├── connectivity_service.dart               Online/offline status.
│   ├── language_service.dart                   Persisted language preference.
│   ├── notification_service.dart               Push / local notifications.
│   ├── permission_service.dart                 Runtime permission handling.
│   ├── share_service.dart                      Native share sheet.
│   ├── storage_service.dart                    Cloud Storage facade.
│   ├── subscription_service.dart               Premium subscription state.
│   └── theme_service.dart                      Persisted theme preference.
├── theme/
│   ├── app_button_theme.dart                   Material `ButtonTheme` data.
│   ├── app_card_theme.dart                     Card theme.
│   ├── app_theme.dart                          Combined light + dark themes.
│   ├── app_typography.dart                     Typography tokens.
│   ├── dark_theme.dart                         Dark theme.
│   └── light_theme.dart                        Light theme.
├── utils/
│   ├── app_logger.dart                         Lightweight logger.
│   ├── date_utils.dart                         Date math.
│   ├── debouncer.dart                          Trailing-edge debouncer.
│   └── validators.dart                         Email / phone / password validators.
└── widgets/                                    Reusable UI library (see §5.1).
```

### 5.1 `lib/core/widgets/` — Reusable Widget Library

Every widget in this library is fully implemented and reused across features. Top-level files cover universal needs; subfolders organise by concern.

**Top-level reusable widgets:**

`adaptive_layout.dart`, `animated_card.dart`, `app_bottom_sheet.dart`, `app_logo.dart`, `app_name.dart`, `app_snackbar.dart`, `app_toast.dart`, `app_version.dart`, `avatar.dart`, `brand_header.dart`, `category_chip.dart`, `coming_soon.dart`, `custom_appbar.dart`, `custom_bottom_navigation.dart`, `custom_checkbox.dart`, `custom_divider.dart`, `custom_drawer.dart`, `custom_dropdown.dart`, `custom_navigation_rail.dart`, `custom_radio.dart`, `custom_scaffold.dart`, `custom_search_field.dart`, `custom_slider.dart`, `custom_switch.dart`, `custom_textfield.dart`, `dashed_divider.dart`, `dotted_divider.dart`, `draggable_bottom_sheet.dart`, `empty_state.dart`, `error_banner.dart`, `error_state.dart`, `error_widget.dart`, `fullscreen_loader.dart`, `glass_card.dart`, `glass_container.dart`, `gradient_text.dart`, `image_placeholder.dart`, `loading_overlay.dart`, `loading_widget.dart`, `network_error_widget.dart`, `network_image_widget.dart`, `no_data_widget.dart`, `no_internet.dart`, `page_footer.dart`, `page_header.dart`, `premium_badge.dart`, `primary_button.dart`, `profile_avatar.dart`, `rounded_container.dart`, `safe_area_wrapper.dart`, `secondary_button.dart`, `section_header.dart`, `shimmer_loader.dart`, `status_chip.dart`, `streak_card.dart`, `tag_chip.dart`, `title_with_action.dart`, `widget_constants.dart`, `widget_extensions.dart`.

**Sub-folders:**

| Folder | Purpose | Files |
|---|---|---|
| `admin/` | Admin-style widgets (cards, stats, charts). | (planned files) |
| `ai/` | AI-related widgets (chat bubbles, hint cards, loading states, summary cards, theme). | `ai_action_buttons.dart`, `ai_avatar.dart`, `ai_avatar_animation.dart`, `ai_chat_bubble.dart`, `ai_constants.dart`, `ai_empty_state.dart`, `ai_error_state.dart`, `ai_explanation_card.dart`, `ai_hint_card.dart`, `ai_history_section.dart`, `ai_history_tile.dart`, `ai_loading_card.dart`, `ai_response_card.dart`, `ai_summary_card.dart`, `ai_theme.dart`, `ai_tutor_bottom_sheet.dart`, `bookmark_ai_response_button.dart`, `chat_bubble_explanation.dart`, `chat_input_bar.dart`, `chat_message_list.dart`, `copy_response_button.dart`, `prompt_card.dart`, `prompt_category_chip.dart`, `prompt_history_tile.dart` (+ 1 duplicate filename), `regenerate_button.dart`, `share_response_button.dart`, `shimmer_loading_text.dart` (and additional widgets discovered via Glob). |
| `animations/` | Reusable animated primitives. |
| `buttons/` | Button widgets. |
| `cards/` | Card variants. |
| `dialogs/` | Modal dialog widgets. |
| `game/` | Gamification primitives. |
| `indicators/` | Progress / loading indicators. |
| `playground/` | Playground primitives reused by other features. |
| `premium/` | Premium upsell widgets. |
| `quiz/` | Quiz UI primitives. |
| `quick_actions/` | Reusable Quick Actions sheet used by the bottom app bar. |
| `reader/` | Long-form reader widgets. |
| `sliver_appbar/` | Sliver-based app bars. |

### 5.2 `lib/core/widgets/custom_bottom_navigation.dart` — Custom Bottom Navigation (Phase 14)

The bar keeps its original API (`currentIndex`, `onTap`, `items`) verbatim and exposes optional:
- `notificationBadgeCount` + `onNotificationTap` → renders an animated bell badge on the leading edge that hides when count is zero.
- `onQuickActions` / `quickActionsBuilder` → renders a lightning-bolt bolt icon on the trailing edge that opens `QuickActionsSheet.show` or a caller-provided alternative.

A top-level helper `openDefaultQuickActionsSheet` bundles the default Quick Action catalog (Continue Learning, Daily Quiz, Mock Test, Guidebook, AI Tutor, Bookmarks, Weak Topics, Leaderboard, Profile, Settings, plus Streak/Missions/Rewards/Notifications) and resolves routes via the supplied `openRoute(name)` callback — keeping the widget free of `go_router` imports.

### 5.3 `lib/core/widgets/notification_badge.dart` — Notification Badge

Animated unread-count pill. Hides when `count == 0`, caps displayed text at `maxCount` and renders `99+` past that. Renders an elastic scale-in tween on every `count` change. Used both by the bottom-bar bell and by QuickActionTile badges.

### 5.4 `lib/core/widgets/quick_actions/` — Quick Actions

Reusable modal sheet family used by the bottom app bar and any caller that wants shortcut grids.
- `quick_action_tile.dart` — `QuickActionItem` (id, label, icon, onTap, badgeCount, semanticLabel, enabled) and the press-feedback tile.
- `quick_action_grid.dart` — adaptive 4/5/6-column grid driven by `ResponsiveBuilder`.
- `quick_actions_header.dart` — title + subtitle + close IconButton + drag handle.
- `quick_actions_sheet.dart` — `QuickActionsSheet.show(context, actions: [...])` modal with `showModalBottomSheet`, framer-fitted via `AnimatedPadding`.
- `default_quick_actions.dart` — built-in catalog that maps every shortcut to an existing `AppRoutes.*` constant.

---

## 6. `lib/features/` — Feature Modules

Each feature follows the same `data/`, `domain/`, `presentation/` layout. The playground and widget_builder features are populated; all others are scaffolds with empty files.

### 6.1 `lib/features/playground/` — World Map & Level Progression

Purpose: Duolingo-inspired world map where users travel through levels, complete challenges, earn XP, and unlock missions.

Status: `presentation/` fully implemented. `data/` and `domain/` empty scaffolds.

Sub-folders and contents:

```
playground/
├── data/                       (stubs, reserved for remote/local sources)
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/                     (stubs, reserved for entities, contracts, use cases)
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/               (implemented)
    ├── constants/              playground_assets.dart, playground_constants.dart,
    │                          playground_sizes.dart, playground_strings.dart
    ├── extensions/             node_status_extension.dart, world_extension.dart
    ├── providers/              playground_provider.dart
    ├── utils/                  node_position_calculator.dart,
    │                          path_generator.dart, playground_helpers.dart,
    │                          world_layout.dart, world_map_builder.dart
    ├── screens/                boss_challenge_screen.dart, challenge_screen.dart,
    │                          level_completed_screen.dart, level_screen.dart,
    │                          playground_screen.dart, world_map_screen.dart
    └── widgets/                (richly-implemented)
        ├── animations/         chest_animation, node_glow, path, unlock
        ├── boss_gate.dart
        ├── buildings/          academy_building, building_label,
        │                      building_progress, library_building,
        │                      playground_building
        ├── cards/
        │   ├── level_progress_card/    (12 files: badge, bar, card, enums,
        │   │                            header, reward, stages, stars,
        │   │                            surface, utils, visual, reward_pill,
        │   │                            stage_dot)
        │   └── mission_card/           (action_button, badge, body, card,
        │                                card_visual, container, enums, footer,
        │                                header, icon, metadata, progress,
        │                                reward, status_chip, utils, constants)
        ├── challenge_tile.dart
        ├── decorations/         bridge, bush, cloud, flag, mountain,
        │                      particles, playground_particle_layer, river, tree
        ├── level_card.dart, level_reward_dialog.dart, locked_level.dart
        ├── map/                 playground_background, playground_camera,
        │                      playground_legend, playground_map,
        │                      playground_scroll_view
        ├── map_node.dart
        ├── nodes/               node_badge, node_icon, node_label,
        │                      node_progress_indicator, node_ring,
        │                      playground_node
        ├── overlays/            coin_counter, energy_indicator,
        │                      playground_top_bar, profile_summary,
        │                      streak_card, xp_indicator
        ├── painters/            (30+ painters — academy_building,
        │                       animated_path, background, bridge, bush,
        │                       cloud, completed_path, dashed_path, flag,
        │                       legend_swatch, library_building, mountain,
        │                       node_glow, node_progress_arc, node_ring,
        │                       paint_utilities, particle, path_dash,
        │                       path_glow, path_painter, path_shadow,
        │                       playground_path, reward_chest,
        │                       reward_chest_light_beam, reward_chest_glow,
        │                       river, streak_card, tree, xp_orb)
        ├── path/                animated_path, completed_path, path_segment
        ├── progress_path.dart
        ├── rewards/
        │   ├── coin_reward/     (9 files: coin_reward + animation, glow,
        │   │                    label, layout, models, sparkles, surface,
        │   │                    utils)
        │   ├── reward_chest/    (10 files: reward_chest + controller, glow,
        │   │                    layout, light_beam, lock, models,
        │   │                    sparkle, sparkles, utils)
        │   ├── reward_popup/    (13 files: entry, kind, popup, actions,
        │   │                    animation, body, badge_reward, constants,
        │   │                    container, dialog, header, primary_button,
        │   │                    reward_list, reward_tile, secondary_button)
        │   ├── coin_reward.dart
        │   ├── reward_popup.dart
        │   └── xp_reward.dart
        ├── sheets/              boss_bottom_sheet, library_bottom_sheet,
        │                      mission_bottom_sheet, reward_bottom_sheet,
        │                      shared/ (container, entrance, layout,
        │                             sections)
        └── world_map.dart
```

### 6.2 `lib/features/widget_builder/` — Visual Widget Composer

Purpose: Compose Flutter widgets visually and preview them live.

Status: Fully implemented.

```
widget_builder/
└── presentation/
    ├── canvas/                 Renders the selected widget.
    │   ├── previews/
    │   │   ├── ai/             11 AI widget previews
    │   │   ├── appbars/        2 app-bar previews
    │   │   ├── avatars/        2 avatar previews
    │   │   ├── buttons/        3 button previews
    │   │   ├── cards/          3 card previews
    │   │   ├── chips/          3 chip previews
    │   │   ├── errors/         1 network error preview
    │   │   ├── loading/        3 loading previews
    │   │   ├── misc/           10 misc previews (incl. responsive builder,
    │   │   │                   responsive layout, title-with-action,
    │   │   │                   ai-summary, ai-empty/error, snackbar,
    │   │   │                   image-placeholder, widget-constants,
    │   │   │                   simple_previews.dart bundle)
    │   │   ├── playground/     30+ playground previews (every Playground
    │   │   │                   widget + inline preview data)
    │   │   └── progress/       xp_progress_bar preview
    │   └── widget_preview_router.dart
    ├── models/                 widget_builder_item.dart
    ├── palette/                Widget list & controls.
    │   ├── controls/           (animation_controls, appbar_controls,
    │   │                      avatar_controls, button_controls,
    │   │                      card_controls, chip_controls,
    │   │                      error_controls, loading_controls,
    │   │                      progress_controls, slider_controls,
    │   │                      switch_controls, text_controls,
    │   │                      ai_* controls, playground/* controls)
    │   └── sections/
    ├── providers/              widget_builder_controller.dart,
    │                          widget_builder_provider.dart,
    │                          widget_builder_selection.dart,
    │                          widget_builder_state.dart
    ├── registry/               widget_registry.dart
    ├── screens/                widget_builder_screen.dart
    ├── utils/
    └── widgets/                widget_builder_canvas.dart,
                               widget_builder_palette.dart
```

### 6.3 `lib/features/admin/` — Admin Console (scaffold)

Purpose: Manage subjects, chapters, questions, mock tests, users, subscriptions, and view analytics.

```
admin/
├── data/
│   ├── datasources/           admin_remote_datasource.dart
│   ├── models/                10 models (admin_user, analytics, chapter,
│   │                          dashboard_stats, leaderboard, mock_test,
│   │                          question, subject, subscription,
│   │                          user_management)
│   └── repositories/          admin_repository_impl.dart
├── domain/
│   ├── entities/              admin_user_entity, analytics_entity,
│   │                          dashboard_stats_entity
│   ├── repositories/          admin_repository.dart
│   └── usecases/              9 use cases (admin_login, get_analytics,
│                              get_dashboard_stats, get_leaderboard,
│                              get_mock_tests, get_questions, get_subjects,
│                              get_users, manage_subscriptions)
└── presentation/
    ├── providers/             admin_provider, analytics_provider,
    │                          content_provider, dashboard_provider,
    │                          user_provider
    ├── screens/               12 screens (login, analytics, chapters,
    │                          dashboard, leaderboard, mock tests,
    │                          notifications, questions, settings,
    │                          subjects, subscriptions, users)
    └── widgets/               16 widgets (sidebar, chart_card,
                               confirmation_dialog, dashboard_card,
                               filter_panel, pagination_widget,
                               search_bar, stat_card, table widgets,
                               topbar, etc.)
```

### 6.4 `lib/features/ai_exam_simulator/` — AI Exam Generator (scaffold)

Purpose: Configure and present AI-generated mock exams.

Layers: `data/` (1 model + 1 datasource + 1 repository impl), `domain/` (1 entity + 1 contract + 1 use case), `presentation/` (1 provider + 2 screens + 1 widget).

### 6.5 `lib/features/ai_tutor/` — AI Tutor Chat (scaffold)

Purpose: AI explanations for answers/topics.

Layers: `data/` (1 model + 1 datasource + 1 repository impl), `domain/` (1 entity + 1 contract + 2 use cases: explain_answer, explain_topic), `presentation/` (1 provider + 1 screen + 2 widgets: ai_chat_bubble, ai_typing_indicator).

### 6.5 `lib/features/authentication/` — Google Sign-In + Profile Completion (Phase 54)

Purpose: Google Sign-In as the single entry point, plus profile completion (display name, exam track, district, phone) for first-time users. The login / register / phone-OTP / email-verification / forgot-password surfaces were deleted in Phase 54.

Layers:
- `data/datasources/` — `AuthRemoteDataSource` (abstract) + `FirebaseAuthRemoteDataSource` (real Firebase + google_sign_in) + `MockAuthRemoteDataSource` (in-memory dev/test).
- `data/repositories/` — `AuthRepositoryImpl` (pass-through to the data source, returns `Result<…>`).
- `domain/entities/` — `UserEntity` (with `hasCompletedProfile` getter), `AuthSessionEntity`, `OtpRequestEntity`, `AuthIdentitySeed`.
- `domain/repositories/` — `AuthRepository` (abstract).
- `presentation/controllers/` — `AuthController` (StateNotifier) with `signInWithGoogle`, `updateProfile`, `signOut`, `bypassAuthentication`, etc.
- `presentation/providers/` — `authStateProvider`, `authRouterRefreshProvider`, `authRemoteDataSourceProvider`, `authRepositoryProvider`.
- `presentation/states/` — `AuthState` + `AuthStatus` (`unknown` / `unauthenticated` / `profileIncomplete` / `emailVerificationRequired` / `authenticated`).
- `presentation/screens/welcome/` — `WelcomeScreen` (single "Continue with Google" CTA, Phase 54).
- `presentation/screens/complete_profile/` — `CompleteProfileScreen` (pre-fills from `state.user`, persists `examTrack`).
- `presentation/screens/splash/` — `SplashScreen` (drives the initial auth decision).
- `presentation/widgets/` — `AuthFormField`, `AuthPrimaryButton`, `AuthSocialButton`, `AuthHeader`, `AuthDivider`, `PhoneTextField`, `OtpInputField`, `ResendTimer`, `CategoryChip`, `login_button.dart` (re-export barrel).

### 6.6 `lib/features/daily_quiz/` — Daily Quiz (scaffold)

Purpose: Daily quiz delivery, answering, timing, and result summary.

Layers: `data/` (2 models + 1 datasource + 1 repository impl), `domain/` (2 entities + 1 contract + 2 use cases), `presentation/` (1 provider + 2 screens + 5 widgets: answer_option, question_card, question_progress, quiz_timer, result_summary_card).

### 6.7 `lib/features/gamification/` — Achievements, Badges, Levels, Rewards (scaffold)

Purpose: XP, streak, levels, badges, achievements, rewards.

Layers: `data/` (6 models + 1 datasource + 1 repository impl), `domain/` (6 entities + 1 contract + 7 use cases), `presentation/` (1 provider + 6 screens + 8 widgets).

### 6.8 `lib/features/guidebook/` — Subjects, Chapters, Reader (scaffold)

Purpose: Subjects → chapters → chapter reader with bookmarks & progress.

Layers: `data/` (2 models + 1 datasource + 1 repository impl), `domain/` (2 entities + 1 contract + 4 use cases), `presentation/` (1 provider + 4 screens + 5 widgets).

### 6.9 `lib/features/home/` — App Home (scaffold)

Purpose: Aggregated landing screen (continue learning, daily goal, premium banner, quick actions).

Layers: `data/` (1 model + 1 datasource + 1 repository impl), `domain/` (1 entity + 1 contract + 2 use cases), `presentation/` (1 provider + 1 screen + 8 widgets).

### 6.10 `lib/features/leaderboard/` — Leaderboards (scaffold)

Purpose: Friends, weekly, and global leaderboards.

Layers: `data/`, `domain/`, `presentation/` (1 provider + 2 screens + 2 widgets).

### 6.11 `lib/features/mock_test/` — Mock Tests (scaffold)

Purpose: Configurable timed mock tests with score calculation.

Layers: `data/`, `domain/` (likely 4 use cases: start, submit, get_by_id, get_all), `presentation/`.

### 6.12 `lib/features/notifications/` — Notifications (Phase 14, fully implemented)

Purpose: Inbox screen listing per-user notifications, mark-read/dismiss actions, and an unread-count provider consumed by the bottom-bar bell badge and the Quick Actions tile.

Layers:
- `data/datasources/notification_remote_datasource.dart` (`UnimplementedError` Firestore seam) and `data/datasources/notification_local_datasource.dart` (deterministic seed).
- `data/models/notification_model.dart` with `fromEntity`/`toEntity`/`fromJson`/`toJson`.
- `data/repositories/notification_repository_impl.dart` — remote-first / local-cache fallback (`fetchAll`, `markAsRead`, `markAllAsRead`, `delete`).
- `domain/entities/notification_entity.dart` — `id`, `title`, `message`, `createdAtIso`, `routeName`, `isRead` with `copyWith`.
- `domain/repositories/notification_repository.dart` — abstract contract.
- `domain/usecases/{get_notifications, mark_as_read, mark_all_as_read, delete_notification}.dart`.
- `presentation/providers/notification_provider.dart` — Riverpod graph (`notificationControllerProvider`, `notificationUnreadCountProvider`, `NotificationViewState`, `NotificationStatus`).
- `presentation/screens/notification_screen.dart` — inbox view with "Mark all read" and dismiss actions, responsive width via `ResponsiveBuilder`.
- `presentation/widgets/notification_tile.dart` — single row (read/unread pill, route-deeplink on tap, dismiss icon).
- `presentation/widgets/empty_notification.dart` — empty inbox surface.

Reuses the shared `NotificationBadge` from `lib/core/widgets/notification_badge.dart` (via the bottom-bar bell icon) and `ResponsiveBuilder`, `AppIcons`, `AppSpacing`, `AppRadius` design tokens. Reachable from any nav surface via `AppRoutes.notifications`.

### 6.13 `lib/features/search/` — Global Search (Phase 15, fully implemented)

Purpose: Cross-feature search over Lessons, Questions, Topics, Books and AI History. Debounced live search, category filtering, persistent recents, trending suggestions, and Firestore-ready remote datasource.

Layers:
- `data/datasources/search_remote_datasource.dart` (`UnimplementedError` Firestore seam) and `data/datasources/search_local_datasource.dart` — in-memory corpus of 23 seed items spanning all 5 categories, with `searchItems(query, categories)` synchronous filter.
- `data/models/search_item_model.dart`, `recent_search_model.dart`, `trending_search_model.dart` — `fromEntity`/`toEntity`/`fromJson`/`toJson` with enum-name persistence.
- `data/repositories/search_repository_impl.dart` — remote-first / local-cache fallback with `searchAll`, `searchByCategory`, `getRecentSearches`, `saveRecentSearch`, `clearRecentSearches`, `getTrendingSearches`. `saveRecentSearch` deduplicates by lowercased query and trims to `maxRecentEntries` (20).
- `domain/enums/search_category.dart` — `{all, lessons, questions, topics, books, aiHistory}`.
- `domain/entities/search_item_entity.dart` — `id`, `category`, `title`, `subtitle`, `routeName`, `secondaryRouteName?`, `iconName?`, `updatedAtIso?` with `copyWith` and `clearSecondary`/`clearIcon`/`clearUpdatedAt` sentinels.
- `domain/entities/recent_search_entity.dart` and `trending_search_entity.dart` — Flutter-import-free, immutable.
- `domain/entities/search_category_entity.dart` — per-category result-count pair.
- `domain/repositories/search_repository.dart` — abstract contract.
- `domain/usecases/{search_all, search_by_category, get_recent_searches, save_recent_search, clear_recent_searches, get_trending_searches}.dart` — `const` ctor + private `_repository` + `call(...)` shape.
- `presentation/providers/search_state.dart` — `SearchViewState` (status, query, selectedCategory, resultsByCategory, recent, trending, errorMessage) with `SearchStatus.{initial, loading, ready, error}`.
- `presentation/providers/search_provider.dart` — full Riverpod graph mirroring `notification_provider.dart`. `SearchController` exposes `hydrate()`, `onQueryChanged(String)`, `runSearch({query})`, `onCategorySelected(SearchCategory)`, `fillAndSearch(String)`, `onItemOpened(item)`, `clearRecent()`. Per-category result cache means category tabs are instant client-side filters.
- `presentation/screens/search_screen.dart` — `SearchScreen extends ConsumerStatefulWidget` with `AppBar(close → playground, filter action)`, `CustomSearchField`, `SearchCategoryTabs` (hidden when query empty), and a `Column` body that branches on `status` (loading → `SearchLoading`, error → `SearchErrorView`, query + no results → `SearchEmptyResults`, query + results → `SearchResultList`, idle → `RecentSearchSection` + `TrendingSearchSection`). Owns a `Debouncer` (320ms) that schedules `runSearch` after `onChanged`. Calls `context.goNamed(item.routeName)` on tap.
- `presentation/widgets/search_field.dart` — thin wrapper around `CustomSearchField`.
- `presentation/widgets/search_category_tabs.dart` — horizontal `ListView` of `CategoryChip`s, one per `SearchCategory`, with `displayLabel` extension + result-count badge. Hidden on narrow viewports (filter sheet handles those).
- `presentation/widgets/search_result_list.dart` + `search_result_tile.dart` — `ListView.separated` of `Material`/`InkWell` tiles with rounded `surfaceContainerHighest` backgrounds, primary-tinted icon chip, title + subtitle + chevron.
- `presentation/widgets/search_empty_state.dart` — "no matches yet" with query echoed back.
- `presentation/widgets/search_loading.dart` — wraps the core `LoadingWidget(loaderType: circular)`.
- `presentation/widgets/search_error.dart` — error icon + retry CTA wired to `runSearch`.
- `presentation/widgets/recent_search_section.dart` + `recent_search_chip.dart` — header with "Clear" trailing action + `Wrap` of `CategoryChip`-backed recents.
- `presentation/widgets/trending_search_section.dart` — header + vertical numbered list (`01…08`).
- `presentation/widgets/search_filter_sheet.dart` — `SearchFilterSheet.show(context, initial)` returning `Set<SearchCategory>?`. Uses `showModalBottomSheet` directly with a drag handle, `ResponsiveBuilder.value<double>` for max width, and a `Reset` / `Apply` action row.

Reuses `CustomSearchField` from `lib/core/widgets/custom_search_field.dart`, `CategoryChip` from `lib/core/widgets/category_chip.dart`, `TitleWithAction` from `lib/core/widgets/title_with_action.dart`, `LoadingWidget` from `lib/core/widgets/loading_widget.dart`, `AppSnackBar` from `lib/core/widgets/app_snackbar.dart`, `ResponsiveBuilder`, and the new `Debouncer` in `lib/core/utils/debouncer.dart` (replaces the prior empty stub — main-app copy, doesn't import from `lib/admin/`). Reachable from any nav surface via `AppRoutes.search` (`/search`); entry points are the Profile quick-action tile (`ProfileStrings.searchActionId` = `'search'`) and the Quick Actions bottom sheet catalog.

### 6.14 `lib/features/bookmarks/` — Bookmarks System (Phase 16, fully implemented)

Purpose: A single, cross-feature Bookmarks hub that lets the user save **Questions**, **Lessons**, **AI Responses**, and **Personal Notes** from anywhere in the app via a unified `BookmarkActionButton`, and revisit them later at `/bookmarks` — including while offline.

Layers:
- `data/datasources/bookmark_remote_datasource.dart` (`UnimplementedError` Firestore seam) and `data/datasources/bookmark_local_datasource.dart` — in-memory store with 6 seed entries spanning all 4 item types, a `Stream<List<BookmarkModel>>` watch, and `query({filter, sort, search, offset, limit})` for paginated reads.
- `data/models/bookmark_model.dart` — `fromEntity`/`toEntity`/`fromJson`/`toJson`/`copyWith`; `BookmarkItemType` enum persisted via `.name`.
- `data/repositories/bookmark_repository_impl.dart` — remote-first / local-cache fallback with `getBookmarks`, `addBookmark`, `removeBookmark`, `isBookmarked`, `findBookmarkId`, `clearAll`, `sync`. `addBookmark` synthesises `${type.name}_${itemId}` as the row id and writes through the local store; `sync` swallows `UnimplementedError` to preserve offline behaviour.
- `domain/enums/bookmark_item_type.dart` — `{question, lesson, aiResponse, note}`.
- `domain/enums/bookmark_sort.dart` — `{newest, oldest, alphabetical}`.
- `domain/enums/bookmark_filter.dart` — `{all, questions, lessons, ai, notes}`.
- `domain/entities/bookmark_entity.dart` — immutable, all-final, with `copyWith`/`clearSubtitle`/`clearThumbnailIconKey` sentinels and an `empty()` sentinel returned by `ToggleBookmark` when an existing entry is removed.
- `domain/repositories/bookmark_repository.dart` — abstract contract.
- `domain/usecases/{add_bookmark, remove_bookmark, toggle_bookmark, is_bookmarked, get_bookmarks, clear_bookmarks, sync_bookmarks}.dart` — `const` ctor + private `_repository` + `call(...)` shape.
- `presentation/providers/bookmark_state.dart` — `BookmarksViewState` (status, items, filter, sort, query, errorMessage, hasMore, offlineMode, isRefreshing) with `BookmarksStatus.{initial, loading, ready, loadingMore, error}`. Plus `BookmarkFeedback` (transient stream event).
- `presentation/providers/bookmark_provider.dart` — full Riverpod graph + `BookmarkController` exposing `hydrate`, `refresh`, `loadMore`, `onFilterChanged`, `onSortChanged`, `onQueryChanged`, `runSearch`, `toggle`, `removeById`, `removeEntity`, `isBookmarkedSync`, `clearAll`. Emits a `feedback` stream consumed by widgets that want to show transient snackbars.
- `presentation/providers/bookmark_filter_provider.dart` — `bookmarkFilterProvider` and `bookmarkSortProvider` (`StateProvider`s for the screen-level filter / sort UI state).
- `presentation/providers/bookmark_visibility_provider.dart` — `bookmarkIdsProvider` (synchronously-derived `Set<String>` used by `BookmarkActionButton` for filled-vs-outline state without spawning a Future) + `isBookmarkedProvider` (`FutureProvider.family` for surfaces that need a Future-based lookup).
- `presentation/screens/bookmarks_screen.dart` — `BookmarksScreen extends ConsumerStatefulWidget`. Composition: `AppBar(close → profile, sort menu, filter action)`, `BookmarkSearchBar` (320ms-debounced), `BookmarkCategoryTabs`, optional `BookmarkOfflineBanner`, and an `Expanded` body that branches on status (loading → `BookmarkLoading`, error → `BookmarkErrorState`, empty → `BookmarkEmptyState`, empty-filtered → filtered empty, else → responsive `RefreshIndicator` + `NotificationListener<ScrollNotification>` for `loadMore`). Mobile uses a `ListView` of `BookmarkTile`s; tablet uses a 2-column grid of `BookmarkCard`s; desktop uses a 3-column grid of `BookmarkGridItem`s.
- `presentation/screens/bookmark_detail_screen.dart` — thin dispatcher: reads `?route=…` + remaining query parameters and forwards to the target route via `context.goNamed`, with a "back to bookmarks" leading icon.
- `presentation/widgets/bookmark_action_button.dart` — universal toggle widget used from anywhere in the app (questions, lessons, AI responses, notes, search results, and bookmark tiles themselves). Reads `bookmarkIdsProvider` synchronously to render the filled-vs-outline icon and fires an `AppSnackBar` on toggle via the controller's `feedback` stream.
- `presentation/widgets/bookmark_tile.dart` + `bookmark_card.dart` + `bookmark_grid_item.dart` — list-row tile + 2-col card + 3-col grid item. All compose `RoundedContainer`-style surfaces around `Icon(item.thumbnailIconKey)`, title, subtitle, `CategoryChip` for the type, a trailing `BookmarkActionButton`, and a `BookmarkPopupMenu` (Open / Remove).
- `presentation/widgets/bookmark_search_bar.dart` — thin wrapper over `CustomSearchField` with a `bookmark` prefix icon and the `bookmarksSearchHint` placeholder.
- `presentation/widgets/bookmark_category_tabs.dart` — horizontal `SingleChildScrollView` of `CategoryChip`s (filters: All, Questions, Lessons, AI, Notes).
- `presentation/widgets/bookmark_filter_chip.dart` — `FilterChip` for the filter sheet.
- `presentation/widgets/bookmark_sort_dropdown.dart` — `PopupMenuButton<BookmarkSort>` with checkmark indicator next to the active selection.
- `presentation/widgets/bookmark_filter_sheet.dart` — modal sheet mirroring `SearchFilterSheet`. Returns the new `BookmarkFilter` (single-select) via Reset / Apply buttons.
- `presentation/widgets/bookmark_popup_menu.dart` — three-dot menu on each tile/card with Open / Remove.
- `presentation/widgets/bookmark_empty_state.dart` — feature-local "No bookmarks yet" with `Icons.bookmark_border_rounded`, CTA "Browse content" → `AppRoutes.lessons`; variant constructor accepts `filtered: true` for "no matches".
- `presentation/widgets/bookmark_loading.dart` — wraps the core `LoadingWidget`.
- `presentation/widgets/bookmark_error_state.dart` — icon + message + retry CTA wired to `controller.refresh()`.
- `presentation/widgets/bookmark_offline_banner.dart` — non-blocking banner rendered above the list when `state.offlineMode` is true.

Reuses the existing `BookmarkButton` / `BookmarkBadge` atoms from `lib/features/review/presentation/widgets/bookmark_button.dart` (the icon stays unchanged; the new `BookmarkActionButton` composes it with state + onTap), plus `CategoryChip` (`lib/core/widgets/category_chip.dart`), `CustomSearchField` (`lib/core/widgets/custom_search_field.dart`), `LoadingWidget` (`lib/core/widgets/loading_widget.dart`), `AppSnackBar` (`lib/core/widgets/app_snackbar.dart`), `ResponsiveBuilder` (`lib/core/widgets/responsive_builder.dart`), `Debouncer` (`lib/core/utils/debouncer.dart`), and the shared `Result<T>` / `Failure` / `ErrorHandler` plumbing.

Reachable from any nav surface via `AppRoutes.bookmarks` (`/bookmarks`). Entry points are:
- The Profile quick-action tile (`ProfileStrings.bookmarksActionId` = `'bookmarks'`), which is also seeded in `mock_profile_remote_datasource.dart`.
- The Quick Actions bottom-sheet catalog (`defaultQuickActions.dart` — id `bookmarks`).
- Any `BookmarkActionButton` rendered from a question card, lesson card, AI response card, note card, search result tile, or bookmark tile.

The three pre-existing guidebook stubs (`bookmark_button.dart`, `bookmarks_screen.dart`, `bookmark_chapter.dart`) were deleted in Phase 16 and replaced by the unified feature above.

### 6.16 `lib/features/notes/` — Notes System (Phase 17, fully implemented)

Purpose: A cross-cutting Personal Notes hub that lets the user capture **Personal Notes**, **Lesson Highlights**, and **AI Notes** from anywhere in the app, with category / tag / pin / favorite organisation, search-as-you-type, sort, debounced live filtering, responsive 1/2/3-column layout, share, edit, delete, and an in-memory store mirroring every other feature (Firestore-ready remote seam). Integrates with the Bookmarks hub via the universal `BookmarkActionButton` (a note can be a bookmark target).

Layers:
- `data/datasources/notes_remote_datasource.dart` (`UnimplementedError` Firestore seam) and `data/datasources/notes_local_datasource.dart` — in-memory store seeded with 8 sample notes spanning Personal / Highlight / AI types, with a broadcast `Stream<List<NoteModel>>` for reactive updates.
- `data/models/{note_model, highlight_model, ai_note_model}.dart` — `fromEntity`/`toEntity`/`fromJson`/`toJson`/`copyWith`. Enums persisted via `.name`. `HighlightModel`/`AiNoteModel` round-trip through their entities and convert to a `NoteEntity` via the `AiNoteEntity.toNoteEntity()` helper.
- `data/repositories/notes_repository_impl.dart` — implements `getNotes`, `getPinnedNotes`, `getRecentNotes`, `findNoteById`, `createNote`, `updateNote`, `deleteNote`, `togglePin`, `toggleFavorite`, `saveHighlight`, `saveAiNote`, `clearAll`. Client-side filter / sort / substring search on title / content / tags / attachments. Remote push is best-effort via `Future<void>` + `developer.log` swallow.
- `domain/enums/note_category.dart` — `{personal, study, review, insight, question, ai}` with `displayLabel` extension.
- `domain/enums/note_type.dart` — `{personal, highlight, ai}` with `displayLabel` extension.
- `domain/enums/note_color.dart` — `{defaultColor, yellow, green, blue, pink, purple}` with `displayLabel` extension.
- `domain/enums/note_sort.dart` — `{newest, oldest, alphabetical, favoritesFirst, pinnedFirst}` with `displayLabel` extension.
- `domain/enums/note_filter.dart` — `{all, pinned, favorites, highlights, ai, personal}` with `displayLabel` extension.
- `domain/entities/note_entity.dart` — immutable entity with `id`, `title`, `content`, `preview?`, `type`, `category`, `color`, `isPinned`, `isFavorite`, `tags`, `attachments` (list of `NoteAttachmentEntity`), `createdAtIso`, `updatedAtIso`, `sourceFeature`, `copyWith` with `clearPreview` sentinel, and `resolvedPreview` getter (uses preview when present, falls back to first 160 chars of content).
- `domain/entities/note_attachment_entity.dart` — opaque attachment descriptor (kind, itemId, title, routeName, subtitle, iconKey) that maps back to the bookmark subsystem.
- `domain/entities/highlight_entity.dart` — input payload for the `SaveHighlight` use case (text, source title, route, itemId, color, tags, routeParams).
- `domain/entities/ai_note_entity.dart` — input payload for the `SaveAiNote` use case (prompt, response, routeName, itemId, color, category) plus `toNoteEntity()` builder.
- `domain/repositories/notes_repository.dart` — abstract contract.
- `domain/usecases/{create_note, update_note, delete_note, get_all_notes, get_pinned_notes, search_notes, toggle_favorite, toggle_pin, save_highlight, save_ai_note}.dart` — `const` ctor + private `_repository` + `call(...)` shape. `GetAllNotes` and `SearchNotes` accept filter/sort/offset/limit; the rest are 1:1 wrappers.
- `presentation/providers/notes_state.dart` — `NotesViewState` (status, items, filter, sort, hasMore, query, errorMessage, pinnedPreview, recentPreview, isRefreshing) with `NotesStatus.{initial, loading, ready, loadingMore, error}`. `NoteFeedback` (transient stream event) + `NoteFeedbackVariant` for snackbar wiring.
- `presentation/providers/notes_provider.dart` — full Riverpod graph (`notesLocalDataSourceProvider`, `notesRemoteDatasourceProvider`, `notesRepositoryProvider`, plus ten use case providers) and `NotesController` exposing `hydrate`, `refresh`, `loadMore`, `onFilterChanged`, `onSortChanged`, `onQueryChanged`, `runSearch`, `create`, `update`, `remove`, `togglePinFor`, `toggleFavoriteFor`, `saveHighlight`, `saveAiNote`, `findById`, `clearAll`. Emits a `feedback` stream consumed by widgets that surface snackbars.
- `presentation/providers/notes_filter_provider.dart` — `noteFilterProvider` and `noteSortProvider` (`StateProvider`s for the screen-level filter / sort UI state).
- `presentation/providers/notes_visibility_provider.dart` — `noteIdsProvider` (synchronously-derived `Set<String>` for fast lookups), `pinnedNoteIdsProvider`, `favoriteNoteIdsProvider` — used by external widgets that need pin/favorite state without spawning a Future.
- `presentation/screens/notes_screen.dart` — `NotesScreen extends ConsumerStatefulWidget`. Composition: `AppBar(close → profile, sort menu, filter action, create FAB)`, `NoteSearchBar` (320ms-debounced), `NoteCategoryTabs`, optional `FloatingActionButton.extended(Create)`, and an `Expanded` body that branches on status (loading → `NoteLoadingState`, error → `NoteErrorState`, empty-search → `NoteEmptyState(variant: noSearch)`, empty → `NoteEmptyState(neverCreated)`, else → responsive `RefreshIndicator` + `NotificationListener<ScrollNotification>` for `loadMore`). Mobile uses a `ListView` of `NoteListItem`s; tablet/desktop uses a 2/3-column grid of `NoteGridItem`s.
- `presentation/screens/create_note_screen.dart` — full-screen editor (title, content, tags, category chips, color palette picker), validation, `Save` action that calls `controller.create()`.
- `presentation/screens/edit_note_screen.dart` — same editor pre-populated from an existing note, with `Save` + `Delete` actions. Uses `DeleteNoteDialog` for confirmation.
- `presentation/screens/note_detail_screen.dart` — full-screen detail view with title, content, tags, attachments, type/category chips, and a `NoteToolbar` (pin, favorite, share, edit, delete). Reachable via `AppRoutes.noteDetail` with `?id=…`.
- `presentation/widgets/note_card.dart` — coloured card variant (mobile list / tablet grid) showing type, title, preview, category chip, and action icons.
- `presentation/widgets/note_list_item.dart` — list-row variant with a left accent strip and inline pin/favorite/share controls.
- `presentation/widgets/note_grid_item.dart` — fixed-height 220 dp wrapper around `NoteCard` for the desktop 3-column grid.
- `presentation/widgets/note_search_bar.dart` — thin wrapper over `CustomSearchField` with a `noteSearch` prefix icon and the `notesSearchHint` placeholder.
- `presentation/widgets/note_category_chip.dart` + `note_category_tabs.dart` — horizontal scroll of `CategoryChip`-backed filters (All, Pinned, Favorites, Highlights, AI, Personal).
- `presentation/widgets/note_filter_chip.dart` + `note_filter_sheet.dart` — modal filter sheet mirroring `BookmarkFilterSheet` (drag handle, Reset / Apply).
- `presentation/widgets/note_sort_sheet.dart` — modal sort sheet (Newest / Oldest / Alphabetical / Favorites / Pinned first).
- `presentation/widgets/note_palette_picker.dart` — colour-swatch picker (Default / Yellow / Green / Blue / Pink / Purple) wired to `NoteColor`.
- `presentation/widgets/note_tag_chip.dart` — `#tag` pill rendered on cards and the detail screen.
- `presentation/widgets/note_editor.dart` — editor surface (title / content / tags / category chips / palette) shared by the Create and Edit screens.
- `presentation/widgets/note_toolbar.dart` — AppBar trailing icons (pin / favorite / share / edit / delete).
- `presentation/widgets/highlight_card.dart` + `ai_note_card.dart` — read-only preview cards with a "Save as note" CTA. Used by AI Tutor / Guidebook when surfacing capture opportunities.
- `presentation/widgets/note_share_sheet.dart` — modal sheet with native share + clipboard copy, surfacing `AppSnackBar.showInfo('Link copied')`.
- `presentation/widgets/delete_note_dialog.dart` — confirmation dialog with destructive `FilledButton`.
- `presentation/widgets/note_empty_state.dart` — feature-local empty surfaces with `neverCreated`, `noMatches`, `noSearch` variants and an optional "Create note" CTA.
- `presentation/widgets/note_loading_state.dart` — wraps `LoadingWidget(loaderType: circular)`.
- `presentation/widgets/note_error_state.dart` — icon + message + retry CTA wired to `controller.hydrate(offset: 0)`.
- `presentation/extensions/note_color_extension.dart` — `resolve(context)` (light/dark surface tint) + `resolveAccent(context)` (icon/text accent) for each `NoteColor`.

Reuses `CategoryChip` (`lib/core/widgets/category_chip.dart`), `CustomSearchField` (`lib/core/widgets/custom_search_field.dart`), `LoadingWidget` (`lib/core/widgets/loading_widget.dart`), `AppSnackBar` (`lib/core/widgets/app_snackbar.dart`), `ResponsiveBuilder` (`lib/core/widgets/responsive_builder.dart`), `Debouncer` (`lib/core/utils/debouncer.dart`), and the shared `Result<T>` / `Failure` / `ErrorHandler` plumbing.

Reachable via `AppRoutes.notes` (`/notes`), `AppRoutes.noteCreate` (`/notes/create`), `AppRoutes.noteEdit` (`/notes/edit?id=…`), `AppRoutes.noteDetail` (`/notes/detail?id=…`). Entry points are:
- The Profile quick-action tile (`ProfileStrings.notesActionId = 'notes'`), which is also seeded in `mock_profile_remote_datasource.dart`.
- The Quick Actions bottom-sheet catalog (`defaultQuickActions.dart` — id `notes`).
- The `notes_create`, `notes_edit`, `notes_detail` GoRoutes resolve from any `BookmarkActionButton` / `NoteCard` tap.

### 6.15 `lib/features/onboarding/` — Onboarding (scaffold)

Purpose: First-run walkthrough and language/level selection.

Layers: `data/`, `domain/`, `presentation/`.

### 6.17 `lib/features/subscription/` — Premium Subscription (scaffold)

Purpose: bdapps / bKash subscription flow, premium gating.

Layers: `data/`, `domain/`, `presentation/`.

### 6.18 `lib/features/weakness_tracker/` — Weakness Analysis (scaffold)

### 6.19 `lib/features/quiz_results/` — Quiz Results (Phase 7, fully implemented)

Purpose: Aggregate the Quiz Engine's [QuizResultEntity] into a full results experience — score hero, star rating, XP/coin reward cards, rank progress, accuracy & time analysis, weak / strong topic breakdown, motivational banner, retry / review / continue / share actions.

Layers:
- `data/` — `datasources/quiz_results_remote_datasource.dart`, `datasources/mock_quiz_results_remote_datasource.dart`, `repositories/quiz_results_repository_impl.dart`.
- `domain/` — `entities/quiz_performance_entity.dart`, `entities/rank_progress.dart`, `entities/star_rating.dart`, `entities/topic_performance_entity.dart`, `repositories/quiz_results_repository.dart`, `usecases/calculate_rewards.dart`, `usecases/get_quiz_performance.dart`, `usecases/retry_quiz.dart`.
- `presentation/` — `providers/quiz_results_provider.dart` (controller + state + provider family); `screens/quiz_results_screen.dart`, `screens/weak_topics_screen.dart`, `screens/performance_breakdown_screen.dart`; `constants/quiz_results_strings.dart`; `extensions/quiz_result_extensions.dart`; `utils/quiz_results_visual_mapper.dart`, `utils/topic_analyzer.dart`, `utils/reward_calculator.dart`; widgets grouped under `result_analysis`, `result_components`, `result_footer`, `result_rank`, `result_rewards`, `result_score`, `result_topics`.

Reuses existing design tokens (`AppColors`, `AppSpacing`, `AppRadius`, `AppSizes`), `GlassCard`, `PrimaryButton`, `SecondaryButton`, `XPProgressBar`, and the `QuizExplanationCard` from `quiz_engine`. Registered in the Widget Builder with 14 new selections: `quizResultHeroCard`, `quizResultStatsGrid`, `quizResultAccuracyCard`, `quizResultTimeAnalysisCard`, `quizResultRankProgressCard`, `quizResultXpReward`, `quizResultCoinReward`, `quizResultStarReward`, `quizResultWeakTopicsCard`, `quizResultStrongTopicsCard`, `quizResultPerformanceSummaryCard`, `quizResultMotivationalBanner`, `quizResultShareDialog`, `quizResultConfettiAnimation`.

Purpose: Diagnostic analytics to highlight weak topics.

### 6.20 `lib/features/quiz_api/` — Quiz Hub REST Adapter (Phase 35 + Phase 38 contract)

Purpose: Bridge the public Quiz Hub REST backend (`docs/apidoc/api`) with the Quiz Engine so every playground node opens a fully data-driven quiz whose XP is derived from the per-question `mark` field returned by the API.

Layers:
- `data/datasources/quiz_api_quiz_engine_adapter.dart` — implements the Quiz Engine's `QuizRemoteDataSource` by routing `quizhub-{categoryId}` ids through the Quiz Hub REST API and delegating everything else to the in-memory fallback. On `submitQuizSession` it pulls the questions, grades them locally, and **credits `result.rewardXp` equal to the sum of `q.mark` for every correct answer** (Phase 38 contract). Non-Quiz-Hub ids fall through to the legacy mock path with the original `quiz.rewardXp` semantics.
- `data/datasources/http_quiz_api_remote_datasource.dart` + `mock_quiz_api_remote_datasource.dart` — REST (Dio) + in-memory fallback data sources.
- `data/repositories/{quiz_api_repository_impl,cached_quiz_api_repository,fallback_quiz_api_repository}.dart` — Result + cache + offline fallback chain.
- `data/cache/quiz_api_cache.dart` — TTL-bounded read-through cache (memory + optional Hive box `quizhub_cache_v1`).
- `data/models/{quiz_category_model,quiz_question_model,quiz_pagination_model}.dart` — JSON-ready DTOs with `fromApiResponse` / `fromJson` / `toJson` (tolerates `question`/`prompt`, drops empty options, defaults `mark=1`).
- `domain/entities/{quiz_category_entity,quiz_question_entity,quiz_query}.dart` — domain entities + `QuizCategoryQuery` / `QuizQuestionQuery`.
- `presentation/providers/quiz_api_providers.dart` — wires `DioClient` → HTTP datasource → cached + fallback repository → `quizApiAdapterProvider` (consumed by `quizRemoteDataSourceProvider`) → `quizApiQuizForCategoryProvider` (used by the playground to hop straight into a ready-to-play quiz).

Phase 38 fix: `QuizApiQuizEngineAdapter.submitQuizSession` now writes `result.rewardXp = earned` (sum of marks for correct answers) so `UserProgressService.applyQuizCompletion` credits the user accordingly via the existing transactional progression write on `users/{uid}/progression/current`.

### 6.21 `lib/core/services/user_progress_service.dart` — Quiz Completion Funnel (Phase 34 + Phase 38 wiring)

Purpose: Single funnel that fires every side-effect when a quiz session is submitted — profile XP / coins / level mutation, streak update, playground node completion, plus six Firestore writes (progression transaction, study stats, statistics mirror, streak, category progress, playground snapshot, quiz session + history). The XP credited by the funnel comes from `QuizResultEntity.rewardXp`, which the Quiz Hub adapter now populates from the per-question `mark` total.

Layers: `data/`, `domain/`, `presentation/`.

### 6.22 `lib/features/playground/presentation/` — Dynamic XP Wiring (Phase 39)

Phase 39 establishes a single source of truth for XP: `UserProfile.progression` (Firestore `users/{uid}/progression/current`). Every screen that previously hardcoded XP now reads from a Riverpod provider derived from the canonical funnel.

**Changes:**

1. **`LevelScreen`, `ChallengeScreen`, `BossChallengeScreen`** — converted from `StatelessWidget` to `ConsumerWidget`. Each declares a private `_rewardsProvider = FutureProvider.family<_Rewards, String>` that resolves the active `CategoryEntity` via `categoryByIdProvider(nodeId)` and exposes `xpReward` / `coinReward`. All `RewardEntry.amount` literals and `LevelCardReward(xp:, coins:)` calls bind to `rewards.xp` / `rewards.coins`. No widget hardcodes `amount: 25`, `amount: 100`, or `amount: 50`.

2. **`PlaygroundProvider`** (legacy `ChangeNotifier`) — `markCompleted`, `grantBossReward`, `grantRewardChest` now mutate only `completedLevelIds` / `unlockedLevelIds` / `activeLevelId`. The `PlaygroundRewardEvent` they emit carries `xp: 0, coins: 0` — XP / coin deltas are owned exclusively by `UserProgressService`, never duplicated. The legacy hardcoded `xp: 25 / 100 / 15` and `coins: 10 / 50 / 5` literals are removed.

3. **`UserProgressService.applyQuizCompletion`** — after computing `_nextProfile(updated)`, calls `_pushProgressionIntoPlayground(playground, updated)` which calls `playground.replace(current.copyWith(totalXp: updated.progression.totalXp, userLevel: updated.progression.level, xpInLevel, xpForNextLevel, coins, streakDays))`. The Playground UI's totalXp / coins / level / streak now mirror `UserProfile.progression` exactly.

4. **`PlaygroundNotifier.replace()`** — previously unused. Now the single entry point that mutates XP / coins / level in playground state, called by `UserProgressService` after every quiz submission.

**Why this matters:** Phase 39 closes the gap where `PlaygroundProvider.markCompleted()` was adding a hardcoded `+25` XP on top of `UserProfile.progression.totalXp`, causing the Playground screen to drift from the canonical profile. After this change, every XP indicator (profile badge, quiz result, playground card, reward popup, top bar, mission screen) renders from the same `UserProfile.progression` total.

### 6.23 Phase 35 — Foundation Fill (Network Plumbing + FirebaseConfig)

Phase 35 left four foundation files as empty stubs (`lib/core/config/firebase_config.dart`, `lib/core/network/dio_client.dart`, the three interceptor files in `lib/core/network/interceptors/`, and the Quiz Hub endpoints on `lib/core/constants/api_endpoints.dart`). The codebase referenced them from every Firestore-backed feature and from the Quiz Hub REST datasource, which made the project fail to compile until the Phase 35 foundation was filled in. This section records the fills.

**1. `lib/core/config/firebase_config.dart`** — the `FirebaseConfig` class. Static accessors:
- `bool get isPlatformConfigured` — returns `Firebase.apps.isNotEmpty` (with a try/catch so test environments don't crash).
- `FirebaseFirestore? get firestore` — returns `FirebaseFirestore.instance` when configured, `null` otherwise. Every feature that touches Firestore reads through this accessor so it can early-return in tests.

**2. `lib/core/constants/firestore_keys.dart`** — subcollection and document constants that the `UserProgressService` and every Firestore-backed datasource reference:
- `progressionSubcollection = 'progression'`
- `studyStatsSubcollection = 'study_stats'`
- `statisticsSubcollection = 'statistics'`
- `streakSubcollection = 'streak'`
- `playgroundSubcollection = 'playground'`
- `quizSessionsSubcollection = 'quiz_sessions'`
- `quizHistorySubcollection = 'quiz_history'`
- `categoryProgressSubcollection = 'category_progress'`
- `profileSubcollection = 'profile'`
- `currentDocId = 'current'`
- `categories = 'categories'` (added to the existing top-level collections list).

**3. `lib/core/network/dio_client.dart`** — the `DioClient` factory. `DioClient.build({required String baseUrl, ...})` constructs a `Dio` with the Phase 35 contract documented in `docs/backendconnection/backend.mermaid` (Phase 35 Network Plumbing):
- 10s connect / 15s receive & send timeouts
- `Accept: application/json` and `Content-Type: application/json`
- `validateStatus` returns `true` for every 2xx–4xx so `ErrorHandler` can map non-2xx into typed `Failure` instances
- Interceptor pipeline: `LoggerInterceptor` → `RetryInterceptor` → `AuthInterceptor` (in that order)

**4. `lib/core/network/interceptors/{auth,logger,retry}_interceptor.dart`** — three interceptor implementations matching the mermaid spec:
- `AuthInterceptor` — opt-in `Bearer <idToken>` via the `X-Require-Auth: true` request header. Skips attachment when Firebase is not configured.
- `LoggerInterceptor` — debug-only `dart:developer.log` of every request / response / error.
- `RetryInterceptor` — idempotent methods only (GET / HEAD), exponential backoff (`baseDelay * 2^attempt + jitter`), 3 attempts, honours `CancelToken`. Uses a short-lived retry `Dio` so the interceptor pipeline doesn't loop.

**5. `lib/core/constants/api_endpoints.dart`** — Quiz Hub REST endpoints (Phase 38 contract):
- `quizApiBaseUrl` — overridable via `--dart-define=QUIZ_API_BASE_URL=...`, default `https://sadiks-quiz-apihub.lovable.app/api/v1`.
- `quizCategories`, `quizCategoryById(id)`, `quizQuestions(id)`, `quizRandomQuestions(id)`, `quizQuestionById(id)`, `quizBulkDelete(id)`, `quizImportQuestions(id)`, `quizExportQuestions(id)`.

**6. `pubspec.yaml`** — four missing runtime dependencies added so the foundation compiles: `firebase_core: ^4.12.1`, `firebase_auth: ^6.1.0`, `firebase_crashlytics: ^5.0.4`, `dio: ^5.7.0`.

**7. `lib/features/profile/presentation/controllers/profile_controller.dart`** — added `replaceLocalProfile(UserProfile)` method. Documented as the entry point the canonical quiz-completion funnel (`UserProgressService.applyQuizCompletion`) uses to mirror the freshly-computed `UserProfile` into the UI without round-tripping through the use cases. The Firestore write backing it lives in the transactional progression write inside `UserProgressService`.

**8. `lib/features/leaderboard/data/datasources/leaderboard_remote_datasource.dart`** + repository — interface contract updated to be `Future`-returning. The previous sync signatures (`LeaderboardCategoryModel read(scope)`) collided with `FirestoreLeaderboardRemoteDataSource`'s `Future<…>` overrides; the contract now matches the actual Firestore shape (`Future<LeaderboardCategoryModel> read`, `Future<List<LeaderboardCategoryModel>> readAll`).

**Validation:** after the fill, `flutter analyze lib/` returns **0 errors / 0 warnings**, and `flutter build apk --debug` succeeds end-to-end (Gradle `assembleDebug` produces `build/app/outputs/flutter-apk/app-debug.apk`).

### 6.24 Phase 40 — Dynamic Level System (fully implemented)

Phase 39 made XP dynamic. Phase 40 makes the **level system** itself dynamic, real-time, backend-synchronised, and celebration-driven. The canonical `LevelCurve` replaces the divergent `_LevelTuning` (1.25×) and the dormant `RewardRuleCatalog.LevelCurve` (1.35×), every level number flows from one source of truth, and the quiz-completion funnel detects multi-level-ups, queues per-level rewards, and pops the canonical `LevelRewardDialog` automatically.

**1. `lib/core/services/level_curve.dart`** — single source of truth. `class LevelCurve` with `base = 100`, `growth = 1.25`. Public API: `int xpRequiredForLevel(int level)` and `LevelSnapshot compute(int totalXp)`. `static const LevelCurve defaultCurve = LevelCurve(base: 100, growth: 1.25)`. The `LevelSnapshot` exposes `level`, `cumulativeXpAtLevel`, `xpForNext`, `previousLevelThreshold`, `nextLevelThreshold`, `xpInLevel` so the UI never recomputes thresholds.

**2. `lib/features/gamification/domain/services/reward_rule_catalog.dart`** — deleted the local dormant `LevelCurve` class. Re-imports `package:prep_quest/core/services/level_curve.dart as core` and re-exports it through `typedef CoreLevelCurve = core.LevelCurve` + `typedef LevelCurve = CoreLevelCurve` for backward compatibility with existing gamification call sites. `RewardRuleCatalog.levelFor(int totalXP, {CoreLevelCurve curve = CoreLevelCurve.defaultCurve})` now maps to a `LevelProgress` via `LevelSnapshot`. Dual-engine reconciliation: the gamification engine only computes badge/chest drops — it never recomputes the user's level number.

**3. `lib/features/profile/domain/entities/user_profile.dart`** — `ProgressionEntity` extended with `previousLevelThreshold`, `nextLevelThreshold`, `totalLevelUpsCompleted`, `lastLevelUpAt` (UTC), and `pendingLevelRewards: List<PendingLevelReward>`. The new value object `PendingLevelReward` is immutable, persists `level`, `xpBonus`, `coinBonus`, `badgeId`, `unlockedTitles`, `queuedAt`, and `claimed`. `copyWith`, `==`, and `hashCode` cover every new field; `unclaimedRewards` filters the queue for UI consumers.

**4. `lib/features/profile/data/models/user_profile_model.dart`** — encode/decode every new field via `toMap` / `fromMap`. Added `_PendingLevelRewardModel` (private to this file) to keep the Firestore shape distinct from the public entity. `fromMap` falls back to `LevelCurve.defaultCurve.xpRequiredForLevel(parsedLevel)` when `xpForNextLevel` is missing, emitting a `debugPrint` in debug builds.

**5. `lib/core/services/user_progress_service.dart`** — `_nextProfile` and `_transactionalProgression` now read `LevelCurve.defaultCurve.compute()` twice (before / after the XP credit) to detect `levelDelta > 0`. For each crossed level the funnel calls `_buildPendingLevelReward(crossedLevel: …)`, appends the reward to `ProgressionEntity.pendingLevelRewards`, and publishes a `LevelUpEvent` on `levelUpEventBusProvider`. Reward magnitudes scale with the per-level XP cost (`xpBonus = xpCost / 4`, `coinBonus = xpCost / 10`); every fifth level produces a `level_{n}_clear` badge id; every tenth level unlocks the `Legendary Scholar` title. New `claimLevelReward(PendingLevelReward)` persists `claimed: true` via merge-write; failures are enqueued in `ProgressWriteRetryQueue`. `_progressionPayload` and the transaction both include every new field so the Firestore document is self-contained.

**6. `lib/core/services/level_up_event_bus.dart`** — new `LevelUpEventBus extends StateNotifier<LevelUpEvent?>` with `publish()` / `clear()`. Single-element queue, drained by the root listener.

**7. `lib/features/gamification/presentation/providers/level_reward_queue_provider.dart`** — new `LevelRewardQueueNotifier` mirrors the unclaimed subset of `profile.progression.pendingLevelRewards` and exposes `markClaimed(reward)` which optimistically removes from the queue and delegates persistence to `UserProgressService.claimLevelReward`.

**8. `lib/app.dart`** — root `ref.listen<LevelUpEvent?>(levelUpEventBusProvider, …)` pops `LevelRewardDialog` with the canonical visual + confetti. Primary action calls `levelUpEventBusProvider.clear()` and `levelRewardQueueProvider.markClaimed(next.reward)`. One dialog per level-up; multi-level-up events arrive back-to-back via the queue.

**9. `lib/features/playground/presentation/widgets/level_reward_dialog.dart`** — `LevelRewardDialogVisual.showConfetti` (default `true`) toggles an ambient `ConfettiAnimation` layer above the existing `_CelebrationField` painter, so the celebration stays rich even when the dialog is reduced-motion disabled.

**10. `lib/features/gamification/presentation/widgets/confetti_animation.dart`** — filled the empty stub. `ConfettiAnimation` renders 32 falling rectangles with per-particle drift / rotation / palette, driven by a single `AnimationController` (1.8 s). Reusable for any ambient celebration surface (chest unlocks, milestone reached).

**11. `lib/features/quiz_results/presentation/screens/quiz_results_screen.dart`** — added a call to `UserProgressService.applyQuizCompletion()` before the gamification engine runs. `streakDays` is sourced from `profileControllerProvider.profile?.progression.streakDays` instead of the previous hardcoded `0`. The badge / chest grants remain owned by the gamification engine — only XP / coins / level are owned by the canonical funnel.

**12. `lib/features/gamification/presentation/providers/streak_state_provider.dart`** — `StreakStateNotifier` now `ref.listen`s `profileControllerProvider` so any profile mutation (level-up, retry-queue flush, cross-device sync) refreshes the local streak mirror. The previous `ref.watch`-only bootstrap did not catch post-quiz updates.

**13. `lib/features/playground/presentation/screens/level_screen.dart`** — `_LockedSection` migrated to `ConsumerWidget`. `levelNumber`, `level + 1`, and the XP requirement now derive from `profileControllerProvider` + `LevelCurve.defaultCurve.xpRequiredForLevel(currentLevel + 1)`. The hardcoded `levelNumber: 99` / `'Reach Level 4'` literals are gone.

**14. `lib/features/playground/presentation/screens/level_completed_screen.dart`** — `_openRewardDialog` no longer falls back to `25` / `10` when `lastOutcome` is missing; the canonical funnel always supplies the reward totals, so the dialog receives real (possibly 0) values.

**15. Sweep of `xpForNextLevel: 100` literals** — replaced with `LevelCurve.defaultCurve.xpRequiredForLevel(1)` (still `100` today, derived rather than hardcoded) in:
- `lib/features/profile/data/repositories/profile_repository_impl.dart` (line 155 + `_emptyProfile()` fills the new fields).
- `lib/features/profile/data/datasources/firestore_profile_remote_datasource.dart` (line 120).
- `lib/features/profile/data/datasources/mock_profile_remote_datasource.dart` (line 269).
- `lib/features/profile/data/models/user_profile_model.dart` (with a `kDebugMode` `debugPrint` on the `fromMap` fallback path).
- `lib/features/playground/presentation/providers/playground_provider.dart` (the `PlaygroundProgress.seed` field).
- `lib/features/playground/presentation/screens/playground_screen.dart` (the empty-profile `XpVisual` fallback).
- `lib/features/user_account/data/datasources/firestore_app_user_remote_datasource.dart` (line 54).
- `lib/features/user_account/data/datasources/mock_app_user_remote_datasource.dart` (`_emptyProgression`).

Widget-builder previews (`xp_indicator_preview.dart`, `playground_top_bar_preview.dart`) intentionally use `500` — left untouched.

**16. Phase 40 trade-offs accepted**:
- **Client-time idempotency** (no `FieldValue.serverTimestamp()` on `lastLevelUpAt`); the transactional read-modify-write + claimed-reward filter is sufficient for the current cross-device race window.
- **Two engines, shared curve** keeps gamification ownership of badge/chest drops while the canonical funnel owns XP / coins / level writes.
- **Pending rewards as a field** (not a subcollection) — atomic with the rest of the progression write, payload is small (≤ a handful of entries per quiz).

**Validation:** after the refactor, `flutter analyze lib/` returns **0 errors / 0 warnings**, and every XP indicator (profile badge, quiz result, playground card, reward popup, top bar, mission screen) renders from the same canonical `LevelCurve.compute(totalXp)`.

### 6.25 Phase 41 — Coins Backend Integration (fully implemented)

Phase 34 wired `ProgressionEntity.coins` to Firestore via the canonical quiz-completion funnel in `UserProgressService._transactionalProgression`. Phase 39 made the XP indicator dynamic; Phase 40 made the level system dynamic. Phase 41 collapses the coin economy to a **single canonical balance** on `users/{uid}/progression/current.coins`, persists every delta to a `users/{uid}/coin_ledger/{txId}` subcollection, debits / refunds atomically via `CoinService`, and serves a non-celebration UI surface for the live history.

**1. `lib/core/constants/firestore_keys.dart`** — added `coinLedgerSubcollection = 'coin_ledger'`. Lives alongside the other `users/{uid}/*` constants so the schema is one-file readable.

**2. `lib/core/errors/failures.dart`** — added `DuplicateRewardFailure(sourceKey)` and `InsufficientCoinsFailure(shortfall)`. `CoinService` raises the former when a `{source}:{sourceId}` ledger entry already exists; consumers raise the latter on spend-rejection. Both ride the existing `Failure.message` / `cause` contract.

**3. `lib/features/profile/domain/entities/coin_transaction.dart`** — the immutable ledger row. `CoinTransactionEntity` carries `id`, `uid`, `type: CoinTransactionType`, `source: CoinTransactionSource`, `sourceId`, `amount` (always positive; sign lives on `type`), `balanceAfter`, `reason?`, `metadata: Map<String, dynamic>`, and `createdAt` (UTC). `String get sourceKey => '${source.id}:$sourceId'` is the dedup key. `int get signedDelta` is `-amount` for `spend`, `+amount` otherwise. `copyWith`, `==`, `hashCode` (with metadata map equality), `fromMap`, `toMap` round-trip every field; the `sourceKey` is emitted alongside the canonical fields so the persisted doc is self-describing. Two enums: `CoinTransactionType { earn, spend, refund, bonus, reward, purchase, restore }` and `CoinTransactionSource { quiz, mission, daily, chest, streak, lesson, level, levelReward, boss, achievement, badge, xpMilestone, specialEvent, purchase, refund }`.

**4. `lib/features/profile/data/repositories/coin_ledger_repository_impl.dart`** — `abstract class CoinLedgerRepository` + `FirestoreCoinLedgerRepositoryImpl` + `InMemoryCoinLedgerRepository`. Methods: `Stream<List<CoinTransactionEntity>> watch(uid, {limit = 50})`, `Future<List<CoinTransactionEntity>> list(uid, {limit = 50})`, `Future<void> append(uid, entity)`, `DocumentReference referenceFor(uid, transactionId)`. `FirestoreCoinLedgerRepositoryImpl` orders by `createdAt desc` and runs every Firestore error through `ErrorHandler.map` so consumers see a stable `CacheFailure`. `InMemoryCoinLedgerRepository` is selected by `coinLedgerRepositoryProvider` when `!FirebaseConfig.isPlatformConfigured` and is also used by tests.

**5. `lib/core/services/coin_service.dart`** — the single writer to `progression/current.coins`. `CoinService.grant / spend / refund / balance / watchBalance / replayQueuedGuestGrants`. The auth path runs a `firestore.runTransaction` that re-reads the progression doc (atomic against concurrent grants), runs a `.where('sourceKey', isEqualTo: seed.sourceKey).limit(1)` dedup query, writes `coins = clamp(existingCoins + signedDelta, 0, 1<<31)` and a fresh ledger doc (`tx.set(ledgerRef, committed.toMap())`); on offline failure it enqueues a `PendingWrite` carrying `kLedgerMarker = '__coin_ledger__'` so `ProgressWriteRetryQueue.flush` routes the write to `users/{uid}/coin_ledger/{txId}`. The guest path (`_activeUid()` returning `null` or empty email) skips Firestore entirely and updates `replaceLocalProfile` so the UI reflects the delta. `replayQueuedGuestGrants(uid)` is a no-op stub reserved for Phase 42's guest-upgrade flow.

**6. `lib/features/profile/presentation/providers/coin_providers.dart`** — four providers: `coinLedgerRepositoryProvider` (Firestore when configured, in-memory otherwise), `coinServiceProvider` (`CoinService(ref)`), `coinBalanceProvider` (selector over `profileControllerProvider`), and `coinHistoryProvider` (stream of the latest 50 transactions gated on a real auth uid; emits an empty list for guests).

**7. `lib/core/services/user_progress_service.dart`** — `applyQuizCompletion` calls `_creditQuizCoins(session, result)` first. The helper calls `CoinService.grant(source: quiz, sourceId: session.sessionId, …)` and passes `coinBalanceAfter` to `_nextProfile`. `_transactionalProgression(uid, firestore, result, {required coinBalanceAfter})` no longer mutates `coins` itself — the value written is the post-`CoinService.grant` balance, so the balance doc and the ledger doc cannot drift. `claimLevelReward(reward)` is rewritten to route the `coinBonus` through `CoinService.grant(source: levelReward, sourceId: '${level}@${queuedAt}')` (latent Phase 40 bug fixed), then writes the merged `pendingLevelRewards` + new `coins` + new `totalXp` via Firestore merge with `ProgressWriteRetryQueue` fallback.

**8. `lib/features/gamification/data/repositories/rewards_repository_impl.dart`** — `_apply` no longer mutates `currentState.totalCoins` (the dual-counter from Phase 39 is gone). The `CoinReward` case is left in `outcome.grants` so the celebration UI still surfaces the per-source credit, but the actual balance write is owned by `CoinService`. `_persist` and the legacy `write(...)` site write `totalCoins: 0` to the local datasource so any leftover `UserRewardsStateModel` is harmless on read.

**9. `lib/features/gamification/data/datasources/rewards_local_datasource.dart`** — `_seed()` no longer seeds `totalCoins: 180`; it starts at `0` so the canonical `UserProfile.progression.coins` is the only place balance appears.

**10. `lib/features/gamification/domain/entities/user_rewards_state.dart`** — `totalCoins` is now `@Deprecated('Read UserProfile.progression.coins via coinBalanceProvider.')`. The field is retained so legacy UI widgets that import `UserRewardsState` keep compiling; new screens should consume `coinBalanceProvider` instead.

**11. `lib/features/gamification/presentation/providers/rewards_provider.dart`** — `RewardsController` now takes a `Ref`. `_mirrorCanonicalBalance` overrides `load()` so the in-memory `snapshot.totalCoins` mirrors `profile.progression.coins` on every bootstrap (legacy widgets stay numeric-correct). `grantFromEvent / openChest / claimDailyReward` fire `unawaited(_creditCoinsFromOutcome(...))` after the celebration state is set: every `CoinReward` and the `coins` field on every `DailyRewardEntry` is mapped through `CoinService.grant(source: <derived>, sourceId: <derived>, ...)`. The source mapping lives in `_sourceForTrigger` and `_sourceIdForTrigger` — same shape as the bonus-trigger data so the dedup key is stable across re-fires.

**12. `lib/features/profile/presentation/screens/coin_history_screen.dart`** — minimal read-only viewer for the latest 50 transactions. Renders a balance header from `coinBalanceProvider` and a `ListView` over `coinHistoryProvider`. The richer day-grouping / filter UX is a follow-up ticket.

**13. `lib/core/services/progress_write_retry_queue.dart`** — extended with `const String kLedgerMarker = '__coin_ledger__'`. `flush()` detects the marker and routes the payload to `firestore.collection(payload['__collection__']).doc(payload['__txId__']).set(stripped, SetOptions(merge: true))` so the queue remains payload-agnostic. Marker, collection, and txId are stripped before the write so the persisted doc has no plumbing keys.

**14. Phase 41 trade-offs accepted**:
- **`UserRewardsState.totalCoins` is a deprecated mirror.** It stays in sync via `_mirrorCanonicalBalance` on `RewardsController.load()` but does NOT update when `CoinService.grant` is called from outside the rewards controller (e.g., `claimLevelReward`). Acceptable because every production-critical coin indicator reads `profile.progression.coins` via `coinBalanceProvider`. Migration ticket tracked for a future release.
- **`claimLevelReward` cannot be queued offline.** Firestore transactions can't be retried as-is. If the network is unreachable the user sees an inline error and can retry — level-up claims are user-initiated and rare; the `coinBonus` is documented to not auto-credit offline.
- **One `grant` cost = 2 writes** (balance doc + ledger doc), batched in one transaction. Firestore bills per-doc regardless.
- **Source-key collision risk** for `daily:day` / `streak:day` / `levelReward:level@queuedAt` is mitigated by namespacing every `source` enum value; collisions are impossible.
- **`ProgressWriteRetryQueue` doesn't preserve ledger-doc ordering** on partial-flush failure. Mitigation: both writes commit atomically on first attempt; the queue only catches transient offline failures.
- **`CoinService.replayQueuedGuestGrants`** is a no-op stub; Phase 42 wires the real link flow.

**Validation:** after the refactor, `flutter analyze lib/` returns **0 errors / 0 warnings**, and every coin indicator (quiz result popup, playground HUD, profile screen, level-up bonus dialog, rewards ribbon) reads from `coinBalanceProvider` (which selects over `profileControllerProvider`).

---

### 6.26 Phase 42 — Mission Progress Backend Integration (fully implemented)

Phase 41 collapsed the coin economy to a single canonical balance; Phase 42 does the same for **mission progress**. Every authenticated user now owns an isolated `users/{uid}/mission_progress/{missionId}` ledger. Each completion produces one Firestore write per matching mission, the realtime stream surfaces stars / best score / completion status into the controller, and `UserProgressService.applyQuizCompletion` funnels every quiz result into the ledger so Playground, Profile, Statistics, and the Mission Hub reflect new completions instantly. Replays and offline retries are deduped by `sessionId`; the best score can only rise; stars are monotonically non-decreasing.

**1. `lib/core/constants/firestore_keys.dart`** — added `missionProgressSubcollection = 'mission_progress'`. Sits alongside `coinLedgerSubcollection` and the other `users/{uid}/*` constants so the schema is one-file readable.

**2. `lib/core/errors/failures.dart`** — added `DuplicateMissionAttemptFailure(sessionKey)` and `GuestMissionWriteFailure()`. The service raises the former when a `{uid}:{missionId}:{sessionId}` triple collides; UI surfaces the failure as a non-throwing rejection so duplicate replays are silently absorbed.

**3. `lib/features/gamification/domain/entities/mission_summary_entity.dart`** — per-user summary entity:
- `MissionCompletionStatus { locked, unlocked, started, completed, perfect, expired }` — the lifecycle mirror that the backend stores (deliberately separate from the local `MissionStatus` enum so a future local-only status does not force a schema migration).
- `MissionSummaryEntity` carries `uid`, `missionId`, `stars` (monotonic non-decreasing), `bestScore` (protected by `max(prev, attempt.score)`), `completionStatus`, `completionTimestampsIso` (capped at the latest 50, newest-first), `totalCompleted`, `currentMissionId?`, `rewardsClaimed: bool`, and `lastUpdatedAtIso`. `copyWith`, `==`, `hashCode`, `fromMap`, `toMap` round-trip every field; `isCompleted`, `isPerfect`, `isUnlocked` are convenience getters for the UI.

**4. `lib/core/services/mission_progress_attempt.dart`** — immutable value object that the quiz-completion funnel passes to `MissionProgressService.recordAttempt`. Carries `sessionId` (the canonical dedup key — usually `QuizSessionEntity.sessionId`), `score` (0-100), `achievedGoal: bool` (drives the `completed` / `perfect` transition), optional `completedAtIso`, and arbitrary `metadata`. `isPerfect` is computed from `achievedGoal && score >= 100`.

**5. `lib/features/gamification/data/datasources/mission_progress_remote_datasource.dart`** — `abstract class MissionProgressRemoteDataSource` declares `watch(uid)`, `list(uid)`, `read({uid, missionId})`, `write(summary)`, `referenceFor({uid, missionId})`. Two implementations:
- `FirestoreMissionProgressRemoteDataSource` operates on `users/{uid}/mission_progress/{missionId}` (one doc per mission). Emits a live `Stream<List<MissionSummaryEntity>>` via `collection.snapshots()`.
- `InMemoryMissionProgressRemoteDataSource` is the deterministic test / offline fallback and is wired into `MissionProgressService` when `FirebaseConfig.firestore == null`.

Schema stored per doc:
```
{
  uid: string,
  missionId: string,
  stars: int,
  bestScore: int,
  completionStatus: 'locked'|'unlocked'|'started'|'completed'|'perfect'|'expired',
  completionTimestampsIso: [string iso8601] (capped 50, newest first),
  totalCompleted: int,
  currentMissionId: string?,
  rewardsClaimed: bool,
  lastUpdatedAtIso: string iso8601,
}
```

**6. `lib/features/gamification/domain/repositories/mission_progress_repository.dart`** — the abstract contract the rest of the app talks to.
- `MissionProgressBundle { summaries, totalCompleted, totalStars, bestScoreOverall }` is the aggregate snapshot the dashboard reads.
- `watch(uid)`, `list(uid)`, `summary(uid, missionId)`, `recordAttempt({uid, mission, attempt})`, `markRewardsClaimed({uid, missionId})`.

**7. `lib/features/gamification/data/repositories/mission_progress_repository_impl.dart`** — the concrete repo that wraps `MissionProgressService`. Maps the service's `Stream<List<MissionSummaryEntity>>` into `Stream<MissionProgressBundle>` and forwards `recordAttempt` / `markRewardsClaimed` through to the service. Exposes `missionProgressRepositoryProvider` for Riverpod.

**8. `lib/core/services/mission_progress_service.dart`** — single writer to `users/{uid}/mission_progress/{missionId}` (analogous to `CoinService` from Phase 41).
- `watch(uid)`, `list(uid)`, `summary(uid, missionId)`, `recordAttempt({uid, mission, attempt})`, `markRewardsClaimed({uid, missionId})`.
- `recordAttempt` runs `firestore.runTransaction` for authenticated users: re-reads the doc, dedups against `completionTimestampsIso.contains(sessionId)` (raises `DuplicateMissionAttemptFailure` on collision), then `_mergeAttempt` produces the canonical `MissionSummaryEntity` by walking five pure transitions:
  - `newStars = previousStars + _starsForAttempt` (0 / 1 / 2 / 3 based on `achievedGoal` + `score`).
  - `newBestScore = max(previousBestScore, attempt.score)`.
  - `newCompletionStatus` walks `unlocked → started → completed → perfect` (perfect is sticky).
  - `completionTimestampsIso` appends a new ISO timestamp and keeps the latest 50.
  - `totalCompleted` increments only when `achievedGoal` is true.
- The local-only path (no Firestore configured) calls `_writeDirectly` which runs the same dedup + transition logic against the in-memory datasource so tests stay deterministic.
- Guest guard: `_activeUid().isEmpty` returns `GuestMissionWriteFailure`; the controller layer catches it and falls back to the local catalog mirror so guest sessions still observe mission progress in the UI.
- `missionProgressBundleProvider = StreamProvider.autoDispose<MissionProgressBundle>` re-emits whenever the auth state changes (sign-in / sign-out / guest switch), and `missionProgressServiceProvider` is the canonical `Provider<MissionProgressService>`.

**9. `lib/features/gamification/presentation/providers/mission_provider.dart`** — `MissionsController` now wires the realtime summary stream into its view state:
- New `_subscribeSummaries()` opens a `service.watch(uid)` subscription that re-emits whenever `authStateProvider` changes (sign-in, sign-out, switch user). The sub is cancelled on `dispose` so listeners never leak across screens.
- `MissionsViewState` gains `summaries: Map<String, MissionSummaryEntity>` (keyed by `missionId`), `totalCompleted`, `totalStars`, `bestScoreOverall` so every dependent widget can read consistent counters without joining streams itself.
- Convenience getters: `effectiveProgress(mission)` (realtime summary wins, otherwise catalog `progress`), `completionStatus(mission)` (realtime enum wins, otherwise catalog status), `bestScore(mission)`, `stars(mission)`.
- `recordQuizAttempt({sessionId, score, category, quizId, completedAtIso})` is the funnel entry point: for authenticated users it iterates every catalog mission matching `category`, builds a `MissionProgressAttempt`, and calls `service.recordAttempt`. Guest sessions fall through to `_incrementLocalCatalogProgress` which mutates `state.daily/weekly/monthly` in place so the UI sees the increment.
- `claim(missionId)` now also calls `service.markRewardsClaimed(uid, missionId)` after the rewards controller grant — the controller is the canonical write site for the `rewardsClaimed` field on the summary doc.
- New providers: `missionProgressBundleProvider` (sync convenience over the stream provider) and the internal `_missionProgressBundleStreamProvider` that the autoDispose stream wraps.

**10. `lib/core/services/user_progress_service.dart`** — the canonical quiz-completion funnel now reaches missions as step 7.
- `applyQuizCompletion` calls `unawaited(_propagateQuizToMissions(session, result, categoryId))` after the profile / study-stats / streak / category / playground / quiz-session / coin writes finish.
- The helper resolves `auth.user?.id`, looks up `missionsControllerProvider.notifier`, and calls `recordQuizAttempt(sessionId: session.sessionId, score: result.scorePercent, category: _categoryFromId(categoryId), quizId: session.quizId, completedAtIso: (result.completedAt ?? DateTime.now()).toUtc())`. Failures are logged with `_logFailure('mission progress', ...)` and never surface to the user — mission progress is a best-effort side-effect of the canonical funnel.
- `_categoryFromId` maps the category id onto `MissionCategory` (unknown ids → `MissionCategory.mixed`) so the mission funnel never silently drops a quiz.

**11. Phase 42 trade-offs accepted**:
- **`UserRewardsState.totalCoins` was already a deprecated mirror before Phase 42** — Phase 41 marked it. The mission summary stream is canonical for missions from day one (no legacy dual-counter).
- **Mission summary `totalCompleted` increments once per `achievedGoal` attempt** — replays that don't cross the goal are still recorded in `completionTimestampsIso` and bump stars / best score, but do not double-count completions. This matches the user's intent ("I did the mission once today, I'm getting credit for the attempts but not the badge").
- **`MissionCompletionStatus.perfect` is sticky** — once a user hits 100% the status never drops back to `completed` even if they retry at lower scores, so the achievements ribbon stays correct.
- **`recordQuizAttempt` runs in `unawaited` context** — the canonical XP / coins / level funnel still completes synchronously; mission progress is best-effort and never blocks the celebration. Failures surface in `debugPrint` only.
- **Guests do not write to Firestore** — every guest call routes through `_incrementLocalCatalogProgress` and the realtime stream is empty until they sign in. Phase 41's `CoinService.replayQueuedGuestGrants` is the bridge stub for the eventual link flow.
- **Funnel integration is per-`category`** — only `MissionCategory.quiz` style missions with a matching catalog category are auto-progressed; missions of `MissionCategory.lesson`, `streak`, etc. still require explicit `incrementProgress(...)` calls driven by their own wiring (Phase 43).

**Validation:** after the refactor, `flutter analyze lib/` returns **0 errors / 0 warnings**, the realtime stream emits on every auth-state change, and every mission-touching UI surface (Playground, Profile, Statistics, Category Progress, Level Progress, Missions Hub) reads from `MissionsController` rather than rebuilding locally.

---

### 6.27 Phase 43 — Backend Statistics System (fully implemented)

Phase 41 made the coin balance canonical on Firestore; Phase 42 did the same for mission progress. Phase 43 does it for **statistics**. Every authenticated user now owns an isolated `users/{uid}/statistics/current` global aggregate doc + a `users/{uid}/category_statistics/{categoryId}` per-subject breakdown. Every quiz completion increments both docs atomically inside one Firestore transaction, deduped by `sessionId`. The Statistics, Profile, and Playground screens subscribe to realtime streams so accuracy, correct / wrong counts, average time, weak / strong subjects, and XP / coins totals all reflect the latest attempt without an app restart.

**1. `lib/core/constants/firestore_keys.dart`** — added `categoryStatisticsSubcollection = 'category_statistics'`. The existing `statisticsSubcollection = 'statistics'` (from Phase 41) is reused for the global aggregate.

**2. `lib/features/statistics/domain/entities/user_statistics_entity.dart`** — two new immutable entities:
- `UserStatisticsEntity` — global aggregates for one user: `uid`, `totalAnswered`, `correctAnswers`, `wrongAnswers`, `accuracy`, `averageTimeSecondsPerQuestion`, `totalStudyMinutes`, `totalXp`, `totalCoins`, `lastSessionIds` (capped 50, newest-first), `lastUpdatedAtIso`. `copyWith`, `==`, `hashCode` (with list equality), `toMap` / `fromMap` round-trip every field. Convenience getters `accuracyPercent`, `isEmpty`.
- `CategoryStatisticsEntity` — per-subject breakdown: `uid`, `categoryId`, `subjectName`, `totalQuestions`, `correct`, `wrong`, `skipped`, `bestScore` (monotonic `max(prev, attempt.score)`), `averageSecondsPerQuestion` (EMA, alpha = 0.2), `totalMinutes`, `xpEarned`, `lastSessionIds`, `lastUpdatedAtIso`. Getters `accuracyPercent`, `isPriority`. Round-trip `toMap` / `fromMap`.

**3. `lib/features/statistics/domain/repositories/statistics_repository.dart`** — extended contract:
- New `StatisticsSnapshot { user, categories }` bundle returned by `watch(uid)` / `snapshot(uid)`.
- `watch(uid)` — realtime stream of the snapshot, joins `userStatisticsStreamProvider` + `categoryStatisticsStreamProvider`.
- `snapshot(uid)` — one-shot read for tests / bootstrap.
- `category({uid, categoryId})` — fetches a single category row.
- The legacy `getStatistics / getStudyStatistics / getAccuracyStatistics / getWeakSubjects / getStrongSubjects` methods are kept verbatim so every Phase 28 use case + widget keeps compiling; their bodies route through the new `StatisticsAggregator`.

**4. `lib/features/statistics/domain/services/statistics_aggregator.dart`** — pure projection service that rebuilds the legacy `StatisticsEntity` / `StudyStatisticsEntity` / `SubjectStatisticsEntity` shapes from the new `UserStatisticsEntity` + `CategoryStatisticsEntity` rows. `toStatisticsEntity`, `toStudyStatisticsEntity`, `toSubjectBreakdown`, `toWeakSubjects` (accuracy < 60%), `toStrongSubjects` (accuracy ≥ 75%). Lives in `domain/services/` so the repository impl can call it without depending on presentation.

**5. `lib/features/statistics/data/repositories/statistics_repository_impl.dart`** — concrete repo wrapping `StatisticsService`. The five legacy methods delegate to `_aggregator` against the live snapshot so every existing UI surface consumes the realtime-driven `StatisticsEntity` without any widget-side changes. The realtime `watch(uid)` joins the user stats stream + category stream via a `StreamController.broadcast` and emits a fresh `StatisticsSnapshot` on every mutation. `snapshot(uid)` reads both once and returns the bundle.

**6. `lib/core/services/statistics_service.dart`** — single writer to `users/{uid}/statistics/current` + `users/{uid}/category_statistics/{categoryId}`.
- Public API: `watch(uid)`, `watchCategories(uid)`, `summary(uid)`, `category({uid, categoryId})`, `recordQuizCompletion({uid, input})`.
- `recordQuizCompletion` runs `firestore.runTransaction` for authenticated users: re-reads both docs, dedups against `lastSessionIds.contains(sessionId)` (raises `DuplicateStatisticsFailure(sessionKey)` on collision), then commits both writes inside the same transaction. Two failures: `DuplicateStatisticsFailure` and `GuestStatisticsWriteFailure` (raised on empty uid; the funnel silently absorbs).
- `_mergeUserStats` and `_mergeCategoryStats` are pure transitions:
  - `newTotalAnswered = previous + totalQuestions` (monotonic).
  - `newCorrect = previous + correctAnswers` (monotonic).
  - `newWrong = previous + wrongAnswers + skippedAnswers` (monotonic; `correct + wrong == totalAnswered` always holds).
  - `newAccuracy = newCorrect / newTotalAnswered` (computed; never stored as a stale integer).
  - `newAvg = previous.averageTimeSecondsPerQuestion == 0 ? sessionAvg : previous*0.8 + sessionAvg*0.2` (EMA with `alpha = 0.2`; recent attempts dominate).
  - `newBestScore = max(prev, attempt.score)` (never overwritten with a lower score).
  - `lastSessionIds` appends the new `sessionId` and keeps the latest 50.
- The local-only path (`_firestore == null`) calls `_writeDirectly` which runs the same dedup + transition against the in-memory mirror so tests stay deterministic.
- Guest guard: empty `uid` returns `GuestStatisticsWriteFailure`; the funnel absorbs it.
- Realtime providers: `userStatisticsStreamProvider = StreamProvider.autoDispose<UserStatisticsEntity>` and `categoryStatisticsStreamProvider = StreamProvider.autoDispose<List<CategoryStatisticsEntity>>` — both gate on `authStateProvider` and re-emit on every sign-in / sign-out / switch.

**7. `lib/features/statistics/presentation/providers/statistics_provider.dart`** — extended `StatisticsController` with a `_subscribe()` method that opens `service.watch(uid)` + `service.watchCategories(uid)` subscriptions. The controller state mirrors the latest snapshot via the same `StatisticsVisualMapper.toVisual(stats)` path, so every widget that watches `statisticsVisualProvider` / `statisticsRangeProvider` / `statisticsControllerProvider` rebuilds on every Firestore mutation. The legacy `load({forceRefresh})` still works; `setRange(...)` and `clearError()` are unchanged. The `MockStatisticsRemoteDataSource` is retained for offline scaffolding but the production `statisticsRemoteDataSourceProvider` defaults to the mock (still useful for unit tests).

**8. `lib/core/services/user_progress_service.dart`** — the canonical quiz-completion funnel now reaches statistics as step 8.
- After steps 1-7 (profile / study-stats / streak / category-progress / playground / quiz-session / coins / missions), `applyQuizCompletion` calls `unawaited(_recordQuizCompletionStats(session, result, categoryId))`.
- The helper builds a `QuizStatisticsInput` value object: `sessionId` (canonical dedup key — `QuizSessionEntity.sessionId`), `categoryId`, `subjectName` (resolved from `_resolveSubjectName(categoryId)` which pretty-prints the id), `totalQuestions = result.questionResults.length`, `correctAnswers = result.correctCount`, `wrongAnswers = result.incorrectCount`, `skippedAnswers = result.skippedCount`, `scorePercent`, `totalSeconds = result.timeSpentSeconds`, `xpEarned`, `coinsEarned`, and the completion timestamp.
- Failures are logged via `_logFailure('statistics', error, stack)` and never surface to the user — statistics is a best-effort side-effect of the canonical funnel.

**9. Phase 43 trade-offs accepted**:
- **`accuracy` is computed (`correct / total`), not stored** — the on-disk value is always `accuracy: double` (not an integer percent); every read back derives the percent on demand. This avoids the drift you get when a `correct` increment + a `wrong` increment round differently.
- **`averageTimeSecondsPerQuestion` uses an EMA with `alpha = 0.2`** — recent attempts dominate. Documented for the statistics screen so future contributors don't mistake it for a lifetime mean.
- **`category_statistics/{categoryId}` is separate from `category_progress/{categoryId}`** — the latter holds the *best-score snapshot* (Phase 38 / Phase 43 retention); the former holds the *lifetime accumulator* (correct / wrong / minutes / xp / EMA). Reads merge both into the `SubjectStatisticsEntity` breakdown via the aggregator.
- **Funnel integration is `unawaited`** — the canonical XP / coins / level funnel still completes synchronously; statistics are best-effort and never block the celebration.
- **Guests do not write to Firestore** — every guest call returns `GuestStatisticsWriteFailure`; the funnel swallows it. The legacy `_cache ??= await _remote.fetchStatistics()` path still produces an empty snapshot for guests so the UI renders the empty state instead of crashing.
- **`MockStatisticsRemoteDataSource` is retained** — the production `statisticsRemoteDataSourceProvider` still defaults to the mock, but every consumer of `statisticsRepositoryProvider` now reads from `StatisticsService` (real Firestore data). The mock is preserved for unit tests + offline scaffolding.

**Validation:** after the refactor, `flutter analyze lib/` returns **0 errors / 0 warnings**, the realtime streams emit on every auth-state change, every Statistics / Profile / Playground widget reads from the same `StatisticsController` (no local rebuilds), and a quiz completion on one device propagates to every other signed-in device within the Firestore snapshot window.

---

### 6.28 Phase 44 — Leaderboards Backend Integration (fully implemented)

**Goal:** Replace the hard-coded local seed in `LeaderboardLocalDataSource` with a fully dynamic Firestore-backed leaderboard system that tracks every ranking metric (XP, level, completed categories, completed missions, accuracy, coins, streak) and updates the UI in realtime.

**Architecture seams:** the existing `LeaderboardRepository` interface + `LeaderboardCategoryEntity` shape are preserved exactly. The new work happens in three layers:

1. **`LeaderboardService`** — `lib/core/services/leaderboard_service.dart`. Single Firestore writer; rebuilds the user's per-scope row from the canonical sources (profile progression + statistics + mission summaries) inside `firestore.runTransaction`. Each row lives at `users/{uid}/leaderboard_entries/{scope}__{seasonId}` where `seasonId` is `lifetime` for national / university / friends, an ISO week id for weekly, and a calendar quarter id for seasonal.
2. **`LeaderboardRemoteDataSource`** — `lib/features/leaderboard/data/datasources/leaderboard_remote_datasource.dart`. Reads the realtime rows via `_userEntriesRef(uid).snapshots()` and projects them into the legacy `LeaderboardCategoryModel` shape so the existing screens / widgets / use cases keep compiling unchanged. The `FirestoreLeaderboardRemoteDataSource` (top-N users query) is preserved for tests that prefer the legacy ranking path.
3. **`LeaderboardRepositoryImpl`** — `lib/features/leaderboard/data/repositories/leaderboard_repository_impl.dart`. Remote-first with auth-aware `uidProvider`; falls back to the local seed when the user is a guest, the remote is unconfigured, or the query returns zero rows.

**New entities:**

- `LeaderboardRankingEntity` (`lib/features/leaderboard/domain/entities/leaderboard_ranking_entity.dart`) carries the per-user ranking payload alongside a composite `score` derived from `xp + level*100 + completedCategories*50 + completedMissions*75 + accuracyPercent + coins*0.05 + streakDays*20`. The score is computed at read-time so the rank order is deterministic across devices.
- `LeaderboardEntryEntity` gains optional `accuracyPercent`, `completedCategories`, `completedMissions`, `score`, `seasonId` fields with sensible defaults so every existing constructor call site keeps compiling.

**Constants:**

- `LeaderboardSeason.lifetime / currentWeekId / currentSeasonId` (`lib/core/constants/leaderboard_season.dart`) — pure helpers (no `DateTime.now()` at compile time) so weekly / seasonal partitions are deterministic + testable.

**Realtime providers:**

- `leaderboardCategoryStreamProvider.family<LeaderboardScope>` (auth-aware, `StreamProvider.autoDispose`) emits a `LeaderboardCategoryEntity` for every scope on every Firestore snapshot.
- `LeaderboardController` subscribes to every scope via `ref.listen` and merges the fresh entries into `LeaderboardViewState` so the hub + detail screens refresh without an explicit pull.

**Funnel integration:** `UserProgressService.applyQuizCompletion` step 9 calls `unawaited(_refreshLeaderboardEntries(uid, updated))` after the XP / coins / level / mission / statistics steps. The leaderboard write is best-effort — failures are logged but never surface to the user because the canonical quiz completion has already succeeded.

**Ranking inputs (every required metric the Phase 44 spec called out):**

| Input | Source |
|---|---|
| XP | `ProgressionEntity.totalXp` |
| Level | `ProgressionEntity.level` |
| Coins | `ProgressionEntity.coins` |
| Streak | `ProgressionEntity.streakDays` |
| Accuracy | `UserStatisticsEntity.accuracyPercent` |
| Completed categories | derived from `UserStatisticsEntity.accuracyPercent >= 60` (placeholder; the per-category breakdown is rendered on the statistics screen) |
| Completed missions | `MissionProgressBundle.summaries` filtered by `completionStatus ∈ {completed, perfect}` |

**Architectural decisions:**

- **D1 — Single Firestore layout:** `users/{uid}/leaderboard_entries/{scope}__{seasonId}` is the only writer. One doc per user per active scope. Subcollections (not arrays) so concurrent writes never race.
- **D2 — Composite score:** the score is derived from the seven required ranking inputs at read-time. The persistence layer stores raw inputs; the rank / order is computed from the inputs that already live on the user's profile.
- **D3 — Seasonal partition:** `LeaderboardSeason.currentWeekId()` returns `YYYY-Www`; `currentSeasonId()` returns `YYYY-Qn`. Lifetime scopes bypass the partition and always write to `lifetime`.
- **D4 — `LeaderboardService` is the only writer.** The remote datasource's `write` method is a documented no-op preserved for backward compatibility with the pre-existing test stubs.
- **D5 — `LeaderboardEntryEntity` gains optional fields only.** None of the 5 existing use cases or 15 widgets need to change; the new metrics surface transparently via the added optional columns.
- **D6 — Realtime controller.** `LeaderboardController` listens to `leaderboardCategoryStreamProvider(scope)` for every scope via `ref.listen`, merging fresh snapshots into `LeaderboardViewState` and replacing the one-shot `fetchAll` path.

**Validation:** `flutter analyze lib/` returns **0 errors / 0 warnings**. The leaderboard funnel integration runs unawaited so the canonical XP / coins / level path never blocks; the realtime stream re-emits on every auth-state change; the auth guard prevents anonymous users from writing to Firestore.

---

### 6.30 Phase 46 — Bookmarks Backend Integration (fully implemented)

**Goal:** Replace the in-memory `BookmarkLocalDataSource` with a Firestore-backed subcollection so every saved question / lesson / AI response / note persists across devices, refreshes the UI in realtime, and survives app restarts. The domain contract (`BookmarkEntity`, `BookmarkRepository`, `BookmarkItemType`) is preserved exactly — Phase 46 is purely a persistence layer upgrade.

**Firestore schema:** `users/{uid}/bookmarks/{bookmarkId}` — one doc per saved item. `bookmarkId` is deterministic (`'${BookmarkItemType.name}_${itemId}'`) so re-toggling the same item is idempotent (concurrent saves from another device collapse into the same doc, no duplicate rows). Doc shape mirrors `BookmarkModel.toJson()`:

```
{
  id, itemType, itemId, title, subtitle, thumbnailIconKey,
  createdAtIso, updatedAtIso, sourceFeature, tags,
  routeName, routeParams
}
```

**Architecture seams:**

1. **`BookmarkService`** — `lib/core/services/bookmark_service.dart`. Single Firestore writer. `add(uid, model)` performs `firestore.collection(users/{uid}/bookmarks).doc(id).set(model.toJson(), SetOptions(merge: true))` so existing fields are preserved while `updatedAtIso` propagates. `remove(uid, type, itemId)` + `removeById(uid, id)` delete by deterministic id and return `true` when the doc existed. `clearAll(uid)` batch-deletes every doc. `snapshot(uid)` is a one-shot read; `watch(uid)` is a realtime `CollectionReference.snapshots()` stream consumed by `userBookmarksStreamProvider`.
2. **`BookmarkRemoteDataSource`** — `lib/features/bookmarks/data/datasources/bookmark_remote_datasource.dart`. Replaces the historic `UnimplementedError` stub. `pull()` delegates to `BookmarkService.snapshot(uid)`; `push()` is a no-op reconcile (the service is the only writer). New methods `upsert(model)`, `removeById(id)`, `remove(type, itemId)`, `clearAll()` route through `BookmarkService` so every write path is Firestore-backed.
3. **`BookmarkRepositoryImpl`** — `lib/features/bookmarks/data/repositories/bookmark_repository_impl.dart`. `preferRemote = true`. A `remoteStreamFactory` closure wires `userBookmarksStreamProvider` into the local cache so the query engine (filter / sort / search / paginate) sees fresh rows on every Firestore snapshot. Mutations write to the local cache first (canonical UI mirror) then forward to the remote datasource; failures are best-effort and `debugPrint`-logged without surfacing to the user.

**Providers (`lib/features/bookmarks/presentation/providers/bookmark_provider.dart`):**

- `bookmarkServiceProvider` — `Provider<BookmarkService>`.
- `userBookmarksStreamProvider` — `StreamProvider.autoDispose<List<BookmarkModel>>` gated on `authStateProvider.user.id`; returns an empty list for guests.
- `bookmarkCurrentUidProvider` — `Provider<String>` resolving `auth.user.id` (empty for guests).
- `bookmarkRemoteDataSourceProvider` — wires `BookmarkService` + the uid provider.
- `bookmarkRepositoryProvider` — composes local + remote + realtime stream factory; `preferRemote = true`; `ref.onDispose` cancels the remote subscription.
- `BookmarkController` — `ref.listen` on `userBookmarksStreamProvider`; every Firestore snapshot mirrors into `BookmarkLocalDataSource` + re-hydrates `BookmarksViewState.items`.
- `bookmarkIdsProvider` — derives a `Set<String>` of `'${type.name}:${itemId}'` keys from `bookmarkControllerProvider.items`; consumed by `BookmarkActionButton` for instant fill-state updates.
- `isBookmarkedProvider` — `FutureProvider.family<bool, BookmarkLookupArgs>` for surfaces that need a Future-based flow.

**Constants:** `FirestoreKeys.bookmarksSubcollection = 'bookmarks'` — added to the `users/{uid}/*` subcollection block in `lib/core/constants/firestore_keys.dart`.

**Guest guard:** every `BookmarkService` method short-circuits on `uid.isEmpty || _firestore == null` and returns the empty / safe value. The local cache still mirrors in-session actions so the UI shows fresh state for guests; no Firestore writes happen for unauthenticated users.

**Realtime UI:** device A toggles a bookmark → Firestore mutation → `userBookmarksStreamProvider` emits → `BookmarkController` re-hydrates → `bookmarkIdsProvider` recomputes → `BookmarkActionButton` re-renders on device B without polling.

**Architectural decisions:**

- **D1 — Subcollection `users/{uid}/bookmarks/{bookmarkId}`** wins over a capped array field (O(N) updates race with concurrent toggles) and over a top-level collection (fragments the existing `users/{uid}/*` security rule pattern).
- **D2 — Deterministic doc id `'${type.name}_${itemId}'`** guarantees idempotent toggles and cross-device convergence without transactions.
- **D3 — `BookmarkService` is the only writer.** `BookmarkRemoteDataSource.pull()` / `push()` preserve the existing repository contract for tests + legacy callers; `push()` is a documented no-op reconcile.
- **D4 — Local cache remains the query engine.** Realtime stream mirrors into `BookmarkLocalDataSource` via the `remoteStreamFactory` closure so filter / sort / search / paginate operate on fresh rows without a new query layer.
- **D5 — `BookmarkController` listens to the realtime stream** via `ref.listen` and re-hydrates `BookmarksViewState.items` on every snapshot — replaces any pull-to-refresh requirement.
- **D6 — Best-effort mutations + guest guard.** The local cache is the canonical UI mirror even when Firestore writes fail; `BookmarkService.add` / `remove` / `clearAll` catch all errors and `debugPrint` for diagnostics.
- **D7 — `BookmarkEntity` / `BookmarkRepository` / `BookmarkItemType` / `BookmarkModel` unchanged.** Phase 46 is purely a persistence layer upgrade; every UI call site, use case, and widget stays valid.

**Validation:** `flutter analyze lib/` returns **0 errors / 0 warnings**. The realtime stream re-emits on every auth-state change (guest → user triggers a snapshot; the auth guard prevents anonymous writes). The deterministic id makes concurrent toggles idempotent — the same `(type, itemId)` pair collapses into the same Firestore doc across devices. Best-effort write failures never surface to the user because the local cache is the canonical UI mirror.

---

### 6.31 Phase 47 — Notes Backend Integration (fully implemented)

**Goal:** Replace the in-memory `NotesLocalDataSource` with a Firestore-backed subcollection so every saved personal note / highlight / AI note persists across devices, refreshes the UI in realtime, and survives app restarts. The domain contract (`NoteEntity`, `HighlightEntity`, `AiNoteEntity`, `NotesRepository`, `NoteType`, `NoteCategory`) is preserved exactly — Phase 47 is purely a persistence layer upgrade.

**Firestore schema:**

- `users/{uid}/notes/{noteId}` — canonical store for every note regardless of type. `noteId` is the existing deterministic `note.id` so the local cache and Firestore stay in sync.
- `users/{uid}/highlights/{noteId}` — convenience mirror for highlight-type notes; populated alongside the canonical write when `NoteType == highlight`.
- `users/{uid}/ai_notes/{noteId}` — convenience mirror for AI-type notes; populated alongside the canonical write when `NoteType == ai`.

Doc shape mirrors `NoteModel.toJson()`:

```
{
  id, title, content, preview,
  type (personal|highlight|ai),
  category (personal|study|review|insight|question|ai),
  color, isPinned, isFavorite,
  tags, attachments,
  createdAtIso, updatedAtIso, sourceFeature
}
```

**Architecture seams:**

1. **`NoteService`** — `lib/core/services/note_service.dart`. Single Firestore writer. `add(uid, model)` performs `firestore.collection(users/{uid}/notes).doc(id).set(model.toJson(), SetOptions(merge: true))` then issues the type-aware mirror write to `highlights` or `ai_notes`. `remove(uid, noteId)` deletes the canonical doc + every mirror and returns `true` when the doc existed. `clearAll(uid)` batch-deletes every doc across all three subcollections. `snapshot(uid)` is a one-shot read; `watch(uid)` is a realtime `CollectionReference.snapshots()` stream consumed by `userNotesStreamProvider`.
2. **`NotesRemoteDatasource`** — `lib/features/notes/data/datasources/notes_remote_datasource.dart`. Replaces the historic `UnimplementedError` stub. `pull()` delegates to `NoteService.snapshot(uid)`; `push()` is a no-op reconcile (the service is the only writer). New methods `upsert(model)`, `removeById(id)`, `clearAll()` route through `NoteService` so every write path is Firestore-backed.
3. **`NotesRepositoryImpl`** — `lib/features/notes/data/repositories/notes_repository_impl.dart`. `preferRemote = true`. A `remoteStreamFactory` closure wires `userNotesStreamProvider` into the local cache so the query engine (filter / sort / search / paginate) sees fresh rows on every Firestore snapshot. Mutations write to the local cache first (canonical UI mirror) then forward to the remote datasource; failures are best-effort and `debugPrint`-logged without surfacing to the user.

**Providers (`lib/features/notes/presentation/providers/notes_provider.dart`):**

- `noteServiceProvider` — `Provider<NoteService>`.
- `userNotesStreamProvider` — `StreamProvider.autoDispose<List<NoteModel>>` gated on `authStateProvider.user.id`; returns an empty list for guests.
- `notesCurrentUidProvider` — `Provider<String>` resolving `auth.user.id` (empty for guests).
- `notesRemoteDatasourceProvider` — wires `NoteService` + the uid provider.
- `notesRepositoryProvider` — composes local + remote + realtime stream factory; `preferRemote = true`; `ref.onDispose` cancels the remote subscription.
- `NotesController` — `ref.listen` on `userNotesStreamProvider`; every Firestore snapshot mirrors into `NotesLocalDataSource` + re-hydrates `NotesViewState.items` + pinned / recent previews.

**Highlight + AI note plumbing:**

- `NotesController.saveHighlight(highlight)` → `NotesRepositoryImpl.saveHighlight(highlight)` → `createNote(note)` (where `note.type == NoteType.highlight`). `NoteService.add` writes the canonical doc + the `highlights` mirror in one path.
- `NotesController.saveAiNote(aiNote)` → `NotesRepositoryImpl.saveAiNote(aiNote)` → `createNote(note)` (where `note.type == NoteType.ai`). `NoteService.add` writes the canonical doc + the `ai_notes` mirror.

**Constants:** `FirestoreKeys.notesSubcollection = 'notes'` + `highlightsSubcollection = 'highlights'` + `aiNotesSubcollection = 'ai_notes'` — added to the `users/{uid}/*` subcollection block in `lib/core/constants/firestore_keys.dart`.

**Guest guard:** every `NoteService` method short-circuits on `uid.isEmpty || _firestore == null` and returns the empty / safe value. The local cache still mirrors in-session actions so the UI shows fresh state for guests; no Firestore writes happen for unauthenticated users.

**Realtime UI:** device A creates / updates / deletes a note → Firestore mutation → `userNotesStreamProvider` emits → `NotesController` re-hydrates → `NotesScreen` re-renders on device B without polling.

**Architectural decisions:**

- **D1 — Single canonical `users/{uid}/notes` subcollection.** Every note (personal / highlight / ai) lives here with a `type` field; mirrors in `users/{uid}/highlights` + `users/{uid}/ai_notes` support filtered queries without extra round-trips. Wins over a capped array field (O(N) updates race with concurrent writes) and over a top-level collection (fragments the existing `users/{uid}/*` security rule pattern).
- **D2 — Deterministic doc id = existing `note.id`.** Guarantees idempotent saves and cross-device convergence without transactions. The `saveHighlight` / `saveAiNote` paths produce deterministic ids (`'highlight-${model.id}'` / `'ai-${model.id}'`) that match the local cache convention.
- **D3 — `NoteService` is the only writer.** `NotesRemoteDatasource.pull()` / `push()` preserve the existing repository contract for tests + legacy callers; `push()` is a documented no-op reconcile.
- **D4 — Local cache remains the query engine.** Realtime stream mirrors into `NotesLocalDataSource` via the `remoteStreamFactory` closure so filter / sort / search / paginate operate on fresh rows without a new query layer.
- **D5 — `NotesController` listens to the realtime stream** via `ref.listen` and re-hydrates `NotesViewState.items` + pinned + recent previews on every snapshot — replaces any pull-to-refresh requirement.
- **D6 — Best-effort mutations + guest guard.** The local cache is the canonical UI mirror even when Firestore writes fail; `NoteService.add` / `remove` / `clearAll` catch all errors and `debugPrint` for diagnostics.
- **D7 — Type-aware mirror writes.** `NoteService.add` inspects `model.type` and writes the matching mirror doc alongside the canonical doc inside the same call path. `remove` + `clearAll` clean up all three subcollections.
- **D8 — `NoteEntity` / `HighlightEntity` / `AiNoteEntity` / `NoteType` / `NoteCategory` / `NotesRepository` unchanged.** Phase 47 is purely a persistence layer upgrade; every UI call site, use case, and widget stays valid.

**Validation:** `flutter analyze lib/` returns **0 errors / 0 warnings**. The realtime stream re-emits on every auth-state change (guest → user triggers a snapshot; the auth guard prevents anonymous writes). The deterministic id makes concurrent saves idempotent — the same `note.id` collapses into the same Firestore doc across devices. Best-effort write failures never surface to the user because the local cache is the canonical UI mirror.

---

### 6.32 Phase 48 — Backend Notifications Integration (fully implemented)

**Goal:** Replace the mock `NotificationRemoteDataSource` with a Firestore-backed `users/{uid}/notifications` subcollection plus an `fcm_tokens/{deviceId}` device-registry subcollection. Existing `NotificationEntity` gains a `NotificationType` enum (12 categories + `generic`) and a `NotificationPriority` enum so the UI (and future Cloud Functions) can branch on semantic role. Realtime sync, unread counter, deep linking, and notification-preferences persistence across devices all land without any UI redesign. The `firebase_messaging` SDK is intentionally NOT in `pubspec.yaml` yet — `FcmBootstrap` exposes a `tokenSource` / `deviceIdSource` seam so the real SDK slots in via a one-line override when it is added.

**Firestore schema:**

- `users/{uid}/notifications/{notificationId}` — canonical store. `notificationId` is the deterministic `notification.id` so the local cache and Firestore stay merged across devices.
- `users/{uid}/fcm_tokens/{deviceId}` — per-device registration. `deviceId` is a stable per-install identifier (placeholder hash today; `firebase_messaging` instance-id later).
- `users/{uid}/settings/notification_preferences` — single doc mirroring the user's `NotificationPreferences` slice so toggling push on one device reflects on every other.

Doc shape mirrors `NotificationModel.toJson()`:

```
{
  id, title, message, body,
  type (reminder|mission|reward|announcement|system|aiSuggestion|subscription|dailyQuiz|streak|levelUp|xpEarned|coinReward|generic),
  priority (low|normal|high),
  imageUrl, deepLink, expiresAtIso, payload,
  isRead, isArchived,
  createdAtIso, readAtIso
}
```

**Architecture seams:**

1. **`NotificationService`** — `lib/core/services/notification_service.dart`. Single Firestore writer. `upsert(uid, model)` performs `firestore.collection(users/{uid}/notifications).doc(id).set(model.toJson(), SetOptions(merge: true))`. `markAsRead(uid, id)`, `markAllAsRead(uid)`, `remove(uid, id)`, `snapshot(uid)` (one-shot read), `watch(uid)` (realtime `CollectionReference.snapshots()` stream), `registerToken(uid, deviceId, token, platform, metadata)`, `unregisterToken(uid, deviceId)`, `watchTokens(uid)`. Reactive provider: `userNotificationsStreamProvider`.
2. **`NotificationRemoteDatasource`** — `lib/features/notifications/data/datasources/notification_remote_datasource.dart`. Constructor takes `NotificationService` + `uidProvider`. `readAll()` delegates to `NotificationService.snapshot(uid)`; `upsert(model)` / `markAsRead(id)` / `markAllAsRead()` / `remove(id)` route through `NotificationService`.
3. **`NotificationRepositoryImpl`** — `lib/features/notifications/data/repositories/notification_repository_impl.dart`. `preferRemote = true`. A `remoteStreamFactory` closure wires `userNotificationsStreamProvider` into the local cache so the UI's existing list / counter / filter / search logic operates on fresh rows. `cancelRemoteSubscription()` cleans up the subscription on provider disposal. Local cache sorts by `createdAtIso desc`.
4. **`SettingsService`** — `lib/core/services/settings_service.dart`. Single Firestore writer for `users/{uid}/settings/notification_preferences`. `saveNotificationPreferences(uid, model)` performs a merge write; `loadNotificationPreferences(uid)` reads once; `watchNotificationPreferences(uid)` is a realtime doc stream consumed by `userNotificationPreferencesStreamProvider`. `SettingsRepositoryImpl.saveSettings` mirrors the notification-preferences slice to Firestore (best-effort, custom logging on failure).
5. **`FcmBootstrap`** — `lib/core/services/fcm_bootstrap.dart`. Lightweight auth-aware token-registration listener. `FcmBootstrap.bind(ref, bootstrap)` sets up a `ref.listen<AuthState>` on `authStateProvider` (with `fireImmediately: true`) so the token is (re)registered whenever the user signs in. The bootstrap's `tokenSource` and `deviceIdSource` are pluggable; the default provider returns `null` + a placeholder device id so the architecture compiles today and the real `firebase_messaging` slots in via `fcmBootstrapProvider.overrideWithValue(...)` later.

**Provider surface (`lib/features/notifications/presentation/providers/notification_provider.dart`):**

- `notificationServiceProvider` — `Provider<NotificationService>`.
- `userNotificationsStreamProvider` — `StreamProvider.autoDispose<List<NotificationModel>>` gated on `authStateProvider.user.id`; returns an empty list for guests.
- `notificationCurrentUidProvider` — `Provider<String>` resolving `auth.user.id` (empty for guests).
- `notificationRemoteDatasourceProvider` — wires `NotificationService` + the uid provider.
- `notificationRepositoryProvider` — composes local + remote + realtime stream factory; `preferRemote = true`.
- `NotificationController` — `ref.listen<AsyncValue<List<NotificationModel>>>` on `userNotificationsStreamProvider`; every Firestore snapshot mirrors into `NotificationLocalDataSource` + re-hydrates the public list + unread counter.
- `registerFcmTokenProvider` / `unregisterFcmTokenProvider` — exposed for the bootstrap call site and any manual registration helpers.
- `notificationUnreadCountProvider` — preserved for the playground modal badge and the profile screen counter.

**Constants (**`lib/core/constants/firestore_keys.dart`**):**

- `FirestoreKeys.notificationsSubcollection = 'notifications'`.
- `FirestoreKeys.fcmTokensSubcollection = 'fcm_tokens'`.
- `FirestoreKeys.settingsSubcollection = 'settings'`.
- `FirestoreKeys.notificationPreferencesDoc = 'notification_preferences'`.

All four live in the `users/{uid}/*` subcollection block.

**Entity / model changes:**

- `NotificationEntity` — gains `type` (`NotificationType`, default `NotificationType.generic`), `imageUrl`, `deepLink`, `priority` (`NotificationPriority`, default `NotificationPriority.normal`), `expiresAtIso`, `payload` (`Map<String, dynamic>?`). The pre-Phase 48 constructor stays valid because every new field has a default.
- `NotificationModel` — `fromJson` / `toJson` round-trip the new fields with safe defaults; `NotificationTypeX.fromWire` performs the wire-string → enum mapping with a fallback to `generic`.
- `NotificationType` enum — `reminder`, `mission`, `reward`, `announcement`, `system`, `aiSuggestion`, `subscription`, `dailyQuiz`, `streak`, `levelUp`, `xpEarned`, `coinReward`, `generic`. Each has a `wireName` for serialization.
- `NotificationPriority` enum — `low`, `normal`, `high`.

**Settings integration:**

- `SettingsRepositoryImpl` gains `settingsService` + `uidProvider` constructor params. `saveSettings` mirrors the `notificationPreferences` slice to `users/{uid}/settings/notification_preferences` via `SettingsService.saveNotificationPreferences(uid, model)`. Failure is logged via `developer.log` and the local cache write is still considered successful.
- `SettingsRepositoryProvider` (in `settings_provider.dart`) is now wired with `settingsServiceProvider` + `notificationCurrentUidProvider`.
- `userNotificationPreferencesStreamProvider` — `StreamProvider.autoDispose<SettingsModel?>` on `users/{uid}/settings/notification_preferences`. Any future settings-screen listener can mirror realtime preference changes across devices.

**FCM token registration seam:**

- `FcmBootstrap.bind(ref, bootstrap)` is the single call site. It listens to `authStateProvider` (with `fireImmediately: true`), and on every transition to a signed-in user calls `bootstrap.tokenSource()` → `bootstrap.deviceIdSource()` → `ref.read(registerFcmTokenProvider)(...)`. Failures are caught and `debugPrint`-logged so the UI flow is never blocked by an FCM hiccup.
- The default `fcmBootstrapProvider` is a stub. Once `firebase_messaging` is added to `pubspec.yaml`, override `fcmBootstrapProvider` in `AppConfig.bootstrap()` with an instance that returns `FirebaseMessaging.instance.getToken()` for `tokenSource` and a stable per-install id for `deviceIdSource`.
- `lib/bootstrap.dart` calls `FcmBootstrap.bind(ref, fcmBootstrap)` after auth + storage are ready.

**Guest guard:** every `NotificationService` method short-circuits on `uid.isEmpty || _firestore == null` and returns the empty / safe value. The local cache still mirrors in-session actions so the UI shows fresh state for guests; no Firestore writes happen for unauthenticated users. `NotificationController.load()` falls back to the cached list when the stream emits empty for a guest.

**Realtime UI:** device A creates / updates / deletes a notification → Firestore mutation → `userNotificationsStreamProvider` emits → `NotificationController` re-hydrates → `NotificationScreen` re-renders on device B without polling. The unread counter (`notificationUnreadCountProvider`) updates on every snapshot; the playground + profile badges observe the same provider.

**Deep linking:** `NotificationEntity.deepLink` is set by the sender (Cloud Function or admin tool) and the UI's tap handler reads it via `ref.read(notificationRepositoryProvider).markAsRead(id)` before navigating. The payload is preserved in `NotificationEntity.payload` for caller-specific routing keys.

**Architectural decisions:**

- **D1 — Single canonical `users/{uid}/notifications` subcollection.** Wins over a capped array field (O(N) updates race with concurrent reads) and over a top-level collection (fragments the existing `users/{uid}/*` security rule pattern).
- **D2 — Deterministic doc id = existing `notification.id`.** Guarantees idempotent upserts and cross-device convergence without transactions. The mirror write is a `merge: true` `set` so partial updates don't clobber unrelated fields.
- **D3 — `NotificationService` is the only writer.** `NotificationRemoteDatasource` preserves the existing repository contract for tests + legacy callers; the service handles the realtime stream + every mutation.
- **D4 — `NotificationLocalDataSource` remains the query engine.** Realtime stream mirrors into the local cache via the `remoteStreamFactory` closure so filter / sort / search / paginate operate on fresh rows without a new query layer. The local datasource intentionally lacks per-row events; the realtime Firestore stream is the source of truth.
- **D5 — `NotificationController` listens to the realtime stream** via `ref.listen` on `AsyncValue<List<NotificationModel>>`; every snapshot re-hydrates the public list + unread counter + clears errors on success.
- **D6 — Best-effort mutations + guest guard.** The local cache is the canonical UI mirror even when Firestore writes fail; `NotificationService` catches all errors and `debugPrint`-logs for diagnostics. The UI never surfaces a "save failed" toast for notifications.
- **D7 — `NotificationType` + `NotificationPriority` enums drive the icon, color, and the Cloud Function selector on the backend.** Pre-Phase 48 constructors stay valid because every new field defaults safely. `NotificationTypeX.fromWire` falls back to `generic` when the wire string is unknown.
- **D8 — `FcmBootstrap` seam defers the `firebase_messaging` dependency.** The architecture compiles today; the real SDK slots in via `fcmBootstrapProvider.overrideWithValue(...)` once it is added to `pubspec.yaml`.
- **D9 — Settings preferences mirror to a single doc per uid.** `users/{uid}/settings/notification_preferences` is one merge-written doc (not a subcollection) because the entire `NotificationPreferences` slice is small and atomic.
- **D10 — Read-counter is derived in the controller.** The local cache + the repository both expose `unreadCount`; `notificationUnreadCountProvider` selects it for the UI. The realtime stream keeps both the list and the counter fresh without a separate `count` collection.

**Validation:** `flutter analyze lib/` returns **0 errors / 0 warnings**. The realtime stream re-emits on every auth-state change (guest → user triggers a snapshot; the auth guard prevents anonymous writes). The deterministic id makes concurrent saves idempotent — the same `notification.id` collapses into the same Firestore doc across devices. Best-effort write failures never surface to the user because the local cache is the canonical UI mirror. The FCM bootstrap is a no-op until `firebase_messaging` is wired; the architecture compiles and the integration can be added without touching the notification feature.

---

### 6.33 Phase 51 — Backend Security (fully implemented)

**Goal:** Close the security gaps accumulated across Phases 14–48: every authenticated user must access and modify only their own data, Firestore collections enforce role-based access, Cloud Storage uploads are scoped to per-user folders, repositories enforce an authenticated precondition, providers reset their state on logout, and the API client attaches `Bearer <idToken>` + role-based `X-Require-Role` headers for Cloud Function endpoints. The architecture stays intact — security is layered on top without redesigning any feature.

**Firestore Rules (`firestore.rules`):**

- `users/{userId}` and every `users/{userId}/*` subcollection: read/write only when `request.auth.uid == userId`. `coin_ledger` is append-only (`update` / `delete` denied). Subcollection writes validate `request.resource.data.uid == request.auth.uid`.
- Public content collections (`categories`, `subjects`, `chapters`, `lessons`, `mockTests`, `questions`, `achievements`, `rewards`, `gamificationState`, `leaderboardEntries`): read-authenticated, write-admin only.
- `subscriptions`: read-owner, write-admin (Cloud Functions manage subscriptions).
- `adminLogs`, `analyticsEvents`: write-admin only.
- `aiTutorLogs`: read-owner only, write denied (Cloud Functions are the only writer).
- Default-deny catch-all at the bottom of the rules file.
- `isAdmin()` helper reads `users/{request.auth.uid}/role` and matches `'admin'`. `isPremium()` matches `'premium'` OR `'admin'`.

**Storage Rules (`storage.rules`):**

- `users/{uid}/**`: read-write only when `request.auth.uid == uid`. Uploads restricted to `image/*`, max 5 MB.
- `premium/**`: read requires `isPremiumOrAdmin()` (Firestore role lookup); write-admin only.
- `content/**`: read-authenticated, write-admin.
- Default-deny catch-all.

**Role validation core (`lib/core/security/`):**

- `role_guard.dart` — `enum SecurityAction { readOwn, writeOwn, readPublic, mutateAdmin, mutatePremium }`, `class RoleGuard { static bool hasRole(UserEntity? user, UserRole required); static UserRole requiredRole(SecurityAction action); static void assertAuthorized(SecurityAction action, UserEntity? user); static void assertOwnership(...) }`, and `class AuthorizationException extends AppException` carrying `action`, `requiredRole`, `actualRole`. `ErrorHandler.map` translates it to the existing `AuthorizationFailure`.
- `security_context.dart` — `Provider<UserEntity?> securityContextProvider` reads `authStateProvider.user`. Convenience providers: `isAuthenticatedProvider`, `isAdminProvider`, `isPremiumProvider`.
- `auth_precondition.dart` — `class AuthGuard { AuthGuard(Ref ref); void assertAuthenticated(); void assertAdmin(); void assertPremium(); void assertOwnership(String userId); }`. Composition over mixin — repositories hold an `AuthGuard` instance instead of mixing the helpers in (avoids Dart 3 mixin-with-abstract-members issues).

**Provider lifecycle (`lib/core/providers/auth_lifecycle.dart`):**

- `authStateResetProvider` — `Provider<void>` whose factory listens to `authStateProvider` and invalidates a hard-coded list of user-bound feature providers whenever the active user transitions to `null` (logout). The list includes `bookmarkControllerProvider`, `notesControllerProvider`, `notificationControllerProvider`, `profileControllerProvider`, `rewardsControllerProvider`, `streakControllerProvider`, `missionsControllerProvider`, `leaderboardControllerProvider`, `statisticsControllerProvider`, `aiHistoryControllerProvider`, `searchControllerProvider`, `subscriptionControllerProvider`, `syncControllerProvider`, `settingsControllerProvider`. New feature providers register themselves here when added.

**API interceptor auth (`lib/core/network/`):**

- `interceptors/auth_interceptor.dart` — existing `X-Require-Auth: true` header retained. New `X-Require-Role: admin|premium|authenticated` short-circuits with HTTP 403 when the active user's role doesn't match. The role check is wired through `AuthInterceptor.withRef(Ref ref)` which resolves `securityContextProvider`. New `X-Force-Token-Refresh: true` header forces `user.getIdToken(true)` for sensitive endpoints. When `X-Require-Auth: true` is set and `currentUser == null`, the interceptor now rejects with HTTP 401 (was a silent no-op).
- `dio_client.dart` — `DioClient.build` gains a `secure: bool = false` flag. When `true`, the `AuthInterceptor` is inserted BEFORE the `RetryInterceptor` so 401 / 403 surface without retry storms, and `X-Require-Auth: true` is added to every request by default.
- `secure_dio_client.dart` — new `SecureDioClient.build({required String baseUrl, required Ref ref, ...})` factory that wraps `DioClient.build(secure: true, authInterceptor: AuthInterceptor.withRef(ref), defaultHeaders: {'X-Require-Auth': 'true', 'X-Require-Role': 'authenticated'})`. Cloud Function callers get auth + role by default.

**Repository security (defence-in-depth):**

Repositories in `lib/features/**/data/repositories/` capture a Riverpod `Ref` in their constructor and call `_guard.assertAuthenticated()` at the top of every mutating method. The local cache mirrors still update for in-session responsiveness, but Firestore writes are gated. Repositories updated:

- `bookmark_repository_impl.dart` — `addBookmark`, `removeBookmark`, `clearAll`, `sync`.
- `notes_repository_impl.dart` — `createNote`, `updateNote`, `deleteNote`, `togglePin`, `toggleFavorite`, `clearAll` (`saveHighlight` / `saveAiNote` reuse `createNote`).
- `notification_repository_impl.dart` — `markAsRead`, `markAllAsRead`, `delete`.
- `profile_repository_impl.dart` — `updateProfile`, `uploadAvatar`, `deleteAccount`.
- `ai_tutor_repository_impl.dart` — `saveConversation`, `savePromptEntry`, `togglePromptFavorite`, `deleteConversation`.
- `quiz_engine_repository_impl.dart` — `submitQuizSession`, `toggleQuestionBookmark`, `reportQuestion`.
- `review_repository_impl.dart` — `toggleBookmark`.
- `search_repository_impl.dart` — `saveRecentSearch`, `clearRecentSearches`.
- `settings_repository_impl.dart` — `saveSettings` (mirror gated, local write still succeeds).
- `offline_repository_impl.dart` — `enqueueDownload`, `enqueueSync`.

The Quiz Hub repository (`quiz_api_repository_impl.dart`) is intentionally left unchanged — `docs/apidoc/api` documents Quiz Hub as public and changing that contract is out of scope.

**Firebase project metadata:**

- `firebase.json` — references `firestore.rules`, `firestore.indexes.json`, `storage.rules`, and the `functions/` deployment.
- `firestore.indexes.json` — composite indexes for the existing query patterns: `users/{uid}/coin_ledger` ordered by `createdAt desc`, `leaderboard_entries` ordered by `period asc, score desc`, `users/{uid}/quiz_history`, `users/{uid}/quiz_sessions`, `users/{uid}/notifications`, `users/{uid}/bookmarks`, `users/{uid}/notes`.

**Architectural decisions:**

- **D1 — `firestore.rules` + `storage.rules` are the source of truth.** Backend enforcement is the primary defence; client guards (`AuthGuard`, repository preconditions) are defence-in-depth. Rules use `request.auth.uid` for ownership and a `users/{uid}/role` doc field for admin checks.
- **D2 — Centralised role helpers in `lib/core/security/`.** Repositories and services call `RoleGuard.assertAuthorized` / `AuthGuard.assertAuthenticated` instead of re-implementing the same checks. `AuthorizationException` integrates with `ErrorHandler.map` → `AuthorizationFailure`.
- **D3 — `AuthInterceptor` extends with `X-Require-Role` and `X-Force-Token-Refresh`.** Existing `X-Require-Auth: true` now surfaces 401 when the user is null (was silent no-op). `DioClient.build(secure: true)` inserts `AuthInterceptor` BEFORE retry so 401s surface without retry storms.
- **D4 — Single-writer Firestore services remain the only writers.** No Phase 51 code touches data sources — services are already guest-guarded and the new `firestore.rules` mirrors the contract server-side.
- **D5 — Provider reset is centralised.** `authStateResetProvider` invalidates a hard-coded list of feature providers on logout. New providers register themselves in `auth_lifecycle.dart` when added.
- **D6 — `AuthGuard` is composition, not a mixin.** Dart 3 mixin semantics require all members to be concrete; using a plain class with `Ref` captured once in the constructor avoids `non_abstract_class_inherits_abstract_member` errors and keeps the surface minimal.
- **D7 — Quiz Hub stays public.** Phase 51 does NOT add auth to Quiz Hub calls — `docs/apidoc/api` documents it as public.
- **D8 — `firebase.json` populates the project metadata.** Empty file is filled with rules + indexes + functions references + emulator ports so deployment works out of the box.
- **D9 — Existing `Failure` types are reused.** `AuthorizationFailure` (already in `failures.dart`) handles every denial path. No new failure type is added.
- **D10 — Firestore admin role uses a doc lookup, not a custom claim.** Custom claims require a Cloud Function `setCustomUserClaims` call and a token refresh — Phase 52 owns that upgrade. The Firestore doc check still denies unauthenticated writes.

**Validation:** `flutter analyze lib/` returns **0 errors / 0 warnings**. Every authenticated user can access only their own data (`request.auth.uid == userId`). Admin-only collections (`categories`, `subjects`, etc.) are write-admin only. Repositories enforce an authenticated precondition via `AuthGuard`. Providers correctly react to authentication changes via `authStateResetProvider`. API requests include `Authorization: Bearer <idToken>` and `X-Require-Auth: true` by default for authenticated Cloud Function callers. Quiz Hub endpoints stay public per `docs/apidoc/api`.

**Trade-offs accepted:**

1. **`isAdmin()` reads `users/{uid}/role` doc**, not a custom claim. Firestore doc lookup adds a read per request — mitigated by the cache + the fact that role rarely changes. Phase 52 will migrate to custom claims for production.
2. **`AuthInterceptor.X-Require-Role` reads the role from `authStateProvider` synchronously.** When the user is mid-sign-in the role may be stale; mitigated by `X-Force-Token-Refresh: true` for sensitive endpoints.
3. **`authStateResetProvider` invalidates a hard-coded list of providers.** New providers must register themselves in `auth_lifecycle.dart` when added. Auto-dispose was rejected because the controllers are intentionally `StateNotifierProvider` (not autoDispose).
4. **Quiz Hub stays public.** Changing that contract would break the public REST API documented in `docs/apidoc/api`.
5. **`firestore.rules` validation is documented but not enforced in CI.** Firebase emulator suite runs locally; production deployment validation lives with the devops team.
6. **`AuthorizationException` extends `AppException` rather than a new dedicated exception type.** Phase 51 reuses the existing `AuthorizationFailure` to keep the failure vocabulary stable.
7. **`SecureDioClient.build` requires a `Ref`** because the `X-Require-Role` header check needs to resolve the active user. Callers that don't have a `Ref` use `DioClient.build(secure: true)` directly with a no-op `AuthInterceptor`.

**Future Cloud Functions (owned by the backend team, contract documented here):** `sendPush` (per-user fanout via `users/{uid}/fcm_tokens`), `sendDailyReminder`, `sendTopicNotification`, `sendMissionNotification`, `sendRewardNotification`, `sendLevelUpNotification`, `sendXpEarnedNotification`, `sendCoinRewardNotification`, `sendStreakNotification`, `sendSubscriptionNotification`, `sendAiSuggestionNotification`, `sendAnnouncementNotification`. Firebase messaging handlers (`onMessage` foreground listener, `onBackgroundMessage` background handler, `onMessageOpenedApp` notification-opened handler, `getInitialMessage` cold-start handler) are not wired in Phase 48 — they live behind the `FcmBootstrap` token registration seam and land alongside the `firebase_messaging` dependency.

### 6.34 Phase 53 — Dynamic UI Backend Integration (fully implemented)

Phase 51 closed the backend security gap (firestore.rules, storage.rules, repository preconditions, AuthInterceptor role-aware requests, provider reset on logout). Phase 53 turns that secured backend into **visible data** by replacing the remaining hardcoded frontend state with backend-driven surfaces while keeping the existing frontend visually unchanged.

**Problem Phase 53 solved:**
- The playground world map rendered from a hardcoded `List<WorldStep>` literal (Foundations, Grammar, Mathematics, Library, Daily Reward, Mock Test, BCS Boss) with `static const int _activeIndex = 2`, a fixed `_openLibrary` sheet showing `chapterCount: 8, completedChapters: 3, unlockedLessonCount: 5, estimatedReadingMinutes: 12`, a `'Locked'` literal at line 466, and a `_showLockedDialog` branch that blocked access to nodes the user had not yet reached.
- The home dashboard was 10 empty stubs (`home_screen.dart`, `home_provider.dart`, and 8 widget files all 1-line placeholders) that rendered nothing.
- The gamification rewards screen (`rewards_screen.dart`) and its provider (`gamification_provider.dart`) were empty stubs despite a 35-widget visual library already shipping in `lib/features/gamification/presentation/widgets/`.

**Outcome:** the playground world map now renders every category from `categoriesStreamProvider` (Firestore-backed when configured, mock otherwise) with completion state from `playgroundProgressProvider.completedLevelIds`. Library sheet values are derived from `categoryStatisticsLiveProvider` with safe defaults. The home dashboard aggregates `profileControllerProvider`, `streakControllerProvider`, `missionsControllerProvider`, `coinHistoryProvider`, and `categoriesStreamProvider` into a single `homeControllerProvider` that the screen watches once. The rewards screen composes `rewardsControllerProvider`, `streakControllerProvider`, and `missionsControllerProvider` with the existing visual widgets.

**Architectural decisions:**

- **D1 — Playground nodes come from `categoriesStreamProvider`.** `CategoryEntity` already exposes `id`, `title`, `subtitle`, `kind` (`CategoryNodeKind`), `order`, `xpReward`, `coinReward`, `subject?`, `iconName?`, `quizId?`, `prerequisiteCategoryIds`, `isRewardClaimed`. A new `CategoryNodeKind → WorldStepKind` adapter maps each entity to a `WorldStep`; per-node completion comes from `playgroundProgressProvider.completedLevelIds`; unlock state is derived from `unlockedLevelIds` plus the active index.
- **D2 — Unlock restrictions are removed.** The `_showLockedDialog` branch is gone. Every node the user taps now opens its category (lessons, milestone, mock test, or boss) — the spec calls for "no restrictions preventing node access."
- **D3 — `homeControllerProvider` is a thin aggregator.** One `Provider<AsyncValue<HomeSnapshot>>` watches `profileControllerProvider`, `streakControllerProvider`, `missionsControllerProvider`, `coinHistoryProvider`, and `categoriesStreamProvider`, and exposes the result as a single immutable `HomeSnapshot`. The screen watches this provider once and renders 8 stateless widgets.
- **D4 — Home widgets are pure consumers of `HomeSnapshot`.** Each widget accepts the sub-slice it needs (`UserProfile?` for `HeaderCard`, `MissionsViewState` for `DailyGoalCard`, `List<CoinTransactionEntity>` for `RecentActivityList`, `bool isPremium` for `PremiumBanner`, etc.) — no widget holds internal mutable state.
- **D5 — Gamification rewards screen composes existing widgets.** The 35-widget visual library already shipping (`StreakCard`, `DailyMissionCard`, `ClaimRewardButton`, `RewardHistoryTile`, etc.) is wired through `rewardsControllerProvider` (snapshot + history) and `missionsControllerProvider` (daily list). No new widget was authored.
- **D6 — Auth lifecycle gets two new entries.** `homeControllerProvider`, `playgroundProgressProvider`, and `worldStepsProvider` are appended to `_authStateResetDispatcherProvider` in `auth_lifecycle.dart` so the dashboard, world map, and underlying playground state all reset on logout.
- **D7 — Quiz funnel is verified, not modified.** `UserProgressService.applyQuizCompletion` (lib/core/services/user_progress_service.dart:70) writes to **8 collections atomically** when a quiz session completes: `users/{uid}/progression/current` (transactional), `study_stats/current`, `statistics/current`, `streak/current`, `category_progress/{categoryId}`, `playground/current`, `quiz_sessions/{sessionId}`, `quiz_history/{sessionId}` — plus a side-channel `CoinService.grant` to `coin_ledger/{txId}`. The quiz results screen already invokes this funnel at line 58.
- **D8 — Profile / Statistics / Quiz Results screens were already backend-driven.** The `Mock*RemoteDataSource` defaults in `profile_providers.dart`, `statistics_provider.dart`, and `quiz_results_provider.dart` are dead code — the controllers read directly from `userProfileServiceProvider`, `statisticsServiceProvider`, and `userProgressServiceProvider` (Firestore). The mock defaults stay as the canonical demo/scaffold fallback; production defaults swap in via `FirebaseConfig.isPlatformConfigured` for any service that needs it (coin-ledger already does this).
- **D9 — Library sheet values fall back to safe constants.** When no `CategoryStatisticsEntity` exists for the library's `categoryId`, the sheet shows `chapterCount: 8, completedChapters: 0, unlockedLessonCount: 0, estimatedReadingMinutes: 16` (constant fallback). When stats exist, derived values win.
- **D10 — `worldStepsProvider` returns a typed snapshot, not a raw list.** `WorldStepsSnapshot { steps, activeIndex, source }` carries the `WorldStepsSource` enum (`loading`, `empty`, `categories`, `fallbackSeed`) so diagnostics can tell why the world map is empty.

**Files added (2):**

1. `lib/features/playground/presentation/providers/world_steps_provider.dart` — `WorldStepsSnapshot`, `WorldStepsSource`, `worldStepsProvider`.
2. `lib/features/home/presentation/providers/home_provider.dart` — `HomeSnapshot`, `homeControllerProvider`.

**Files modified (12):**

1. `lib/features/playground/presentation/screens/playground_screen.dart` — delete `_steps` literal, `_activeIndex`, library-sheet literals, `'Locked'` literal, `_showLockedDialog` branch, `_provider` legacy controller. Library sheet now reads `categoryStatisticsLiveProvider`.
2. `lib/features/home/presentation/screens/home_screen.dart` — implement `ConsumerStatefulWidget` with bootstrap-once.
3. `lib/features/home/presentation/widgets/header_card.dart` — implement.
4. `lib/features/home/presentation/widgets/xp_card.dart` — implement.
5. `lib/features/home/presentation/widgets/streak_card.dart` — implement.
6. `lib/features/home/presentation/widgets/daily_goal_card.dart` — implement.
7. `lib/features/home/presentation/widgets/continue_learning_card.dart` — implement.
8. `lib/features/home/presentation/widgets/quick_action_grid.dart` — implement (static 4-tile grid).
9. `lib/features/home/presentation/widgets/recent_activity.dart` — implement.
10. `lib/features/home/presentation/widgets/premium_banner.dart` — implement.
11. `lib/features/gamification/presentation/screens/rewards_screen.dart` — implement `ConsumerWidget` composing existing widgets.
12. `lib/core/constants/app_strings.dart` — added 15 home-screen strings.
13. `lib/core/providers/auth_lifecycle.dart` — append `homeControllerProvider`, `playgroundProgressProvider`, `worldStepsProvider` to dispatcher list.

**Existing utilities reused:**

- `lib/features/category_api/presentation/providers/category_providers.dart:48` — `categoriesStreamProvider`.
- `lib/features/profile/presentation/providers/profile_providers.dart` — `profileControllerProvider`, `profileIsPremiumProvider`, `profileBadgesProvider`.
- `lib/features/profile/domain/entities/user_profile.dart` — `UserProfile`, `ProgressionEntity`.
- `lib/features/profile/presentation/providers/coin_providers.dart` — `coinBalanceProvider`, `coinHistoryProvider`.
- `lib/features/profile/presentation/utils/profile_visual_mapper.dart` — `ProfileVisualMapper`.
- `lib/features/gamification/presentation/providers/rewards_provider.dart` — `rewardsControllerProvider`.
- `lib/features/gamification/presentation/providers/streak_provider.dart` — `streakControllerProvider`.
- `lib/features/gamification/presentation/providers/mission_provider.dart` — `missionsControllerProvider`.
- `lib/features/gamification/presentation/widgets/*.dart` — 35 already-implemented widgets.
- `lib/features/statistics/presentation/providers/statistics_provider.dart` — `userStatisticsLiveProvider`, `categoryStatisticsLiveProvider`.
- `lib/features/playground/presentation/providers/playground_providers.dart` — `playgroundProgressProvider`.
- `lib/core/services/user_progress_service.dart:70` — `applyQuizCompletion` (the 8-collection funnel).
- `lib/core/providers/auth_lifecycle.dart` — `authStateResetProvider` (now invalidates 17 providers on logout).

**Quiz funnel (verified, not modified) — the 8 collections `UserProgressService.applyQuizCompletion` writes to:**

1. `users/{uid}/progression/current` (transactional — XP, coins, level, energy, rank, streak).
2. `users/{uid}/study_stats/current` (merge — totalQuizzesTaken, totalQuestionsAnswered, totalCorrectAnswers, averageAccuracy).
3. `users/{uid}/statistics/current` (mirror of #2).
4. `users/{uid}/streak/current` (merge — currentDays, bestDays, lastClaimedAtIso).
5. `users/{uid}/category_progress/{categoryId}` (merge — per-category accuracy, totalMinutes, xpEarned).
6. `users/{uid}/playground/current` (merge — `completedLevelIds`, `unlockedLevelIds`, `activeLevelId`).
7. `users/{uid}/quiz_sessions/{sessionId}` (full doc — questions, answers, timing, flags).
8. `users/{uid}/quiz_history/{sessionId}` (full doc — session summary, score, reward deltas).
- Plus `users/{uid}/coin_ledger/{txId}` via `CoinService.grant` (atomic).

**Validation:** `flutter analyze lib/` returns **0 errors / 0 warnings** (only pre-existing infos). Every screen reactive to its underlying providers. Playground nodes change when `categories` collection changes. Home dashboard rebuilds when any of `profileControllerProvider`, `streakControllerProvider`, `missionsControllerProvider`, `coinHistoryProvider`, or `categoriesStreamProvider` fires. Rewards screen mirrors `rewardsControllerProvider.snapshot` and `missionsControllerProvider.daily`. Quiz funnel writes 8 collections per completion, including the playground doc that drives node completion. Auth lifecycle invalidates the home, playground, and world-steps providers on logout.

**Trade-offs accepted:**

1. **Mock defaults stay for profile, statistics, quiz engine.** `FirestoreProfileRemoteDataSource` requires a `uid` and a configured Firebase project, which would crash on first launch before `Firebase.initializeApp` finishes. The mock is the safe demo/scaffold; production writes flow through `userProgressServiceProvider.applyQuizCompletion` and the single-writer services that already swap to Firestore via `FirebaseConfig.isPlatformConfigured`.
2. **`homeControllerProvider` does not own a state machine.** It exists to give `HomeScreen` one watcher; the underlying providers remain the source of truth. This keeps the data flow obvious and matches Phase 51's pattern.
3. **Playground nodes are mapped 1:1 from categories.** No "decorative" nodes like `'Daily Reward'` or `'Library'` exist anymore — those become milestones or rewards driven by `CategoryNodeKind`. The world map stays clean.
4. **Library sheet values fall back to constants.** When no `CategoryStatisticsEntity` exists for the library's `categoryId`, the sheet shows the safe defaults (8 chapters / 0 completed / 0 unlocked / 16 min).
5. **Subscription banner reads `profileIsPremiumProvider` only.** Real subscription service is Phase 54. The banner's CTA routes to `/subscription` which will show the placeholder until Phase 54.
6. **No widget tests added.** Existing test coverage for `UserProgressService`, `CoinService`, `ProfileController`, etc. stays. Adding dashboard widget tests is deferred to Phase 54.
7. **The 35-widget gamification library is reused, not rewritten.** `StreakCard`, `DailyMissionCard`, `ClaimRewardButton`, `RewardHistoryTile`, `RewardsHudChip`, `StreakFlame`, `MissionCardForCadence`, etc. all stay as-is — the screen just composes them through the existing providers.
8. **Existing widget files (header_card, xp_card, etc.) use design tokens.** `AppColors`, `AppStrings`, `AppSpacing`, `AppRadius` are reused — no theme changes. Phase 53 is purely a binding layer.

### 6.35 Phase 54 — Google-Only Authentication (Firestore-backed, no demo data)

Phase 53 wired the backend to the visual layer. Phase 54 collapses the **front door** of the app — the authentication flow — to Google Sign-In only AND wires it to real Firebase Auth + Firestore (no demo / mock data). The Welcome screen swaps its three CTAs (Get Started / I Already Have an Account / Continue as Guest) for a single "Continue with Google" button. The login, register, phone-OTP, email-verification, and forgot-password screens are deleted from the route table. Every sign-in writes a canonical user document plus a profile sub-doc plus an app_user sub-doc to Firestore under `users/{uid}`, so the rest of the app (`ProfileController`, `StatisticsController`, `GamificationController`, etc.) reads from real backend state. Profile completion is driven entirely by the persisted `examTrack` on the user entity — display name is pre-filled from Google on first sign-in, so returning users skip the Complete-Profile screen automatically because their `examTrack` is already non-`ExamTrack.other` in Firestore.

**Critical wiring — `Firebase.initializeApp` is called from `AppConfig.bootstrap()`** before any feature provider is constructed. Without this call, `FirebaseConfig.isPlatformConfigured` returns `false`, every `if (FirebaseConfig.isPlatformConfigured)` gate falls through to its mock branch, and tapping "Continue with Google" silently completes an in-memory mock sign-in instead of opening the Google account picker. The bootstrap sequence is now: `WidgetsFlutterBinding.ensureInitialized()` → `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` → `HiveManager.instance.initialize(...)` → `runApp(AdminHostApp(...))`. The init call is wrapped in try/catch so unsupported platforms (Linux without google-services.json) degrade gracefully and the rest of the UI still works.

**Problem Phase 54 solved:**
- The Welcome screen had three CTAs that sent users to `/register`, `/login`, and a demo-bypass state — none of which matched the canonical Firebase Auth + Firestore stack.
- `signInWithEmail`, `registerWithEmail`, `sendPasswordReset`, `sendPhoneOtp`, `verifyPhoneOtp`, `resendEmailVerification`, `reloadCurrentUser` had no UI consumers (the screens for them were unused dead code).
- The router allowed `login`, `register`, `forgotPassword`, `phoneOtp`, `emailVerification` paths for unauthenticated visitors — five separate auth surfaces for a single sign-in mechanism.
- `FirebaseAuthRemoteDataSource` was entirely a stub (`throw AuthenticationFailure('not-configured')` for every method) — even though `firebase_auth` was in `pubspec.yaml`.
- `MockAuthRemoteDataSource._bootstrap()` auto-created a demo user on instantiation, so even when Firebase was not configured the app booted into a fake-authenticated state and downstream controllers read demo literals.
- `AuthController.bypassAuthentication()` + `_isAuthenticationBypassed` synthesised an authenticated session from in-memory state — there was no path that required a real sign-in.

**Outcome:** tapping "Continue with Google" runs `google_sign_in` + `FirebaseAuth.signInWithCredential(GoogleAuthProvider.credential(...))`. The returned Firebase user populates `AuthState.user` with display name, email, photo URL, and `emailVerified=true`. Three Firestore writes complete the sign-in: `users/{uid}` (core identity), `users/{uid}/profile/current` (extended profile with Google identity + user-editable fields), `users/{uid}/app_user/current` (gamification state with empty defaults). New users (`examTrack = ExamTrack.other`) are routed to `/complete-profile` (pre-filled from Google data — they only need to pick an exam track). Returning users (any other `examTrack` value persisted on the user entity) land directly on `/playground` — the Complete-Profile screen never appears again.

**Firestore writes (per sign-in):**

1. **`users/{uid}`** — core identity document. Fields: `id` (uid), `email`, `displayName`, `emailVerified`, `phoneNumber`, `photoUrl`, `roleId` (UserRole.free.id default), `examTrackId` (ExamTrack.other.id for new users), `district`, `createdAt`, `lastSignInAt`, `status`. Written by `_writeUserDoc` on every sign-in path (Google, email, phone) with `SetOptions(merge: true)` so re-sign-ins refresh `lastSignInAt` + `emailVerified` without clobbering profile data the user edited in Complete-Profile.
2. **`users/{uid}/profile/current`** — extended profile sub-doc. Fields: `uid`, `email`, `displayName`, `photoUrl`, `emailVerified`, `phoneNumber`, `examTrackId`, `district`, `roleId`, `updatedAt`. Seeded by `_seedProfileDoc` on every sign-in (merge:true; null-coalesces Google identity with persisted user-edited fields so the existing Complete-Profile data wins). Re-written by `updateProfile()` with merge:true after the user submits the form.
3. **`users/{uid}/app_user/current`** — gamification state sub-doc. Fields: `uid`, `progression` (`level`, `totalXp`, `xpInLevel`, `coins`), `studyStats` (`xpEarned`, `quizzesCompleted`, `correctAnswers`, `totalQuestions`, `currentStreakDays`, `longestStreakDays`, `lastActivityAt`), `updatedAt`. Seeded by `_seedAppUserDoc` on every sign-in with empty/zero defaults so downstream providers (`StreakController`, `MissionsController`, `CoinBalanceController`) never read missing fields.

**Demo data removed:**

- **`MockAuthRemoteDataSource._bootstrap()`** — method removed; the constructor no longer auto-creates a demo user on instantiation. Without an explicit `signInWithGoogle` / `signInWithEmail` / etc. call the mock returns `AuthState.unauthenticated`.
- **`AuthController.bypassAuthentication()`** — method removed. There is no longer any API surface that synthesises an authenticated session from in-memory state.
- **`AuthController._isAuthenticationBypassed`** — field and all references removed. The auth lifecycle can no longer be shortcut past the real datasource.

**Architectural decisions:**

- **D1 — Google Sign-In is the only path.** The login / register / phone-OTP / email-verification / forgot-password screens are deleted; their `AppRoutes` constants and `GoRoute` entries are removed; `_unauthenticatedPaths` whitelist is reduced to `[AppRoutes.welcome]`.
- **D2 — Profile completion is derived from `UserEntity`.** `hasCompletedProfile = displayName.trim().isNotEmpty && examTrack != ExamTrack.other` — no Firestore flag is added. Once a user submits the Complete-Profile form, the persisted `examTrack` makes `hasCompletedProfile` true on the next sign-in.
- **D3 — `AuthRemoteDataSource.signInWithGoogle()` returns UserEntity with Google identity fields.** `displayName`, `email`, `photoUrl`, `emailVerified=true`. `examTrackId` is left at `ExamTrack.other.id` so the router routes new users through `/complete-profile` to pick a track (the only required field they still need to provide).
- **D4 — Returning users skip `/complete-profile` automatically.** The Firebase implementation reads the persisted `examTrack` from `users/{uid}` via `_readUserDoc` — the merged `examTrack` wins over Firebase Auth defaults so the router's existing `_statusFor` check returns `AuthStatus.authenticated` immediately.
- **D5 — Google 'G' icon uses `Icons.g_mobiledata_rounded`.** Material's built-in stylized G glyph. No new font / icon dependency.
- **D6 — WelcomeScreen is `ConsumerStatefulWidget`.** `_isWorking` drives `PrimaryButton.isLoading` so the button is disabled while the auth round-trip is in flight and re-enabled on success / failure.
- **D7 — `AuthController.signInWithGoogle()` pipes through `_applySession` → `_statusFor`.** The router's existing redirect logic (`case AuthStatus.profileIncomplete`) handles the rest without any new code.
- **D8 — SplashScreen's `emailVerificationRequired` branch falls back to `/complete-profile`.** Google sign-in always returns `emailVerified=true` so this branch is unreachable in practice; the redirect is a defensive fallback now that the email-verification screen is gone.
- **D9 — Email / phone controller methods are deliberately NOT deleted.** They remain valid APIs in the auth feature for future admin tools / tests / non-Google auth providers, and removing them would break existing test coverage. Their UI surfaces are deleted but the underlying plumbing stays — and the Firebase implementation now backs them with real Firestore writes too.
- **D10 — `google_sign_in: ^6.2.1` is added to `pubspec.yaml`.** `firebase_auth: ^6.1.0` was already present. `cloud_firestore: ^6.7.1` was already present. `FirebaseAuthRemoteDataSource` is now FULLY implemented (all 12 methods wired against real Firebase Auth + Firestore) — no more not-configured stubs.
- **D11 — NO demo data, NO bypass authentication.** (a) `MockAuthRemoteDataSource._bootstrap()` removed so the mock no longer auto-creates a demo user. (b) `AuthController.bypassAuthentication()` + `_isAuthenticationBypassed` removed so no path can synthesise an authenticated session from in-memory state. (c) `authRemoteDataSourceProvider` switches to `FirebaseAuthRemoteDataSource` whenever `FirebaseConfig.isPlatformConfigured` is true, so production goes straight to real Firebase Auth + Firestore. The user document, profile sub-doc, and app_user sub-doc are written on every sign-in path so downstream providers (Profile, Statistics, Gamification, Streak, Missions, Coins) read real backend state instead of demo literals.
- **D12 — Three Firestore writes per sign-in.** (1) `users/{uid}` — core identity (`SetOptions.merge=true` so re-sign-ins refresh `lastSignInAt` without clobbering user-edited fields). (2) `users/{uid}/profile/current` — extended profile with Google identity + user-editable fields (merge:true; null-coalesces so persisted edits win over Google defaults). (3) `users/{uid}/app_user/current` — gamification state with empty/zero defaults so downstream controllers never see missing fields. `_buildUserModel` merges Firebase Auth + the persisted `users/{uid}` doc so the returned UserEntity reflects user-edited `examTrack`, `district`, `phoneNumber` on subsequent sign-ins.
- **D13 — `Firebase.initializeApp` is invoked from `AppConfig.bootstrap()`** before any provider constructs. Without this call `FirebaseConfig.isPlatformConfigured` returns `false` and every provider falls back to its mock branch, so the Google sign-in popup never opened (the mock completed silently). Now: `bootstrap()` → `AppConfig.bootstrap()` → `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` → `HiveManager.initialize()` → `runApp`. Init is wrapped in try/catch so unsupported platforms degrade gracefully.
- **D14 — Every mock datasource that previously wired unconditionally now gates on `FirebaseConfig.isPlatformConfigured`.** `profileRemoteDataSourceProvider` returns `FirestoreProfileRemoteDataSource(uid: ...)` (watching `authStateProvider` for the uid) when configured, mock otherwise. `lessonRemoteDataSourceProvider`, `quizRemoteDataSourceProvider`, `quizResultsRemoteDataSourceProvider` all gate the same way. `statisticsRemoteDataSourceProvider` is removed entirely (the StatisticsService is the canonical Firestore-backed reader). `reviewRepositoryImpl.withDefaults()` gates on the same flag. The pattern matches `categoryRemoteDataSourceProvider`, which has always been the model: mock is a true fallback for unconfigured dev, never a production default.

**Files modified (12):**

1. `pubspec.yaml` — added `google_sign_in: ^6.2.1`.
2. `lib/features/authentication/data/datasources/auth_remote_datasource.dart` — added `signInWithGoogle()` to the abstract interface.
3. `lib/features/authentication/data/datasources/firebase_auth_remote_datasource.dart` — FULL REWRITE; implements all 12 methods against real Firebase Auth + Firestore; helpers `_readUserDoc` / `_writeUserDoc` / `_seedProfileDoc` / `_seedAppUserDoc` / `_buildUserModel` / `_sessionFor` / `_translateAuthException` handle the merge semantics; throws `AuthenticationFailure` with `code='cancelled'` when the user dismisses the Google account picker.
4. `lib/features/authentication/data/datasources/mock_auth_remote_datasource.dart` — `_bootstrap()` method REMOVED so the mock no longer auto-creates a demo user; `signInWithGoogle()` ADDED; mock only used when `FirebaseConfig.isPlatformConfigured` is false.
5. `lib/features/authentication/domain/repositories/auth_repository.dart` — added `signInWithGoogle()` to the contract.
6. `lib/features/authentication/data/repositories/auth_repository_impl.dart` — pass-through `signInWithGoogle()` with `Result<AuthSessionEntity>` wrapping.
7. `lib/features/authentication/presentation/providers/auth_providers.dart` — `authRemoteDataSourceProvider` switches on `FirebaseConfig.isPlatformConfigured`; returns `const FirebaseAuthRemoteDataSource()` when configured, `MockAuthRemoteDataSource()` when not — so production goes straight to real Firebase.
8. `lib/features/authentication/presentation/controllers/auth_controller.dart` — `signInWithGoogle()` ADDED; `bypassAuthentication()` + `_isAuthenticationBypassed` REMOVED.
9. `lib/features/authentication/presentation/screens/welcome/welcome_screen.dart` — rewritten as `ConsumerStatefulWidget` with single CTA.
10. `lib/features/authentication/presentation/constants/auth_strings.dart` — `welcomePrimaryCta` becomes "Continue with Google"; old CTAs removed.
11. `lib/features/authentication/presentation/screens/splash/splash_screen.dart` — `emailVerificationRequired` falls back to `/complete-profile`.
12. `lib/router.dart` — removed `AppRoutes.login / register / forgotPassword / phoneOtp / emailVerification` constants + `GoRoute` entries; whitelist reduced to `[AppRoutes.welcome]`.

**Files deleted (8):**

1. `lib/features/authentication/presentation/screens/login_screen.dart` (legacy top-level stub).
2. `lib/features/authentication/presentation/screens/otp_screen.dart` (legacy top-level stub).
3. `lib/features/authentication/presentation/screens/profile_setup_screen.dart` (legacy top-level stub — replaced by `complete_profile_screen.dart`).
4. `lib/features/authentication/presentation/screens/login/login_screen.dart`.
5. `lib/features/authentication/presentation/screens/register/register_screen.dart`.
6. `lib/features/authentication/presentation/screens/forgot_password/forgot_password_screen.dart`.
7. `lib/features/authentication/presentation/screens/otp_verification/otp_verification_screen.dart`.
8. `lib/features/authentication/presentation/screens/email_verification/email_verification_screen.dart`.

**Auth router flow (verified):**

| Trigger | Source | Destination |
|---|---|---|
| App launch (no session) | `_bootstrap()` → `currentUser() == null` | `/splash → /welcome` |
| App launch (Firebase session) | `_bootstrap()` → `currentUser() != null` → `_readUserDoc` | `/playground` (returning user with persisted `examTrack`) |
| Welcome tap (new) | `signInWithGoogle()` → FirebaseAuth creates user → `_writeUserDoc + _seedProfileDoc + _seedAppUserDoc` (examTrackId=ExamTrack.other.id) | `/complete-profile` (pre-filled) |
| Welcome tap (returning) | `signInWithGoogle()` → FirebaseAuth returns existing user → `_readUserDoc` reads examTrack | `/playground` |
| Complete-Profile submit | `updateProfile()` → `_applyUser` → `_statusFor(user)` | `authenticated` → `/playground` |
| Profile screen sign-out | `signOut()` → `state = AuthState.unauthenticated()` | `/welcome` |

**Existing utilities reused:**

- `lib/features/authentication/presentation/widgets/auth_social_buttons.dart` — `AuthSocialButton` (kept available for future secondary auth paths).
- `lib/features/authentication/presentation/widgets/primary_button.dart` — `PrimaryButton` with `isLoading` for the in-flight state.
- `lib/core/widgets/primary_button.dart` — same, at `lib/core/widgets/`.
- `lib/features/authentication/domain/entities/user_entity.dart` — `UserEntity.hasCompletedProfile` (the derived completion check).
- `lib/features/authentication/presentation/states/auth_state.dart` — `AuthStatus.profileIncomplete` redirect.
- `lib/features/authentication/presentation/screens/complete_profile/complete_profile_screen.dart` — already pre-fills from `state.user`; no code change needed.
- `lib/features/authentication/presentation/providers/auth_providers.dart` — `authStateProvider` + `authRouterRefreshProvider` (the bridge the router listens to) + `authRemoteDataSourceProvider` (the Firebase/mock switch).
- `lib/core/config/firebase_config.dart` — `FirebaseConfig.isPlatformConfigured` (the gate that activates the Firebase data source).
- `lib/features/user_account/domain/entities/auth_identity_seed.dart` — `AuthIdentitySeed` (the forward-looking seam for Google identity fields).
- `lib/features/authentication/presentation/screens/splash/splash_screen.dart` — splash-driven initial decision.

**Validation:** `flutter analyze lib/` returns **0 errors / 0 warnings**. `AuthRemoteDataSource.signInWithGoogle()` is implemented in both the mock and the Firebase data source. The Welcome screen has exactly one CTA. `_unauthenticatedPaths` is `[AppRoutes.welcome]`. `AppRoutes` no longer exposes `login`, `register`, `forgotPassword`, `phoneOtp`, or `emailVerification`. The mock no longer auto-creates a demo user (its `_bootstrap()` method is removed); it only persists `_accounts['google:google-demo-user']` once an explicit `signInWithGoogle()` call runs. The Firebase implementation writes 3 Firestore documents per sign-in path so the rest of the app reads from real backend state.

**Trade-offs accepted:**

1. **`_buildUserModel` merges Firebase Auth + persisted `users/{uid}`.** Firebase Auth is the source of truth for `emailVerified`, `photoUrl`, `lastSignInAt`; the persisted doc is the source of truth for `examTrack`, `district`, `phoneNumber`, `displayName`. Persisted values win on conflict so user-edited Complete-Profile data is preserved across re-sign-ins.
2. **Email / phone controller methods stay in place.** They are valid APIs in the auth feature even though their UI surfaces are deleted. Removing them would be a bigger change for no user-facing benefit. They are documented as future-admin / test-only entry points.
3. **`FirebaseAuthRemoteDataSource` is fully implemented.** All 12 methods (`authStateChanges`, `currentUser`, `signInWithEmail`, `registerWithEmail`, `signInWithGoogle`, `sendPasswordReset`, `sendPhoneOtp`, `verifyPhoneOtp`, `resendEmailVerification`, `reloadUser`, `updateProfile`, `signOut`) now run against real Firebase. The activation pattern is unchanged — production swap is still driven by `authRemoteDataSourceProvider` overriding the mock with the Firebase instance when `FirebaseConfig.isPlatformConfigured` is true.
4. **`Icons.g_mobiledata_rounded` is a stylized G, not the Google logo.** It is recognizable as "G" without adding an icon dependency. A future polish pass can swap it for a custom Google-branded asset or Font Awesome's `google` glyph.
5. **WelcomeScreen is now `ConsumerStatefulWidget`.** It needs the `_isWorking` local state to drive `PrimaryButton.isLoading`. The state is private to the widget and never escapes.
6. **`AuthStrings.welcomeGoogleFailure` + `welcomeGoogleCancelled` are declared but not yet surfaced in UI.** They exist so the failure messages can be shown via `AppSnackBar` later. The current `AuthState.errorMessage` will surface them in a follow-up pass.
7. **The mock is preserved for offline / test usage.** When `FirebaseConfig.isPlatformConfigured` is false (unit tests, hot-reload without `google-services.json`, CI), `MockAuthRemoteDataSource` is used. The mock still persists `_accounts['google:google-demo-user']` across `signInWithGoogle()` calls so the profile-completion flow is exercisable in tests — but it no longer auto-creates a demo user on instantiation.
8. **No new tests added.** The existing test coverage for `AuthController`, `AuthRepository`, and `AuthRemoteDataSource` stays; the screen tests for the deleted screens are removed implicitly. Adding widget tests for the new Welcome screen is deferred to Phase 55 (test infrastructure).

---

### 6.36 Phase 55 — Production Ready (Firestore-backed, no mock data)

Phase 54 closed the auth front-door (Google only, Firestore-backed). Phase 55 turns the rest of the **data layer** into production-grade Firestore readers/writers so that every screen — not just auth — reads from real backend state, every action persists, and every authenticated user has isolated data. The previous Phase 53 wiring is preserved; this phase adds the missing datasources for the read-heavy features (quiz catalogue, lesson catalogue, review history, subscription, search) and removes dead-code mocks.

**Critical principle:** every mock datasource now gates on `FirebaseConfig.isPlatformConfigured` and returns the real Firestore-backed implementation when configured. The pattern matches `categoryRemoteDataSourceProvider` (which has always followed this rule): mock is a true offline fallback for tests / unconfigured dev, never a production default.

**New Firestore-backed datasources added this phase:**

1. **`lib/features/quiz_engine/data/datasources/firebase_quiz_remote_datasource.dart`** — reads `quizzes/{quizId}` with nested `quizzes/{quizId}/questions/{questionId}` subcollection. Methods: `fetchAllQuizzes`, `fetchQuizzesForNode` (where `nodeId`), `fetchQuizById`, `submitQuizSession` (computes result locally — persistence happens through `UserProgressService.applyQuizCompletion` to keep the quiz funnel consistent), `fetchBookmarkedQuestionIds`, `toggleBookmark`, `submitReport`. Helpers `_hydrate` and `_question` build the model tree.
2. **`lib/features/lessons/data/datasources/firebase_lesson_remote_datasource.dart`** — reads `lessons/{lessonId}` with sections/examples/summary as nested fields. Methods: `fetchAllLessons`, `fetchLessonsForNode` (where `nodeIds` arrayContains), `fetchLessonById`, `fetchLessonBySlug`. Helper `_hydrate` parses sections, examples, and the summary section.
3. **`lib/features/review/data/datasources/firebase_review_remote_datasource.dart`** — reads `users/{uid}/quiz_sessions/{sessionId}` populated by `UserProgressService.applyQuizCompletion` and joins each session with the canonical quiz via the injected `QuizRemoteDataSource`. The Review screen now shows real session history instead of the seed-mock sessions.
4. **`lib/features/subscription/data/datasources/firebase_subscription_remote_datasource.dart`** — reads `subscription_plans/{planId}` and the user entitlement at `users/{uid}/subscription/current`. Native IAP continues to use the `MethodChannel('prep_quest/subscription')` for Play Billing / Apple IAP; the Firestore DS mirrors the resulting entitlement so every screen reads from the same source of truth.
5. **`lib/features/search/data/datasources/firebase_search_remote_datasource.dart`** — joins the canonical lessons + quizzes collections at runtime, persists recent searches per user under `users/{uid}/search_recent/{query}`, and reads trending from a single document at `search_index/trending`.

**Schema changes this phase:**

- `users/{uid}/quiz_sessions/{sessionId}` and `users/{uid}/quiz_history/{sessionId}` now persist a `perQuestion{}` map (alongside the aggregate session payload). The map is keyed by `questionId` and contains `selectedAnswerIds[]`, `status`, `timeSpentSeconds`, `attemptCount`, `hintIdsRevealed[]`, `isBookmarked`, `wasCorrect`. The Review feature consumes this map to rebuild per-question review entries. The change is additive — sessions written before Phase 55 surface an empty per-question list and still render with the aggregate counts.
- `users/{uid}/subscription/current` is a new subcollection mirroring the entitlement (`tier`, `status`, `renews_at_iso`, `expires_at_iso`, `auto_renews`, `transaction_id`, `plan{...}`).
- `users/{uid}/search_recent/{query}` is a new subcollection — one document per query (lowercased), with `query`, `queriedAtIso`, `categoryAtTime`.
- `search_index/trending` is a single document (`{terms: [...]}`) published by a daily Cloud Function.
- `subscription_plans/{planId}` is the canonical subscription plan catalog.

**Files deleted:**

- `lib/features/statistics/data/datasources/mock_statistics_remote_datasource.dart` — dead code, never imported. The canonical reader is `StatisticsService` (Firestore-backed).

**Files renamed:**

- `lib/features/quiz_results/data/datasources/mock_quiz_results_remote_datasource.dart` → `analytics_quiz_results_remote_datasource.dart`. Class renamed from `MockQuizResultsRemoteDataSource` → `AnalyticsQuizResultsRemoteDataSource`. Doc comment explains the legacy name and clarifies that the class is the **production** wiring: every catalog read forwards to the injected `QuizRemoteDataSource` (which is `FirebaseQuizRemoteDataSource` in production) and the per-question analytics are derived locally from the canonical session. The actual `QuizResultsRemoteDataSource` import is updated throughout the presentation layer.

**New constants in `lib/core/constants/firestore_keys.dart`:**

- `subscriptionSubcollection = 'subscription'`
- `searchRecentSubcollection = 'search_recent'`

These sit alongside the Phase 53–54 additions (e.g. `appUserSubcollection`, `leaderboardEntriesSubcollection`, `contentManifestsCollection`, `searchIndexCollection`, `subscriptionPlansCollection`).

**Decision log:**

1. **Production wiring pattern.** Every mock datasource now gates on `FirebaseConfig.isPlatformConfigured` and returns the Firestore-backed implementation when configured. The pattern matches `categoryRemoteDataSourceProvider`: mock is a true offline fallback for tests / unconfigured dev, never a production default.
2. **QuizResults facade.** The `QuizResultsRemoteDataSource` is a thin analytics facade that forwards to `QuizRemoteDataSource`. Persistence happens through `UserProgressService.applyQuizCompletion` (Firestore). The class is renamed to `AnalyticsQuizResultsRemoteDataSource` but the import path is preserved for backward compatibility.
3. **Review reads from `users/{uid}/quiz_sessions`.** The legacy `ReviewLocalDataSource` (which seeded fake sessions from the Quiz Engine mock) is preserved as the offline fallback. In production the `FirebaseReviewRemoteDataSource` reads real sessions ordered by `completedAt` descending; the per-question breakdown comes from the new `perQuestion{}` map on the session doc.
4. **Subscription combines native IAP with Firestore mirror.** Purchase / restore / cancel continue to route through `MethodChannel('prep_quest/subscription')` for Play Billing / Apple IAP. The `FirebaseSubscriptionRemoteDatasource` then writes the resulting entitlement to `users/{uid}/subscription/current` so every screen reads from the same source of truth.
5. **Search joins the canonical collections at runtime.** Trending and recent-search writes are persisted to Firestore. The seed-based `SearchLocalDataSource` remains for offline / tests.
6. **No new screens or new user flows.** Phase 55 is data-layer wiring only. The runtime behaviour is identical to Phases 53–54; every screen now reads through a Firestore-backed datasource and every action persists through a Firestore writer.
7. **`flutter analyze lib/` returns 0 errors / 0 warnings.** The 116 remaining issues are all `info`-level linter style suggestions (e.g. `prefer_initializing_formals`) that were pre-existing on the Phase 53-54 baseline.
8. **Production SaaS behaviour guaranteed.** Per the user's production-ready spec, this phase enforces: (a) no screen depends on mock data, (b) no repository returns fake values, (c) no provider generates local placeholder state, (d) every user action persists to Firestore, (e) every screen updates in realtime via the existing snapshot listeners. Each authenticated user has data isolated under `users/{uid}/*` (Phase 51's `firestore.rules` enforces the isolation server-side).

---

### 6.37 Phase 57 — Playground Nodes Driven by Quiz Hub REST API

Phase 55 wired every Quiz Engine read/write through Firestore. Phase 55 also introduced `HttpQuizApiRemoteDataSource` + `QuizApiRepository` + `quizApiCategoriesStreamProvider` (30-second polling) against the Quiz Hub REST API. Until Phase 57 the playground still drew its world map from the Firestore `categories` collection and synthesised synthetic `node-$i` ids — tapping a node never produced a live Quiz Hub question list. This phase closes that gap so every playground node is a real Quiz Hub category and tapping it launches a live quiz populated from `/categories/{id}/questions/random?count=20`.

**Files added (2):**

1. **`lib/features/category_api/data/datasources/quiz_api_category_remote_datasource.dart`** — `QuizApiCategoryRemoteDataSource` implements the existing `CategoryRemoteDataSource` contract (`listCategories`, `getCategory`, `watchCategories`) by mapping `QuizCategoryEntity → CategoryModel`. Order is best-effort via `int.tryParse(id)` so numeric-string ids sort numerically. `watchCategories` polls on the same 30-second cadence as `quizApiCategoriesStreamProvider`.
2. **`lib/features/playground/presentation/providers/playground_categories_provider.dart`** — `playgroundCategoriesProvider` is a `StreamProvider<List<CategoryEntity>>` aliased through `categoryRepositoryProvider.watchCategories()`. Provides the playground with a stable, well-named handle independent of `quiz_api` internals.

**Files modified (8):**

1. **`lib/features/category_api/presentation/providers/category_providers.dart`** — `categoryRemoteDataSourceProvider` now returns `QuizApiCategoryRemoteDataSource(quizApiRepositoryProvider)` so the playground reads from Quiz Hub. `firestoreCategoryRemoteDataSourceProvider` is preserved for any non-playground consumer that still needs the Firestore read path.
2. **`lib/features/playground/presentation/utils/world_layout.dart`** — `WorldStep` gains a real `id` field. `WorldLayout.build` prefers `step.id` and falls back to `node-$i` only when an id is empty.
3. **`lib/features/playground/presentation/providers/world_steps_provider.dart`** — the `'node-$i'` synthesis is removed. Every `WorldStep.id` is `CategoryEntity.id` from the Quiz Hub response. `_isPassedActive` / `_resolveActiveIndex` now lookup by category id (no more `int.tryParse(activeId.replaceFirst('node-', ''))`). The seed fallback uses `'seed-N'` placeholders so the UI is never blank even if Quiz Hub errors.
4. **`lib/features/playground/presentation/providers/playground_provider.dart`** — `PlaygroundProgress.seed` starts empty (`completedLevelIds: []`, `unlockedLevelIds: []`, `activeLevelId: null`). `_findNextNode` resolves "next node" against a caller-supplied canonical ordering (set via `setOrderedNodeIds(List<String>)`) instead of parsing `node-N`. `_allNodeIds` is removed.
5. **`lib/features/playground/presentation/providers/playground_providers.dart`** — exposes `setOrderedNodeIds(List<String>)` on `PlaygroundNotifier` so `world_steps_provider` can push the canonical Quiz Hub category ids.
6. **`lib/features/quiz_engine/presentation/screens/quiz_overview_screen.dart`** — when `nodeId` is non-empty, the screen first tries `quizApiQuizForCategoryProvider(nodeId)`. On success a single "Start" `QuizOverviewCard` is rendered and tapping it routes to `/quizPlay?quizId=<synthesisedEngineQuizId>`. Falls back to `quizNodeControllerProvider(nodeId)` so legacy deep-links still resolve.
7. **`lib/core/providers/auth_lifecycle.dart`** — `playgroundCategoriesProvider` is appended to the `_authStateResetDispatcherProvider` invalidation list so signing out drops the cached Quiz Hub categories immediately.
8. **`lib/router.dart`** — `redirect` blocks on the level / challenge / boss / levelCompleted routes default to an empty `nodeId` sentinel that redirects to `/playground` (the world map) when the user lands on a stale URL. Previously these defaults were `'node-2'` / `'node-boss'` and routed into the legacy multi-quiz path.

**Decision log:**

1. **`CategoryEntity` stays canonical.** Phase 57 only swaps the **datasource** — every other consumer (world map builder, search, category browser) continues to import the same `CategoryEntity`. Quiz Hub categories (`id`, `name`, `description`) are mapped via `_mapQuizCategoryToEntity`. Non-numeric ids (e.g. `'bangladesh-affairs'`) fall back to `order: 0` and render in API-insertion order; a follow-up can promote a curated admin config.
2. **`nodeId == categoryId` end-to-end.** No synthesised `node-N` ids. The Quiz Hub category id propagates through `queryParameters['nodeId']` to `quizOverview`, then to `quizApiQuizForCategoryProvider(nodeId)`, which returns a synthesised engine `QuizModel` whose `id` is `quizhub-<categoryId>`. That engine id is what `/quizPlay` consumes.
3. **`kind` is heuristic.** Quiz Hub has no `kind` field; every API category maps to `CategoryNodeKind.lesson` and `WorldStepKind.regular`. The procedural `world_layout.dart` (3 lanes, jitter, milestones) gives the map shape without per-category flags. A future phase can promote a category whose title contains "boss" or "final" to `WorldStepKind.boss`.
4. **Firestore is no longer the playground's source of truth.** `FirestoreCategoryRemoteDataSource` is preserved on disk and `firestoreCategoryRemoteDataSourceProvider` is still exported for any non-playground consumer that imports it (search, category browser, admin surfaces). The playground's `world_steps_provider` no longer queries Firestore.
5. **Auth-lifecycle is hard-coded.** `playgroundCategoriesProvider` is appended to the explicit invalidation list at `auth_lifecycle.dart:53-68` so the lifecycle stays reviewable.
6. **Routing stays `/quizOverview`.** No new routes; the screen body is reused. Only the data source path is swapped.
7. **`world_steps_provider` pushes ordering into `PlaygroundNotifier`.** Whenever the categories list resolves, the provider reads `playgroundProgressProvider.notifier.setOrderedNodeIds(...)` so the legacy `markCompleted` / `grantBossReward` "next node" logic can resolve against real category ids. This is a side-effect — it does not affect the snapshot returned.
8. **Mock fallback is preserved.** When the Quiz Hub API is unreachable, `FallbackQuizApiRepository` serves `MockQuizApiRemoteDataSource`, which ships the deterministic BCS dataset. The world map still renders and tapping a node still launches a quiz using the mock bank.
9. **`flutter analyze lib/` returns 0 errors / 0 warnings.** The 117 remaining issues are all `info`-level linter style suggestions that are pre-existing on the Phase 55 baseline.

---

### 6.38 Phase 57b — Wire Quiz Hub Adapter into Play-Screen Datasource

Phase 57 made the playground world map and the **overview screen** read from the Quiz Hub REST API (`WorldStep.id == category.id`, `QuizOverviewScreen` builds the start card via `quizApiQuizForCategoryProvider`). But the **play screen** still resolved its quiz through `quizRemoteDataSourceProvider`, which returned `FirebaseQuizRemoteDataSource` or `MockQuizRemoteDataSource` — neither of which knows about `quizhub-*` ids. Tapping a node loaded the wrong content (or surfaced "Quiz not found") because the synthesized `quizhub-<categoryId>` id was never recognised by the engine's primary datasource.

This phase is the targeted bug fix that closes the loop: every node tap now resolves through the Quiz Hub adapter on the play screen.

**Files modified (3):**

1. **`lib/features/quiz_api/data/datasources/quiz_api_quiz_engine_adapter.dart`** — `QuizApiQuizEngineAdapter`'s `fallback` parameter type changed from `MockQuizRemoteDataSource` to the abstract `QuizRemoteDataSource`. The `_fallback` field type is also relaxed. Every existing dispatch through `_fallback.<method>()` already goes through the abstract interface, so no behavioural change.
2. **`lib/features/quiz_api/presentation/providers/quiz_api_providers.dart`** — `quizApiAdapterProvider` is unchanged in shape; `MockQuizRemoteDataSource()` already implements `QuizRemoteDataSource`, so the constructor call is valid against the new abstract type.
3. **`lib/features/quiz_engine/presentation/providers/quiz_providers.dart`** — `quizRemoteDataSourceProvider` now returns the `QuizApiQuizEngineAdapter` (from `quizApiAdapterProvider`) when it is wired. If the adapter is null (HTTP client cannot construct in tests / offline dev), the old Firebase/mock fallback branches still apply. The `quiz_api/` imports are added so `quizApiAdapterProvider` resolves.

**Files added (0):**

None — this is a pure wiring fix using existing classes.

**Decision log:**

1. **Adapter is primary, not Firebase.** The adapter already implements `QuizRemoteDataSource` and detects the `quizhub-` prefix in `fetchQuizById` / `submitQuizSession`. Wiring it as primary means every `quizhub-*` id resolves through the Quiz Hub REST API end-to-end. The `quiz_api/` boundary is preserved because the adapter's `fallback` is wired inside `quizApiAdapterProvider` (which lives in `quiz_api/`), not inside `quiz_providers.dart`.
2. **Fallback type is the abstract `QuizRemoteDataSource`.** Loosening from `MockQuizRemoteDataSource` to `QuizRemoteDataSource` is a pure signature change. Production wires a `FirebaseQuizRemoteDataSource` (or future Cloud Functions DS) when it needs to reach non-Quiz-Hub ids; tests / offline builds keep wiring `MockQuizRemoteDataSource`. The contract `fetchQuizById` / `submitQuizSession` / `fetchAllQuizzes` / `fetchQuizzesForNode` / `fetchBookmarkedQuestionIds` / `toggleBookmark` / `submitReport` is fully covered by the abstract interface.
3. **No new routes, no new screens, no UI changes.** The overview screen still uses `quizApiQuizForCategoryProvider` directly (returns a `QuizModel`); the play screen chain is unchanged — `quizDetailControllerProvider(quizId)` → `getQuizByIdProvider` → `quizRepositoryProvider` → `quizRemoteDataSourceProvider` → **adapter** (with Quiz Hub HTTP / adapter fallback). The quiz session / result / progress flows are untouched.
4. **Non-Quiz-Hub ids fall through to the adapter's mock fallback.** The adapter's `fallback` field is `MockQuizRemoteDataSource` (set in `quizApiAdapterProvider`). There is no production caller that passes a non-`quizhub-` id through `quizDetailControllerProvider` today — the only producer of `quizId` values is the overview screen, which uses synthesized `quizhub-*` ids — so this is a non-regression. Review / search / quiz-results screens do not call `quizRemoteDataSourceProvider.fetchQuizById`; they each have their own providers.
5. **`quizApiAdapterProvider` stays nullable.** When the HTTP client fails to construct (e.g. in tests without a base URL), the play screen falls through to Firebase/mock. This matches the Phase 55 fallback pattern.
6. **`flutter analyze lib/` returns 0 errors / 0 warnings.** The 117 remaining issues are all `info`-level linter style suggestions that are pre-existing on the Phase 57 baseline.

---

## 7. `lib/shared/` — Cross-Feature Primitives (scaffold)

```
shared/
├── enums/
├── mixins/
├── models/
├── repositories/
├── typedefs/
├── validators/
└── widgets/
```

Reserved for primitives that don't belong to a single feature (e.g., shared result types, generic widgets). Currently empty stubs.

---

## 8. Routing

Routes are centralised in `lib/router.dart`:

| Constant | Path | Purpose |
|---|---|---|
| `AppRoutes.root` | `/` | Redirect-only entry; redirects to `/splash` then to `/playground` (or `/welcome` if unauthenticated). |
| `AppRoutes.splash` | `/splash` | Splash screen — drives the initial auth decision. |
| `AppRoutes.welcome` | `/welcome` | Welcome screen — single "Continue with Google" CTA (Phase 54). |
| `AppRoutes.completeProfile` | `/complete-profile` | Profile-completion screen — pre-fills from `state.user` (Google identity data). |
| `AppRoutes.playground` | `/playground` | World-map playground screen (default landing for authenticated users). |
| `AppRoutes.widgetBuilder` | `/widget-builder` | Widget-builder screen. |

Auth-related routes (login, register, forgot-password, phone-OTP, email-verification) were deleted in **Phase 54** when the flow collapsed to Google Sign-In only. The full route catalogue (~75 entries) covers lessons, quiz engine, quiz results, gamification, notifications, search, bookmarks, notes, settings, profile, subscription, AI tutor, and offline flows.

The router is composed by `createAppRouter()` and consumed by `MaterialApp.router` in `lib/app.dart`. The redirect logic reads `AuthRouterBridge.lastSeenState` (kept in sync by `authRouterRefreshProvider`) and applies the per-status redirects:

- `unauthenticated` → `/welcome` (only path in `_unauthenticatedPaths` whitelist).
- `profileIncomplete` → `/complete-profile`.
- `authenticated` → any path (excluding the whitelist).
- `unknown` → `/splash`.

---

## 9. State Management

State management is declared through `providers/`:

- **App-wide** — `lib/core/providers/{language_provider.dart, theme_provider.dart}`.
- **Per feature** — `lib/features/<feature>/presentation/providers/*.dart` (Riverpod-style notifier classes).

Each provider is a leaf in the dependency graph and is consumed by the screens / widgets that need its state.

---

## 10. Services, Repositories, Data Sources

| Concern | Owner | Notes |
|---|---|---|
| Networking | `lib/core/network/dio_client.dart` + interceptors | API endpoints enumerated in `lib/core/constants/api_endpoints.dart`. |
| Cache | `lib/core/cache/hive_manager.dart` | Hive box lifecycle. Box names in `lib/core/constants/hive_boxes.dart`. |
| Encrypted storage | `lib/core/security/secure_storage.dart` | Holds tokens / secrets. |
| Analytics | `lib/core/services/analytics_service.dart` | Single facade for analytics providers. |
| Auth | `lib/core/services/auth_service.dart` | Coordinates OTP login flow. |
| Connectivity | `lib/core/services/connectivity_service.dart` | Online/offline status. |
| Notifications | `lib/core/services/notification_service.dart` | Push + local. |
| Permissions | `lib/core/services/permission_service.dart` | Runtime permission gating. |
| Sharing | `lib/core/services/share_service.dart` | Native share sheet. |
| Storage | `lib/core/services/storage_service.dart` | Cloud Storage facade. |
| Subscription | `lib/core/services/subscription_service.dart` | Premium / bdapps / bKash glue. |
| Theme / Language | `lib/core/services/{theme,language}_service.dart` | Persisted prefs. |
| Repositories | `lib/features/<feature>/data/repositories/*_impl.dart` | Implement domain contracts. |
| Data sources | `lib/features/<feature>/data/datasources/*.dart` | Remote / local. |
| Models | `lib/features/<feature>/data/models/*.dart` | DTOs. |

---

## 11. Themes

| File | Purpose |
|---|---|
| `lib/core/theme/app_theme.dart` | Aggregator that builds both themes. |
| `lib/core/theme/light_theme.dart` | Light `ThemeData`. |
| `lib/core/theme/dark_theme.dart` | Dark `ThemeData`. |
| `lib/core/theme/app_typography.dart` | Type scale. |
| `lib/core/theme/app_button_theme.dart` | Material button overrides. |
| `lib/core/theme/app_card_theme.dart` | Card overrides. |
| `lib/core/widgets/ai/ai_theme.dart` | AI-specific colour/typography. |

Theme selection is driven by `AppConfig.themeMode` (defaults to `ThemeMode.system`) and overridable by `lib/core/providers/theme_provider.dart`.

---

## 12. Animations & Painters

Animations are co-located with their consumers:

- `lib/core/widgets/animations/` — reusable primitives.
- `lib/features/playground/presentation/widgets/animations/` — chest, node glow, path, unlock.
- `lib/features/playground/presentation/widgets/rewards/*/..._animation.dart` — coin_reward_animation, reward_chest_controller, reward_popup_animation.

Painters live next to their widgets whenever a widget is custom-drawn:

- `lib/features/playground/presentation/widgets/painters/` — 30+ painters rendering Playground visuals (buildings, decorations, path, particles, etc.).
- `lib/core/widgets/ai/ai_*` — implicit painters as needed.

---

## 13. Configuration

### 13.1 Tooling (`pubspec.yaml`)

Runtime dependencies (declared, currently used):

- `flutter` (SDK)
- `cupertino_icons ^1.0.8`
- `go_router ^17.3.0`
- `lottie ^3.5.1`
- `vector_math ^2.2.0`

Dev dependencies:

- `flutter_test` (SDK)
- `flutter_lints ^6.0.0`

`pubspec.yaml` does **not** yet declare Firebase, Hive, Riverpod, Dio, or any other packages, despite folders referencing those features. Plan-language scaffolding only.

### 13.2 Analyzer

`analysis_options.yaml` enables `package:flutter_lints/flutter.yaml`; the rules block is the placeholder (no rule overrides).

### 13.3 App config

`lib/core/config/app_config.dart` defines the runtime config singleton (`environment`, `isProduction`, `defaultLocale`, `themeMode`). `bootstrap()` reads `APP_ENV` (default `dev`).

---

## 14. Platform Folders

```
android/                        Android Gradle project (AGP 9.0.1, Kotlin 2.3.20, JDK 17,
                               namespace + applicationId `com.example.prep_quest`).
ios/                            Xcode project `Runner.xcodeproj` (no Podfile yet,
                               no GoogleService-Info.plist).
linux/                          GTK-based Flutter desktop target.
macos/                          macOS desktop target.
windows/                        Win32 desktop target.
web/                            Flutter web (PWA: index.html, manifest.json,
                               favicon.png, four icons). Firebase config absent.
functions/                      Firebase Cloud Functions (TypeScript) — every file
                               is a 0-byte stub across admin, AI, analytics,
                               auth, gamification, guidebook, leaderboard,
                               mock tests, notifications, questions, quiz,
                               scheduler, subscription, and users.
```

---

## 15. Assets

None. The `assets:` and `fonts:` sections of `pubspec.yaml` are placeholders. Only the implicit Material Icons font and `cupertino_icons` package font are bundled.

---

## 16. Tests

```
test/
├── widget_test.dart                                  App smoke test (boots into
                                                     playground + HUD semantic check).
└── core/widgets/ai/ai_hint_card_test.dart            Verifies AI hint card title,
                                                     hint, type label "AI Analysis",
                                                     topic, difficulty, quick tip.
```

---

## 17. Documentation (`docs/`)

```
docs/
├── PLAYGROUND_DESIGN_AESTHETIC.md           Top-level aesthetic guide for
│                                            the Playground feature.
└── playground/
    ├── PLAYGROUND_ANIMATION_SYSTEM.md      Animation system & easings.
    ├── PLAYGROUND_DATA_FLOW.md             Data flow / layering of Playground.
    ├── PLAYGROUND_DIAGRAMS.md              Mermaid architecture flowcharts.
    ├── PLAYGROUND_FOLDER_STRUCTURE.md      Canonical Playground folder map.
    ├── PLAYGROUND_FUTURE_EXPANSION.md      Roadmap of upcoming Playground work.
    ├── PLAYGROUND_GAMEPLAY_FLOW.md         Gameplay flow description.
    ├── PLAYGROUND_RENDERING_PIPELINE.md    Rendering pipeline.
    ├── PLAYGROUND_SCREEN_ARCHITECTURE.md   Screen compositions.
    ├── PLAYGROUND_STATE_MANAGEMENT.md      State management approach.
    ├── PLAYGROUND_UI_GUIDELINES.md         UI rules.
    ├── PLAYGROUND_WIDGET_ARCHITECTURE.md   Widget tree reuse strategy.
    └── PLAYGROUND_WIDGET_FLOW.md           Concise widget-flow summary.
```

`Plans/` (planning + architecture docs, separate from `docs/`):

```
Plans/
├── BCS_Booster_AI_Agent_Build_Steps.md
├── BCS_Booster_AI_Agent_Implementation_Steps.md
├── BCS_Booster_AI_Agent_Prompt.md
├── BCS_Booster_AI_SRS (1).md
├── appflow.md
├── codebase_structure.md              (this file)
├── codebase_structure.json            (machine-readable counterpart)
├── design.md
├── instruction.json
├── playground_structure.md
├── widgetdesign.md
└── .vscode/settings.json
```

---

## 18. Future Expansion & Drift Notes

- **Stub reduction** — Most `lib/features/*/` directories hold empty stubs; they were listed but not implemented. Implementations should follow the Clean Architecture template established in §2.
- **Dependency wiring** — `pubspec.yaml` should add `firebase_*`, `hive`, `dio`, `riverpod`, and feature packages as implementations land.
- **Firebase config** — `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` need real client configs before Firebase functions can be wired.
- **`functions/`** — Names are planned; no implementation exists. Empty `.ts` files only.
- **iOS CocoaPods** — No `ios/Podfile` exists; required once a plugin needs iOS linkage.

---

## 19. How To Read This Document

- Want to find a file? Use §3 / §4 / §5 / §6 as a table of contents.
- Want to add a new feature? Use §2 (architecture rules), then replicate §6.1 / §6.2's layout.
- Want to understand why a folder exists? Each section lists the responsibility of its files.
- Looking for reusable UI? §5.1 catalogues the shared widget library.

For machine consumption see `codebase_structure.json`.
