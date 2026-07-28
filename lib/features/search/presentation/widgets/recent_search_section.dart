import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/title_with_action.dart';
import '../../domain/entities/recent_search_entity.dart';
import 'recent_search_chip.dart';

class RecentSearchSection extends StatelessWidget {
  const RecentSearchSection({
    super.key,
    required this.items,
    required this.onTap,
    required this.onClear,
  });

  final List<RecentSearchEntity> items;
  final ValueChanged<RecentSearchEntity> onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TitleWithAction(
          title: AppStrings.searchRecent,
          actionText: items.isEmpty ? null : AppStrings.searchClearHistory,
          onActionPressed: items.isEmpty ? null : onClear,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Your recent searches will appear here.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final RecentSearchEntity entry in items)
                  RecentSearchChip(
                    query: entry.query,
                    onTap: () => onTap(entry),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}