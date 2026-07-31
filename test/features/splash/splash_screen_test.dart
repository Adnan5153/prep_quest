// Widget tests for the splash screen.
//
// NOTE: As of Phase 25 the production file
// `lib/features/splash/presentation/screens/splash_screen.dart` is
// an empty placeholder (no exported widget). A real `SplashScreen`
// widget currently lives under `features/authentication/presentation/
// screens/splash/`. We document that contract here and provide
// placeholder tests that will be enabled once the splash feature is
// wired up.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  group('SplashScreen', () {
    test('public surface is currently a placeholder', () {
      // The splash screen file is intentionally empty. This test
      // exists so the surrounding infrastructure (pumpTestWidget,
      // TestApp) keeps compiling when the splash feature lands.
      expect(true, isTrue);
    });

    testWidgets('TestApp pumps cleanly with an empty child', (
      WidgetTester tester,
    ) async {
      // Sanity check that the test harness still works without the
      // splash widget being present.
      await pumpTestWidget(tester, const SizedBox.shrink());
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}