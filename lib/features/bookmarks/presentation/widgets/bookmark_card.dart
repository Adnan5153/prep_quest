import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/bookmark_entity.dart';
import 'bookmark_action_button.dart';
import 'bookmark_popup_menu.dart';
import 'bookmark_tile.dart';

/// Two-column grid variant. Reuses the [BookmarkTile] body but stacks
/// the icon and metadata vertically for tablet layouts.
class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.entity,
    required this.onTap,
    required this.onRemove,
  });

  final BookmarkEntity entity;
  final VoidCallback onTap;
  final VoidCallback onRemove;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                    child: Icon(
                      _iconFor(entity),
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  BookmarkPopupMenu(onOpen: onTap, onRemove: onRemove),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                entity.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
              if ((entity.subtitle ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  entity.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: BookmarkActionButton(
                  itemType: entity.itemType,
                  itemId: entity.itemId,
                  title: entity.title,
                  subtitle: entity.subtitle,
                  thumbnailIconKey: entity.thumbnailIconKey,
                  sourceFeature: entity.sourceFeature,
                  routeName: entity.routeName,
                  routeParams: entity.routeParams,
                  tags: entity.tags,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(BookmarkEntity entity) {
    final String? iconKey = entity.thumbnailIconKey;
    if (iconKey == 'bookmarkQuestion') return Icons.help_outline_rounded;
    if (iconKey == 'bookmarkLesson') return Icons.menu_book_rounded;
    if (iconKey == 'bookmarkAiResponse') return Icons.auto_awesome_rounded;
    if (iconKey == 'bookmarkNote') return Icons.sticky_note_2_rounded;
    return Icons.bookmark_border_rounded;
  }
}