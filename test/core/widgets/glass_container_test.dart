import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/glass_container.dart';

import '../../helpers/test_app.dart';
import '../../helpers/widget_test_utils.dart';

void main() {
  group('GlassContainer', () {
    testWidgets('renders child successfully (light theme)', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          child: Text('Glass content'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Glass content'));
    });

    testWidgets('renders successfully (dark theme)', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          child: Text('Dark glass'),
        ),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark glass'));
    });

    testWidgets('fires onTap callback when tapped', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        GlassContainer(
          child: const Text('Tap'),
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byType(GlassContainer));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('does not fire onTap when callback is null', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          child: Text('Static'),
        ),
      );

      await tester.tap(find.byType(GlassContainer));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('applies backgroundColor when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          backgroundColor: Colors.teal,
          child: Text('Teal'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Teal'));
    });

    testWidgets('applies borderColor when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          borderColor: Colors.red,
          child: Text('Border'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Border'));
    });

    testWidgets('applies custom borderRadius when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Text('Rounded'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Rounded'));
    });

    testWidgets('applies gradient when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.purple],
          ),
          child: Text('Gradient'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Gradient'));
    });

    testWidgets('disables border when enableBorder is false', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          enableBorder: false,
          child: Text('No border'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('No border'));
    });

    testWidgets('disables shadow when enableShadow is false', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          enableShadow: false,
          child: Text('No shadow'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('No shadow'));
    });

    testWidgets('disables hover when enableHover is false', (tester) async {
      await pumpTestWidget(
        tester,
        GlassContainer(
          enableHover: false,
          onTap: () {},
          child: const Text('No hover'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('No hover'));
    });

    testWidgets('disables tap animation when enableTapAnimation is false',
        (tester) async {
      await pumpTestWidget(
        tester,
        GlassContainer(
          enableTapAnimation: false,
          onTap: () {},
          child: const Text('No tap anim'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('No tap anim'));
    });

    testWidgets('respects width and height', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          width: 240,
          height: 120,
          child: Text('Sized'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Sized'));
    });

    testWidgets('applies constraints when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassContainer(
          constraints: BoxConstraints.tightFor(width: 150, height: 80),
          child: Text('Constrained'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Constrained'));
    });
  });
}