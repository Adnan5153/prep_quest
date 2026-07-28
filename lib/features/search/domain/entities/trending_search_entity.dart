import 'package:flutter/foundation.dart';

import '../enums/search_category.dart';

/// One trending search term surfaced on the idle search screen.
@immutable
class TrendingSearchEntity {
  const TrendingSearchEntity({
    required this.label,
    required this.query,
    required this.rank,
    this.category,
  });

  final String label;
  final String query;
  final int rank;
  final SearchCategory? category;

  TrendingSearchEntity copyWith({
    String? label,
    String? query,
    int? rank,
    SearchCategory? category,
    bool clearCategory = false,
  }) {
    return TrendingSearchEntity(
      label: label ?? this.label,
      query: query ?? this.query,
      rank: rank ?? this.rank,
      category: clearCategory ? null : (category ?? this.category),
    );
  }
}