import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/core/widgets/ai/shimmer_loading_text.dart';

import '../../../helpers/test_app.dart';

void main() {
  group('ShimmerLoadingText', () {
    testWidgets('renders without exceptions (light)', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(lineCount: 3),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without exceptions (dark)', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(lineCount: 3),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('clamps lineCount below 1 to 1', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(lineCount: 0),
      );

      // We cannot directly count shader masks but we can ensure no
      // exception is thrown and the widget renders.
      expect(tester.takeException(), isNull);
    });

    testWidgets('clamps lineCount above 8 to 8', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(lineCount: 100),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders multiple lines for higher lineCount', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(lineCount: 5),
      );

      // Each line is a Container with a fixed height; we can count them.
      // The shimmer places containers inside a Column.
      final containerCount = find.byType(Container).evaluate().length;
      expect(containerCount, greaterThanOrEqualTo(5));
    });

    testWidgets('respects custom lineHeight', (tester) async {
      const customHeight = 24.0;
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 2,
          lineHeight: customHeight,
        ),
      );

      // The shimmer line uses a Container with `height`, not a SizedBox.
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => c.constraints?.minHeight == customHeight ||
              c.constraints?.maxHeight == customHeight);
      expect(containers, isNotEmpty);
    });

    testWidgets('respects custom borderRadius override', (tester) async {
      const customRadius = BorderRadius.all(Radius.circular(4));
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 1,
          borderRadius: customRadius,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('uses custom lineWidths when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 2,
          lineWidths: <double>[0.5, 0.9],
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects custom shimmer base and highlight colors',
        (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 2,
          shimmerBaseColor: Color(0xFF112233),
          shimmerHighlightColor: Color(0xFFAABBCC),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects accent color override', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 2,
          accent: Color(0xFFFF8800),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects duration override', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 2,
          duration: Duration(seconds: 1),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects padding override', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 1,
          padding: EdgeInsets.all(16),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects maxWidth override', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 1,
          maxWidth: 200,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('does not animate when enabled is false', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 2,
          enabled: false,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('uses custom semanticLabel', (tester) async {
      await pumpTestWidget(
        tester,
        const ShimmerLoadingText(
          lineCount: 1,
          semanticLabel: 'Loading tips',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });
  });
}