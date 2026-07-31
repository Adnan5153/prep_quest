import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/widget_builder/presentation/providers/widget_builder_provider.dart';
import 'package:prep_quest/features/widget_builder/presentation/widgets/widget_builder_palette.dart';

import '../../helpers/test_app.dart';

Future<void> _pumpPalette(
  WidgetTester tester, {
  WidgetBuilderProvider? provider,
  ValueChanged<WidgetBuilderSelection>? onSelectionChanged,
  ValueChanged<String>? onLabelChanged,
  ValueChanged<String>? onSubtitleChanged,
  ValueChanged<bool>? onShowLeadingChanged,
  ValueChanged<bool>? onShowAccentStripeChanged,
  ThemeMode theme = ThemeMode.light,
}) async {
  final p = provider ?? WidgetBuilderProvider();
  await pumpTestWidget(
    tester,
    Scaffold(
      body: SizedBox(
        width: 360,
        height: 800,
        child: WidgetBuilderPalette(
          provider: p,
          onSelectionChanged: onSelectionChanged ?? (_) {},
          onLabelChanged: onLabelChanged ?? (_) {},
          onSubtitleChanged: onSubtitleChanged,
          onShowLeadingChanged: onShowLeadingChanged,
          onShowAccentStripeChanged: onShowAccentStripeChanged,
        ),
      ),
    ),
    theme: theme,
  );
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  group('WidgetBuilderPalette', () {
    testWidgets('renders successfully with title labels', (
      WidgetTester tester,
    ) async {
      await _pumpPalette(tester);

      expect(find.byType(WidgetBuilderPalette), findsOneWidget);
      expect(find.text('Widget'), findsOneWidget);
      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('shows dropdown for selecting widget', (
      WidgetTester tester,
    ) async {
      await _pumpPalette(tester);

      expect(find.byType(DropdownButtonFormField<WidgetBuilderSelection>),
          findsOneWidget);
    });

    testWidgets('shows label text field', (WidgetTester tester) async {
      await _pumpPalette(tester);

      // The palette has multiple TextFormFields (label + subtitle), so
      // assert that at least one is rendered rather than exactly one.
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('renders under dark theme without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpPalette(tester, theme: ThemeMode.dark);

      expect(find.byType(WidgetBuilderPalette), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple pumps do not throw', (WidgetTester tester) async {
      await _pumpPalette(tester);

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('label text field renders initial label from provider', (
      WidgetTester tester,
    ) async {
      final provider = WidgetBuilderProvider();
      provider.label = 'Initial';
      await _pumpPalette(tester, provider: provider);

      expect(find.text('Initial'), findsOneWidget);
    });

    testWidgets('handles changing selection without exceptions', (
      WidgetTester tester,
    ) async {
      final provider = WidgetBuilderProvider();

      await _pumpPalette(tester, provider: provider);

      provider.selection = WidgetBuilderSelection.secondaryButton;
      await tester.pump();

      expect(find.byType(WidgetBuilderPalette), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders dropdown items from registry', (
      WidgetTester tester,
    ) async {
      await _pumpPalette(tester);

      // Tap dropdown to open menu
      await tester.tap(find.byType(DropdownButtonFormField<WidgetBuilderSelection>));
      await tester.pumpAndSettle();

      // The menu should contain widget names
      expect(find.byType(DropdownMenuItem<WidgetBuilderSelection>),
          findsWidgets);
    });
  });
}