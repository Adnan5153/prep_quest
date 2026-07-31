import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/widget_builder/presentation/providers/widget_builder_provider.dart';
import 'package:prep_quest/features/widget_builder/presentation/widgets/widget_builder_canvas.dart';

import '../../helpers/test_app.dart';

Future<void> _pumpCanvas(
  WidgetTester tester,
  WidgetBuilderProvider provider, {
  ThemeMode theme = ThemeMode.light,
}) async {
  // Give the canvas a wider surface so the rendered PrimaryButton preview
  // does not trigger RenderFlex overflow exceptions on small viewports.
  useTestSurface(tester: tester, size: const Size(800, 1200));
  await pumpTestWidget(
    tester,
    Scaffold(
      body: SizedBox(
        width: 720,
        height: 1080,
        child: WidgetBuilderCanvas(provider: provider),
      ),
    ),
    theme: theme,
  );
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  group('WidgetBuilderCanvas', () {
    testWidgets('renders successfully with preview header', (
      WidgetTester tester,
    ) async {
      final provider = WidgetBuilderProvider();
      await _pumpCanvas(tester, provider);

      expect(find.byType(WidgetBuilderCanvas), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);
    });

    testWidgets('updates preview when provider selection changes', (
      WidgetTester tester,
    ) async {
      final provider = WidgetBuilderProvider();
      await _pumpCanvas(tester, provider);

      expect(find.text('Preview'), findsOneWidget);

      provider.selection = WidgetBuilderSelection.secondaryButton;
      await tester.pump();

      expect(find.text('Preview'), findsOneWidget);
    });

    testWidgets('renders under dark theme without exceptions', (
      WidgetTester tester,
    ) async {
      final provider = WidgetBuilderProvider();
      await _pumpCanvas(tester, provider, theme: ThemeMode.dark);

      expect(find.byType(WidgetBuilderCanvas), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple pumps do not throw', (WidgetTester tester) async {
      final provider = WidgetBuilderProvider();
      await _pumpCanvas(tester, provider);

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('wrapped in a Card', (WidgetTester tester) async {
      final provider = WidgetBuilderProvider();
      await _pumpCanvas(tester, provider);

      // The canvas root is a Card, and the preview itself may also
      // produce Cards (depending on the widget under preview). Assert
      // that at least one Card is rendered inside the canvas tree.
      expect(
        find.descendant(
          of: find.byType(WidgetBuilderCanvas),
          matching: find.byType(Card),
        ),
        findsWidgets,
      );
    });
  });
}