import 'package:flutter/material.dart';
import '../../../../../../core/widgets/ai/ai_hint_card/ai_hint_card.dart';
import '../../../../../../core/widgets/ai/ai_hint_card/ai_hint_constants.dart';
import '../../../providers/widget_builder_provider.dart';

class AiHintCardPreview extends StatelessWidget {
  const AiHintCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AiHintCard(
          title: provider.aiHintTitle,
          hint: provider.aiHintText,
          type: _parseType(provider.aiHintType),
          difficulty: _parseDifficulty(provider.aiHintDifficulty),
          topic: provider.aiHintTopic,
          quickTip: provider.aiHintQuickTip,
          showBadge: provider.aiHintShowBadge,
          showActions: provider.aiHintShowActions,
          isBookmarked: provider.aiHintIsBookmarked,
          badgeText: provider.aiHintBadgeText,
          onCopy: () {},
          onShare: () {},
          onBookmark: () {
            provider.aiHintIsBookmarked = !provider.aiHintIsBookmarked;
          },
        ),
      ),
    );
  }

  AiHintType _parseType(String type) {
    return AiHintType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => AiHintType.quickTip,
    );
  }

  AiHintDifficulty _parseDifficulty(String difficulty) {
    return AiHintDifficulty.values.firstWhere(
      (e) => e.name == difficulty,
      orElse: () => AiHintDifficulty.beginner,
    );
  }
}
