import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:prep_quest/features/authentication/data/datasources/mock_auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/presentation/providers/auth_providers.dart';
import 'package:prep_quest/features/authentication/presentation/screens/splash/splash_screen.dart';

import '../../helpers/test_app.dart';

/// Golden tests for the [SplashScreen] widget.
///
/// Captures the splash layout in light + dark themes. The screen
/// listens to [authStateProvider] and would normally `context.go(...)`
/// when the bootstrap finishes; we override the remote data source
/// with an in-memory mock and route navigation into a no-op stub.
void main() {
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
    final GoRouter router = stubRouter(const SplashScreen());

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authRemoteDataSourceProvider.overrideWithValue(dataSource),
        ],
        child: TestApp(
          theme: theme,
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    // Splash has a pulsing loader — pump a couple of frames so the
    // surface is stable enough to compare.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));

    await expectLater(
      find.byType(MaterialApp).last,
      matchesGoldenFile('goldens/auth/splash_screen_$name.png'),
    );
  }

  testWidgets('splash · light+dark', (WidgetTester tester) async {
    await capture(tester, 'light', theme: ThemeMode.light);
    await capture(tester, 'dark', theme: ThemeMode.dark);
  });
}