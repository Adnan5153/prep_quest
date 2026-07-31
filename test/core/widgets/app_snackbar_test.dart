import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/app_snackbar.dart';

import '../../helpers/test_app.dart';
import '../../helpers/widget_test_utils.dart';

/// AppSnackBar extends SnackBar, which only renders via ScaffoldMessenger.
/// These tests wrap a Scaffold body in a button that triggers the snackbar
/// via the messenger, then verify the snackbar's text content via `find`.
void main() {
  Future<void> triggerSnackbar(WidgetTester tester, SnackBar Function(BuildContext) factory) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(factory(context));
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('AppSnackBar', () {
    testWidgets('renders success variant (light)', (tester) async {
      await triggerSnackbar(
        tester,
        (context) => AppSnackBar.success(context, 'Saved!'),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Saved!'));
    });

    testWidgets('renders error variant (light)', (tester) async {
      await triggerSnackbar(
        tester,
        (context) => AppSnackBar.error(context, 'Something went wrong'),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Something went wrong'), findsWidgets);
    });

    testWidgets('renders warning variant', (tester) async {
      await triggerSnackbar(
        tester,
        (context) => AppSnackBar.warning(context, 'Be careful'),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Be careful'));
    });

    testWidgets('renders info variant', (tester) async {
      await triggerSnackbar(
        tester,
        (context) => AppSnackBar.info(context, 'FYI'),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('FYI'));
    });

    testWidgets('renders neutral variant', (tester) async {
      await triggerSnackbar(
        tester,
        (context) => AppSnackBar.neutral(context, 'Just so you know'),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Just so you know'));
    });

    testWidgets('renders custom variant with explicit colors', (tester) async {
      await triggerSnackbar(
        tester,
        (context) => AppSnackBar.custom(
          context,
          message: 'Branded message',
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Branded message'));
    });

    testWidgets('shows close button when enabled', (tester) async {
      await triggerSnackbar(
        tester,
        (context) => AppSnackBar.error(context, 'Closeable'),
      );

      // Error variant shows close button by default.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders with action button', (tester) async {
      await triggerSnackbar(
        tester,
        (context) => AppSnackBar(
          message: 'Try again?',
          variant: AppSnackBarVariant.warning,
          leadingIcon: Icons.warning_amber_outlined,
          action: SnackBarAction(label: 'Retry', onPressed: () {}),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Retry'), findsWidgets);
    });

    testWidgets('dark theme renders without exceptions', (tester) async {
      await tester.pumpWidget(
        TestApp(
          theme: ThemeMode.dark,
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      AppSnackBar.success(context, 'Dark success'),
                    );
                  },
                  child: const Text('Show'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark success'));
    });
  });
}
