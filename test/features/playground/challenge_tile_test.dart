import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/playground/presentation/constants/playground_constants.dart';
import 'package:prep_quest/features/playground/presentation/widgets/challenge_tile.dart';

import '../../helpers/test_app.dart';

ChallengeTileVisual _buildVisual({
  String title = 'Reading Practice',
  String subtitle = 'Chapter 1',
  PlaygroundChallengeKind kind = PlaygroundChallengeKind.reading,
  String difficulty = PlaygroundProgressionDifficulty.medium,
  int xpReward = 50,
  int coinReward = 10,
  bool isLocked = false,
  bool isCompleted = false,
  bool isPremium = false,
}) {
  return ChallengeTileVisual(
    title: title,
    subtitle: subtitle,
    kind: kind,
    difficulty: difficulty,
    xpReward: xpReward,
    coinReward: coinReward,
    isLocked: isLocked,
    isCompleted: isCompleted,
    isPremium: isPremium,
  );
}

Future<void> _pumpTile(
  WidgetTester tester,
  ChallengeTile tile, {
  ThemeMode theme = ThemeMode.light,
}) async {
  await pumpTestWidget(
    tester,
    Scaffold(body: Center(child: tile)),
    theme: theme,
  );
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  group('ChallengeTile', () {
    testWidgets('renders successfully and shows title/subtitle', (
      WidgetTester tester,
    ) async {
      await _pumpTile(
        tester,
        ChallengeTile(visual: _buildVisual(), onTap: () {}),
      );

      expect(find.byType(ChallengeTile), findsOneWidget);
      expect(find.text('Reading Practice'), findsOneWidget);
      expect(find.text('Chapter 1'), findsOneWidget);
    });

    testWidgets('has RepaintBoundary wrapper', (WidgetTester tester) async {
      await _pumpTile(
        tester,
        ChallengeTile(visual: _buildVisual(), onTap: () {}),
      );
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('triggers onTap when interactive', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await _pumpTile(
        tester,
        ChallengeTile(visual: _buildVisual(), onTap: () => taps++),
      );

      await tester.tap(find.byType(ChallengeTile));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('does not trigger onTap when locked', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await _pumpTile(
        tester,
        ChallengeTile(
          visual: _buildVisual(isLocked: true),
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byType(ChallengeTile));
      await tester.pump();

      expect(taps, 0);
    });

    testWidgets('does not trigger onTap when completed', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await _pumpTile(
        tester,
        ChallengeTile(
          visual: _buildVisual(isCompleted: true),
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byType(ChallengeTile));
      await tester.pump();

      expect(taps, 0);
    });

    testWidgets('shows lock icon when locked', (WidgetTester tester) async {
      await _pumpTile(
        tester,
        ChallengeTile(
          visual: _buildVisual(isLocked: true),
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.lock_outline), findsWidgets);
    });

    testWidgets('shows check icon when completed', (
      WidgetTester tester,
    ) async {
      await _pumpTile(
        tester,
        ChallengeTile(
          visual: _buildVisual(isCompleted: true),
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.check_circle_outline), findsWidgets);
    });

    testWidgets('renders reward values when not locked', (
      WidgetTester tester,
    ) async {
      await _pumpTile(
        tester,
        ChallengeTile(visual: _buildVisual(xpReward: 75, coinReward: 12), onTap: () {}),
      );

      expect(find.textContaining('75'), findsWidgets);
      expect(find.textContaining('12'), findsWidgets);
    });

    testWidgets('renders under dark theme without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpTile(
        tester,
        ChallengeTile(visual: _buildVisual(), onTap: () {}),
        theme: ThemeMode.dark,
      );

      expect(find.byType(ChallengeTile), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple pumps do not throw', (WidgetTester tester) async {
      await _pumpTile(
        tester,
        ChallengeTile(visual: _buildVisual(), onTap: () {}),
      );

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(tester.takeException(), isNull);
    });
  });
}
