import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_item_type.dart';
import 'bookmark_action_button.dart';
import 'bookmark_popup_menu.dart';

/// Compact list-row tile for a single bookmark.
class BookmarkTile extends StatelessWidget {
  const BookmarkTile({
    super.key,
    required this.entity,
    required this.onTap,
    required this.onRemove,
  });

  final BookmarkEntity entity;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  IconData _iconFor(BookmarkItemType type, String? iconKey) {
    if (iconKey == 'bookmarkQuestion') return AppIcons.bookmarkQuestion;
    if (iconKey == 'bookmarkLesson') return AppIcons.bookmarkLesson;
    if (iconKey == 'bookmarkAiResponse') return AppIcons.bookmarkAiResponse;
    if (iconKey == 'bookmarkNote') return AppIcons.bookmarkNote;
    switch (type) {
      case BookmarkItemType.question:
        return AppIcons.bookmarkQuestion;
      case BookmarkItemType.lesson:
        return AppIcons.bookmarkLesson;
      case BookmarkItemType.aiResponse:
        return AppIcons.bookmarkAiResponse;
      case BookmarkItemType.note:
        return AppIcons.bookmarkNote;
    }
  }

  String _typeLabel(BookmarkItemType type) {
    switch (type) {
      case BookmarkItemType.question:
        return 'Question';
      case BookmarkItemType.lesson:
        return 'Lesson';
      case BookmarkItemType.aiResponse:
        return 'AI';
      case BookmarkItemType.note:
        return 'Note';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(
                  _iconFor(entity.itemType, entity.thumbnailIconKey),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      entity.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    if ((entity.subtitle ?? '').isNotEmpty) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        entity.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    CategoryChip(
                      label: _typeLabel(entity.itemType),
                      selected: false,
                      enabled: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                    ),
                  ],
                ),
              ),
              BookmarkActionButton(
                itemType: entity.itemType,
                itemId: entity.itemId,
                title: entity.title,
                subtitle: entity.subtitle,
                thumbnailIconKey: entity.thumbnailIconKey,
                sourceFeature: entity.sourceFeature,
                routeName: entity.routeName,
                routeParams: entity.routeParams,
                tags: entity.tags,
              ),
              const SizedBox(width: AppSpacing.xs),
              BookmarkPopupMenu(onOpen: onTap, onRemove: onRemove),
            ],
          ),
        ),
      ),
    );
  }
}