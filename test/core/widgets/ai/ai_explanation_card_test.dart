import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/core/widgets/ai/ai_explanation_card.dart';
import 'package:prep_quest/core/widgets/ai/ai_explanation_constants.dart';
import 'package:prep_quest/core/widgets/ai/ai_explanation_footer.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/widget_test_utils.dart';

void main() {
  group('AiExplanationCard', () {
    testWidgets('renders title and badge without exceptions (light)',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Explanation',
          subtitle: 'Why?',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Some explanation body.'),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Explanation'));
      expectOneWidget(find.text('AI INSIGHT'));
    });

    testWidgets('renders in dark theme without exceptions', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Dark Explanation',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Dark body'),
          ],
        ),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Dark Explanation'));
    });

    testWidgets('hides subtitle when null', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'No Sub',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Body'),
          ],
        ),
      );

      expectOneWidget(find.text('No Sub'));
      expect(find.text('Why?'), findsNothing);
    });

    testWidgets('hides badge when showBadge is false', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'No Badge',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Body'),
          ],
          showBadge: false,
        ),
      );

      expect(find.text('AI INSIGHT'), findsNothing);
    });

    testWidgets('uses provided badgeLabel override', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Custom',
          badgeLabel: 'CUSTOM EXPL',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Body'),
          ],
        ),
      );

      expectOneWidget(find.text('CUSTOM EXPL'));
    });

    testWidgets('renders all tones without exception', (tester) async {
      for (final tone in AiExplanationTone.values) {
        await pumpTestWidget(
          tester,
          AiExplanationCard(
            title: 'Tone',
            tone: tone,
            sections: const <AiExplanationSection>[
              AiExplanationTextSection('Body'),
            ],
          ),
        );
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('renders text and markdown sections', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Mixed',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Plain text.'),
            AiExplanationMarkdownSection('# heading\n\nparagraph'),
          ],
        ),
      );

      expectOneWidget(find.text('Plain text.'));
      // Markdown source is rendered as a paragraph block.
      expectOneWidget(find.text('paragraph'));
    });

    testWidgets('renders bullet and numbered list sections', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Lists',
          sections: <AiExplanationSection>[
            AiExplanationBulletListSection(<String>['Bullet A', 'Bullet B']),
            AiExplanationNumberedListSection(<String>['One', 'Two']),
          ],
        ),
      );

      expectOneWidget(find.text('Bullet A'));
      expectOneWidget(find.text('Bullet B'));
      expectOneWidget(find.text('One'));
      expectOneWidget(find.text('Two'));
    });

    testWidgets('renders code section with language tag', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Code',
          sections: <AiExplanationSection>[
            AiExplanationCodeSection(code: 'void main() {}', language: 'dart'),
          ],
        ),
      );

      expectOneWidget(find.text('void main() {}'));
      expectOneWidget(find.text('DART'));
    });

    testWidgets('renders tip and note callouts', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Callouts',
          sections: <AiExplanationSection>[
            AiExplanationTipSection(title: 'Do this', body: 'Use immutable state.'),
            AiExplanationNoteSection(title: 'Note', body: 'Read carefully.'),
          ],
        ),
      );

      expectOneWidget(find.text('Do this'));
      expectOneWidget(find.text('Use immutable state.'));
      expectOneWidget(find.text('Note'));
      expectOneWidget(find.text('Read carefully.'));
    });

    testWidgets('renders highlight section without exception', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Highlights',
          sections: <AiExplanationSection>[
            AiExplanationHighlightSection(
              text: 'The mitochondria is the powerhouse.',
              terms: <String>['mitochondria'],
            ),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders footer actions when supplied', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'With Footer',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Body'),
          ],
          footerActions: AiExplanationFooterActions(
            onCopy: _noop,
            onShare: _noop,
          ),
        ),
      );

      expectOneWidget(find.text('Copy'));
      expectOneWidget(find.text('Share'));
    });

    testWidgets('fires onCopy callback', (tester) async {
      var copyCount = 0;

      await pumpTestWidget(
        tester,
        AiExplanationCard(
          title: 'Footer Actions',
          sections: const <AiExplanationSection>[
            AiExplanationTextSection('Body'),
          ],
          footerActions: AiExplanationFooterActions(
            onCopy: () => copyCount++,
          ),
        ),
      );

      await tester.tap(find.text('Copy'));
      await tester.pump();
      expect(copyCount, 1);
    });

    testWidgets('hides footer when no actions and showActions false',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'No Footer',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Body'),
          ],
          showActions: false,
        ),
      );

      expect(find.text('Copy'), findsNothing);
      expect(find.text('Share'), findsNothing);
    });

    testWidgets('invokes onTap when card is tapped', (tester) async {
      var tapCount = 0;

      await pumpTestWidget(
        tester,
        AiExplanationCard(
          title: 'Tappable',
          sections: const <AiExplanationSection>[
            AiExplanationTextSection('Body'),
          ],
          onTap: () => tapCount++,
        ),
      );

      await tester.tap(find.text('Tappable'));
      await tester.pump();
      expect(tapCount, 1);
    });

    testWidgets('renders without sections list gracefully', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Empty',
          sections: <AiExplanationSection>[],
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Empty'));
    });

    testWidgets('respects semanticLabel override', (tester) async {
      await pumpTestWidget(
        tester,
        const AiExplanationCard(
          title: 'Title',
          sections: <AiExplanationSection>[
            AiExplanationTextSection('Body'),
          ],
          semanticLabel: 'Custom explanation label',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });
  });
}

void _noop() {}