import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// A tagged integration test binding that hands the [IntegrationTestWidgetsFlutterBinding]
/// to the caller and exposes convenience helpers for waiting on
/// real Firestore writes, dismissing dialogs, and capturing screenshots.
class IntegrationTestHarness {
  IntegrationTestHarness(this.binding);

  final IntegrationTestWidgetsFlutterBinding binding;

  /// Convenience getter that returns the actively-bound [IntegrationTestWidgetsFlutterBinding].
  static IntegrationTestWidgetsFlutterBinding ensure() {
    return IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  }

  /// Awaits a real-time stream to emit its first non-null value or until
  /// [timeout] elapses. Useful for waiting on Firestore writes that
  /// propagate after a tap.
  Future<T> firstValue<T>(
    Stream<T> stream, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final T value = await stream
        .firstWhere((T value) => value != null)
        .timeout(timeout, onTimeout: () => throw TimeoutException(
              'Stream did not emit a non-null value within $timeout',
            ));
    return value;
  }

  /// Captures a screenshot of the current frame and stores it under
  /// [name]. Screenshot files are written to the host machine running
  /// the integration tests.
  Future<void> captureScreenshot(String name) async {
    await binding.convertFlutterSurfaceToImage();
    await binding.takeScreenshot(name);
  }

  /// Returns a [Finder] that resolves to the on-screen [SnackBar] if one
  /// is currently visible.
  Finder snackBarFinder() => find.byType(SnackBar);

  /// Dismisses any visible modal by tapping the barrier or sending the
  /// Escape key depending on platform.
  Future<void> dismissAnyModal(WidgetTester tester) async {
    final Finder barrier = find.byType(ModalBarrier).first;
    if (barrier.evaluate().isNotEmpty) {
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    }
  }

  /// Pumps frames for [duration] so any in-flight animations or async
  /// notifier listeners can settle.
  Future<void> pumpFor(WidgetTester tester, Duration duration) async {
    await tester.pumpAndSettle(duration);
  }
}

/// Mounts [child] inside a minimal [MaterialApp] inside an integration
/// test environment. Use this for ad-hoc harness tests that don't need
/// the full Prep Quest app.
Future<void> pumpIntegrationWidget(
  WidgetTester tester,
  Widget child, {
  ThemeMode themeMode = ThemeMode.light,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeMode,
      home: Scaffold(body: child),
    ),
  );
  await tester.pump();
}
