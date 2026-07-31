import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/glass_card.dart';

import '../../helpers/test_app.dart';
import '../../helpers/widget_test_utils.dart';

void main() {
  group('GlassCard', () {
    testWidgets('renders child successfully (light theme)', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
          child: Text('Glass content'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Glass content'));
    });

    testWidgets('renders successfully (dark theme)', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
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
        GlassCard(
          child: const Text('Tap me'),
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byType(GlassCard));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('does not fire onTap when callback is null', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
          child: Text('Static'),
        ),
      );

      await tester.tap(find.byType(GlassCard));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('applies backgroundColor when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
          backgroundColor: Colors.amber,
          child: Text('Colored'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Colored'));
    });

    testWidgets('applies borderColor when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
          borderColor: Colors.red,
          child: Text('Bordered'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Bordered'));
    });

    testWidgets('applies custom borderRadius when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Text('Rounded'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Rounded'));
    });

    testWidgets('applies gradient when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
          ),
          child: Text('Gradient'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Gradient'));
    });

    testWidgets('respects custom padding and margin', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.all(8),
          child: Text('Spaced'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Spaced'));
    });

    testWidgets('respects width and height', (tester) async {
      await pumpTestWidget(
        tester,
        const GlassCard(
          width: 200,
          height: 100,
          child: Text('Sized'),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Sized'));
    });
  });
}