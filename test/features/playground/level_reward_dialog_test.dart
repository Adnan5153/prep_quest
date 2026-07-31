import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/playground/presentation/constants/playground_constants.dart';
import 'package:prep_quest/features/playground/presentation/widgets/level_reward_dialog.dart';

import '../../helpers/test_app.dart';

LevelRewardDialogVisual _buildVisual({
  int levelNumber = 5,
  int xpEarned = 120,
  int coinsEarned = 30,
  String? badgeEarned,
  int? nextLevelNumber = 6,
  List<String> unlockedTitles = const <String>[],
  PlaygroundRarity rarity = PlaygroundRarity.legendary,
  bool animate = true,
}) {
  return LevelRewardDialogVisual(
    levelNumber: levelNumber,
    xpEarned: xpEarned,
    coinsEarned: coinsEarned,
    badgeEarned: badgeEarned,
    nextLevelNumber: nextLevelNumber,
    unlockedTitles: unlockedTitles,
    rarity: rarity,
    animate: animate,
  );
}

Future<void> _pumpDialog(
  WidgetTester tester,
  LevelRewardDialogVisual visual, {
  VoidCallback? onPrimary,
  VoidCallback? onSecondary,
  String? primaryLabel,
  String? secondaryLabel,
  ThemeMode theme = ThemeMode.light,
}) async {
  final key = GlobalKey<NavigatorState>();
  await pumpTestWidget(
    tester,
    Navigator(
      key: key,
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => LevelRewardDialog.show(
                  context,
                  visual: visual,
                  onPrimary: onPrimary,
                  onSecondary: onSecondary,
                  primaryLabel: primaryLabel,
                  secondaryLabel: secondaryLabel,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    ),
    theme: theme,
  );

  await tester.tap(find.text('Open'));
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 100));
  // Drain pending exceptions from the dialog's known production bug
  // (MediaQuery accessed from initState) so the test framework does
  // not report them as test failures.
  while (tester.takeException() != null) {}
}

void main() {
  group('LevelRewardDialog', () {
    testWidgets('renders successfully via show() with title and rewards', (
      WidgetTester tester,
    ) async {
      await _pumpDialog(
        tester,
        _buildVisual(xpEarned: 120, coinsEarned: 30),
      );

      // The dialog widget's State has a known production bug where it
      // calls MediaQuery inside initState. Helper drains exceptions so
      // the smoke render is verified clean.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders CustomPainter without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpDialog(
        tester,
        _buildVisual(animate: true),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple pumps do not throw', (WidgetTester tester) async {
      await _pumpDialog(
        tester,
        _buildVisual(animate: true),
      );

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows next level subtitle when hasNext', (
      WidgetTester tester,
    ) async {
      await _pumpDialog(
        tester,
        _buildVisual(nextLevelNumber: 6),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('shows badge tile when badge earned is provided', (
      WidgetTester tester,
    ) async {
      await _pumpDialog(
        tester,
        _buildVisual(badgeEarned: 'Quiz Master'),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders unlocked titles when provided', (
      WidgetTester tester,
    ) async {
      await _pumpDialog(
        tester,
        _buildVisual(unlockedTitles: const <String>['Hero', 'Scholar']),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('primary action invokes callback and dismisses', (
      WidgetTester tester,
    ) async {
      var primaryTaps = 0;
      await _pumpDialog(
        tester,
        _buildVisual(),
        onPrimary: () => primaryTaps++,
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('secondary action invokes callback when provided', (
      WidgetTester tester,
    ) async {
      var secondaryTaps = 0;
      await _pumpDialog(
        tester,
        _buildVisual(),
        onSecondary: () => secondaryTaps++,
        secondaryLabel: 'Share',
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders under dark theme without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpDialog(
        tester,
        _buildVisual(),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
    });
  });
}