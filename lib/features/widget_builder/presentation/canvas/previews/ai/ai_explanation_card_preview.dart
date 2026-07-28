import 'package:flutter/material.dart';
import '../../../../../../core/widgets/ai/ai_explanation_card.dart';
import '../../../../../../core/widgets/ai/ai_explanation_constants.dart';
import '../../../../../../core/widgets/ai/ai_explanation_footer.dart';
import '../../../providers/widget_builder_provider.dart';

class AiExplanationCardPreview extends StatelessWidget {
  const AiExplanationCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AiExplanationCard(
          title: provider.aiExpTitle,
          subtitle: provider.aiExpSubtitle,
          badgeLabel: provider.aiExpBadgeLabel,
          tone: _parseTone(provider.aiExpTone),
          showBadge: provider.aiExpShowBadge,
          showActions: provider.aiExpShowActions,
          expanded: provider.aiExpExpanded,
          canExpand: provider.aiExpCanExpand,
          sections: _getMockSections(provider.aiExpLongContent),
          footerActions: AiExplanationFooterActions(
            onCopy: () {},
            onShare: () {},
            onBookmark: () {},
            isBookmarked: false,
            canExpand: provider.aiExpCanExpand,
            onExpandToggle: () {
              provider.aiExpExpanded = !provider.aiExpExpanded;
            },
            isExpanded: provider.aiExpExpanded,
          ),
        ),
      ),
    );
  }

  AiExplanationTone _parseTone(String tone) {
    return AiExplanationTone.values.firstWhere(
      (e) => e.name == tone,
      orElse: () => AiExplanationTone.insight,
    );
  }

  List<AiExplanationSection> _getMockSections(bool longContent) {
    if (longContent) {
      return [
        const AiExplanationTextSection(
          'A **B-Tree** is a self-balancing tree data structure that maintains sorted data and allows searches, sequential access, insertions, and deletions in logarithmic time.',
        ),
        const AiExplanationBulletListSection([
          'All leaves are at the same level.',
          'Defined by a minimum degree `t`. Every node must have at least `t-1` keys.',
          'Root can have as few as 1 key.',
        ]),
        const AiExplanationCodeSection(
          code:
              'class BTreeNode {\n  int[] keys;\n  int t;\n  BTreeNode[] children;\n  int n;\n  bool leaf;\n}',
          language: 'java',
        ),
        const AiExplanationTipSection(
          title: 'Performance Note',
          body:
              'B-Trees are optimized for systems that read and write large blocks of data, such as databases and filesystems.',
        ),
        const AiExplanationNoteSection(
          body:
              'Searching a B-Tree is similar to searching a Binary Search Tree.',
        ),
      ];
    }

    return [
      const AiExplanationTextSection(
        'The time complexity of this algorithm is **O(n log n)** because it uses a divide-and-conquer approach.',
      ),
      const AiExplanationBulletListSection([
        'Divide: O(1)',
        'Conquer: 2 * T(n/2)',
        'Combine: O(n)',
      ]),
    ];
  }
}
