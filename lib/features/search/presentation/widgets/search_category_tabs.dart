import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../domain/enums/search_category.dart';

extension SearchCategoryLabel on SearchCategory {
  String get displayLabel {
    switch (this) {
      case SearchCategory.all:
        return AppStrings.categoryAll;
      case SearchCategory.lessons:
        return AppStrings.categoryLessons;
      case SearchCategory.questions:
        return AppStrings.categoryQuestions;
      case SearchCategory.topics:
        return AppStrings.categoryTopics;
      case SearchCategory.books:
        return AppStrings.categoryBooks;
      case SearchCategory.aiHistory:
        return AppStrings.categoryAiHistory;
    }
  }
}

/// Horizontal chip row used to filter the visible results by category.
class SearchCategoryTabs extends StatelessWidget {
  const SearchCategoryTabs({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.counts,
    this.includeAll = true,
  });

  final SearchCategory selected;
  final ValueChanged<SearchCategory> onSelect;
  final Map<SearchCategory, int> counts;
  final bool includeAll;

  static const List<SearchCategory> _order = <SearchCategory>[
    SearchCategory.all,
    SearchCategory.lessons,
    SearchCategory.questions,
    SearchCategory.topics,
    SearchCategory.books,
    SearchCategory.aiHistory,
  ];

  @override
  Widget build(BuildContext context) {
    final List<SearchCategory> categories =
        includeAll ? _order : _order.where((SearchCategory c) => c != SearchCategory.all).toList();
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          final SearchCategory category = categories[index];
          final int count = counts[category] ?? 0;
          return CategoryChip(
            label: category.displayLabel,
            count: count == 0 ? null : count,
            selected: category == selected,
            onTap: () => onSelect(category),
          );
        },
      ),
    );
  }
}