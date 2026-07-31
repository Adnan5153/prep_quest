import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/glass_container.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [GlassContainer] widget.
///
/// Captures the foundational glass surface in light + dark themes
/// along with the tappable variant and a fully-bordered override.
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
              'XP this week',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              'You earned 320 XP across 5 sessions.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );

  Widget frame(Widget child) => Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      );

  group('GlassContainer · static', () {
    testWidgets('default · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 240);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/glass_container_default',
        builder: (BuildContext context, ThemeMode mode) => frame(
          GlassContainer(
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
        'core/glass_container_tappable',
        builder: (BuildContext context, ThemeMode mode) => frame(
          GlassContainer(
            width: 280,
            height: 120,
            onTap: () {},
            child: buildBody(),
          ),
        ),
      );
    });

    testWidgets('borders disabled · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 240);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/glass_container_no_border',
        builder: (BuildContext context, ThemeMode mode) => frame(
          GlassContainer(
            width: 280,
            height: 120,
            enableBorder: false,
            child: buildBody(),
          ),
        ),
      );
    });
  });
}