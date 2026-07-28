import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/search_item_entity.dart';
import 'search_result_tile.dart';

/// Vertical list of [SearchItemEntity] tiles.
class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<SearchItemEntity> items;
  final ValueChanged<SearchItemEntity> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (BuildContext context, int index) {
        final SearchItemEntity item = items[index];
        return SearchResultTile(
          item: item,
          onTap: () => onTap(item),
        );
      },
    );
  }
}