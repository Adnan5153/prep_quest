import 'package:flutter/foundation.dart';

import '../enums/search_category.dart';

/// One row in a search result list, irrespective of where the data
/// ultimately comes from (lesson, question, topic, book, AI message).
@immutable
class SearchItemEntity {
  const SearchItemEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.routeName,
    this.secondaryRouteName,
    this.iconName,
    this.updatedAtIso,
  });

  final String id;
  final SearchCategory category;
  final String title;
  final String subtitle;

  /// Route pushed when the user taps the tile. Kept as a string so the
  /// entity has no Flutter / go_router imports.
  final String routeName;

  /// Optional secondary route (e.g. the chapter underneath a topic).
  final String? secondaryRouteName;

  /// Optional icon-name hint — the presentation layer maps it to
  /// `IconData` via `AppIcons` so the entity stays Flutter-light.
  final String? iconName;

  final String? updatedAtIso;

  SearchItemEntity copyWith({
    String? id,
    SearchCategory? category,
    String? title,
    String? subtitle,
    String? routeName,
    String? secondaryRouteName,
    bool clearSecondary = false,
    String? iconName,
    bool clearIcon = false,
    String? updatedAtIso,
    bool clearUpdatedAt = false,
  }) {
    return SearchItemEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      routeName: routeName ?? this.routeName,
      secondaryRouteName:
          clearSecondary ? null : (secondaryRouteName ?? this.secondaryRouteName),
      iconName: clearIcon ? null : (iconName ?? this.iconName),
      updatedAtIso:
          clearUpdatedAt ? null : (updatedAtIso ?? this.updatedAtIso),
    );
  }
}