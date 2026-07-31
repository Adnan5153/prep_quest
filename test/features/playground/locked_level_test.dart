import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/playground/presentation/widgets/locked_level.dart';

import '../../helpers/test_app.dart';

LockedLevelVisual _buildVisual({
  int levelNumber = 7,
  String title = 'Locked Level',
  String? subtitle = 'Beat earlier levels first',
  List<LockedLevelRequirementSpec> requirements = const <LockedLevelRequirementSpec>[],
  bool animate = true,
}) {
  return LockedLevelVisual(
    levelNumber: levelNumber,
    title: title,
    subtitle: subtitle,
    requirements: requirements,
    animate: animate,
  );
}

Future<void> _pumpLocked(
  WidgetTester tester,
  LockedLevel widget, {
  ThemeMode theme = ThemeMode.light,
}) async {
  await pumpTestWidget(
    tester,
    Scaffold(body: Center(child: widget)),
    theme: theme,
  );
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  group('LockedLevel', () {
    testWidgets('renders successfully with title', (WidgetTester tester) async {
      await _pumpLocked(
        tester,
        LockedLevel(visual: _buildVisual(), onTap: () {}),
      );

      expect(find.byType(LockedLevel), findsOneWidget);
      expect(find.textContaining('Locked Level'), findsOneWidget);
    });

    testWidgets('wraps in RepaintBoundary', (WidgetTester tester) async {
      await _pumpLocked(
        tester,
        LockedLevel(visual: _buildVisual(), onTap: () {}),
      );
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('triggers onTap callback', (WidgetTester tester) async {
      var taps = 0;
      await _pumpLocked(
        tester,
        LockedLevel(visual: _buildVisual(), onTap: () => taps++),
      );

      await tester.tap(find.byType(LockedLevel));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('shows lock icon', (WidgetTester tester) async {
      await _pumpLocked(
        tester,
        LockedLevel(visual: _buildVisual(), onTap: () {}),
      );
      expect(find.byIcon(Icons.lock), findsWidgets);
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
    });

    testWidgets('renders subtitle when provided', (
      WidgetTester tester,
    ) async {
      await _pumpLocked(
        tester,
        LockedLevel(
          visual: _buildVisual(subtitle: 'Subtitle text'),
          onTap: () {},
        ),
      );

      expect(find.text('Subtitle text'), findsOneWidget);
    });

    testWidgets('hides subtitle when null', (WidgetTester tester) async {
      await _pumpLocked(
        tester,
        LockedLevel(
          visual: _buildVisual(subtitle: null),
          onTap: () {},
        ),
      );

      expect(find.text('Subtitle text'), findsNothing);
    });

    testWidgets('renders requirements when provided', (
      WidgetTester tester,
    ) async {
      await _pumpLocked(
        tester,
        LockedLevel(
          visual: _buildVisual(
            requirements: const <LockedLevelRequirementSpec>[
              LockedLevelRequirementSpec(
                kind: LockedLevelRequirement.level,
                label: 'Reach level 5',
              ),
              LockedLevelRequirementSpec(
                kind: LockedLevelRequirement.missions,
                label: 'Complete 3 missions',
              ),
            ],
          ),
          onTap: () {},
        ),
      );

      expect(find.text('Reach level 5'), findsOneWidget);
      expect(find.text('Complete 3 missions'), findsOneWidget);
    });

    testWidgets('renders under dark theme without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpLocked(
        tester,
        LockedLevel(visual: _buildVisual(), onTap: () {}),
        theme: ThemeMode.dark,
      );

      expect(find.byType(LockedLevel), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple pumps do not throw', (WidgetTester tester) async {
      await _pumpLocked(
        tester,
        LockedLevel(visual: _buildVisual(), onTap: () {}),
      );

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders level number in title', (WidgetTester tester) async {
      await _pumpLocked(
        tester,
        LockedLevel(
          visual: _buildVisual(levelNumber: 42, title: 'Boss Battle'),
          onTap: () {},
        ),
      );

      expect(find.textContaining('Level 42'), findsOneWidget);
    });
  });
}