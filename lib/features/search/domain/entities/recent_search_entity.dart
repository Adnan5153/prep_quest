import 'package:flutter/foundation.dart';

import '../enums/search_category.dart';

/// One persisted recent-search entry.
@immutable
class RecentSearchEntity {
  const RecentSearchEntity({
    required this.query,
    required this.queriedAtIso,
    this.categoryAtTime,
  });

  final String query;
  final String queriedAtIso;
  final SearchCategory? categoryAtTime;

  RecentSearchEntity copyWith({
    String? query,
    String? queriedAtIso,
    SearchCategory? categoryAtTime,
    bool clearCategory = false,
  }) {
    return RecentSearchEntity(
      query: query ?? this.query,
      queriedAtIso: queriedAtIso ?? this.queriedAtIso,
      categoryAtTime:
          clearCategory ? null : (categoryAtTime ?? this.categoryAtTime),
    );
  }
}