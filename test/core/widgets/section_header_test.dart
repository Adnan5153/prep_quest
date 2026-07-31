import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/title_with_action.dart';

import '../../helpers/test_app.dart';
import '../../helpers/widget_test_utils.dart';

/// Tests for the section-header surface of the app.
///
/// `lib/core/widgets/section_header.dart` is currently an empty stub file.
/// The production code that fulfils the "section header" role lives in
/// `lib/core/widgets/title_with_action.dart` and is exercised here so the
/// shared UI is covered while the unified `SectionHeader` API is being
/// designed.
void main() {
  group('Section header surface (TitleWithAction)', () {
    testWidgets('renders title successfully (light theme)', (tester) async {
      await pumpTestWidget(
        tester,
        const TitleWithAction(title: 'Featured'),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Featured'));
    });

    testWidgets('renders successfully in dark theme', (tester) async {
      await pumpTestWidget(
        tester,
        const TitleWithAction(title: 'Dark Featured'),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark Featured'));
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const TitleWithAction(
          title: 'Section',
          subtitle: 'Section description',
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Section'));
      expectOneWidget(find.text('Section description'));
    });

    testWidgets('renders actionText and fires onActionPressed',
        (tester) async {
      var pressed = false;
      await pumpTestWidget(
        tester,
        TitleWithAction(
          title: 'Section',
          actionText: 'See all',
          onActionPressed: () => pressed = true,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('See all'));

      await tester.tap(find.text('See all'));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('renders leading widget when provided', (tester) async {
      await pumpTestWidget(
        tester,
        const TitleWithAction(
          title: 'With leading',
          leading: Icon(Icons.menu),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byIcon(Icons.menu));
    });

    testWidgets('renders divider when showDivider is true', (tester) async {
      await pumpTestWidget(
        tester,
        const TitleWithAction(
          title: 'Divided',
          showDivider: true,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.byType(Divider));
    });

    testWidgets('does not render divider by default', (tester) async {
      await pumpTestWidget(
        tester,
        const TitleWithAction(title: 'Plain'),
      );

      expectMissing(find.byType(Divider));
    });
  });
}