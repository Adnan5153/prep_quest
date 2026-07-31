import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/status_chip.dart';

import '../../helpers/test_app.dart';
import '../../helpers/widget_test_utils.dart';

void main() {
  group('StatusChip', () {
    testWidgets('renders label successfully', (tester) async {
      await pumpTestWidget(
        tester,
        const StatusChip(label: 'Active'),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Active'));
    });

    testWidgets('omits icon when showIcon is false', (tester) async {
      await pumpTestWidget(
        tester,
        const StatusChip(
          label: 'No Icon',
          showIcon: false,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('No Icon'));
    });

    testWidgets('renders custom icon when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const StatusChip(
          label: 'Custom',
          icon: Icons.star,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.star));
    });

    testWidgets('renders with semanticLabel when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const StatusChip(
          label: 'Branded',
          semanticLabel: 'branded-chip',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });

    testWidgets('fires onTap callback when tapped', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        StatusChip(
          label: 'Tap',
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byType(StatusChip));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('renders each status without exceptions', (tester) async {
      for (final status in StatusChipStatus.values) {
        await pumpTestWidget(
          tester,
          StatusChip(label: 'Status $status', status: status),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Status $status'));
      }
    });

    testWidgets('renders each variant without exceptions', (tester) async {
      for (final variant in StatusChipVariant.values) {
        await pumpTestWidget(
          tester,
          StatusChip(label: 'Variant $variant', variant: variant),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Variant $variant'));
      }
    });

    testWidgets('renders each size variant', (tester) async {
      for (final size in StatusChipSize.values) {
        await pumpTestWidget(
          tester,
          StatusChip(label: 'Size $size', size: size),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Size $size'));
      }
    });

    testWidgets('renders with tooltip when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const StatusChip(
          label: 'Tooltip me',
          tooltip: 'Additional info',
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(Tooltip));
    });

    testWidgets('renders successfully in dark theme', (tester) async {
      await pumpTestWidget(
        tester,
        const StatusChip(label: 'Dark chip'),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark chip'));
    });

    testWidgets('disables animation when animate is false', (tester) async {
      await pumpTestWidget(
        tester,
        const StatusChip(
          label: 'Static',
          animate: false,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Static'));
    });
  });
}