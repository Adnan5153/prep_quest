import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/title_with_action.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the section-header surface of the app.
///
/// `lib/core/widgets/section_header.dart` is currently an empty stub. The
/// production code that fulfils the "section header" role lives in
/// `lib/core/widgets/title_with_action.dart` and is exercised here so
/// the shared UI is covered while the unified `SectionHeader` API is
/// being designed.
void main() {
  group('SectionHeader (TitleWithAction)', () {
    testWidgets('plain title · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/section_header_plain',
        builder: (BuildContext context, ThemeMode mode) => const Padding(
          padding: EdgeInsets.all(16),
          child: TitleWithAction(title: 'Featured Topics'),
        ),
      );
    });

    testWidgets('title + subtitle · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/section_header_with_subtitle',
        builder: (BuildContext context, ThemeMode mode) => const Padding(
          padding: EdgeInsets.all(16),
          child: TitleWithAction(
            title: 'Featured Topics',
            subtitle: 'Hand-picked quizzes for this week',
          ),
        ),
      );
    });

    testWidgets('title + action button · light+dark', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/section_header_with_action',
        builder: (BuildContext context, ThemeMode mode) => Padding(
          padding: const EdgeInsets.all(16),
          child: TitleWithAction(
            title: 'Featured Topics',
            actionText: 'See all',
            onActionPressed: () {},
          ),
        ),
      );
    });

    testWidgets('title + divider · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/section_header_with_divider',
        builder: (BuildContext context, ThemeMode mode) => const Padding(
          padding: EdgeInsets.all(16),
          child: TitleWithAction(
            title: 'Featured Topics',
            showDivider: true,
          ),
        ),
      );
    });

    testWidgets('title + leading icon · light+dark', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/section_header_with_leading',
        builder: (BuildContext context, ThemeMode mode) => const Padding(
          padding: EdgeInsets.all(16),
          child: TitleWithAction(
            title: 'Featured Topics',
            leading: Icon(Icons.local_fire_department_rounded),
          ),
        ),
      );
    });
  });
}