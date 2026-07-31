import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/tag_chip.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [TagChip] widget.
///
/// Captures every [TagChipVariant] in light + dark themes along with
/// the selected, disabled, and closable variants.
void main() {
  Widget frame(Widget child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(spacing: 8, runSpacing: 8, children: <Widget>[child]),
      );

  // ---------------------------------------------------------------------------
  // Variant sweep — exercises the canonical tag surface in production.
  // ---------------------------------------------------------------------------
  for (final TagChipVariant variant in TagChipVariant.values) {
    testWidgets('${variant.name} · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/tag_chip_${variant.name}',
        builder: (BuildContext context, ThemeMode mode) => frame(
          TagChip(
            label: 'Cardiology',
            variant: variant,
          ),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Selected, disabled, and closable variants
  // ---------------------------------------------------------------------------
  group('TagChip · states', () {
    testWidgets('selected · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/tag_chip_selected',
        builder: (BuildContext context, ThemeMode mode) => frame(
          TagChip(
            label: 'Cardiology',
            selected: true,
            onSelected: (_) {},
          ),
        ),
      );
    });

    testWidgets('disabled · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/tag_chip_disabled',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const TagChip(
            label: 'Cardiology',
            enabled: false,
          ),
        ),
      );
    });

    testWidgets('closable · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/tag_chip_closable',
        builder: (BuildContext context, ThemeMode mode) => frame(
          TagChip(
            label: 'Cardiology',
            closable: true,
            onDeleted: () {},
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Sizes — small / medium / large
  // ---------------------------------------------------------------------------
  group('TagChip · sizes', () {
    for (final TagChipSize size in TagChipSize.values) {
      testWidgets('${size.name} · light+dark', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(360, 160);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await captureGoldenPair(
          tester,
          'core/tag_chip_size_${size.name}',
          builder: (BuildContext context, ThemeMode mode) => frame(
            TagChip(
              label: 'Cardiology',
              size: size,
            ),
          ),
        );
      });
    }
  });
}