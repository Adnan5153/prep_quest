import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/ai/ai_response_card.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [AiResponseCard] widget.
///
/// Captures every [AiResponseType] in light + dark themes plus a
/// metadata-rich variant and an expandable card.
void main() {
  const String title = 'AI Tutor';
  const String subtitle = 'Cardiology · Module 4';
  const String body =
      'The right coronary artery supplies blood to the right atrium, '
      'right ventricle, and—in most people—the sinoatrial node. '
      'Occlusion classically presents with inferior ST-elevation on '
      'the ECG.';

  Widget frame(Widget child) => Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      );

  // ---------------------------------------------------------------------------
  // Loop through every response type — the type drives the badge label
  // and accent palette.
  // ---------------------------------------------------------------------------
  for (final AiResponseType type in AiResponseType.values) {
    testWidgets('${type.name} · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_response_card_${type.name}',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiResponseCard(
            title: title,
            subtitle: subtitle,
            body: body,
            responseType: type,
          ),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Metadata strip
  // ---------------------------------------------------------------------------
  group('AiResponseCard · metadata', () {
    testWidgets('metadata strip · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 440);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_response_card_metadata',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiResponseCard(
            title: title,
            subtitle: subtitle,
            body: body,
            responseType: AiResponseType.explanation,
            metadata: const AiResponseMetadata(
              model: 'GPT-4',
              timestamp: '2m ago',
              category: 'Cardiology',
              confidence: AiResponseConfidence.high,
              status: AiResponseStatus.delivered,
            ),
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Action footer
  // ---------------------------------------------------------------------------
  group('AiResponseCard · actions', () {
    testWidgets('full footer · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 440);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_response_card_actions',
        builder: (BuildContext context, ThemeMode mode) => frame(
          AiResponseCard(
            title: title,
            subtitle: subtitle,
            body: body,
            responseType: AiResponseType.explanation,
            actions: AiResponseActions(
              onCopy: () {},
              onShare: () {},
              onRegenerate: () {},
              onFavorite: () {},
              onLike: () {},
              onDislike: () {},
              isFavorite: true,
              isLiked: true,
            ),
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Markdown body
  // ---------------------------------------------------------------------------
  group('AiResponseCard · markdown', () {
    testWidgets('markdown body · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 440);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/ai_response_card_markdown',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const AiResponseCard(
            title: title,
            subtitle: subtitle,
            body: '# Coronary anatomy\n\nThe **right** coronary artery '
                'supplies the right atrium and ventricle.',
            responseType: AiResponseType.explanation,
            markdown: true,
          ),
        ),
      );
    });
  });
}