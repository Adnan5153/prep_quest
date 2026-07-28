import 'package:flutter/foundation.dart';

import '../enums/bookmark_item_type.dart';

/// A saved reference to content that the user wants to revisit.
@immutable
class BookmarkEntity {
  const BookmarkEntity({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.sourceFeature,
    required this.tags,
    required this.routeName,
    this.subtitle,
    this.thumbnailIconKey,
    this.routeParams = const <String, String>{},
  });

  /// Sentinel returned by toggle operations when an existing bookmark was removed.
  const BookmarkEntity.empty()
      : id = '',
        itemType = BookmarkItemType.note,
        itemId = '',
        title = '',
        subtitle = null,
        thumbnailIconKey = null,
        createdAt = null,
        updatedAt = null,
        sourceFeature = '',
        tags = const <String>[],
        routeName = '',
        routeParams = const <String, String>{};

  /// ULID / UUID generated on first save.
  final String id;

  /// Which kind of feature produced this bookmark.
  final BookmarkItemType itemType;

  /// Opaque identifier of the underlying entity in its source feature.
  final String itemId;

  /// Headline shown on tiles (resolved at save time so future renames
  /// don't break the entry).
  final String title;

  /// Optional one-line secondary text.
  final String? subtitle;

  /// Optional AppIcons.* key for the leading glyph.
  final String? thumbnailIconKey;

  /// When the bookmark was first added.
  final DateTime? createdAt;

  /// When the bookmark was last modified (tag change, re-save, etc.).
  final DateTime? updatedAt;

  /// Tag of the producing feature: 'quiz' / 'guidebook' / 'ai_tutor' / 'notes'.
  final String sourceFeature;

  /// Free-form tags for in-screen filter chips + on-device search.
  final List<String> tags;

  /// Destination route name (one of `AppRoutes.*`).
  final String routeName;

  /// Query parameters to forward to the destination route.
  final Map<String, String> routeParams;

  /// True when this is the `BookmarkEntity.empty()` sentinel.
  bool get isEmpty => id.isEmpty;

  BookmarkEntity copyWith({
    String? id,
    BookmarkItemType? itemType,
    String? itemId,
    String? title,
    String? subtitle,
    bool clearSubtitle = false,
    String? thumbnailIconKey,
    bool clearThumbnailIconKey = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sourceFeature,
    List<String>? tags,
    String? routeName,
    Map<String, String>? routeParams,
  }) {
    return BookmarkEntity(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      subtitle: clearSubtitle ? null : (subtitle ?? this.subtitle),
      thumbnailIconKey: clearThumbnailIconKey
          ? null
          : (thumbnailIconKey ?? this.thumbnailIconKey),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceFeature: sourceFeature ?? this.sourceFeature,
      tags: tags ?? this.tags,
      routeName: routeName ?? this.routeName,
      routeParams: routeParams ?? this.routeParams,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookmarkEntity &&
        other.id == id &&
        other.itemType == itemType &&
        other.itemId == itemId &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.thumbnailIconKey == thumbnailIconKey &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.sourceFeature == sourceFeature &&
        listEquals(other.tags, tags) &&
        other.routeName == routeName &&
        mapEquals(other.routeParams, routeParams);
  }

  @override
  int get hashCode => Object.hash(
        id,
        itemType,
        itemId,
        title,
        subtitle,
        thumbnailIconKey,
        createdAt,
        updatedAt,
        sourceFeature,
        Object.hashAll(tags),
        routeName,
        Object.hashAll(
          routeParams.entries.map((MapEntry<String, String> e) => Object.hash(e.key, e.value)),
        ),
      );
}
