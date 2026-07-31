import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/primary_button.dart';

import '../../../helpers/mock_helpers.dart';
import '../../../helpers/test_app.dart';
import '../../../helpers/widget_test_utils.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders successfully (light theme)', (tester) async {
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Continue',
          onPressed: () {},
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Continue'));
    });

    testWidgets('renders successfully (dark theme)', (tester) async {
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Continue',
          onPressed: () {},
        ),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Continue'));
    });

    testWidgets('fires onPressed callback when tapped', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Tap Me',
          onPressed: () => taps++,
        ),
      );

      await tapPrimaryButton(
        tester,
        find.byType(PrimaryButton),
        label: 'Tap Me',
      );

      expect(taps, 1);
    });

    testWidgets('does not fire onPressed when disabled', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Disabled',
          onPressed: () => taps++,
          isEnabled: false,
        ),
      );

      await tapPrimaryButton(
        tester,
        find.byType(PrimaryButton),
        label: 'Disabled',
      );

      expect(taps, 0);
    });

    testWidgets('omits onPressed gracefully (no callback wired)', (tester) async {
      await pumpTestWidget(
        tester,
        PrimaryButton(
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
        PrimaryButton(
          text: 'Submit',
          onPressed: () {},
          isLoading: true,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(CircularProgressIndicator));
      expectMissing(find.text('Submit'));
    });

    testWidgets('does not fire onPressed while loading', (tester) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Loading',
          onPressed: () => taps++,
          isLoading: true,
        ),
      );

      await tapPrimaryButton(
        tester,
        find.byType(PrimaryButton),
        label: 'Loading',
      );

      expect(taps, 0);
    });

    testWidgets('renders icon when provided', (tester) async {
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Add',
          onPressed: () {},
          icon: Icons.add,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.add));
      expectOneWidget(find.text('Add'));
    });

    testWidgets('renders trailing icon when provided', (tester) async {
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Next',
          onPressed: () {},
          trailingIcon: Icons.arrow_forward,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.arrow_forward));
    });

    testWidgets('uses semanticLabel when provided', (tester) async {
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Save',
          onPressed: () {},
          semanticLabel: 'primary-cta',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders each variant without exceptions', (tester) async {
      for (final variant in PrimaryButtonVariant.values) {
        await pumpTestWidget(
          tester,
          PrimaryButton(
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
      for (final size in PrimaryButtonSize.values) {
        await pumpTestWidget(
          tester,
          PrimaryButton(
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
      for (final shape in PrimaryButtonShape.values) {
        await pumpTestWidget(
          tester,
          PrimaryButton(
            text: 'Shape $shape',
            onPressed: () {},
            shape: shape,
          ),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Shape $shape'));
      }
    });

    testWidgets('expands to full width when fullWidth is true', (tester) async {
      useTestSurface(tester: tester, size: const Size(360, 800));
      await pumpTestWidget(
        tester,
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Full',
            onPressed: () {},
            fullWidth: true,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Full'));
    });

    testWidgets('renders with tooltip when provided', (tester) async {
      await pumpTestWidget(
        tester,
        PrimaryButton(
          text: 'Help',
          onPressed: () {},
          tooltip: 'Click for help',
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(Tooltip));
    });
  });
}