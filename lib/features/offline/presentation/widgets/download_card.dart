import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/enums/offline_content_type.dart';
import '../../domain/entities/offline_item_entity.dart';

/// Compact card representing a single downloadable (or already
/// downloaded) item. Used by the offline downloads and downloaded
/// lessons / questions screens.
class DownloadCard extends StatelessWidget {
  const DownloadCard({
    super.key,
    required this.item,
    required this.onDownload,
    required this.onOpen,
    required this.onDelete,
    this.isDownloading = false,
    this.progress = 0,
  });

  final OfflineItemEntity item;
  final VoidCallback onDownload;
  final VoidCallback onOpen;
  final VoidCallback onDelete;
  final bool isDownloading;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final IconData icon = _iconFor(item.contentType);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: AppSizes.iconLg + 8,
            height: AppSizes.iconLg + 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                if (isDownloading) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      backgroundColor:
                          theme.colorScheme.onSurface.withValues(alpha: 0.06),
                      minHeight: 4,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildActions(context, theme),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          onPressed: onDownload,
          icon: Icon(
            Icons.cloud_download_outlined,
            color: colorScheme.primary,
          ),
          tooltip: 'Download',
        ),
        IconButton(
          onPressed: onOpen,
          icon: Icon(Icons.menu_book_rounded, color: colorScheme.secondary),
          tooltip: 'Open',
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(Icons.delete_outline, color: AppColors.error),
          tooltip: 'Delete',
        ),
      ],
    );
  }

  IconData _iconFor(OfflineContentType type) {
    switch (type) {
      case OfflineContentType.lesson:
        return AppIcons.bookmarkLesson;
      case OfflineContentType.chapter:
        return Icons.layers_outlined;
      case OfflineContentType.subject:
        return Icons.book_outlined;
      case OfflineContentType.questionSet:
        return AppIcons.bookmarkQuestion;
      case OfflineContentType.mockTest:
        return Icons.assignment_rounded;
    }
  }
}