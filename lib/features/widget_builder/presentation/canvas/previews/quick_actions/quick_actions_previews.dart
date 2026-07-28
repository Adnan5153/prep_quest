import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/quick_actions/quick_action_grid.dart';
import '../../../../../../core/widgets/quick_actions/quick_action_tile.dart';
import '../../../../../../core/widgets/quick_actions/quick_actions_header.dart';
import '../../../providers/widget_builder_provider.dart';

/// Widget-builder preview for the quick-actions family.
class QuickActionsPreview extends StatelessWidget {
  const QuickActionsPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  List<QuickActionItem> _items() => <QuickActionItem>[
        QuickActionItem(
          id: 'continue',
          label: 'Continue Learning',
          icon: AppIcons.play,
          onTap: () {},
        ),
        QuickActionItem(
          id: 'quiz',
          label: 'Daily Quiz',
          icon: Icons.quiz_rounded,
          badgeCount: 2,
          onTap: () {},
        ),
        QuickActionItem(
          id: 'leaderboard',
          label: 'Leaderboard',
          icon: AppIcons.trophy,
          onTap: () {},
        ),
        QuickActionItem(
          id: 'profile',
          label: 'Profile',
          icon: AppIcons.profile,
          onTap: () {},
        ),
      ];

  @override
  Widget build(BuildContext context) {
    switch (provider.selection) {
      case WidgetBuilderSelection.quickActionTile:
        return SizedBox(
          width: 140,
          height: 140,
          child: QuickActionTile(action: _items().first),
        );
      case WidgetBuilderSelection.quickActionGrid:
        return SizedBox(
          width: 520,
          child: QuickActionGrid(actions: _items()),
        );
      case WidgetBuilderSelection.quickActionsHeader:
        return QuickActionsHeader(
          title: 'Quick Actions',
          subtitle: 'Jump straight to what matters.',
          onClose: () {},
        );
      case WidgetBuilderSelection.quickActionsSheet:
        return SizedBox(
          width: 560,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  QuickActionsHeader(
                    title: 'Quick Actions',
                    subtitle: 'Jump straight to what matters.',
                    onClose: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: QuickActionGrid(actions: _items()),
                  ),
                ],
              ),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
