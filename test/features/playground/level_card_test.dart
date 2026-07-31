import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/playground/presentation/constants/playground_constants.dart';
import 'package:prep_quest/features/playground/presentation/widgets/level_card.dart';

import '../../helpers/test_app.dart';

LevelCardVisual _buildVisual({
  String title = 'Algebra Basics',
  String subtitle = 'Foundations',
  LevelCardState state = LevelCardState.unlocked,
  double progress = 0.5,
  int duration = 5,
  LevelCardVariant variant = LevelCardVariant.standard,
  List<String> tags = const <String>['Math', 'Starter'],
}) {
  return LevelCardVisual(
    title: title,
    subtitle: subtitle,
    difficulty: PlaygroundProgressionDifficulty.medium,
    state: state,
    reward: const LevelCardReward(xp: 100, coins: 25),
    progress: progress,
    duration: duration,
    variant: variant,
    tags: tags,
  );
}

Future<void> _pumpCard(
  WidgetTester tester,
  LevelCard card, {
  ThemeMode theme = ThemeMode.light,
}) async {
  await pumpTestWidget(
    tester,
    Scaffold(body: Center(child: card)),
    theme: theme,
  );
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  group('LevelCard', () {
    testWidgets('renders successfully and shows title/subtitle', (
      WidgetTester tester,
    ) async {
      await _pumpCard(
        tester,
        LevelCard(visual: _buildVisual(), onTap: () {}),
      );

      expect(find.byType(LevelCard), findsOneWidget);
      expect(find.text('Algebra Basics'), findsOneWidget);
      expect(find.text('Foundations'), findsOneWidget);
    });

    testWidgets('wraps in a RepaintBoundary for isolated repaints', (
      WidgetTester tester,
    ) async {
      await _pumpCard(
        tester,
        LevelCard(visual: _buildVisual(), onTap: () {}),
      );

      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('triggers onTap when in interactive state', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await _pumpCard(
        tester,
        LevelCard(visual: _buildVisual(), onTap: () => taps++),
      );

      await tester.tap(find.byType(LevelCard));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('does not trigger onTap when locked', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await _pumpCard(
        tester,
        LevelCard(
          visual: _buildVisual(state: LevelCardState.locked),
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byType(LevelCard));
      await tester.pump();

      expect(taps, 0);
    });

    testWidgets('renders reward pills for xp and coins', (
      WidgetTester tester,
    ) async {
      await _pumpCard(
        tester,
        LevelCard(visual: _buildVisual(), onTap: () {}),
      );

      expect(find.textContaining('100'), findsWidgets);
      expect(find.textContaining('25'), findsWidgets);
    });

    testWidgets('renders all provided tags', (WidgetTester tester) async {
      await _pumpCard(
        tester,
        LevelCard(
          visual: _buildVisual(tags: const <String>['TagA', 'TagB']),
          onTap: () {},
        ),
      );

      expect(find.text('TagA'), findsOneWidget);
      expect(find.text('TagB'), findsOneWidget);
    });

    testWidgets('renders under dark theme without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpCard(
        tester,
        LevelCard(visual: _buildVisual(), onTap: () {}),
        theme: ThemeMode.dark,
      );

      expect(find.byType(LevelCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple pumps do not throw', (WidgetTester tester) async {
      await _pumpCard(
        tester,
        LevelCard(visual: _buildVisual(), onTap: () {}),
      );

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('completed variant shows completed badge', (
      WidgetTester tester,
    ) async {
      await _pumpCard(
        tester,
        LevelCard(
          visual: _buildVisual(state: LevelCardState.completed, progress: 1.0),
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}
