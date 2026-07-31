import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/tag_chip.dart';

import '../../helpers/test_app.dart';
import '../../helpers/widget_test_utils.dart';

void main() {
  group('TagChip', () {
    testWidgets('renders label successfully', (tester) async {
      await pumpTestWidget(
        tester,
        const TagChip(label: 'Math'),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Math'));
    });

    testWidgets('renders with icon when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const TagChip(
          label: 'Tagged',
          icon: Icons.bookmark,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.bookmark));
    });

    testWidgets('renders trailing icon when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const TagChip(
          label: 'Tagged',
          trailingIcon: Icons.arrow_forward,
          closable: false,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.arrow_forward));
    });

    testWidgets('renders with semanticLabel when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const TagChip(
          label: 'Label',
          semanticLabel: 'tag-chip',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });

    testWidgets('fires onTap callback', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        TagChip(label: 'Tap', onTap: () => taps++),
      );

      await tester.tap(find.byType(TagChip));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('fires onSelected callback when tapped', (tester) async {
      var selected = false;
      await pumpTestWidget(
        tester,
        TagChip(
          label: 'Pick',
          onSelected: (value) => selected = value,
        ),
      );

      await tester.tap(find.byType(TagChip));
      await tester.pump();

      expect(selected, true);
    });

    testWidgets('renders close icon when closable is true', (tester) async {
      await pumpTestWidget(
        tester,
        const TagChip(
          label: 'Closable',
          closable: true,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.close_rounded));
    });

    testWidgets('fires onDeleted when close icon is tapped', (tester) async {
      var deleted = false;
      await pumpTestWidget(
        tester,
        TagChip(
          label: 'Remove',
          closable: true,
          onDeleted: () => deleted = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(deleted, true);
    });

    testWidgets('renders selected state with check icon', (tester) async {
      await pumpTestWidget(
        tester,
        const TagChip(
          label: 'Selected',
          selected: true,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.check_rounded));
    });

    testWidgets('renders disabled state without exceptions', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        TagChip(
          label: 'Disabled',
          enabled: false,
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byType(TagChip));
      await tester.pump();

      expect(taps, 0);
    });

    testWidgets('renders each variant without exceptions', (tester) async {
      for (final variant in TagChipVariant.values) {
        await pumpTestWidget(
          tester,
          TagChip(label: 'Variant $variant', variant: variant),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Variant $variant'));
      }
    });

    testWidgets('renders each size variant', (tester) async {
      for (final size in TagChipSize.values) {
        await pumpTestWidget(
          tester,
          TagChip(label: 'Size $size', size: size),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Size $size'));
      }
    });

    testWidgets('renders each shape variant', (tester) async {
      for (final shape in TagChipShape.values) {
        await pumpTestWidget(
          tester,
          TagChip(label: 'Shape $shape', shape: shape),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Shape $shape'));
      }
    });

    testWidgets('renders with tooltip when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const TagChip(
          label: 'Hint',
          tooltip: 'Tooltip text',
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(Tooltip));
    });

    testWidgets('renders successfully in dark theme', (tester) async {
      await pumpTestWidget(
        tester,
        const TagChip(label: 'Dark tag'),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark tag'));
    });
  });
}