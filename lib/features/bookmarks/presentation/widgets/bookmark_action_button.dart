import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../features/review/presentation/widgets/bookmark_button.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_item_type.dart';
import '../providers/bookmark_provider.dart';
import '../providers/bookmark_visibility_provider.dart';

/// Universal bookmark toggle shared by questions, lessons, AI responses,
/// notes, search results, and bookmark tiles.
class BookmarkActionButton extends ConsumerWidget {
  const BookmarkActionButton({
    super.key,
    required this.itemType,
    required this.itemId,
    required this.title,
    required this.sourceFeature,
    required this.routeName,
    this.subtitle,
    this.thumbnailIconKey,
    this.routeParams = const <String, String>{},
    this.tags = const <String>[],
    this.size = 22,
    this.showLabel = false,
  });

  final BookmarkItemType itemType;
  final String itemId;
  final String title;
  final String? subtitle;
  final String? thumbnailIconKey;
  final String sourceFeature;
  final String routeName;
  final Map<String, String> routeParams;
  final List<String> tags;
  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<String> ids = ref.watch(bookmarkIdsProvider);
    final bool bookmarked = ids.contains(bookmarkLookupKey(itemType, itemId));
    final Widget button = BookmarkButton(
      isBookmarked: bookmarked,
      size: size,
      tooltip: bookmarked
          ? AppStrings.bookmarkRemoveTooltip
          : AppStrings.bookmarkAddTooltip,
      onTap: () async {
        final BookmarkEntity entity = BookmarkEntity(
          id: '${itemType.name}_$itemId',
          itemType: itemType,
          itemId: itemId,
          title: title,
          subtitle: subtitle,
          thumbnailIconKey: thumbnailIconKey,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          sourceFeature: sourceFeature,
          tags: tags,
          routeName: routeName,
          routeParams: routeParams,
        );
        final bool added = await ref
            .read(bookmarkControllerProvider.notifier)
            .toggle(entity);
        if (!context.mounted) return;
        if (added) {
          AppSnackBar.showSuccess(context, AppStrings.bookmarksAdded);
        } else {
          AppSnackBar.showInfo(context, AppStrings.bookmarksRemoved);
        }
      },
    );
    if (!showLabel) return button;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[button, const SizedBox(width: 4), Text(bookmarked ? 'Saved' : 'Save')],
    );
  }
}
