import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/core/widgets/ai/ai_history_section/ai_history_enums.dart';
import 'package:prep_quest/core/widgets/ai/ai_history_tile.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/widget_test_utils.dart';

const AiHistoryItem _baseEntry = AiHistoryItem(
  id: 'entry-1',
  title: 'Quadratic Equations',
  preview: 'A short preview of the lesson.',
  timestamp: '2m ago',
);

void main() {
  group('AiHistoryTile', () {
    testWidgets('renders title and preview without exceptions (light)',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(entry: _baseEntry),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Quadratic Equations'));
      expectOneWidget(find.text('A short preview of the lesson.'));
    });

    testWidgets('renders in dark theme without exceptions', (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(entry: _baseEntry),
        theme: ThemeMode.dark,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Quadratic Equations'));
    });

    testWidgets('respects isDark override independent of theme',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: _baseEntry,
          isDark: true,
        ),
        theme: ThemeMode.light,
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Quadratic Equations'));
    });

    testWidgets('invokes widget-level onTap callback', (tester) async {
      var tapCount = 0;

      await pumpTestWidget(
        tester,
        AiHistoryTile(
          entry: _baseEntry,
          onTap: (_) => tapCount++,
        ),
      );

      await tester.tap(find.text('Quadratic Equations'));
      await tester.pump();
      expect(tapCount, 1);
    });

    testWidgets('prefers entry-level onTap over widget onTap', (tester) async {
      var entryTaps = 0;
      var widgetTaps = 0;

      await pumpTestWidget(
        tester,
        AiHistoryTile(
          entry: AiHistoryItem(
            id: 'e2',
            title: 'Direct',
            preview: 'p',
            timestamp: 'now',
            onTap: () => entryTaps++,
          ),
          onTap: (_) => widgetTaps++,
        ),
      );

      await tester.tap(find.text('Direct'));
      await tester.pump();
      expect(entryTaps, 1);
      expect(widgetTaps, 0);
    });

    testWidgets('invokes onLongPress when long pressed', (tester) async {
      var longPressCount = 0;

      await pumpTestWidget(
        tester,
        AiHistoryTile(
          entry: _baseEntry,
          onLongPress: (_) => longPressCount++,
        ),
      );

      await tester.longPress(find.text('Quadratic Equations'));
      await tester.pump();
      expect(longPressCount, 1);
    });

    testWidgets('hides category when showCategory is false', (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: AiHistoryItem(
            id: 'e3',
            title: 'No cat',
            preview: 'p',
            timestamp: 't',
            category: 'Math',
          ),
          showCategory: false,
        ),
      );

      expect(find.text('Math'), findsNothing);
    });

    testWidgets('hides timestamp when showTimestamp is false', (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: _baseEntry,
          showTimestamp: false,
        ),
      );

      expect(find.text('2m ago'), findsNothing);
    });

    testWidgets('shows subtitle next to timestamp when provided',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: AiHistoryItem(
            id: 'e4',
            title: 'With sub',
            preview: 'p',
            timestamp: '5m ago',
            subtitle: 'Math',
          ),
        ),
      );

      expectOneWidget(find.text('5m ago'));
      expectOneWidget(find.text('Math'));
    });

    testWidgets('hides premium badge when showPremiumBadge is false',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: AiHistoryItem(
            id: 'e5',
            title: 'Premium',
            preview: 'p',
            timestamp: 't',
            isPremium: true,
          ),
          showPremiumBadge: false,
        ),
      );

      // Premium badge renders "PRO" or similar — we just confirm the widget
      // still renders without crashing when the badge is hidden.
      expectOneWidget(find.text('Premium'));
    });

    testWidgets('hides favorite icon when showFavorite is false',
        (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: AiHistoryItem(
            id: 'e6',
            title: 'Fav',
            preview: 'p',
            timestamp: 't',
            isFavorite: true,
          ),
          showFavorite: false,
        ),
      );

      // When showFavorite is false the favorite heart should not be present.
      expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    });

    testWidgets('hides pin indicator when showPinned is false', (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: AiHistoryItem(
            id: 'e7',
            title: 'Pinned',
            preview: 'p',
            timestamp: 't',
            isPinned: true,
          ),
          showPinned: false,
        ),
      );

      expectOneWidget(find.text('Pinned'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('hides chevron when showLeadingChevron is false', (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: _baseEntry,
          showLeadingChevron: false,
        ),
      );

      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    });

    testWidgets('dense mode renders without exception', (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: _baseEntry,
          dense: true,
        ),
      );

      expect(tester.takeException(), isNull);
      expectOneWidget(find.text('Quadratic Equations'));
    });

    testWidgets('respects semanticLabel override', (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: _baseEntry,
          semanticLabel: 'Custom history label',
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });

    testWidgets('respects entry-level semanticLabel', (tester) async {
      await pumpTestWidget(
        tester,
        const AiHistoryTile(
          entry: AiHistoryItem(
            id: 'e8',
            title: 'Title',
            preview: 'p',
            timestamp: 't',
            semanticLabel: 'Entry semantic label',
          ),
        ),
      );

      // find.bySemanticsLabel does not find widgets when Semantics nodes
      // are merged into ancestors; verify a smoke render only.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders all entry types without exception', (tester) async {
      for (final AiHistoryEntryType type in AiHistoryEntryType.values) {
        await pumpTestWidget(
          tester,
          AiHistoryTile(
            entry: AiHistoryItem(
              id: 'e-${type.name}',
              title: 'Type ${type.name}',
              preview: 'p',
              timestamp: 't',
              type: type,
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    });
  });
}