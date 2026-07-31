import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/loading_widget.dart';

import '../../helpers/test_app.dart';
import '../../helpers/widget_test_utils.dart';

void main() {
  group('LoadingWidget', () {
    testWidgets('renders with default circular loader', (tester) async {
      await pumpTestWidget(
        tester,
        const LoadingWidget(
          loaderType: LoaderType.circular,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(CircularProgressIndicator));
    });

    testWidgets('renders with linear loader', (tester) async {
      await pumpTestWidget(
        tester,
        const LoadingWidget(
          loaderType: LoaderType.linear,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(LinearProgressIndicator));
    });

    testWidgets('renders custom loader widget when provided', (tester) async {
      const key = ValueKey('custom-loader');
      await pumpTestWidget(
        tester,
        const LoadingWidget(
          loaderType: LoaderType.custom,
          loaderWidget: SizedBox(
            key: key,
            width: 50,
            height: 50,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byKey(key));
    });

    testWidgets('renders title and subtitle when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const LoadingWidget(
          loaderType: LoaderType.circular,
          title: 'Loading title',
          subtitle: 'Loading subtitle',
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Loading title'));
      expectOneWidget(find.text('Loading subtitle'));
    });

    testWidgets('omits title and subtitle when not provided', (tester) async {
      await pumpTestWidget(
        tester,
        const LoadingWidget(loaderType: LoaderType.circular),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders with progress percentage when enabled',
        (tester) async {
      await pumpTestWidget(
        tester,
        const LoadingWidget(
          loaderType: LoaderType.circular,
          showProgress: true,
          progress: 0.42,
          showPercentage: true,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('42%'));
    });

    testWidgets('hides percentage when showPercentage is false',
        (tester) async {
      await pumpTestWidget(
        tester,
        const LoadingWidget(
          loaderType: LoaderType.linear,
          showProgress: true,
          progress: 0.5,
          showPercentage: false,
        ),
      );

      expect(tester.takeException(), isNull);
      expectMissing(find.text('50%'));
    });

    testWidgets('respects custom width and height', (tester) async {
      await pumpTestWidget(
        tester,
        const LoadingWidget(
          loaderType: LoaderType.circular,
          width: 200,
          height: 240,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(CircularProgressIndicator));
    });

    testWidgets('renders successfully in dark theme', (tester) async {
      await pumpTestWidget(
        tester,
        const LoadingWidget(
          loaderType: LoaderType.circular,
          title: 'Dark loader',
        ),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark loader'));
    });
  });
}