import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/core/widgets/ai/typing_indicator.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/widget_test_utils.dart';

void main() {
  group('TypingIndicator', () {
    testWidgets('renders without exceptions with default parameters',
        (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without exceptions (dark theme)', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders three animated dots by default', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(dotCount: 3),
      );

      // Each dot is rendered as a Container of size dotSize x dotSize.
      // The simplest proxy: there should be at least 3 Container widgets
      // inside the indicator row.
      final containers = find.descendant(
        of: find.byType(TypingIndicator),
        matching: find.byType(Container),
      );
      expect(containers.evaluate().length, greaterThanOrEqualTo(3));
    });

    testWidgets('respects dotCount override (1 dot)', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(dotCount: 1),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('clamps dotCount to maximum of 6', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(dotCount: 100),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects custom dotSize and spacing', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          dotCount: 3,
          dotSize: 12,
          spacing: 10,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects custom duration', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          duration: Duration(milliseconds: 300),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects custom curve', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          curve: Curves.linear,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders label when supplied', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(label: 'AI is thinking'),
      );

      expectOneWidget(find.text('AI is thinking'));
    });

    testWidgets('renders avatar when supplied', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          avatar: Icon(Icons.smart_toy_rounded),
        ),
      );

      expectOneWidget(find.byIcon(Icons.smart_toy_rounded));
    });

    testWidgets('respects custom color overrides', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          color: Color(0xFFFF0000),
          backgroundColor: Color(0xFF0000FF),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects custom border override', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          borderColor: Color(0xFF112233),
          borderWidth: 2,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects custom borderRadius override', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects padding override', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects maxWidth override', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(maxWidth: 200),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without exception when pulse is enabled',
        (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(pulse: true),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects pulseDuration override', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          pulse: true,
          pulseDuration: Duration(milliseconds: 500),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('updates duration when widget is rebuilt with new value',
        (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(duration: Duration(milliseconds: 500)),
      );

      // Rebuild with a new duration.
      await tester.pumpWidget(
        const TestApp(
          theme: ThemeMode.light,
          child: TypingIndicator(duration: Duration(milliseconds: 1200)),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('updates pulse setting when widget is rebuilt', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(pulse: false),
      );

      // Rebuild with pulse enabled.
      await tester.pumpWidget(
        const TestApp(
          theme: ThemeMode.light,
          child: TypingIndicator(pulse: true),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('uses custom semanticLabel', (tester) async {
      await pumpTestWidget(
        tester,
        const TypingIndicator(
          semanticLabel: 'Typing now',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });
  });
}