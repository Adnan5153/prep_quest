import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/playground/presentation/widgets/path/path_segment.dart'
    show PlaygroundPathVariant;
import 'package:prep_quest/features/playground/presentation/widgets/progress_path.dart';

import '../../helpers/test_app.dart';

ProgressPathVisual _buildVisual({
  double progress = 0.4,
  int currentLevel = 3,
  int totalLevels = 5,
  String? upcomingMilestone,
  PlaygroundPathVariant variant = PlaygroundPathVariant.straight,
  bool showLabels = true,
  bool animate = true,
}) {
  return ProgressPathVisual(
    progress: progress,
    currentLevel: currentLevel,
    totalLevels: totalLevels,
    upcomingMilestone: upcomingMilestone,
    variant: variant,
    showLabels: showLabels,
    animate: animate,
  );
}

Future<void> _pumpPath(
  WidgetTester tester,
  ProgressPath widget, {
  ThemeMode theme = ThemeMode.light,
}) async {
  await pumpTestWidget(
    tester,
    Scaffold(
      body: Center(
        child: SizedBox(width: 320, height: 200, child: widget),
      ),
    ),
    theme: theme,
  );
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  group('ProgressPath', () {
    testWidgets('renders successfully', (WidgetTester tester) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(), onTap: () {}),
      );

      expect(find.byType(ProgressPath), findsOneWidget);
    });

    testWidgets('wraps in RepaintBoundary', (WidgetTester tester) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(), onTap: () {}),
      );
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('triggers onTap callback', (WidgetTester tester) async {
      var taps = 0;
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(), onTap: () => taps++),
      );

      await tester.tap(find.byType(ProgressPath));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('shows current level and total levels when labels shown', (
      WidgetTester tester,
    ) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(currentLevel: 3, totalLevels: 7)),
      );

      expect(find.textContaining('3 / 7'), findsOneWidget);
    });

    testWidgets('shows completion percent', (WidgetTester tester) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(progress: 0.42)),
      );

      expect(find.textContaining('42%'), findsOneWidget);
    });

    testWidgets('shows upcoming milestone text when provided', (
      WidgetTester tester,
    ) async {
      await _pumpPath(
        tester,
        ProgressPath(
          visual: _buildVisual(upcomingMilestone: 'Final Boss'),
        ),
      );

      expect(find.textContaining('Final Boss'), findsOneWidget);
    });

    testWidgets('hides labels when showLabels is false', (
      WidgetTester tester,
    ) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(showLabels: false)),
      );

      expect(find.textContaining(' / '), findsNothing);
    });

    testWidgets('renders CustomPaint via PathSegment without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(), onTap: () {}),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('multiple pumps do not throw', (WidgetTester tester) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(), onTap: () {}),
      );

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders under dark theme without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(), onTap: () {}),
        theme: ThemeMode.dark,
      );

      expect(find.byType(ProgressPath), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles single total level (degenerate case)', (
      WidgetTester tester,
    ) async {
      await _pumpPath(
        tester,
        ProgressPath(visual: _buildVisual(totalLevels: 1, progress: 1.0)),
      );

      expect(find.byType(ProgressPath), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('supports vertical axis', (WidgetTester tester) async {
      await _pumpPath(
        tester,
        ProgressPath(
          visual: _buildVisual(),
          axis: ProgressPathAxis.vertical,
        ),
      );

      expect(find.byType(ProgressPath), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}