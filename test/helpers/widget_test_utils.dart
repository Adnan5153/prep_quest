import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

/// Pumps [child] inside a [TestApp] with the given [theme] and awaits
/// the first idle frame. Use this helper in any widget test that needs
/// a MaterialApp ancestor but does not need a router.
Future<void> pumpWidgetForTest(
  WidgetTester tester,
  Widget child, {
  ThemeMode theme = ThemeMode.light,
  Size? surfaceSize,
}) async {
  if (surfaceSize != null) {
    tester.view.physicalSize = surfaceSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }
  await tester.pumpWidget(
    TestApp(theme: theme, child: child),
  );
  await tester.pump();
}

/// Asserts that [finder] resolves to exactly one widget. Throws a
/// descriptive error if not.
void expectOneWidget(Finder finder) {
  expect(finder, findsOneWidget);
}

/// Asserts [finder] matches no widget in the current tree.
void expectMissing(Finder finder) {
  expect(finder, findsNothing);
}

/// Asserts [finder] matches the expected [count].
void expectCount(Finder finder, int count) {
  expect(finder, findsNWidgets(count));
}