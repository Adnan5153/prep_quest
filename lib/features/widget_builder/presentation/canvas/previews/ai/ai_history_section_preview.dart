import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_history_section.dart';
import '../../../providers/widget_builder_provider.dart';

class AiHistorySectionPreview extends StatelessWidget {
  const AiHistorySectionPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth < 480
            ? constraints.maxWidth
            : (constraints.maxWidth < 900 ? 600 : 720);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: AiHistorySection(
                items: _resolveItems(),
                state: _resolveState(),
                title: provider.aiHistoryHeaderTitle,
                subtitle: provider.aiHistoryHeaderSubtitle,
                showHeader: provider.aiHistoryShowHeader,
                showViewAll: provider.aiHistoryShowViewAll,
                showCategory: provider.aiHistoryShowCategory,
                showTimestamp: provider.aiHistoryShowTimestamp,
                showPremiumBadge: provider.aiHistoryShowPremiumBadge,
                showFavorite: provider.aiHistoryShowFavorite,
                showPinned: provider.aiHistoryShowPinned,
                showLeadingChevron: provider.aiHistoryShowLeadingChevron,
                loadingItemCount: provider.aiHistoryLoadingItemCount,
                maxItems: 4,
              ),
            ),
          ),
        );
      },
    );
  }

  AiHistoryState _resolveState() {
    switch (provider.aiHistoryState) {
      case 'empty':
        return AiHistoryState.empty;
      case 'loading':
        return AiHistoryState.loading;
      case 'error':
        return AiHistoryState.error;
      default:
        return AiHistoryState.ready;
    }
  }

  List<AiHistoryItem> _resolveItems() {
    return <AiHistoryItem>[
      AiHistoryItem(
        id: 'tutor-1',
        title: 'B-Tree insertions',
        preview:
            'A B-Tree of minimum degree `t=2` maintains sorted data and supports search, insert, and delete in logarithmic time.',
        timestamp: '2 min ago',
        subtitle: 'Data Structures',
        category: 'Tutor',
        type: AiHistoryEntryType.tutor,
        isPinned: true,
        isFavorite: true,
        isUnread: true,
        onTap: () {},
      ),
      AiHistoryItem(
        id: 'prompt-1',
        title: 'Explain gradient descent in Bangla',
        preview:
            'একটি ছোট উদাহরণের মাধ্যমে প্রতিটি ধাপ ব্যাখ্যা করো এবং শেষে একটি সারসংক্ষেপ দাও।',
        timestamp: '10 min ago',
        subtitle: 'Bangla',
        category: 'Prompt',
        type: AiHistoryEntryType.prompt,
        isPremium: true,
        onTap: () {},
      ),
      AiHistoryItem(
        id: 'exam-1',
        title: 'BCS Mock Test 14 — Analytics',
        preview:
            'You scored 18/25. Focus on International Affairs and General Science for the next attempt.',
        timestamp: 'Yesterday',
        subtitle: 'Mock Test',
        category: 'Exam',
        type: AiHistoryEntryType.exam,
        onTap: () {},
      ),
      AiHistoryItem(
        id: 'summary-1',
        title: 'Lecture summary — Constitution',
        preview:
            'A concise recap covering Articles of Association, fundamental rights, and amendment procedures.',
        timestamp: '2 days ago',
        subtitle: 'Summary',
        category: 'Summary',
        type: AiHistoryEntryType.summary,
        isFavorite: true,
        onTap: () {},
      ),
    ];
  }
}
