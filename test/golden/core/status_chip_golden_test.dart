import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/status_chip.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [StatusChip] widget.
///
/// Captures every [StatusChipStatus] in the default soft variant for
/// light + dark themes. The soft variant is the canonical surface used
/// throughout the app — the filled, outlined, glass, gradient, and
/// pill variants are exercised separately.
void main() {
  Widget frame(Widget child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(spacing: 8, runSpacing: 8, children: <Widget>[child]),
      );

  // ---------------------------------------------------------------------------
  // Status sweep — every status rendered with the default (soft) variant.
  // ---------------------------------------------------------------------------
  for (final StatusChipStatus status in StatusChipStatus.values) {
    testWidgets('${status.name} · soft · light+dark', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/status_chip_${status.name}_soft',
        builder: (BuildContext context, ThemeMode mode) => frame(
          StatusChip(
            label: _labelFor(status),
            status: status,
          ),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Variant sweep on the "success" status to surface the visual
  // differences between filled / outlined / glass / gradient / pill.
  // ---------------------------------------------------------------------------
  group('StatusChip · variants', () {
    for (final StatusChipVariant variant in StatusChipVariant.values) {
      testWidgets('success · ${variant.name} · light+dark', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(360, 160);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await captureGoldenPair(
          tester,
          'core/status_chip_success_${variant.name}',
          builder: (BuildContext context, ThemeMode mode) => frame(
            StatusChip(
              label: 'Completed',
              status: StatusChipStatus.success,
              variant: variant,
            ),
          ),
        );
      });
    }
  });

  // ---------------------------------------------------------------------------
  // Sizes — small / medium / large
  // ---------------------------------------------------------------------------
  group('StatusChip · sizes', () {
    for (final StatusChipSize size in StatusChipSize.values) {
      testWidgets('success · ${size.name} · light+dark', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(360, 160);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await captureGoldenPair(
          tester,
          'core/status_chip_success_size_${size.name}',
          builder: (BuildContext context, ThemeMode mode) => frame(
            StatusChip(
              label: 'Active',
              status: StatusChipStatus.success,
              size: size,
            ),
          ),
        );
      });
    }
  });
}

String _labelFor(StatusChipStatus status) {
  switch (status) {
    case StatusChipStatus.success:
    case StatusChipStatus.completed:
    case StatusChipStatus.online:
      return 'Success';
    case StatusChipStatus.warning:
    case StatusChipStatus.pending:
      return 'Warning';
    case StatusChipStatus.error:
    case StatusChipStatus.expired:
    case StatusChipStatus.offline:
      return 'Error';
    case StatusChipStatus.info:
    case StatusChipStatus.inProgress:
      return 'Info';
    case StatusChipStatus.premium:
      return 'Premium';
    case StatusChipStatus.locked:
      return 'Locked';
    case StatusChipStatus.newStatus:
      return 'New';
    case StatusChipStatus.live:
      return 'Live';
  }
}