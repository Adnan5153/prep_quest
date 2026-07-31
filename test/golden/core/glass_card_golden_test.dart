import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/glass_card.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [GlassCard] widget.
///
/// Captures the canonical glass surface in light + dark themes along
/// with the interactive (tappable) variant. The body text is identical
/// across captures so any visual drift is purely from the surface
/// treatment, not the content.
void main() {
  // Body rendered inside every glass surface. Kept constant so each
  // capture is a true apples-to-apples comparison.
  Widget buildBody() => const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Daily goal',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              'You have completed 12 of 20 practice questions today.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );

  Widget frame(Widget child) => Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      );

  group('GlassCard · static', () {
    testWidgets('default · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 240);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/glass_card_default',
        builder: (BuildContext context, ThemeMode mode) => frame(
          GlassCard(
            width: 280,
            height: 120,
            child: buildBody(),
          ),
        ),
      );
    });

    testWidgets('with onTap · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 240);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/glass_card_tappable',
        builder: (BuildContext context, ThemeMode mode) => frame(
          GlassCard(
            width: 280,
            height: 120,
            onTap: () {},
            child: buildBody(),
          ),
        ),
      );
    });

    testWidgets('with custom gradient · light+dark', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 240);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/glass_card_gradient',
        builder: (BuildContext context, ThemeMode mode) => frame(
          GlassCard(
            width: 280,
            height: 120,
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: buildBody(),
          ),
        ),
      );
    });
  });
}