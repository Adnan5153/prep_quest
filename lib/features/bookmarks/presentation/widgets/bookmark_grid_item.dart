import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/bookmark_entity.dart';
import 'bookmark_action_button.dart';

/// Full-bleed grid card for desktop layouts.
class BookmarkGridItem extends StatelessWidget {
  const BookmarkGridItem({
    super.key,
    required this.entity,
    required this.onTap,
  });

  final BookmarkEntity entity;
  final VoidCallback onTap;

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
                  Icon(Icons.bookmark_rounded,
                      color: theme.colorScheme.primary, size: 20),
                  const Spacer(),
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
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                entity.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              if ((entity.subtitle ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  entity.subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}