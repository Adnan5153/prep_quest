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

### 6.5 `lib/features/authentication/` — Phone/OTP Auth (scaffold)

Purpose: Phone-OTP login and initial profile setup.

Layers: `data/` (1 model + 1 datasource + 1 repository impl), `domain/` (1 entity + 1 contract + 3 use cases: logout, send_otp, verify_otp), `presentation/` (2 providers + 3 screens: login, otp, profile_setup + 4 widgets: login_button, otp_input, phone_text_field, resend_timer).

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

Layers: `data/`, `domain/`, `presentation/`.

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
| `AppRoutes.root` | `/` | Redirect-only entry; redirects to `/playground`. |
| `AppRoutes.widgetBuilder` | `/widget-builder` | Widget-builder screen. |
| `AppRoutes.playground` | `/playground` | World-map playground screen (default landing). |

The router is composed by `createAppRouter()` and consumed by `MaterialApp.router` in `lib/app.dart`.

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
