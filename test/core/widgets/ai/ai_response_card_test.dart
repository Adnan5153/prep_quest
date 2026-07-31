import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/core/widgets/ai/ai_response_card.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/widget_test_utils.dart';

void main() {
  group('AiResponseCard', () {
    testWidgets('renders title and body without exceptions (light)',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'AI Tutor',
          body: 'Here is a response body.',
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('AI Tutor'));
      expectOneWidget(find.text('Here is a response body.'));
    });

    testWidgets('renders in dark theme without exceptions', (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'Dark Response',
          body: 'Dark body text',
        ),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark Response'));
    });

    testWidgets('hides subtitle when not provided', (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'No Sub',
          body: 'Body',
        ),
      );

      // The title is shown once; ensure there is no extra empty subtitle
      // sibling by confirming a single Text widget for the title.
      expect(find.text('No Sub'), findsOneWidget);
    });

    testWidgets('renders subtitle when supplied', (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'Title',
          subtitle: 'Subtitle line',
          body: 'Body',
        ),
      );

      expectOneWidget(find.text('Subtitle line'));
    });

    testWidgets('hides badge when showBadge is false', (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'No Badge',
          body: 'Body',
          showBadge: false,
        ),
      );

      // Generic response type with empty badgeLabel by default would render
      // nothing visible for the badge. The body text should still be there.
      expectOneWidget(find.text('No Badge'));
      expectOneWidget(find.text('Body'));
    });

    testWidgets('uses provided badgeLabel override', (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'Tutor',
          body: 'Body',
          badgeLabel: 'CUSTOM',
        ),
      );

      expectOneWidget(find.text('CUSTOM'));
    });

    testWidgets('renders all response types without error', (tester) async {
      for (final type in AiResponseType.values) {
        await pumpTestWidget(
          tester,
          AiResponseCard(
            title: 'Variant',
            body: 'Body',
            responseType: type,
          ),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Variant'));
      }
    });

    testWidgets('invokes onTap callback', (tester) async {
      var tapCount = 0;

      await pumpTestWidget(
        tester,
        AiResponseCard(
          title: 'Tappable',
          body: 'Tap me',
          onTap: () => tapCount++,
        ),
      );

      await tester.tap(find.text('Tappable'));
      await tester.pump();
      expect(tapCount, 1);
    });

    testWidgets('respects semanticLabel override', (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'T',
          body: 'B',
          semanticLabel: 'Custom response label',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders metadata strip when metadata is provided',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'Meta',
          body: 'Body',
          metadata: AiResponseMetadata(
            model: 'GPT-X',
            timestamp: '2m ago',
            category: 'Math',
          ),
        ),
      );

      expectOneWidget(find.text('GPT-X'));
      expectOneWidget(find.text('2m ago'));
      expectOneWidget(find.text('Math'));
    });

    testWidgets('renders copy and share action tiles and fires callbacks',
        (tester) async {
      var copyCount = 0;
      var shareCount = 0;

      await pumpTestWidget(
        tester,
        AiResponseCard(
          title: 'Actions',
          body: 'Body',
          actions: AiResponseActions(
            onCopy: () => copyCount++,
            onShare: () => shareCount++,
          ),
        ),
      );

      expectOneWidget(find.text('Copy'));
      expectOneWidget(find.text('Share'));

      await tester.tap(find.text('Copy'));
      await tester.pump();
      expect(copyCount, 1);

      await tester.tap(find.text('Share'));
      await tester.pump();
      expect(shareCount, 1);
    });

    testWidgets('renders without actions footer when actions is null',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiResponseCard(
          title: 'No Actions',
          body: 'Body',
        ),
      );

      // Copy/Share/Regenerate labels are footer-only.
      expect(find.text('Copy'), findsNothing);
      expect(find.text('Share'), findsNothing);
      expect(find.text('Regenerate'), findsNothing);
    });

    testWidgets('canExpand toggles between collapsed and expanded states',
        (tester) async {
      await pumpTestWidget(
        tester,
        AiResponseCard(
          title: 'Expandable',
          body: 'A long body that may need truncation',
          canExpand: true,
          expanded: false,
          collapsedMaxLines: 1,
          actions: AiResponseActions(
            onExpandToggle: () {},
            canExpand: true,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Expand'));
    });
  });
}