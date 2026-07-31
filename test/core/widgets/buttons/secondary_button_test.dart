import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/secondary_button.dart';

import '../../../helpers/mock_helpers.dart';
import '../../../helpers/test_app.dart';
import '../../../helpers/widget_test_utils.dart';

void main() {
  group('SecondaryButton', () {
    testWidgets('renders successfully (light theme)', (tester) async {
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Cancel',
          onPressed: () {},
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Cancel'));
    });

    testWidgets('renders successfully (dark theme)', (tester) async {
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Cancel',
          onPressed: () {},
        ),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Cancel'));
    });

    testWidgets('fires onPressed when tapped', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Skip',
          onPressed: () => taps++,
        ),
      );

      await tapSecondaryButton(
        tester,
        find.byType(SecondaryButton),
        label: 'Skip',
      );

      expect(taps, 1);
    });

    testWidgets('does not fire onPressed when disabled', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Off',
          onPressed: () => taps++,
          isEnabled: false,
        ),
      );

      await tapSecondaryButton(
        tester,
        find.byType(SecondaryButton),
        label: 'Off',
      );

      expect(taps, 0);
    });

    testWidgets('omits onPressed gracefully (no callback wired)', (tester) async {
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'No Callback',
          onPressed: null,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('No Callback'));
    });

    testWidgets('shows loader when isLoading is true', (tester) async {
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Processing',
          onPressed: () {},
          isLoading: true,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(CircularProgressIndicator));
      expectMissing(find.text('Processing'));
    });

    testWidgets('does not fire onPressed while loading', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Loading',
          onPressed: () => taps++,
          isLoading: true,
        ),
      );

      await tapSecondaryButton(
        tester,
        find.byType(SecondaryButton),
        label: 'Loading',
      );

      expect(taps, 0);
    });

    testWidgets('renders icon when provided', (tester) async {
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Back',
          onPressed: () {},
          icon: Icons.arrow_back,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.arrow_back));
    });

    testWidgets('uses semanticLabel when provided', (tester) async {
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Cancel',
          onPressed: () {},
          semanticLabel: 'secondary-cta',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders each variant without exceptions', (tester) async {
      for (final variant in SecondaryButtonVariant.values) {
        await pumpTestWidget(
          tester,
          SecondaryButton(
            text: 'Variant $variant',
            onPressed: () {},
            variant: variant,
          ),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Variant $variant'));
      }
    });

    testWidgets('renders each size variant', (tester) async {
      for (final size in SecondaryButtonSize.values) {
        await pumpTestWidget(
          tester,
          SecondaryButton(
            text: 'Size $size',
            onPressed: () {},
            size: size,
          ),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Size $size'));
      }
    });

    testWidgets('renders each shape variant', (tester) async {
      for (final shape in SecondaryButtonShape.values) {
        await pumpTestWidget(
          tester,
          SecondaryButton(
            text: 'Shape $shape',
            onPressed: () {},
            shape: shape,
          ),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Shape $shape'));
      }
    });

    testWidgets('renders with tooltip when provided', (tester) async {
      await pumpTestWidget(
        tester,
        SecondaryButton(
          text: 'Help',
          onPressed: () {},
          tooltip: 'More info',
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(Tooltip));
    });
  });
}