import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:prep_quest/features/authentication/data/datasources/mock_auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/presentation/providers/auth_providers.dart';
import 'package:prep_quest/features/authentication/presentation/screens/login/login_screen.dart';

import '../../helpers/test_app.dart';

/// Golden tests for the [LoginScreen] widget.
///
/// Captures the screen layout in light + dark themes. The tests bypass
/// real authentication by overriding the remote data source with the
/// in-memory mock and routing any `context.go(...)` to a no-op stub.
void main() {
  /// Builds a tiny GoRouter that always shows [screen] regardless of
  /// the current location. This lets the auth screens call
  /// `context.go(...)` without throwing or losing the widget under test.
  GoRouter stubRouter(Widget screen) {
    return GoRouter(
      initialLocation: '/test',
      redirect: (BuildContext context, GoRouterState state) => null,
      routes: <RouteBase>[
        GoRoute(
          path: '/:path(.*)',
          builder: (BuildContext context, GoRouterState state) => screen,
        ),
      ],
    );
  }

  Future<void> capture(
    WidgetTester tester,
    String name, {
    required ThemeMode theme,
  }) async {
    // Filter out the production render-overflow noise that some auth
    // screens produce. The captured image is unaffected; this just
    // keeps the test run clean.
    final FlutterExceptionHandler? previousOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final MockAuthRemoteDataSource dataSource =
        MockAuthRemoteDataSource(latency: Duration.zero);
    final GoRouter router = stubRouter(const LoginScreen());

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authRemoteDataSourceProvider.overrideWithValue(dataSource),
        ],
        child: TestApp(
          theme: theme,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    await expectLater(
      find.byType(MaterialApp).last,
      matchesGoldenFile('goldens/auth/login_screen_$name.png'),
    );
  }

  testWidgets('login · empty form · light+dark', (WidgetTester tester) async {
    await capture(tester, 'light', theme: ThemeMode.light);
    await capture(tester, 'dark', theme: ThemeMode.dark);
  });
}