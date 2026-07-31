import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/features/playground/presentation/widgets/boss_gate.dart';

import '../../helpers/test_app.dart';

BossGateVisual _buildVisual({
  String title = 'Dragon Boss',
  String? subtitle = 'The final test',
  int requiredLevel = 10,
  BossGateRarity rarity = BossGateRarity.legendary,
  bool isShaking = false,
  bool animate = true,
}) {
  return BossGateVisual(
    title: title,
    subtitle: subtitle,
    requiredLevel: requiredLevel,
    rarity: rarity,
    isShaking: isShaking,
    animate: animate,
  );
}

Future<void> _pumpGate(
  WidgetTester tester,
  BossGate gate, {
  ThemeMode theme = ThemeMode.light,
}) async {
  await pumpTestWidget(
    tester,
    Scaffold(body: Center(child: gate)),
    theme: theme,
  );
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  group('BossGate', () {
    testWidgets('renders successfully with title and required level', (
      WidgetTester tester,
    ) async {
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.locked,
          onTap: () {},
        ),
      );

      expect(find.byType(BossGate), findsOneWidget);
      expect(find.text('Dragon Boss'), findsOneWidget);
      expect(find.textContaining('10'), findsWidgets);
    });

    testWidgets('wraps in RepaintBoundary', (WidgetTester tester) async {
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.locked,
          onTap: () {},
        ),
      );

      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('renders without exceptions (CustomPainter)', (
      WidgetTester tester,
    ) async {
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.locked,
          onTap: () {},
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple pumps do not throw for the painter', (
      WidgetTester tester,
    ) async {
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.locked,
          onTap: () {},
        ),
      );

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('triggers onTap callback', (WidgetTester tester) async {
      var taps = 0;
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.open,
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byType(BossGate));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('triggers onUnlocked when state transitions to unlocking', (
      WidgetTester tester,
    ) async {
      var unlocks = 0;
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.unlocking,
          onUnlocked: () => unlocks++,
        ),
      );

      await tester.pump();

      expect(unlocks, 1);
    });

    testWidgets('shows lock icon when locked', (WidgetTester tester) async {
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.locked,
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.lock), findsWidgets);
    });

    testWidgets('shows lock_open icon when unlocking', (
      WidgetTester tester,
    ) async {
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.unlocking,
        ),
      );

      expect(find.byIcon(Icons.lock_open), findsWidgets);
    });

    testWidgets('renders under dark theme without exceptions', (
      WidgetTester tester,
    ) async {
      await _pumpGate(
        tester,
        BossGate(
          visual: _buildVisual(),
          state: BossGateState.locked,
          onTap: () {},
        ),
        theme: ThemeMode.dark,
      );

      expect(find.byType(BossGate), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders all rarity variants', (WidgetTester tester) async {
      for (final rarity in BossGateRarity.values) {
        await _pumpGate(
          tester,
          BossGate(
            visual: _buildVisual(rarity: rarity),
            state: BossGateState.open,
          ),
        );
        expect(find.byType(BossGate), findsOneWidget);
      }
    });
  });
}