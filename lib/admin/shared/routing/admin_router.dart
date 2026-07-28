import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/admin_login_screen.dart';
import '../../features/auth/presentation/screens/admin_shell_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/domain/entities/auth_session.dart';
import '../../features/audit/presentation/screens/activity_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/rewards/presentation/screens/rewards_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/themes/presentation/screens/theme_editor_screen.dart';
import '../../features/themes/presentation/screens/themes_screen.dart';
import '../../features/translations/presentation/screens/translations_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/assets/presentation/screens/assets_screen.dart';
import '../../features/worlds/presentation/screens/world_editor_screen.dart';
import '../../features/worlds/presentation/screens/worlds_screen.dart';
import 'admin_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'admin.root');

final adminRouterProvider = Provider<GoRouter>((Ref ref) {
  final ValueNotifier<int> refresh = ref.watch(authRouterRefreshProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AdminRoutes.dashboard,
    debugLogDiagnostics: false,
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState auth = ref.read(authStateProvider);
      final bool isAuthRoute = state.matchedLocation == AdminRoutes.login;
      final bool isRoot = state.matchedLocation == AdminRoutes.root;

      if (auth.status == AuthStatus.unknown) return null;

      if (auth.status == AuthStatus.unauthenticated && !isAuthRoute) {
        return AdminRoutes.login;
      }

      if (auth.status == AuthStatus.authenticated && (isAuthRoute || isRoot)) {
        return AdminRoutes.dashboard;
      }

      return null;
    },
    refreshListenable: refresh,
    routes: <RouteBase>[
      GoRoute(
        path: AdminRoutes.login,
        name: 'login',
        builder: (_, _) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: AdminRoutes.root,
        redirect: (_, _) => AdminRoutes.dashboard,
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AdminShellScreen(location: state.matchedLocation, child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: AdminRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.worlds,
            name: 'worlds',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: WorldsScreen(),
            ),
            routes: <RouteBase>[
              GoRoute(
                path: 'new',
                name: 'worlds.new',
                builder: (_, _) => const WorldEditorScreen(worldId: null),
              ),
              GoRoute(
                path: ':worldId/edit',
                name: 'worlds.edit',
                builder: (BuildContext ctx, GoRouterState s) {
                  return WorldEditorScreen(worldId: s.pathParameters['worldId']);
                },
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.themes,
            name: 'themes',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: ThemesScreen(),
            ),
            routes: <RouteBase>[
              GoRoute(
                path: ':themeId',
                name: 'themes.edit',
                builder: (BuildContext ctx, GoRouterState s) {
                  return ThemeEditorScreen(themeId: s.pathParameters['themeId']);
                },
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.assets,
            name: 'assets',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: AssetsScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.translations,
            name: 'translations',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: TranslationsScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.events,
            name: 'events',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: EventsScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.rewards,
            name: 'rewards',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: RewardsScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.activity,
            name: 'activity',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: ActivityScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.users,
            name: 'users',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: UsersScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.settings,
            name: 'settings',
            pageBuilder: (_, _) => const NoTransitionPage<void>(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: Center(child: Text('Route not found: ${state.uri}')),
      );
    },
  );
});
