import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/app_snackbar.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [AppSnackBar] widget.
///
/// Captures the four primary variants — success, error, warning, info —
/// in light + dark themes. Each snackbar is mounted inside a [Scaffold]
/// using a transient [ScaffoldMessenger] host so the floating behaviour
/// is part of the snapshot.
void main() {
  // Snackbar variants take a BuildContext so they can resolve margins
  // for the host Scaffold. We expose the context via a [Builder] and
  // schedule the show-call inside a post-frame callback so the
  // floating widget actually paints before the snapshot is taken.
  Future<void> captureVariant(
    WidgetTester tester,
    String variant,
    AppSnackBar Function(BuildContext) factory,
  ) async {
    tester.view.physicalSize = const Size(360, 220);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await captureGoldenPair(
      tester,
      'core/app_snackbar_$variant',
      builder: (BuildContext context, ThemeMode mode) => Scaffold(
        body: SafeArea(
          child: Builder(
            builder: (BuildContext innerContext) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(innerContext)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(factory(innerContext));
              });
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
  }

  group('AppSnackBar · success', () {
    testWidgets('success · light+dark', (WidgetTester tester) async {
      await captureVariant(
        tester,
        'success',
        (ctx) => AppSnackBar.success(
          ctx,
          'Profile updated successfully.',
        ),
      );
    });
  });

  group('AppSnackBar · error', () {
    testWidgets('error · light+dark', (WidgetTester tester) async {
      await captureVariant(
        tester,
        'error',
        (ctx) => AppSnackBar.error(
          ctx,
          'We could not save your changes.',
        ),
      );
    });
  });

  group('AppSnackBar · warning', () {
    testWidgets('warning · light+dark', (WidgetTester tester) async {
      await captureVariant(
        tester,
        'warning',
        (ctx) => AppSnackBar.warning(
          ctx,
          'Your session will expire in 5 minutes.',
        ),
      );
    });
  });

  group('AppSnackBar · info', () {
    testWidgets('info · light+dark', (WidgetTester tester) async {
      await captureVariant(
        tester,
        'info',
        (ctx) => AppSnackBar.info(
          ctx,
          'New study material is available.',
        ),
      );
    });
  });
}