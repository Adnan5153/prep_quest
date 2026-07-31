import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/ai/ai_explanation_card.dart';
import 'package:prep_quest/core/widgets/ai/ai_explanation_constants.dart';
import 'package:prep_quest/core/widgets/ai/ai_explanation_footer.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [AiExplanationCard] widget.
///
/// Captures every [AiExplanationTone] in light + dark themes, plus
/// the expanded variant and a card loaded with rich body sections.
void main() {
  const String title = 'Why does RCA occlusion cause inferior STEMI?';
  const String subtitle = 'Cardiology · 4 min read';

  List<AiExplanationSection> buildSections() {
    return const <AiExplanationSection>[
      AiExplanationTextSection(
        'The right coronary artery (RCA) runs along the AV groove and '
        'supplies the inferior wall of the left ventricle in '
        'right-dominant circulations.',
      ),
      AiExplanationBulletListSection(<String>[
        'Inferior wall is fed by the posterior descending artery.',
        'PDA branches from the RCA in 85% of patients.',
        'Occlusion therefore deprives the inferior myocardium of flow.',
      ]),
      AiExplanationTipSection(
        title: 'Exam tip',
        body: 'Look for ST elevation in II, III, and aVF; reciprocal '
            'depression in I and aVL supports RCA occlusion.',
      ),
      AiExplanationCodeSection(
        code: 'ECG: ST↑ II, III, aVF\n     ST↓ I, aVL',
        language: 'ecg',
      ),
    ];
  }

  Widget frame(Widget child) => Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      );

  // ---------------------------------------------------------------------------
  // Tone variants — the tone drives the accent palette across the
  // header, accent strip, and inline callouts.
  // ---------------------------------------------------------------------------
  for (final AiExplanationTone tone in AiExplanationTone.values) {
    testWidgets('${tone.name} · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 540);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_explanation_card_${tone.name}',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiExplanationCard(
            title: title,
            subtitle: subtitle,
            sections: buildSections(),
            tone: tone,
            timestamp: '2m ago',
          ),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Expanded variant — exercises the SizeTransition animation
  // while stationary so the snapshot is stable.
  // ---------------------------------------------------------------------------
  group('AiExplanationCard · expanded', () {
    testWidgets('expanded · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_explanation_card_expanded',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiExplanationCard(
            title: title,
            subtitle: subtitle,
            sections: buildSections(),
            tone: AiExplanationTone.insight,
            timestamp: '2m ago',
            canExpand: true,
            expanded: true,
            footerActions: const AiExplanationFooterActions(
              onCopy: _noop,
              onShare: _noop,
              onBookmark: _noop,
            ),
          ),
        ),
      );
    });
  });
}

void _noop() {}