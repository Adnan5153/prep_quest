import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/ai/ai_hint_card/ai_hint_card.dart';
import 'package:prep_quest/core/widgets/ai/ai_hint_card/ai_hint_constants.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [AiHintCard] widget.
///
/// Captures every [AiHintType] in light + dark themes. The card body
/// is intentionally kept short so the snapshot is dominated by the
/// accent strip and header — the same surface used in production for
/// the hint list.
void main() {
  const String title = 'Mnemonic for cell biology';
  const String hint =
      'Think "PLANT ME" — Plasmid, Lipids, ATP, Nucleus, Transport, '
      'Membrane, Enzymes — to recall the components of a typical '
      'eukaryotic cell when answering MCQs.';

  Widget frame(Widget child) => Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      );

  // ---------------------------------------------------------------------------
  // Loop through every hint type so the golden set covers all eight
  // accents + icons in one place.
  // ---------------------------------------------------------------------------
  for (final AiHintType type in AiHintType.values) {
    testWidgets('${type.name} · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 360);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final String label = AiHintConstants.labelForType(type);
      await captureGoldenPair(
        tester,
        'core/ai_hint_card_${type.name}',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiHintCard(
            title: title,
            hint: hint,
            type: type,
            difficulty: AiHintDifficulty.intermediate,
            topic: 'Biology',
            quickTip: 'Pair this with a 30-second recall drill.',
          ),
        ),
      );
      // Reference `label` so the analyzer doesn't drop the unused
      // import. The label is exposed via [AiHintConstants.labelForType]
      // and we want it in scope for any future variant comparison.
      expect(label, isNotEmpty);
    });
  }

  // ---------------------------------------------------------------------------
  // Difficulty variants
  // ---------------------------------------------------------------------------
  group('AiHintCard · difficulty', () {
    for (final AiHintDifficulty difficulty in AiHintDifficulty.values) {
      testWidgets('${difficulty.name} · light+dark', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(360, 360);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await captureGoldenPair(
          tester,
          'core/ai_hint_card_difficulty_${difficulty.name}',
          builder: (BuildContext context, ThemeMode mode) => frame(
            AiHintCard(
              title: title,
              hint: hint,
              type: AiHintType.memoryTrick,
              difficulty: difficulty,
              topic: 'Biology',
            ),
          ),
        );
      });
    }
  });

  // ---------------------------------------------------------------------------
  // Bookmark state
  // ---------------------------------------------------------------------------
  group('AiHintCard · bookmarked', () {
    testWidgets('bookmarked · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 360);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_hint_card_bookmarked',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiHintCard(
            title: title,
            hint: hint,
            type: AiHintType.memoryTrick,
            isBookmarked: true,
            onCopy: () {},
            onBookmark: () {},
            onShare: () {},
          ),
        ),
      );
    });
  });
}