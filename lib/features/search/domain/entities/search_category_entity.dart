import 'package:flutter/foundation.dart';

import '../enums/search_category.dart';

/// Per-category metadata surfaced in the filter chips (label + count).
@immutable
class SearchCategoryEntity {
  const SearchCategoryEntity({required this.category, required this.resultCount});

  final SearchCategory category;
  final int resultCount;

  SearchCategoryEntity copyWith({
    SearchCategory? category,
    int? resultCount,
  }) {
    return SearchCategoryEntity(
      category: category ?? this.category,
      resultCount: resultCount ?? this.resultCount,
    );
  }
}