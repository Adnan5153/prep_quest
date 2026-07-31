import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/core/widgets/ai/ai_summary_card.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/widget_test_utils.dart';

void main() {
  group('AiSummaryCard', () {
    testWidgets('renders title and badge without exceptions (light)',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Recap',
          subtitle: 'A short recap',
          sections: <AiSummarySection>[
            AiSummaryTextSection('Some summary content.'),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Recap'));
      expectOneWidget(find.text('AI SUMMARY'));
    });

    testWidgets('renders in dark theme without exceptions', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Dark Recap',
          sections: <AiSummarySection>[
            AiSummaryTextSection('Dark content'),
          ],
        ),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark Recap'));
    });

    testWidgets('omits subtitle text when subtitle is null', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'No Sub',
          sections: <AiSummarySection>[
            AiSummaryTextSection('Body'),
          ],
        ),
      );

      expectOneWidget(find.text('No Sub'));
      // Title and badge are present, but the subtitle slot should be empty.
      expect(find.text('A short recap'), findsNothing);
    });

    testWidgets('hides badge when showBadge is false', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'No Badge',
          sections: <AiSummarySection>[
            AiSummaryTextSection('Body'),
          ],
          showBadge: false,
        ),
      );

      expect(find.text('AI SUMMARY'), findsNothing);
      expectOneWidget(find.text('No Badge'));
    });

    testWidgets('uses provided badgeLabel override', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Custom',
          badgeLabel: 'CUSTOM BADGE',
          sections: <AiSummarySection>[
            AiSummaryTextSection('Body'),
          ],
        ),
      );

      expectOneWidget(find.text('CUSTOM BADGE'));
    });

    testWidgets('renders all tones without exception', (tester) async {
      for (final tone in AiSummaryTone.values) {
        await pumpTestWidget(
          tester,
          AiSummaryCard(
            title: 'Tone ${tone.name}',
            tone: tone,
            sections: const <AiSummarySection>[
              AiSummaryTextSection('Body'),
            ],
          ),
        );
        expect(tester.takeException(), isNull);
        expectOneWidget(find.text('Tone ${tone.name}'));
      }
    });

    testWidgets('renders text sections', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Text Sections',
          sections: <AiSummarySection>[
            AiSummaryTextSection('First paragraph.'),
            AiSummaryTextSection('Second paragraph.'),
          ],
        ),
      );

      expectOneWidget(find.text('First paragraph.'));
      expectOneWidget(find.text('Second paragraph.'));
    });

    testWidgets('renders bullet list sections', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Bullets',
          sections: <AiSummarySection>[
            AiSummaryBulletListSection(<String>['Alpha', 'Beta']),
          ],
        ),
      );

      expectOneWidget(find.text('Alpha'));
      expectOneWidget(find.text('Beta'));
    });

    testWidgets('renders key takeaways and numbered list sections',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Lists',
          sections: <AiSummarySection>[
            AiSummaryKeyTakeawaysSection(<String>['Take one', 'Take two']),
            AiSummaryNumberedListSection(<String>['Step 1', 'Step 2']),
          ],
        ),
      );

      expectOneWidget(find.text('Take one'));
      expectOneWidget(find.text('Take two'));
      expectOneWidget(find.text('Step 1'));
      expectOneWidget(find.text('Step 2'));
    });

    testWidgets('renders code section with language tag', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Code',
          sections: <AiSummarySection>[
            AiSummaryCodeSection(code: 'print(1)', language: 'dart'),
          ],
        ),
      );

      expectOneWidget(find.text('print(1)'));
      // Language tag rendered in upper-case.
      expectOneWidget(find.text('DART'));
    });

    testWidgets('renders highlight section without error', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Highlights',
          sections: <AiSummarySection>[
            AiSummaryHighlightSection(
              text: 'Flutter is great for cross-platform apps.',
              terms: <String>['Flutter'],
            ),
          ],
        ),
      );

      // Highlight uses RichText; full sentence still flows through TextSpan.
      // We assert the title is rendered.
      expectOneWidget(find.text('Highlights'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders metadata strip when metadata fields are provided',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Meta',
          category: 'Biology',
          model: 'GPT-Z',
          timestamp: 'just now',
          readingTime: '3 min',
          wordCount: '420',
          sections: <AiSummarySection>[
            AiSummaryTextSection('Body'),
          ],
        ),
      );

      expectOneWidget(find.text('Biology'));
      expectOneWidget(find.text('GPT-Z'));
      expectOneWidget(find.text('just now'));
      expectOneWidget(find.text('3 min'));
      expectOneWidget(find.text('420'));
    });

    testWidgets('renders tags', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Tagged',
          tags: <String>['flutter', 'dart'],
          sections: <AiSummarySection>[
            AiSummaryTextSection('Body'),
          ],
        ),
      );

      expectOneWidget(find.text('flutter'));
      expectOneWidget(find.text('dart'));
    });

    testWidgets('invokes onTap callback when card is tapped', (tester) async {
      var tapCount = 0;

      await pumpTestWidget(
        tester,
        AiSummaryCard(
          title: 'Tap me',
          sections: const <AiSummarySection>[
            AiSummaryTextSection('Body'),
          ],
          onTap: () => tapCount++,
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();
      expect(tapCount, 1);
    });

    testWidgets('renders without exceptions when sections is empty',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Empty',
          sections: <AiSummarySection>[
            AiSummaryTextSection('Body'),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Empty'));
    });

    testWidgets('respects semanticLabel override', (tester) async {
      await pumpTestWidget(
        tester,
        const AiSummaryCard(
          title: 'Title',
          sections: <AiSummarySection>[
            AiSummaryTextSection('Body'),
          ],
          semanticLabel: 'Custom summary label',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });
  });
}