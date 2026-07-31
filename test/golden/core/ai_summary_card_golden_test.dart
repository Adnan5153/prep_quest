import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/ai/ai_summary_card.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [AiSummaryCard] widget.
///
/// Captures every [AiSummaryTone] in light + dark themes along with
/// the expanded and tag-rich variants.
void main() {
  const String title = 'Coronary circulation summary';
  const String subtitle = 'Cardiology · 3 min read';

  // Build a multi-section body covering the supported section shapes
  // so each variant gets a deterministic surface.
  List<AiSummarySection> buildSections() {
    return const <AiSummarySection>[
      AiSummaryTextSection(
        'The right coronary artery supplies the right atrium and '
        'ventricle, and usually the sinoatrial node.',
      ),
      AiSummaryBulletListSection(<String>[
        'RCA → right atrium, right ventricle, SA node',
        'Inferior ST-elevation = suspect RCA occlusion',
        'Verify with right-sided leads V3R / V4R',
      ]),
      AiSummaryKeyTakeawaysSection(<String>[
        'RCA supplies the right heart and conduction tissue.',
        'Inferior STEMI typically traces back to RCA.',
      ]),
    ];
  }

  Widget frame(Widget child) => Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      );

  // ---------------------------------------------------------------------------
  // Tone variants drive the accent palette.
  // ---------------------------------------------------------------------------
  for (final AiSummaryTone tone in AiSummaryTone.values) {
    testWidgets('${tone.name} · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_summary_card_${tone.name}',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiSummaryCard(
            title: title,
            subtitle: subtitle,
            sections: buildSections(),
            tone: tone,
            category: 'Cardiology',
            model: 'GPT-4',
            timestamp: '5m ago',
            readingTime: '3 min',
            wordCount: '180 words',
            tags: const <String>['Cardiology', 'ECG', 'RCA'],
          ),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Expanded-vs-collapsed
  // ---------------------------------------------------------------------------
  group('AiSummaryCard · expanded', () {
    testWidgets('expanded · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_summary_card_expanded',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiSummaryCard(
            title: title,
            subtitle: subtitle,
            sections: buildSections(),
            tone: AiSummaryTone.deepDive,
            expanded: true,
            canExpand: true,
            tags: const <String>['Cardiology', 'ECG', 'RCA'],
            actions: const AiSummaryActions(
              onCopy: _noop,
              onShare: _noop,
              onExpandToggle: _noop,
            ),
          ),
        ),
      );
    });
  });
}

// Stable no-op callbacks shared by the expansion test. Defined at top
// level so they can be const-referenced in the [AiSummaryActions]
// constructor.
void _noop() {}
