import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/title_with_action.dart';
import '../../../../../../core/widgets/status_chip.dart';
import '../../../providers/widget_builder_provider.dart';

class TitleWithActionPreview extends StatelessWidget {
  const TitleWithActionPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  TitleWithAction(
                    title: provider.headerTitle,
                    subtitle: provider.showHeaderSubtitle
                        ? provider.headerSubtitle
                        : null,
                    showDivider: provider.showHeaderDivider,
                    leading: provider.showHeaderLeading
                        ? Container(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : null,
                    actionText: provider.headerActionType == 'text'
                        ? provider.headerActionText
                        : null,
                    actionIcon: provider.headerActionType == 'icon'
                        ? Icons.arrow_forward_rounded
                        : null,
                    trailing: provider.headerActionType == 'custom'
                        ? const StatusChip(
                            label: 'LIVE',
                            status: StatusChipStatus.live,
                            pulse: true,
                          )
                        : null,
                    onActionPressed: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Placeholder(
                      fallbackHeight: 100,
                      color: theme.dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Text('Context Examples'),
            const SizedBox(height: AppSpacing.md),
            const TitleWithAction(
              title: 'Daily Quiz',
              subtitle: '10 questions • 5 minutes',
              actionText: 'START',
              showDivider: true,
            ),
            const TitleWithAction(
              title: 'Recent Activity',
              actionIcon: Icons.history_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
